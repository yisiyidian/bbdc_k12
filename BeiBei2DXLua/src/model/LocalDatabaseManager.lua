local RBWORDNUM = 10
local MAXWRONGWORDCOUNT = s_max_wrong_num_everyday
local MAXTYPEINDEX = 4

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
        DataTodayReviewBossNum
    }

local localdatabase_utils = nil
local localdatabase_user = nil

local localdatabase_dailyStudyInfo = nil
local localdatabase_currentIndex = nil
local localdatabase_newPlayState = nil
local localdatabase_studyConfiguration = nil
local localdatabase_todayReviewBossNum = nil

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

    Manager.initTables()
end

-- close local sqlite
function Manager.close() Manager.database:close() end

-- init data structure
function Manager.initTables()    
    -- CREATE table Wrong Word Buffer
    Manager.database:exec[[
        create table if not exists DataWrongWordBuffer(
            userId TEXT,
            bookKey TEXT,
            wordNum INTEGER,
            wordBuffer TEXT,
            lastUpdate INTEGER
        );
    ]]
    
    -- CREATE table Boss Word
    Manager.database:exec[[
        create table if not exists DataBossWord(
            userId TEXT,
            bookKey TEXT,
            bossID INTEGER,
            typeIndex INTEGER,
            wordList TEXT,
            lastUpdate INTEGER
        );
    ]]
    
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
    
    local wordPool = {}
    
    for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if row.wordBuffer ~= "" then
            local wordList = split(row.wordBuffer, "|")
            for i = 1, #wordList do
                table.insert(wordPool, wordList[i])
            end
        end
    end
    
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if row.wordList ~= "" then
            local wordList = split(row.wordList, "|")
            for i = 1, #wordList do
                table.insert(wordPool, wordList[i])
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

function Manager.setCurrentIndex(currentIndex)
    localdatabase_currentIndex.setCurrentIndex(currentIndex)
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

function Manager.getNewPlayState()
    return localdatabase_newPlayState.getNewPlayState()
end

function Manager.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate)
    localdatabase_newPlayState.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate)
end

---------------------------------------------------------------------------------------------------------

function Manager.printWrongWordBuffer()
    if RELEASE_APP ~= DEBUG_FOR_TEST then return end

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<wrongWordBuffer>")
    for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("<item>")
        print("wordNum: "..row.wordNum)
        print("wordBuffer: "..row.wordBuffer)
        print("lastUpdate: "..row.lastUpdate)
        print("</item>")
    end
    print("</wrongWordBuffer>")
end

function Manager.getWrongWordBufferNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    local wrongWordBufferNum = 0
    for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        wrongWordBufferNum = wrongWordBufferNum + row.wordNum
    end
    
    return wrongWordBufferNum
end

function Manager.addWrongWordBuffer(wrongWord)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    
    local num = 0
    local oldWordBuffer = ""
    local oldWordNum = 0
    for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        num = num + 1
        oldWordBuffer = row.wordBuffer
        oldWordNum = row.wordNum
    end
    
    if num == 0 then
        local wordNum = 1
        local query = "INSERT INTO DataWrongWordBuffer VALUES ('"..userId.."', '"..bookKey.."', "..wordNum..", '"..wrongWord.."', "..time..");"
        Manager.database:exec(query)
    else
        local wordNum = nil
        local wordBuffer = nil
        if oldWordNum + 1 >= MAXWRONGWORDCOUNT then
            local bossWordListString = oldWordBuffer.."|"..wrongWord
            Manager.addBossWord(bossWordListString)
            
            wordNum = 0
            wordBuffer = ""
        else
            wordNum = oldWordNum + 1
            wordBuffer = oldWordBuffer.."|"..wrongWord
        end
        
        local query = "UPDATE DataWrongWordBuffer SET wordNum = "..wordNum..", wordBuffer = '"..wordBuffer.."', lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';"    
        Manager.database:exec(query)
    end
end

---------------------------------------------------------------------------------------------------------

function Manager.printBossWord()
    if RELEASE_APP ~= DEBUG_FOR_TEST then return end

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<bossWord>")
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("<item>")
        print("bossID: "..row.bossID)
        print("typeIndex: "..row.typeIndex)
        print("wordList: "..row.wordList)
        print("lastUpdate: "..row.lastUpdate)
        print("</item>")
    end
    print("</bossWord>")
end

function Manager.addBossWord(bossWordList)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    
    local maxBossID = 0
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if row.bossID > maxBossID then
            maxBossID = row.bossID
        end
    end
    
    local bossID = maxBossID + 1
    local typeIndex = 0
    
    local query = "INSERT INTO DataBossWord VALUES ('"..userId.."', '"..bookKey.."', "..bossID..", "..typeIndex..", '"..bossWordList.."', "..time..");"
    Manager.database:exec(query)
end

function Manager.getBossWordNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    local bossWordNum = 0
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
        bossWordNum = bossWordNum + MAXWRONGWORDCOUNT
    end

    return bossWordNum
end

function Manager.getBossWord()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    local today = os.date("%x", time)
    
    local candidate = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ORDER BY lastUpdate LIMIT 0, 1 ;") do
        local lastUpdate = tostring(row.lastUpdate)
        local lastUpdateDay = os.date("%x", lastUpdate)
        if lastUpdateDay ~= today then
            candidate           = {}
            candidate.bossID    = row.bossID
            candidate.typeIndex = row.typeIndex
            candidate.wordList  = row.wordList
        end
    end
    
    return candidate
end

function Manager.getTodayRemainBossNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
        local lastUpdate = tostring(row.lastUpdate)
        local lastUpdateDay = os.date("%x", lastUpdate)
        if lastUpdateDay ~= today then
            num = num + 1
        end
    end

    return num
end

function Manager.updateBossWord(bossID)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    
    local typeIndex = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;") do
        typeIndex = row.typeIndex
    end
    
    if typeIndex + 1 == MAXTYPEINDEX then
        Manager.addGraspWordsNum(MAXWRONGWORDCOUNT)
        
        local query = "DELETE FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataBossWord SET typeIndex = "..(typeIndex+1)..", lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;"    
        Manager.database:exec(query)
    end
end

---------------------------------------------------------------------------------------------------------

function Manager.getTodayTotalBossNum()
    localdatabase_todayReviewBossNum.getTodayTotalBossNum()
end

---------------------------------------------------------------------------------------------------------

-- newstudy configuration
function Manager.getIsAlterOn()
    return localdatabase_studyConfiguration.getIsAlterOn()
end

function Manager.setIsAlterOn(isAlterOn)
    localdatabase_studyConfiguration.setIsAlterOn(isAlterOn)
end

function Manager.getSlideNum()
    return localdatabase_studyConfiguration.getSlideNum()
end

function Manager.updateSlideNum()
    localdatabase_studyConfiguration.updateSlideNum()
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


