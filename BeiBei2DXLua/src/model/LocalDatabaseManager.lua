RBWORDNUM = 10
MAXWRONGWORDCOUNT = s_max_wrong_num_everyday
MAXTYPEINDEX = 5

require("common.global")
local sqlite3 = require("lsqlite3")

-- useless
local DataDailyCheckIn = require('model.user.DataDailyCheckIn')
local DataDailyWord = require('model.user.DataDailyWord')
local DataIAP = require('model.user.DataIAP')
local DataLevel = require('model.user.DataLevel')

local DataLogIn = require('model.user.DataLogIn')
local DataUser = require('model.user.DataUser')
local DataBookProgress = require('model.user.DataBookProgress')

local DataCurrentIndex = require('model.user.DataCurrentIndex')
local DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')
local DataNewPlayState = require('model.user.DataNewPlayState')
local DataStudyConfiguration = require('model.user.DataStudyConfiguration')
local DataTodayReviewBossNum = require('model.user.DataTodayReviewBossNum')
local DataWrongWordBuffer = require('model.user.DataWrongWordBuffer')
local DataBossWord = require('model.user.DataBossWord')

local databaseTables = {
        DataDailyCheckIn,
        DataDailyWord,
        DataIAP,
        DataLevel,

        DataLogIn,
        DataUser,
        DataBookProgress,

        DataCurrentIndex,
        DataDailyStudyInfo,
        DataNewPlayState,
        DataStudyConfiguration,
        DataTodayReviewBossNum,
        DataWrongWordBuffer,
        DataBossWord
    }

local localdatabase_utils = nil
local localdatabase_user = nil

local localdatabase_dailyStudyInfo = nil
local localdatabase_currentIndex = nil
local localdatabase_newPlayState = nil
local localdatabase_studyConfiguration = nil
local localdatabase_todayReviewBossNum = nil
local localdatabase_wrongWordBuffer = nil
local localdatabase_bossWord = nil
local localdatabase_unknownWordTask = nil

-- define Manager
local Manager = {}

-- define Manager's variables
Manager.database = nil

-- connect local sqlite
function Manager.init()
    local databasePath = cc.FileUtils:getInstance():getWritablePath() .. "localDB.sqlite"
    Manager.database = sqlite3.open(databasePath)
    print ('databasePath:' .. databasePath)

    localdatabase_utils = reloadModule('model.localDatabase.utils')
    localdatabase_user = reloadModule('model.localDatabase.user')

    localdatabase_dailyStudyInfo = reloadModule('model.localDatabase.dailyStudyInfo')
    localdatabase_currentIndex = reloadModule('model.localDatabase.currentIndex')
    localdatabase_newPlayState = reloadModule('model.localDatabase.newPlayState')
    localdatabase_studyConfiguration = reloadModule('model.localDatabase.studyConfiguration')
    localdatabase_todayReviewBossNum = reloadModule('model.localDatabase.todayReviewBossNum')
    localdatabase_wrongWordBuffer = reloadModule('model.localDatabase.wrongWordBuffer')
    localdatabase_bossWord = reloadModule('model.localDatabase.bossWord')

    localdatabase_unknownWordTask = reloadModule('model.localDatabase.unknownWordTask')

    Manager.initTables()
end

-- close local sqlite
function Manager.close() Manager.database:close() end

-- init data structure
function Manager.initTables()    
    
    -- CREATE table Download State
    -- just used in local
    Manager.database:exec[[
        create table if not exists DataDownloadState(
            bookKey TEXT,
            isDownloaded INTEGER,
            lastUpdate INTEGER
        );
    ]]

    for i = 1, #databaseTables do
        localdatabase_utils.createTable(databaseTables[i].create())
    end
end

function Manager.saveDataClassObject(objectOfDataClass, userId, username)
    localdatabase_utils.saveDataClassObject(objectOfDataClass, userId, username)
end
---------------------------------------------------------------------------------------------------------

function Manager.getLastLogInUser(objectOfDataClass, usertype)
    return localdatabase_user.getUserDataFromLocalDB(objectOfDataClass, usertype)
end

---------------------------------------------------------------------------------------------------------

function Manager.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
    localdatabase_utils.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
end

function Manager.getDatas(classNameOfDataClass, userId, username)
    return localdatabase_utils.getDatas(classNameOfDataClass, userId, username)
end

---------------------------------------------------------------------------------------------------------
-- show word info

function Manager.getRandomWord()
    return localdatabase_dailyStudyInfo.getRandomWord()
end

function Manager.addStudyWordsNum()
    localdatabase_dailyStudyInfo.addStudyWordsNum()
end

function Manager.addGraspWordsNum(addNum)
    localdatabase_dailyStudyInfo.addGraspWordsNum(addNum)
end

function Manager.getStudyDayNum()
    return localdatabase_dailyStudyInfo.getStudyDayNum()
end

function Manager.getStudyWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    return localdatabase_dailyStudyInfo.getStudyWordsNum(dayString)
end

function Manager.getGraspWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    return localdatabase_dailyStudyInfo.getGraspWordsNum(dayString)
end

---------------------------------------------------------------------------------------------------------

function Manager.getTotalStudyWordsNum()
    return Manager.getCurrentIndex() - 1
end

function Manager.getTotalGraspWordsNum()
    local totalStudyWordsNum = Manager.getTotalStudyWordsNum()
    local wrongWordBufferNum = Manager.getWrongWordBufferNum()
    local bossWordNum = Manager.getBossWordNum()
    print("totalStudyWordsNum: "..totalStudyWordsNum)
    print("wrongWordBufferNum: "..wrongWordBufferNum)
    print("bossWordNum: "..bossWordNum)
    return totalStudyWordsNum - wrongWordBufferNum - bossWordNum
end

function Manager.getSummaryBossWordCandidate()
    local wrongWordPool = Manager.getWrongWords()
    local graspWordPool = Manager.getGraspWords() 

    local wrongWordPoolSize = #wrongWordPool
    local graspWordPoolSize = #graspWordPool
    
    local wordPool = {}
    if wrongWordPoolSize + graspWordPoolSize < 9 then
        return wordPool
    end
    
    local tureWrongWordNum = 3
    local tureGraspWordNum = 6
    
    if wrongWordPoolSize < 3 then
        tureWrongWordNum = wrongWordPoolSize
        tureGraspWordNum = 9 - tureWrongWordNum
    end
    
    if graspWordPoolSize < 6 then
        tureGraspWordNum = graspWordPoolSize
        tureWrongWordNum = 9 - tureGraspWordNum
    end
    
    local index1 = randomMinN(tureWrongWordNum, wrongWordPoolSize)
    local index2 = randomMinN(tureGraspWordNum, graspWordPoolSize)
    
    for i = 1, #index1 do
        table.insert(wordPool, wrongWordPool[index1[i]])
    end
    
    for i = 1, #index2 do
        table.insert(wordPool, graspWordPool[index2[i]])
    end
    return wordPool
end


function Manager.getStudyWords()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local wordList = s_BookWord[bookKey]

    local currentIndex = Manager.getCurrentIndex()
    
    local wordPool = {}
    for i = 1, currentIndex-1 do
        table.insert(wordPool, wordList[i])
    end

    return wordPool
end


function Manager.getWrongWords()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local wordPool = {}
    
    local n1 = 0
    local n2 = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            n1 = n1 + 1
            if row.wordBuffer ~= "" then
                local wordList = split(row.wordBuffer, "|")
                for i = 1, #wordList do
                    table.insert(wordPool, wordList[i])
                end
            end
        end

        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            if row.wordList ~= "" and row.typeIndex + 1 <= MAXTYPEINDEX then
                n2 = n2 + 1
                local wordList = split(row.wordList, "|")
                for i = 1, #wordList do
                    table.insert(wordPool, wordList[i])
                end
            end
        end
    end

    if username ~= '' then
        if n1 == 0 then
            for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
                if row.wordBuffer ~= "" and row.typeIndex + 1 <= MAXTYPEINDEX then
                    local wordList = split(row.wordBuffer, "|")
                    for i = 1, #wordList do
                        table.insert(wordPool, wordList[i])
                    end
                end
            end
        end

        if n2 == 0 then
            for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
                if row.wordList ~= "" and row.typeIndex + 1 <= MAXTYPEINDEX then
                    local wordList = split(row.wordList, "|")
                    for i = 1, #wordList do
                        table.insert(wordPool, wordList[i])
                    end
                end
            end
        end
    end
    
    return wordPool
end


function Manager.getGraspWords()
    local studyWordPool = Manager.getStudyWords()
    local wrongWordPool = Manager.getWrongWords()
    
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

---------------------------------------------------------------------------------------------------------
-- DataCurrentIndex
-- record word info
function Manager.printCurrentIndex()
    localdatabase_currentIndex.printCurrentIndex()
end

function Manager.getCurrentIndex()    
    return localdatabase_currentIndex.getCurrentIndex()
end

-- lastUpdate : nil means now
function Manager.setCurrentIndex(currentIndex, lastUpdate)
    localdatabase_currentIndex.saveDataCurrentIndex(currentIndex, lastUpdate)
    s_UserBaseServer.saveDataCurrentIndex()
end

function Manager.getDataCurrentIndex()
    return localdatabase_currentIndex.getDataCurrentIndex()
end

-- lastUpdate : nil means now
function Manager.saveDataCurrentIndex(currentIndex, lastUpdate)
    localdatabase_currentIndex.saveDataCurrentIndex(currentIndex, lastUpdate)
end

---------------------------------------------------------------------------------------------------------

function Manager.printNewPlayState()
    localdatabase_newPlayState.printNewPlayState()
end

function Manager.getTodayPlayModel()    
    return localdatabase_newPlayState.getTodayPlayModel()
end

function Manager.getwrongWordListSize()
    return localdatabase_newPlayState.getwrongWordListSize()
end

function Manager.getDataNewPlayState()
    return localdatabase_newPlayState.getDataNewPlayState()
end

function Manager.getNewPlayState()
    return localdatabase_newPlayState.getNewPlayState()
end

-- lastUpdate : nil means now
function Manager.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate, lastUpdate)
    localdatabase_newPlayState.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate, lastUpdate)
    s_UserBaseServer.saveDataNewPlayState()
end

-- lastUpdate : nil means now
function Manager.saveDataNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate, lastUpdate)
    localdatabase_newPlayState.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate, lastUpdate)
end

---------------------------------------------------------------------------------------------------------

function Manager.printWrongWordBuffer()
    localdatabase_wrongWordBuffer.printWrongWordBuffer()
end

function Manager.getWrongWordBufferNum()
    return localdatabase_wrongWordBuffer.getWrongWordBufferNum()
end

function Manager.addWrongWordBuffer(wrongWord)
    localdatabase_wrongWordBuffer.addWrongWordBuffer(wrongWord)
    s_UserBaseServer.saveDataWrongWordBuffer()
end

function Manager.getDataWrongWordBuffer()
    return localdatabase_wrongWordBuffer.getDataWrongWordBuffer()
end

-- lastUpdate : nil means now
function Manager.saveDataWrongWordBuffer(wordNum, wordBuffer, lastUpdate)
    return localdatabase_wrongWordBuffer.saveDataWrongWordBuffer(wordNum, wordBuffer, lastUpdate)
end

---------------------------------------------------------------------------------------------------------

function Manager.printBossWord()
    localdatabase_bossWord.printBossWord()
end

function Manager.addBossWord(bossWordList)
    localdatabase_bossWord.addBossWord(bossWordList)
end

function Manager.getBossWordNum()
    return localdatabase_bossWord.getBossWordNum()
end

function Manager.getBossWord()
    return localdatabase_bossWord.getBossWord()
end

function Manager.getTodayRemainBossNum()
    return localdatabase_bossWord.getTodayRemainBossNum()
end

function Manager.updateBossWord(bossID)
    localdatabase_bossWord.updateBossWord(bossID)
end

function Manager.getMaxBossID()
    return localdatabase_bossWord.getMaxBossID()
end

---------------------------------------------------------------------------------------------------------

function Manager.getTodayTotalBossNum()
    local ret = localdatabase_todayReviewBossNum.getTodayTotalBossNum()
    s_UserBaseServer.saveDataTodayReviewBossNum()
    return ret
end

function Manager.getDataTodayTotalBoss()
    return localdatabase_todayReviewBossNum.getDataTodayTotalBoss()
end

-- lastUpdate : nil means now
function Manager.saveDataTodayReviewBossNum(bossNum, lastUpdate)
    localdatabase_todayReviewBossNum.saveDataTodayReviewBossNum(bossNum, lastUpdate)
end

---------------------------------------------------------------------------------------------------------

-- newstudy configuration
function Manager.getIsAlterOn()
    return localdatabase_studyConfiguration.getIsAlterOn()
end

-- lastUpdate : nil means now
function Manager.setIsAlterOn(isAlterOn, lastUpdate)
    localdatabase_studyConfiguration.setIsAlterOn(isAlterOn, lastUpdate)
    s_UserBaseServer.synUserConfig(nil, false)
end

function Manager.getSlideNum()
    return localdatabase_studyConfiguration.getSlideNum()
end

-- lastUpdate : nil means now
function Manager.updateSlideNum(lastUpdate)
    localdatabase_studyConfiguration.updateSlideNum(lastUpdate)
    s_UserBaseServer.synUserConfig(nil, false)
end

-- lastUpdate : nil means now
function Manager.saveDataStudyConfiguration(isAlterOn, slideNum, lastUpdate)
    localdatabase_studyConfiguration.saveDataStudyConfiguration(isAlterOn, slideNum, lastUpdate)
end

---------------------------------------------------------------------------------------------------------

-- download state
function Manager.getDownloadState(bookKey)
    local isDownloaded = 0
    for row in Manager.database:nrows("SELECT * FROM DataDownloadState WHERE bookKey = '"..bookKey.."' ;") do
        isDownloaded = row.isDownloaded
    end
    return isDownloaded
end

function Manager.updateDownloadState(bookKey, isDownloaded)
    local time = os.time()

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataDownloadState WHERE bookKey = '"..bookKey.."' ;") do
        num = num + 1
    end
    
    if num == 0 then
        local query = "INSERT INTO DataDownloadState VALUES ('"..bookKey.."', "..isDownloaded..", "..time..");"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataDownloadState SET isDownloaded = "..isDownloaded..", lastUpdate = "..time.." WHERE bookKey = '"..bookKey.."' ;"    
        Manager.database:exec(query)
    end
end

--s_gamestate_reviewbossmodel = 1
--s_gamestate_studymodel      = 2
--s_gamestate_reviewmodel     = 3
--s_gamestate_overmodel       = 4

function Manager.getGameState() -- 1 for review boss model, 2 for study model, 3 for review model and 4 for over
    if Manager.getTodayRemainBossNum() > 0 then
        return s_gamestate_reviewbossmodel
    end
    
    if Manager.getCurrentIndex() > s_DataManager.books[s_CURRENT_USER.bookKey].words then
        return s_gamestate_overmodel
    end
    
    local playModel = Manager.getTodayPlayModel()
    if playModel == 0 then
        return s_gamestate_studymodel
    elseif playModel == 1 then
        return s_gamestate_reviewmodel
    else
        return s_gamestate_overmodel
    end
end

---- UserDefault -----------------------------------------------------------

local is_log_out_key = 'log_out'
function Manager.isLogOut() return cc.UserDefault:getInstance():getBoolForKey(is_log_out_key, false) end
function Manager.setLogOut(b) cc.UserDefault:getInstance():setBoolForKey(is_log_out_key, b) end

local is_sound_on_key = 'sound'
function Manager.isSoundOn() return cc.UserDefault:getInstance():getBoolForKey(is_sound_on_key, true) end
function Manager.setSoundOn(b) cc.UserDefault:getInstance():setBoolForKey(is_sound_on_key, b) end

local is_music_on_key = 'music'
function Manager.isMusicOn() return cc.UserDefault:getInstance():getBoolForKey(is_music_on_key, true) end
function Manager.setMusicOn(b) cc.UserDefault:getInstance():setBoolForKey(is_music_on_key, b) end

return Manager


