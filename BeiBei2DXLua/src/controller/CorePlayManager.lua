require "common.global"

local ReviewBossLayer        = require("view.reviewboss.reviewbossI.ReviewBossLayer")
local ReviewBossLayerII      = require("view.reviewboss.reviewbossII.ReviewBossLayerII")
local ReviewBossLayerIII     = require("view.reviewboss.reviewbossIII.ReviewBossLayerIII")
local IntroLayer             = require("view.login.IntroLayer")
local HomeLayer              = require("view.home.HomeLayer")
local LevelLayer             = require("view.LevelLayer")
local BookLayer              = require("view.book.BookLayer")
local DownloadLayer          = require("view.book.DownloadLayer")
local WordListLayer          = require("view.wordlist.WordList")
local FriendLayer            = require("view.friend.FriendLayer") 

local NewStudyChooseLayer    = require("view.newstudy.NewStudyChooseLayer")
local NewStudyRightLayer     = require("view.newstudy.NewStudyRightLayer")
local NewStudyWrongLayer     = require("view.newstudy.NewStudyWrongLayer")
local NewStudySlideLayer     = require("view.newstudy.NewStudySlideLayer")
local NewStudyMiddleLayer    = require("view.newstudy.NewStudyMiddleLayer")
local NewStudySuccessLayer   = require("view.newstudy.NewStudySuccessLayer")
local NewStudyOverLayer      = require("view.newstudy.NewStudyOverLayer")
local NewStudyBookOverLayer  = require("view.newstudy.NewStudyBookOverLayer")

local ReviewBossMainLayer    = require("view.newreviewboss.NewReviewBossMainLayer")
local ReviewBossHintLayer    = require("view.newreviewboss.NewReviewBossHintLayer")
local ReviewBossSummaryLayer = require("view.newreviewboss.NewReviewBossSummaryLayer")

local CorePlayManager = {}


function CorePlayManager.initTotalPlay()
    local todayReviewBoss = s_LocalDatabaseManager.getTodayReviewBoss()

    if #todayReviewBoss == 0 then
        CorePlayManager.currentBossID = s_LocalDatabaseManager.getMaxBossID()
    else
        CorePlayManager.currentBossID = todayReviewBoss[1]
    end

    CorePlayManager.currentBoss       = s_LocalDatabaseManager.getBossInfo(CorePlayManager.currentBossID)
    CorePlayManager.currentTypeIndex  = CorePlayManager.currentBoss.typeIndex
    CorePlayManager.currentRightWordList   = CorePlayManager.currentBoss.rightWordList
    CorePlayManager.currentWrongWordList   = CorePlayManager.currentBoss.wrongWordList 


    if     CorePlayManager.currentTypeIndex == 0 then
        -- study   model
        CorePlayManager.initStudyModel()
    elseif CorePlayManager.currentTypeIndex == 1 then
        -- test    model
        CorePlayManager.initTestModel()
    elseif CorePlayManager.currentTypeIndex == 2 then
        -- review  model
        CorePlayManager.initReviewModel()
    elseif CorePlayManager.currentTypeIndex == 3 then
        -- summary model
        CorePlayManager.initSummaryModel()
    elseif CorePlayManager.currentTypeIndex >= 4 and CorePlayManager.currentTypeIndex <= 7 then
        -- review model
        CorePlayManager.initReviewModel()
    elseif CorePlayManager.currentBossState == 8 then
        -- over model
        CorePlayManager.initOverModel()
    else
        -- default model
        CorePlayManager.initOverModel()
    end
end

function CorePlayManager.initStudyModel()
    CorePlayManager.BookWordList          = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex          = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum          = #CorePlayManager.currentWrongWordList

    local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
    CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum)
end

function CorePlayManager.enterStudyModel(wordName, wrongWordNum)
    if wordName == nil then
        -- book over
        -- TODO
    else
        local CollectUnfamiliarLayer = require("view.newstudy.CollectUnfamiliarLayer")
        local collectUnfamiliarLayer = CollectUnfamiliarLayer.create(wordName, wrongWordNum)
        s_SCENE:replaceGameLayer(collectUnfamiliarLayer)
    end
end

function CorePlayManager.leaveStudyModel(state)
    if state == true then
        print('answer right')
        s_LocalDatabaseManager.addRightWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
        s_CURRENT_USER.levelInfo:setCurrentWordIndex(CorePlayManager.currentIndex)

        local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
        CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum)
    else
        print('answer wrong')
        local isNewBossBirth = s_LocalDatabaseManager.addWrongWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
        s_CURRENT_USER.levelInfo:setCurrentWordIndex(CorePlayManager.currentIndex)

        CorePlayManager.wrongWordNum = CorePlayManager.wrongWordNum + 1

        if isNewBossBirth then
            -- do collect enough words
            CorePlayManager.enterStudyOverModel()
        else
            -- do not collect enough words
            local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
            CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum)
        end
    end
end

function CorePlayManager.enterStudyOverModel()
    local MiddleLayer = require("view.newstudy.MiddleLayer")
    local middleLayer = MiddleLayer.create()
    s_SCENE:replaceGameLayer(middleLayer)
end

function CorePlayManager.leaveStudyOverModel()
    CorePlayManager.enterLevelLayer()
end


function CorePlayManager.initTestModel()

end

function CorePlayManager.initReviewModel()
end

function CorePlayManager.initSummaryModel()
end

function CorePlayManager.initOverModel()
end

function CorePlayManager.enterTestModel(wordList)

end

function CorePlayManager.leaveTest(state)

end

function CorePlayManager.enterReviewModel(wordlist)

end

function CorePlayManager.leaveReview(state)

end

function CorePlayManager.enterSummaryModel(wordlist)

end

function CorePlayManager.leaveSummary(state)

end

function CorePlayManager.enterIntroLayer()
    local IntroLayer = IntroLayer.create(false)
    s_SCENE:replaceGameLayer(IntroLayer)
end

function CorePlayManager.enterHomeLayer()
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
end

function CorePlayManager.enterLevelLayer()
    local testLayer = require('view.ChapterLayer')
    local chapterLayer = testLayer.create()
    s_SCENE:replaceGameLayer(chapterLayer)
end

function CorePlayManager.enterBookLayer()
    local bookLayer = BookLayer.create()
    s_SCENE:replaceGameLayer(bookLayer)
end

function CorePlayManager.enterDownloadLayer(bookKey)
    local downloadLayer = DownloadLayer.create(bookKey)
    s_SCENE:replaceGameLayer(downloadLayer)
end

function CorePlayManager.enterWordListLayer()
    local wordListlayer = WordListLayer.create()
    s_SCENE:replaceGameLayer(wordListlayer)
end

function CorePlayManager.enterFriendLayer()
    local friendLayer = FriendLayer.create()
    s_SCENE:replaceGameLayer(friendLayer)
end

return CorePlayManager
