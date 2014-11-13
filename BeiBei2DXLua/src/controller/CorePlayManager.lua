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


local CorePlayManager = {}

-- study scene and test scene variate
CorePlayManager.wordList = {"apple","pear","water","day"}
--CorePlayManager.wordList = {}
CorePlayManager.currentWordIndex = 1
CorePlayManager.currentWord = nil
CorePlayManager.answerStateRecord = {}
CorePlayManager.wordProficiency = {}

CorePlayManager.currentScore = 0
CorePlayManager.currentRatio = 0

CorePlayManager.replayWrongWordState = false
CorePlayManager.wrongWordList = {}

CorePlayManager.newPlayerState = false

CorePlayManager.chapterIndex = 4

-- reviewboss scene variate
CorePlayManager.rbWordList = {"apple","pear","water","day","wonder","needle"}


function CorePlayManager.create()
    CorePlayManager.loadConfiguration()
end

function CorePlayManager.loadConfiguration()
    for i = 1, #CorePlayManager.wordList do
        CorePlayManager.answerStateRecord[i] = 0    -- 0 for answer wrong and 1 for answer right
        CorePlayManager.wordProficiency[i]   = 1    -- 0 for unfamiliar word and 1 for familiar word
    end
end

function CorePlayManager.enterStudyLayer()
    if CorePlayManager.replayWrongWordState then
        CorePlayManager.currentWord = s_WordPool[CorePlayManager.wrongWordList[CorePlayManager.currentWordIndex]]
    else
        CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
    end
    
    if CorePlayManager.chapterIndex == 1 then
        local studyLayer = StudyLayer.create()
        s_SCENE:replaceGameLayer(studyLayer)
    elseif CorePlayManager.chapterIndex == 2 then
        local studyLayerII = StudyLayerII.create()
        s_SCENE:replaceGameLayer(studyLayerII)
    elseif CorePlayManager.chapterIndex == 3 then
        local studyLayerIII = StudyLayerIII.create()
        s_SCENE:replaceGameLayer(studyLayerIII)
    elseif CorePlayManager.chapterIndex == 4 then
        local studyLayerIV = StudyLayerIV.create()
        s_SCENE:replaceGameLayer(studyLayerIV)
    end
end

function CorePlayManager.leaveStudyLayer()
    s_logd("leave")
end

function CorePlayManager.enterTestLayer()
    CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
    
    if CorePlayManager.chapterIndex == 1 then
        local testLayer = TestLayer.create()
        s_SCENE:replaceGameLayer(testLayer)
    elseif CorePlayManager.chapterIndex == 2 then
        local testLayerII = TestLayerII.create()
        s_SCENE:replaceGameLayer(testLayerII)
    elseif CorePlayManager.chapterIndex == 3 then
        local testLayerIII = TestLayerIII.create()
        s_SCENE:replaceGameLayer(testLayerIII)
    elseif CorePlayManager.chapterIndex == 4 then
        local testLayerIV = TestLayerIV.create()
        s_SCENE:replaceGameLayer(testLayerIV)
    end
end

function CorePlayManager.leaveTestLayer()
    if s_CURRENT_USER.currentLevelKey == s_CURRENT_USER.selectedLevelKey then
        s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
    end
    s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.chapterKey,s_CURRENT_USER.levelKey,2)
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
            print("word: "..CorePlayManager.wordList[i].." pro:0")
            s_DATABASE_MGR.insertTable_Word_Prociency(CorePlayManager.wordList[i], 0)
        else
            print("word: "..CorePlayManager.wordList[i].." pro:5")
            s_DATABASE_MGR.insertTable_Word_Prociency(CorePlayManager.wordList[i], 5)
        end
    end
end

function CorePlayManager.enterReviewBossLayer()
    if CorePlayManager.chapterIndex == 1 then
        local reviewBossLayer = ReviewBossLayer.create()
        s_SCENE:replaceGameLayer(reviewBossLayer)
    elseif CorePlayManager.chapterIndex == 2 then
        local reviewBossLayerII = ReviewBossLayerII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerII)
    elseif CorePlayManager.chapterIndex == 3 then
        local reviewBossLayerIII = ReviewBossLayerIII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerIII)
    end
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

return CorePlayManager
