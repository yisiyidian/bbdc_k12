require "common.global"

local StudyLayer = require("view.StudyLayer")
local TestLayer = require("view.TestLayer")
local ReviewBossLayer = require("view.ReviewBossLayer")

local CorePlayManager = {}

-- study scene and test scene variate
CorePlayManager.dictionary = {}
CorePlayManager.currentWordIndex = 1
CorePlayManager.wordList = {"apple","pear","water","day"}
CorePlayManager.currentWord = nil
CorePlayManager.answerStateRecord = {}
CorePlayManager.wordProficiency = {}

-- study scene and test scene variate
CorePlayManager.rbWordList = {"apple","pear","water","day","sun","moon","book"}
CorePlayManager.rbCurrentWordIndex = 1
CorePlayManager.rbDictionary = {}
CorePlayManager.rbCurrentWord = nil


function CorePlayManager.create()
    CorePlayManager.loadConfiguration()
    --CorePlayManager.enterStudyLayer()
end

function CorePlayManager.loadConfiguration()
    for i = 1, #CorePlayManager.wordList do
        CorePlayManager.dictionary[i] = s_WordPool[CorePlayManager.wordList[i]]
        CorePlayManager.answerStateRecord[i] = 0
        CorePlayManager.wordProficiency[i] = 1
    end
end

function CorePlayManager.enterStudyLayer()
    CorePlayManager.currentWord = CorePlayManager.dictionary[CorePlayManager.currentWordIndex]
    local studyLayer = StudyLayer.create()
    s_SCENE:replaceGameLayer(studyLayer)
end

function CorePlayManager.leaveStudyLayer()
    s_logd("leave")
end

function CorePlayManager.enterTestLayer()
    CorePlayManager.currentWord = CorePlayManager.dictionary[CorePlayManager.currentWordIndex]
    local testLayer = TestLayer.create()
    s_SCENE:replaceGameLayer(testLayer)
end

function CorePlayManager.leaveTestLayer()
    s_logd("leave")
end

function CorePlayManager.answerRight()
    CorePlayManager.answerStateRecord[CorePlayManager.currentWordIndex] = 1
end

function CorePlayManager.enterReviewBossLayer()
    CorePlayManager.rbCurrentWordIndex = 1
    for i = 1, #CorePlayManager.rbWordList do
        CorePlayManager.rbDictionary[i] = s_WordPool[CorePlayManager.rbWordList[i]]
    end

    local reviewBossLayer = ReviewBossLayer.create()
    s_SCENE:replaceGameLayer(reviewBossLayer)
end


return CorePlayManager
