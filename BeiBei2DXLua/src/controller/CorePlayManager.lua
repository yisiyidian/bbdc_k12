require "common.global"

local StudyLayer = require("view.StudyLayer")
local TestLayer = require("view.TestLayer")

local CorePlayManager = {}

CorePlayManager.dictionary = {}
CorePlayManager.currentWordIndex = 1
CorePlayManager.wordList = {"apple","pear","water","day"}
CorePlayManager.currentWord = nil
CorePlayManager.answerStateRecord = {}
CorePlayManager.wordProficiency = {}

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


return CorePlayManager
