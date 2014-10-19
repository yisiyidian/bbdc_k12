require "common.global"

local StudyLayer = require("view.StudyLayer")
local TestLayer = require("view.TestLayer")
local ReviewBossLayer = require("view.ReviewBossLayer")

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
    local studyLayer = StudyLayer.create()
    s_SCENE:replaceGameLayer(studyLayer)
end

function CorePlayManager.leaveStudyLayer()
    s_logd("leave")
end

function CorePlayManager.enterTestLayer()
    CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
    local testLayer = TestLayer.create()
    s_SCENE:replaceGameLayer(testLayer)
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
    local reviewBossLayer = ReviewBossLayer.create()
    s_SCENE:replaceGameLayer(reviewBossLayer)
end


return CorePlayManager
