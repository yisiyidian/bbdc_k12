require "common.global"

local StudyLayer = require("view.StudyLayer")
local TestLayer = require("view.TestLayer")

local CorePlayManager = {}

CorePlayManager.dictionary = {}
CorePlayManager.currentWordIndex = 1
CorePlayManager.wordList = {"apple","pear","water"}
CorePlayManager.currentWord = nil

function CorePlayManager.create()
    CorePlayManager.loadConfiguration()
    --CorePlayManager.enterStudyLayer()
end

function CorePlayManager.loadConfiguration()
    for i = 1, #CorePlayManager.wordList do
        CorePlayManager.dictionary[i] = s_WordPool[CorePlayManager.wordList[i]]
    end
    --CorePlayManager.currentWord = CorePlayManager.dictionary[CorePlayManager.currentWordIndex]
end

function CorePlayManager.enterStudyLayer()
    CorePlayManager.currentWord = CorePlayManager.dictionary[CorePlayManager.currentWordIndex]
    local studyLayer = StudyLayer.create()
    s_SCENE:replaceGameLayer(studyLayer)
end

function CorePlayManager.leaveStudyLayer()
    print("leave")
end

function CorePlayManager.enterTestLayer()
    CorePlayManager.currentWord = CorePlayManager.dictionary[CorePlayManager.currentWordIndex]
    local testLayer = TestLayer.create()
    s_SCENE:replaceGameLayer(testLayer)
end

function CorePlayManager.leaveTestLayer()
    print("leave")
end


return CorePlayManager
