require "common.global"


local StudyLayer            = require("view.study.studyI.StudyLayer")
local StudyLayerII          = require("view.study.studyII.StudyLayerII")
local StudyLayerIII         = require("view.study.studyIII.studyLayerIII")
local TestLayer             = require("view.test.testI.TestLayer")
local TestLayerII           = require("view.test.testII.TestLayerII")
local TestLayerIII          = require("view.test.testIII.testLayerIII")
local ReviewBossLayer       = require("view.reviewboss.reviewbossI.ReviewBossLayer")
local ReviewBossLayerII     = require("view.reviewboss.reviewbossII.ReviewBossLayerII")
local ReviewBossLayerIII    = require("view.reviewboss.reviewbossIII.ReviewBossLayerIII")


local CorePlayManager = {}

-- study scene and test scene variate
CorePlayManager.wordList = {"apple","pear","water","day"}
CorePlayManager.currentWordIndex = 1
CorePlayManager.currentWord = nil
CorePlayManager.answerStateRecord = {}
CorePlayManager.wordProficiency = {}

CorePlayManager.currentScore = 0
CorePlayManager.currentRatio = 0

CorePlayManager.replayWrongWordState = false
CorePlayManager.wrongWordList = {}

CorePlayManager.newPlayerState = false

CorePlayManager.chapterIndex = 3

-- reviewboss scene variate
CorePlayManager.rbWordList = {"apple","pear","water","day","wonder","needle"}


function CorePlayManager.create()
    CorePlayManager.loadConfiguration()
end

function CorePlayManager.loadConfiguration()
    for i = 1, #CorePlayManager.wordList do
        CorePlayManager.answerStateRecord[i] = 0
        CorePlayManager.wordProficiency[i] = 1
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
    end
end

function CorePlayManager.leaveTestLayer()
    s_logd("leave")
end

function CorePlayManager.answerRight()
    CorePlayManager.answerStateRecord[CorePlayManager.currentWordIndex] = 1
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


return CorePlayManager
