require "common.global"

local StudyLayer = require("view.StudyLayer")

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
    print("wordindex.."..CorePlayManager.currentWordIndex)
    CorePlayManager.currentWord = CorePlayManager.dictionary[CorePlayManager.currentWordIndex]
    print("wordindex.."..CorePlayManager.currentWordIndex)
    local studyLayer = StudyLayer.create()
    s_SCENE:replaceGameLayer(studyLayer)
end

function CorePlayManager.leaveStudyLayer()
    print("leave")
end


return CorePlayManager
