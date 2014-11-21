require "common.global"

local StudyLayer            = require("view.study.studyI.StudyLayer")
local StudyLayerII          = require("view.study.studyII.StudyLayerII")
local StudyLayerIII         = require("view.study.studyIII.StudyLayerIII")
local StudyLayerIV          = require("view.study.studyIV.StudyLayerIV")
local TestLayer             = require("view.test.testI.TestLayer")
local TestLayerII           = require("view.test.testII.TestLayerII")
local TestLayerIII          = require("view.test.testIII.TestLayerIII")
local TestLayerIV           = require("view.test.testIV.TestLayerIV")
local ReviewBossLayer       = require("view.reviewboss.reviewbossI.ReviewBossLayer")
local ReviewBossLayerII     = require("view.reviewboss.reviewbossII.ReviewBossLayerII")
local ReviewBossLayerIII    = require("view.reviewboss.reviewbossIII.ReviewBossLayerIII")
local IntroLayer            = require("view.login.IntroLayer")
local HomeLayer             = require("view.home.HomeLayer")
local LevelLayer            = require("view.LevelLayer")
local BookLayer             = require("view.book.BookLayer")
local WordLayer             = require("view.word.WordLayer")


local CorePlayManager = {}

function CorePlayManager.create()
    CorePlayManager.loadConfiguration()
end

function CorePlayManager.loadConfiguration()
    -- reviewboss scene variate
    CorePlayManager.rbWordList = {"apple","pear","water","day","wonder","needle"}
end

function CorePlayManager.initStudyTestState()
    CorePlayManager.currentChapterKey = 1

    CorePlayManager.currentWordIndex = 1
    CorePlayManager.currentWord = nil

    CorePlayManager.answerStateRecord = {}
    CorePlayManager.wordProficiency = {}
    for i = 1, #CorePlayManager.wordList do
        CorePlayManager.answerStateRecord[i] = 0    -- 0 for answer wrong and 1 for answer right
        CorePlayManager.wordProficiency[i]   = 1    -- 0 for unfamiliar word and 1 for familiar word
    end

    CorePlayManager.currentScore = 0
    CorePlayManager.currentRatio = 0

    CorePlayManager.newPlayerState = false
    CorePlayManager.replayWrongWordState = false
    CorePlayManager.wrongWordList = {}
    
    CorePlayManager.buttonListState = -1
end

function CorePlayManager.enterStudyLayer()
    if CorePlayManager.replayWrongWordState then
        CorePlayManager.currentWord = s_WordPool[CorePlayManager.wrongWordList[CorePlayManager.currentWordIndex]]
    else
        CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
    end
    
    if s_CURRENT_USER.currentChapterKey == "chapter0" then
        local studyLayer = StudyLayer.create()
        s_SCENE:replaceGameLayer(studyLayer)
    elseif s_CURRENT_USER.currentChapterKey == "chapter1" then
        local studyLayerII = StudyLayerII.create()
        s_SCENE:replaceGameLayer(studyLayerII)
    elseif s_CURRENT_USER.currentChapterKey == "chapter2" then
        local studyLayerIII = StudyLayerIII.create()
        s_SCENE:replaceGameLayer(studyLayerIII)
    elseif s_CURRENT_USER.currentChapterKey == "chapter3" then
        local studyLayerIV = StudyLayerIV.create()
        s_SCENE:replaceGameLayer(studyLayerIV)
    else
        s_logd("system error")
        s_logd(s_CURRENT_USER.currentChapterKey)
    end
end

function CorePlayManager.leaveStudyLayer()
    s_logd("leave")
    
    
end

function CorePlayManager.enterTestLayer()
    CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
    
    if s_CURRENT_USER.currentChapterKey == "chapter0" then
        local testLayer = TestLayer.create()
        s_SCENE:replaceGameLayer(testLayer)
    elseif s_CURRENT_USER.currentChapterKey == "chapter1" then
        local testLayerII = TestLayerII.create()
        s_SCENE:replaceGameLayer(testLayerII)
    elseif s_CURRENT_USER.currentChapterKey == "chapter2" then
        local testLayerIII = TestLayerIII.create()
        s_SCENE:replaceGameLayer(testLayerIII)
    elseif s_CURRENT_USER.currentChapterKey == "chapter3" then
        local testLayerIV = TestLayerIV.create()
        s_SCENE:replaceGameLayer(testLayerIV)
    else
        s_logd("system error")
        s_logd(s_CURRENT_USER.currentChapterKey)
    end
end

function CorePlayManager.leaveTestLayer()
    if s_CURRENT_USER.currentLevelKey == s_CURRENT_USER.currentSelectedLevelKey then
        s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
    end
    CorePlayManager.enterLevelLayer()
end

function CorePlayManager.leaveTestLayer_replay()
    CorePlayManager.enterLevelLayer()
end

function CorePlayManager.answerRight()
    CorePlayManager.answerStateRecord[CorePlayManager.currentWordIndex] = 1
end

function CorePlayManager.unfamiliarWord()
    CorePlayManager.wordProficiency[CorePlayManager.currentWordIndex] = 0
end

function CorePlayManager.generateWrongWordList()
    for i = 1, #CorePlayManager.wordList do
        if CorePlayManager.answerStateRecord[i] == 0 then
            table.insert( CorePlayManager.wrongWordList, CorePlayManager.wordList[i] )
        end
    end
    CorePlayManager.replayWrongWordState = true
    CorePlayManager.currentWordIndex = 1
end

function CorePlayManager.recordWordProciency()
    for i = 1, #CorePlayManager.wordList do
        if CorePlayManager.wordProficiency[i] == 0 then
            s_logd("word: "..CorePlayManager.wordList[i].." pro:0")
            s_DATABASE_MGR.insertTable_DataWordProciency(CorePlayManager.wordList[i], 0)
        else
            s_logd("word: "..CorePlayManager.wordList[i].." pro:5")
            s_DATABASE_MGR.insertTable_DataWordProciency(CorePlayManager.wordList[i], 5)
        end
    end
    
    s_CURRENT_USER.wordsCount = s_DATABASE_MGR.getStudyWordsNum(s_CURRENT_USER.bookKey)
    s_CURRENT_USER.masterCount = s_DATABASE_MGR.getGraspWordsNum(s_CURRENT_USER.bookKey)
    s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER,
        function(api,result)
        end,
        function(api, code, message, description)
        end)
end

function CorePlayManager.enterReviewBossLayer_special()
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentChapterKey,"level0")
    CorePlayManager.rbWordList = split(levelConfig.word_content, "|")
    local reviewBossLayer = ReviewBossLayer.create()
    s_SCENE:replaceGameLayer(reviewBossLayer)
end

function CorePlayManager.enterReviewBossLayer()
    local bossID = s_DATABASE_MGR.getCurrentReviewBossID()
    CorePlayManager.rbWordList = s_DATABASE_MGR.getRBWordList(bossID)
    if #CorePlayManager.rbWordList < 3 then
        return
    end

    if s_CURRENT_USER.currentChapterKey == "chapter0" then
        local reviewBossLayer = ReviewBossLayer.create()
        s_SCENE:replaceGameLayer(reviewBossLayer)
    elseif s_CURRENT_USER.currentChapterKey == "chapter1" then
        local reviewBossLayerII = ReviewBossLayerII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerII)
    elseif s_CURRENT_USER.currentChapterKey == "chapter2" then
        local reviewBossLayerIII = ReviewBossLayerIII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerIII)
    else
        s_logd("system error")
        s_logd(s_CURRENT_USER.currentChapterKey)
    end
end

function CorePlayManager.leaveReviewBossLayer()
    s_SCENE.levelLayerState = s_review_boss_pass_state
    CorePlayManager.enterLevelLayer()
end

function CorePlayManager.enterIntroLayer()
    local IntroLayer = IntroLayer.create()
    s_SCENE:replaceGameLayer(IntroLayer)
end

function CorePlayManager.enterHomeLayer()
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
end

function CorePlayManager.enterLevelLayer()
    local levelLayer = LevelLayer.create()
    s_SCENE:replaceGameLayer(levelLayer)
end

function CorePlayManager.enterBookLayer()
    local bookLayer = BookLayer.create()
    s_SCENE:replaceGameLayer(bookLayer)
end

function CorePlayManager.enterWordLayer()
    local wordLayer = WordLayer.create()
    s_SCENE:replaceGameLayer(wordLayer)
end

return CorePlayManager
