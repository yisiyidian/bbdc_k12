
---本地数据管理器 
---1、管理所有本地sqlite数据库的表
---2、也管理UserDefault
local LocalDataBaseManager = {}


require("common.global")
local sqlite3 = require("lsqlite3")
--Model 层
local DataEverydayInfo          = require('model.user.DataEverydayInfo')
local DataLevelInfo             = require('model.user.DataLevelInfo')
local DataDailyStudyInfo        = require('model.user.DataDailyStudyInfo')
local DataBossWord              = require('model.user.DataBossWord')
local DataTask                  = require('model.user.DataTask')
local DataUnit                  = require('model.user.DataUnit')
local DataDailyUsing            = require('model.user.DataDailyUsing')

local DataMission               = require("model.user.DataMission")--任务

local databaseTables = {
        DataEverydayInfo,
        DataUser,
        DataLevelInfo,
        DataDailyStudyInfo,
        DataBossWord,
        DataTask,
        DataUnit,
        DataDailyUsing,
        DataMission, --任务
    }

local localdatabase_utils           = nil --本地数据库管理工具 localDatabase.utils里的表M
local localdatabase_user            = nil 
local localdatabase_dailyStudyInfo  = nil
local localdatabase_bossWord        = nil
local localdatabase_task            = nil
local localdatabase_unit            = nil
local localdatabase_mission         = nil --任务

--初始化
function LocalDataBaseManager.init()
    LocalDataBaseManager.database = nil
    --打开数据库
    local databasePath = cc.FileUtils:getInstance():getWritablePath() .. 'bbdx.sqlite' --  version 1.7.x- "localDB.sqlite"
    LocalDataBaseManager.database = sqlite3.open(databasePath)
    print ('databasePath:' .. databasePath)
    --数据 业务访问层
    localdatabase_utils             = reloadModule('model.localDatabase.utils')
    localdatabase_user              = reloadModule('model.localDatabase.user')
    localdatabase_dailyStudyInfo    = reloadModule('model.localDatabase.dailyStudyInfo')
    localdatabase_bossWord          = reloadModule('model.localDatabase.bossWord')
    localdatabase_task              = reloadModule('model.localDatabase.task')
    localdatabase_unitWord          = reloadModule('model.localDatabase.unitWord')
    localdatabase_mission           = reloadModule('model.localDatabase.mission') --业务层
    --创建数据表
    LocalDataBaseManager.initTables()
end

--关闭数据库连接
function LocalDataBaseManager.close() 
    LocalDataBaseManager.database:close() 
end

--创建sqlite里的各种表
function LocalDataBaseManager.initTables()
    -- CREATE table Download State
    -- just used in local
    LocalDataBaseManager.database:exec[[
        create table if not exists DataDownloadState(
            bookKey TEXT,
            isDownloaded INTEGER,
            lastUpdate INTEGER
        );
    ]]
    --依次创建数据表
    dump(databaseTables)
    for i = 1, #databaseTables do
        localdatabase_utils.createTable(databaseTables[i].create())
    end
end

function LocalDataBaseManager.saveDataClassObject(objectOfDataClass, userId, username, conditions)
    localdatabase_utils.saveDataClassObject(objectOfDataClass, userId, username, conditions)
end
---------------------------------------------------------------------------------------------------------

function LocalDataBaseManager.getLastLogInUser(objectOfDataClass, usertype)
    return localdatabase_user.getUserDataFromLocalDB(objectOfDataClass, usertype)
end

---------------------------------------------------------------------------------------------------------

function LocalDataBaseManager.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
    localdatabase_utils.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
end

-- handleRecordRow : nil or function(row)
function LocalDataBaseManager.getDatas(classNameOfDataClass, userId, username, handleRecordRow)
    return localdatabase_utils.getDatas(classNameOfDataClass, userId, username, handleRecordRow)
end

---------------------------------------------------------------------------------------------------------

function LocalDataBaseManager.getWordInfoFromWordName(word)
    local DataWord = require('model.user.DataWord')
    local ret = DataWord.create()
    ret.wordName = word
    if s_WordDictionaryDatabase.allwords ~= nil then
        local raw = s_WordDictionaryDatabase.allwords[word]
        if not IS_DEVELOPMENT_MODE and raw == nil then
            s_WordDictionaryDatabase.allwords[word] = require('model.words.' .. word)
            raw = s_WordDictionaryDatabase.allwords[word]
        end
        if raw ~= nil then
            local indexOffset = 0
            if IS_DEVELOPMENT_MODE then indexOffset = 1 end
            ret.wordSoundMarkEn    =   raw[1 + indexOffset]
            ret.wordSoundMarkAm    =   raw[2 + indexOffset]
            ret.wordMeaningSmall   =   raw[3 + indexOffset]
            ret.wordMeaning        =   raw[4 + indexOffset]
            ret.sentenceEn         =   raw[5 + indexOffset]
            ret.sentenceCn         =   raw[6 + indexOffset]
            ret.sentenceEn2        =   raw[7 + indexOffset]
            ret.sentenceCn2        =   raw[8 + indexOffset]
        else
            print("-------------------")
            print("not get word!")
            print("-------------------")
        end
    end
    return ret
end

---- Daily Study Info -----------------------------------------------------------------------------------
function LocalDataBaseManager.getRandomWord()
    return localdatabase_dailyStudyInfo.getRandomWord()
end

function LocalDataBaseManager.addStudyWordsNum(addNum)
    local data = localdatabase_dailyStudyInfo.addStudyWordsNum(addNum)
end

function LocalDataBaseManager.addGraspWordsNum(addNum)
    local data = localdatabase_dailyStudyInfo.addGraspWordsNum(addNum)
end


function LocalDataBaseManager.getStudyDayNum()
    return localdatabase_dailyStudyInfo.getStudyDayNum()
end

function LocalDataBaseManager.getStudyWordsNum(dayString)
    -- day must be a string like "11/16/14", as month + day + year
    return localdatabase_dailyStudyInfo.getStudyWordsNum(dayString)
end

function LocalDataBaseManager.getGraspWordsNum(dayString)
    -- day must be a string like "11/16/14", as month + day + year
    return localdatabase_dailyStudyInfo.getGraspWordsNum(dayString)
end

function LocalDataBaseManager.getDataDailyStudyInfo(dayString)
    return localdatabase_dailyStudyInfo.getDataDailyStudyInfo(dayString)
end

function LocalDataBaseManager.saveDataDailyStudyInfo(data)
   localdatabase_dailyStudyInfo.saveDataDailyStudyInfo(data)
end

---- Task ------------------------------------------------------------------------------------------------

function LocalDataBaseManager.getTodayTotalTaskNum()
    return localdatabase_task.getTodayTotalTaskNum()
end

function LocalDataBaseManager.getTodayRemainTaskNum()
    return localdatabase_task.getTodayRemainTaskNum()
end

function LocalDataBaseManager.getTodayTotalBossNum()
    return localdatabase_task.getTodayTotalBossNum()
end

function LocalDataBaseManager.getTodayRemainBossNum()
    return #localdatabase_bossWord.getTodayReviewBoss()
end

function LocalDataBaseManager.minusTodayRemainTaskNum()
    local todayRemainTaskNum = localdatabase_task.getTodayRemainTaskNum()

    if todayRemainTaskNum > 0 then
        localdatabase_task.setTodayRemainTaskNum(todayRemainTaskNum-1)
    end
end

---- Boss Word -------------------------------------------------------------------------------------------

function LocalDataBaseManager.getPrevWordState()
    return localdatabase_bossWord.getPrevWordState()
end

function LocalDataBaseManager.getMaxBoss()
    return localdatabase_bossWord.getMaxBoss()
end

function LocalDataBaseManager.getMaxBossByBookKey(bookKey)
    return localdatabase_bossWord.getMaxBossByBookKey(bookKey)
end

function LocalDataBaseManager.getMaxBossID()
    return localdatabase_bossWord.getMaxBossID()
end

function LocalDataBaseManager.getBossInfo(bossID)
    return localdatabase_bossWord.getBossInfo(bossID)
end

function LocalDataBaseManager.getAllBossInfo()
    return localdatabase_bossWord.getAllBossInfo()
end

function LocalDataBaseManager.addWrongWord(wordindex)
    return localdatabase_bossWord.addWrongWord(wordindex)
end

function LocalDataBaseManager.updateTypeIndex(bossID)
    LocalDataBaseManager.minusTodayRemainTaskNum()
    localdatabase_bossWord.updateTypeIndex(bossID)
end

function LocalDataBaseManager.printBossWord()
    localdatabase_bossWord.printBossWord()
end

---- Unit word -----------------------------------------------------------------------------------------
function LocalDataBaseManager.getTodayReviewBoss()
    return localdatabase_unitWord.getTodayReviewBoss()
end

function LocalDataBaseManager.getMaxUnit()
    return localdatabase_unitWord.getMaxUnit()
end

function LocalDataBaseManager.getMaxUnitByBookKey(bookKey)
    return localdatabase_unitWord.getMaxUnitByBookKey(bookKey)
end

function LocalDataBaseManager.getMaxUnitID()
    return localdatabase_unitWord.getMaxUnitID()
end

function LocalDataBaseManager.getUnitInfo(unitID)
    return localdatabase_unitWord.getUnitInfo(unitID)
end

function LocalDataBaseManager.getAllUnitInfo()
    return localdatabase_unitWord.getAllUnitInfo()
end

function LocalDataBaseManager.initUnitInfo(unitID)
    return localdatabase_unitWord.initUnitInfo(unitID)
end

function LocalDataBaseManager.getBookMaxUnitID(bookKey)
    return localdatabase_unitWord.getBookMaxUnitID(bookKey)
end

function LocalDataBaseManager.updateUnitState(unitID)   -- TODO
    LocalDataBaseManager.minusTodayRemainTaskNum()
    localdatabase_unitWord.updateUnitState(unitID)
end

function LocalDataBaseManager.getUnitCoolingSeconds(unitID)
    return localdatabase_unitWord.getUnitCoolingSeconds(unitID)
end

function LocalDataBaseManager.printUnitWord()
    localdatabase_unitWord.printUnitWord()
end

function LocalDataBaseManager.addRightWord(wordList,unitID)
    localdatabase_unitWord.addRightWord(wordList,unitID)
end

---- Mission -----------------------------任务------------------------------------------------------------
--获取当前用户的任务数据
function LocalDataBaseManager.getMissionData()
    return localdatabase_mission.getMissionData()
end

---- Statistics -----------------------------------------------------------------------------------------

function LocalDataBaseManager.getTotalStudyWordsNum()
    return localdatabase_dailyStudyInfo.getTotalStudyWordsNum()
end

function LocalDataBaseManager.getTotalStudyWordsNumByBookKey(bookKey)
    return localdatabase_dailyStudyInfo.getTotalStudyWordsNumByBookKey(bookKey)
end

function LocalDataBaseManager.getTotalGraspWordsNum()
    return localdatabase_dailyStudyInfo.getTotalGraspWordsNum()
end

function LocalDataBaseManager.getStudyWords()
    local bookKey = s_CURRENT_USER.bookKey
    local wordList = s_BookWord[bookKey]
    local currentIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    
    local wordPool = {}
    for i = 1, currentIndex-1 do
        table.insert(wordPool, wordList[i])
    end
    return wordPool
end

function LocalDataBaseManager.getWrongWords()
    return localdatabase_bossWord.getAllWrongWordList()
end

function LocalDataBaseManager.getGraspWords()
    local studyWordPool = LocalDataBaseManager.getStudyWords()
    local wrongWordPool = LocalDataBaseManager.getWrongWords()
    
    local dict = {}
    for i = 1, #wrongWordPool do
        local wordname = wrongWordPool[i]
        dict[wordname] = 1
    end
    
    local wordPool = {}
    for i = 1, #studyWordPool do
        local wordname = studyWordPool[i]
        if dict[wordname] == nil then
            table.insert(wordPool, wordname)
        end
    end

    return wordPool
end

---- Download --------------------------------------------------------------------------------------------
function LocalDataBaseManager.getDownloadState(bookKey)
    local isDownloaded = 0
    for row in LocalDataBaseManager.database:nrows("SELECT * FROM DataDownloadState WHERE bookKey = '"..bookKey.."' ;") do
        isDownloaded = row.isDownloaded
    end
    return isDownloaded
end

function LocalDataBaseManager.updateDownloadState(bookKey, isDownloaded)
    local time = os.time()

    local num = 0
    for row in LocalDataBaseManager.database:nrows("SELECT * FROM DataDownloadState WHERE bookKey = '"..bookKey.."' ;") do
        num = num + 1
    end
    
    if num == 0 then
        local query = "INSERT INTO DataDownloadState VALUES ('"..bookKey.."', "..isDownloaded..", "..time..");"
        LocalDataBaseManager.database:exec(query)
    else
        local query = "UPDATE DataDownloadState SET isDownloaded = "..isDownloaded..", lastUpdate = "..time.." WHERE bookKey = '"..bookKey.."' ;"    
        LocalDataBaseManager.database:exec(query)
    end
end

---- UserDefault -----------------------------------------------------------------------------------------

local is_log_out_key = 'log_out'
function LocalDataBaseManager.isLogOut() return false end -- TODO return cc.UserDefault:getInstance():getBoolForKey(is_log_out_key, false) end
function LocalDataBaseManager.setLogOut(b) cc.UserDefault:getInstance():setBoolForKey(is_log_out_key, b) end

local is_sound_on_key = 'sound'
function LocalDataBaseManager.isSoundOn() return cc.UserDefault:getInstance():getBoolForKey(is_sound_on_key, true) end
function LocalDataBaseManager.setSoundOn(b) cc.UserDefault:getInstance():setBoolForKey(is_sound_on_key, b) end

local is_music_on_key = 'music'
function LocalDataBaseManager.isMusicOn() return cc.UserDefault:getInstance():getBoolForKey(is_music_on_key, true) end
function LocalDataBaseManager.setMusicOn(b) cc.UserDefault:getInstance():setBoolForKey(is_music_on_key, b) end

local is_buy_key = 'buy'
function LocalDataBaseManager.isBuy() return cc.UserDefault:getInstance():getIntegerForKey(is_buy_key) end
function LocalDataBaseManager.setBuy(b) cc.UserDefault:getInstance():setIntegerForKey(is_buy_key, b) end

local DA_DEVICE_ID = 'DA_DEVICE_ID'
function LocalDataBaseManager.get_DA_DEVICE_ID() 
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        return cx.CXNetworkStatus:getInstance():getDeviceUDID()
    else
        return cc.UserDefault:getInstance():getStringForKey(DA_DEVICE_ID) 
    end
end

return LocalDataBaseManager


