require "common.global"

local StudyLayer            = require("view.study.studyI.StudyLayer")
local StudyLayerII          = require("view.study.studyII.StudyLayerII")
--local StudyLayerIII         = require("view.study.studyIII.StudyLayerIII")
local TestLayer             = require("view.test.testI.TestLayer")
local TestLayerII           = require("view.test.testII.TestLayerII")
--local TestLayerIII          = require("view.test.testIII.TestLayerIII")
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
--    local studyLayer = StudyLayer.create()
--    s_SCENE:replaceGameLayer(studyLayer)
    local studyLayerII = StudyLayerII.create()
    s_SCENE:replaceGameLayer(studyLayerII)
end

function CorePlayManager.leaveStudyLayer()
    s_logd("leave")
end

function CorePlayManager.enterTestLayer()
    CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
--    local testLayer = TestLayer.create()
--    s_SCENE:replaceGameLayer(testLayer)
    local testLayerII = TestLayerII.create()
    s_SCENE:replaceGameLayer(testLayerII)
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
--    local reviewBossLayer = ReviewBossLayer.create()
--    s_SCENE:replaceGameLayer(reviewBossLayer)
--    local reviewBossLayerII = ReviewBossLayerII.create()
--    s_SCENE:replaceGameLayer(reviewBossLayerII)
    local reviewBossLayerIII = ReviewBossLayerIII.create()
    s_SCENE:replaceGameLayer(reviewBossLayerIII)
end


return CorePlayManager
