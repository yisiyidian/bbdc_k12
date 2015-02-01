require "common.global"

local StudyLayer             = require("view.study.studyI.StudyLayer")
local StudyLayerII           = require("view.study.studyII.StudyLayerII")
local StudyLayerIII          = require("view.study.studyIII.StudyLayerIII")
local StudyLayerIV           = require("view.study.studyIV.StudyLayerIV")
local TestLayer              = require("view.test.testI.TestLayer")
local TestLayerII            = require("view.test.testII.TestLayerII")
local TestLayerIII           = require("view.test.testIII.TestLayerIII")
local TestLayerIV            = require("view.test.testIV.TestLayerIV")
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

local ZiaoangTestLayer       = require("view.ZiaoangTest")

local CorePlayManager = {}

function CorePlayManager.create()
    CorePlayManager.loadConfiguration()
end

function CorePlayManager.getBossState()
    -- if review boss exist
    -- get latest
    
    bossList = {}
    table.insert(bossList, 4)
    table.insert(bossList, 4)
    table.insert(bossList, 0)

    return bossList
end

function CorePlayManager.initTotalPlay()  
    -- local gameState = s_LocalDatabaseManager.getGameState()
    -- if gameState == s_gamestate_reviewbossmodel_beforetoday then
    --     CorePlayManager.initNewReviewBossRewardAndTotalWord()
    --     local candidate = CorePlayManager.getReviewBossCandidate()
    --     CorePlayManager.initNewReviewBossLayer(candidate)
    --     AnalyticsReviewBoss()
    -- elseif gameState == s_gamestate_studymodel or gameState == s_gamestate_reviewmodel or  gameState == s_gamestate_studymodel_extra or  gameState == s_gamestate_reviewmodel_extra then
    --     CorePlayManager.initNewStudyReward()
    --     CorePlayManager.initNewStudyLayer()
    -- elseif gameState == s_gamestate_reviewbossmodel_today then
    --     CorePlayManager.initNewReviewBossRewardAndTotalWord()
    --     local candidate = CorePlayManager.getReviewBossCandidateToday()
    --     CorePlayManager.initNewReviewBossLayer(candidate)
    -- end
    
    CorePlayManager.enterCoreControl()

end


function CorePlayManager.enterCoreControl()
    CorePlayManager.currentBossID    = 1
    CorePlayManager.currentBossState = 0

    if     CorePlayManager.currentBossState == 0 then   -- study   model
        CorePlayManager.initStudyModel()
    elseif CorePlayManager.currentBossState == 1 then   -- test    model
        CorePlayManager.initTestModel()
    elseif CorePlayManager.currentBossState == 2 then   -- review  model
        CorePlayManager.initReviewModel(0)
    elseif CorePlayManager.currentBossState == 3 then   -- summary model
        CorePlayManager.initSummaryModel()
    elseif CorePlayManager.currentBossState == 4 then   -- review1 model
        CorePlayManager.initReviewModel(1)
    elseif CorePlayManager.currentBossState == 5 then   -- review2 model
        CorePlayManager.initReviewModel(2)
    elseif CorePlayManager.currentBossState == 6 then   -- review3 model
        CorePlayManager.initReviewModel(3)
    elseif CorePlayManager.currentBossState == 7 then   -- review4 model
        CorePlayManager.initReviewModel(4)
    elseif CorePlayManager.currentBossState == 8 then   -- over    model
        CorePlayManager.initOverModel()
    end
end

-- init model
function CorePlayManager.initStudyModel()
    CorePlayManager.NewStudyLayerWordList = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum = 0

    local wordName = CorePlayManager.NewStudyLayerWordList[CorePlayManager.currentIndex]
    CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum)
end

function CorePlayManager.initTestModel()

end

function CorePlayManager.initReviewModel(reviewNum)
end

function CorePlayManager.initSummaryModel()
end

function CorePlayManager.initOverModel()
end


function CorePlayManager.enterStudyModel(wordName, wrongWordNum)
    local CollectUnfamiliarLayer = require("view.newstudy.CollectUnfamiliarLayer")
    local collectUnfamiliarLayer = CollectUnfamiliarLayer.create(wordName, wrongWordNum)
    s_SCENE:replaceGameLayer(collectUnfamiliarLayer)
end

function CorePlayManager.leaveStudyModel(state)
    if state == true then
        print('answer right')
        s_LocalDatabaseManager.addRightWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
        s_CURRENT_USER.levelInfo:setCurrentWordIndex(CorePlayManager.currentIndex)
        -- s_CURRENT_USER.levelInfo:sysData()

        local wordName = CorePlayManager.NewStudyLayerWordList[CorePlayManager.currentIndex]
        CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum)
    else
        print('answer wrong')
        s_LocalDatabaseManager.addWrongWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.wrongWordNum = CorePlayManager.wrongWordNum + 1
        s_CURRENT_USER.levelInfo:setCurrentWordIndex(CorePlayManager.currentIndex)
        -- s_CURRENT_USER.levelInfo:sysData()

        if CorePlayManager.wrongWordNum == s_max_wrong_num_everyday then
            -- do collect enough words
            CorePlayManager.enterStudyOverModel()
        else
            -- do not collect enough words
            CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
            local wordName = CorePlayManager.NewStudyLayerWordList[CorePlayManager.currentIndex]
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






function CorePlayManager.getProgress()
    local lastPlayState = s_LocalDatabaseManager.getNewPlayState()
    if lastPlayState.lastUpdate == nil then
        return 0
    else
        local lastupdate              = lastPlayState.lastUpdate
        local lastupdate_day          = os.date("%x", lastupdate)
        local current_day             = os.date("%x", os.time())
        if lastupdate_day == current_day then
            -- 0 for study and 1 for review and 2 for play over
            if lastPlayState.playModel == 0 then
                local wrongWordList
                local wordCandidate
                if lastPlayState.wrongWordList == "" then
                    wrongWordList = {}
                else
                    wrongWordList = split(lastPlayState.wrongWordList, "|")
                end
                if lastPlayState.wordCandidate == "" then
                    wordCandidate = {}
                else
                    wordCandidate = split(lastPlayState.wordCandidate, "|")
                end
                return #wrongWordList - #wordCandidate 
            elseif lastPlayState.playModel == 1 then
                if lastPlayState.wrongWordList == "" then
                    return 0
                else
                    local wrongWordList = split(lastPlayState.wrongWordList, "|")
                    local wordCandidate = split(lastPlayState.wordCandidate, "|")
                    return #wrongWordList * 2 - #wordCandidate
                end
            elseif lastPlayState.playModel == 2 then
                return s_max_wrong_num_everyday * 2
            end
        else
            return 0
        end
    end 
end

function CorePlayManager.initNewStudyLayer()
    CorePlayManager.maxWrongWordCount = s_max_wrong_num_everyday
    CorePlayManager.NewStudyLayerWordList = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    print("currentBookWordIndex is "..CorePlayManager.currentIndex)
    
    if CorePlayManager.bookOver() then
        CorePlayManager.enterNewStudyBookOverLayer()
        return
    end
    
--    local lastPlayState = s_LocalDatabaseManager.getNewPlayState()
--    if lastPlayState.lastUpdate == nil then
--        print("lastPlayStateRecord not exist...")
--        CorePlayManager.playModel     = 0 -- 0 for study and 1 for review and 2 for play over
--        CorePlayManager.rightWordList = {}
--        CorePlayManager.wrongWordList = {}
--        CorePlayManager.wordCandidate = {}
--        CorePlayManager.rightWordNum  = 0
--        CorePlayManager.wrongWordNum  = 0
--        CorePlayManager.candidateNum  = 0
--        CorePlayManager.enterNewStudyChooseLayer()
--    else
--        -- day format is a string like "11/16/14", as month + day + year
--        local lastupdate              = lastPlayState.lastUpdate
--        local lastupdate_day          = os.date("%x", lastupdate)
--        local current_day             = os.date("%x", os.time())
--        if lastupdate_day == current_day then
--            print("lastPlayStateRecord is today...")
--            CorePlayManager.playModel     = lastPlayState.playModel
--            if CorePlayManager.playModel == 2 then
--                print("lastPlayStateRecord is today but over...")
--                CorePlayManager.enterNewStudyOverLayer()
--            else
--                print("lastPlayStateRecord is today and not over...")
--                if lastPlayState.rightWordList == "" then
--                    CorePlayManager.rightWordList = {}
--                else
--                    CorePlayManager.rightWordList = split(lastPlayState.rightWordList, "|")
--                end
--                if lastPlayState.wrongWordList == "" then
--                    CorePlayManager.wrongWordList = {}
--                else
--                    CorePlayManager.wrongWordList = split(lastPlayState.wrongWordList, "|")
--                end
--                if lastPlayState.wordCandidate == "" then
--                    CorePlayManager.wordCandidate = {}
--                else
--                    CorePlayManager.wordCandidate = split(lastPlayState.wordCandidate, "|")
--                end
--                CorePlayManager.rightWordNum  = #CorePlayManager.rightWordList
--                CorePlayManager.wrongWordNum  = #CorePlayManager.wrongWordList
--                CorePlayManager.candidateNum  = #CorePlayManager.wordCandidate
--                print("right word list: "..lastPlayState.rightWordList)
--                print("wrong word list: "..lastPlayState.wrongWordList)
--                print("candidate word list: "..lastPlayState.wordCandidate)
--                CorePlayManager.enterNewStudyChooseLayer()
--            end
--        else
--            print("lastPlayStateRecord is before today...")
--            CorePlayManager.playModel     = 0
--            CorePlayManager.rightWordList = {}
--            CorePlayManager.wrongWordList = {}
--            CorePlayManager.wordCandidate = {}
--            CorePlayManager.rightWordNum  = 0
--            CorePlayManager.wrongWordNum  = 0
--            CorePlayManager.candidateNum  = 0
--            CorePlayManager.enterNewStudyChooseLayer()
--        end
--    end

    local lastPlayState = s_LocalDatabaseManager.getNewPlayState()
    s_LocalDatabaseManager.addOrdinalNum(0)
    if lastPlayState.lastUpdate == nil then
        print("lastPlayStateRecord not exist...")
        CorePlayManager.playModel     = 0 -- 0 for study and 1 for review and 2 for play over
        CorePlayManager.rightWordList = {}
        CorePlayManager.wrongWordList = {}
        CorePlayManager.wordCandidate = {}
        CorePlayManager.rightWordNum  = 0
        CorePlayManager.wrongWordNum  = 0
        CorePlayManager.candidateNum  = 0
        CorePlayManager.ordinalNum    = s_LocalDatabaseManager.getOrdinalNum()
        CorePlayManager.enterNewStudyChooseLayer()
    else
        -- day format is a string like "11/16/14", as month + day + year
        local lastupdate              = lastPlayState.lastUpdate
        local lastupdate_day          = os.date("%x", lastupdate)
        local current_day             = os.date("%x", os.time())
        CorePlayManager.playModel     = lastPlayState.playModel
        if CorePlayManager.playModel == 2 then
            print("lastPlayStateRecord is over and begin new ...")
            CorePlayManager.playModel     = 0
            CorePlayManager.rightWordList = {}
            CorePlayManager.wrongWordList = {}
            CorePlayManager.wordCandidate = {}
            CorePlayManager.rightWordNum  = 0
            CorePlayManager.wrongWordNum  = 0
            CorePlayManager.candidateNum  = 0
            s_LocalDatabaseManager.addOrdinalNum(1)
            CorePlayManager.ordinalNum    = s_LocalDatabaseManager.getOrdinalNum()
            CorePlayManager.enterNewStudyChooseLayer()
        else
            print("lastPlayStateRecord is not over...")
            if lastPlayState.rightWordList == "" then
                CorePlayManager.rightWordList = {}
            else
                CorePlayManager.rightWordList = split(lastPlayState.rightWordList, "|")
            end
            if lastPlayState.wrongWordList == "" then
                CorePlayManager.wrongWordList = {}
            else
                CorePlayManager.wrongWordList = split(lastPlayState.wrongWordList, "|")
            end
            if lastPlayState.wordCandidate == "" then
                CorePlayManager.wordCandidate = {}
            else
                CorePlayManager.wordCandidate = split(lastPlayState.wordCandidate, "|")
            end
            CorePlayManager.rightWordNum  = #CorePlayManager.rightWordList
            CorePlayManager.wrongWordNum  = #CorePlayManager.wrongWordList
            CorePlayManager.candidateNum  = #CorePlayManager.wordCandidate
            CorePlayManager.ordinalNum    = s_LocalDatabaseManager.getOrdinalNum()
            if lastPlayState.playModel == 0 and CorePlayManager.wrongWordNum ~= nil then
                if CorePlayManager.wrongWordNum >= CorePlayManager.maxWrongWordCount then
                    CorePlayManager.initWordCandidate()
                    CorePlayManager.checkInReviewModel()
                    CorePlayManager.enterNewStudyMiddleLayer()
                    return
                end
            end
            print("right word list: "..lastPlayState.rightWordList)
            print("wrong word list: "..lastPlayState.wrongWordList)
            print("candidate word list: "..lastPlayState.wordCandidate)
            CorePlayManager.enterNewStudyChooseLayer()
        end
    end
end

function CorePlayManager.bookOver()
    if CorePlayManager.currentIndex > s_DataManager.books[s_CURRENT_USER.bookKey].words then
        return true
    else
        return false
    end
end

function CorePlayManager.recordStudyStateIntoDB()
    s_CURRENT_USER.levelInfo:setCurrentWordIndex(CorePlayManager.currentIndex)
    s_CURRENT_USER.levelInfo:sysData()

    local rightWordListString = changeTableToString(CorePlayManager.rightWordList)
    local wrongWordListString = changeTableToString(CorePlayManager.wrongWordList)
    local wordCandidateString = changeTableToString(CorePlayManager.wordCandidate)
    
    s_LocalDatabaseManager.setNewPlayState(CorePlayManager.playModel, rightWordListString, wrongWordListString, wordCandidateString)
    s_LocalDatabaseManager.printNewPlayState()
end

function CorePlayManager.checkInStudyModel()
    CorePlayManager.playModel = 0
    CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.checkInReviewModel()
    CorePlayManager.playModel = 1
    CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.checkInOverModel()
    CorePlayManager.playModel = 2
    CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.isStudyModel()
    if CorePlayManager.playModel == 0 then
        return true
    else
        return false
    end
end

function CorePlayManager.isReviewModel()
    if CorePlayManager.playModel == 1 then
        return true
    else
        return false
    end
end

function CorePlayManager.isOverModel()
    if CorePlayManager.playModel == 2 then
        return true
    else
        return false
    end
end

function CorePlayManager.initWordCandidate()
    for i = 1, CorePlayManager.wrongWordNum do
        table.insert(CorePlayManager.wordCandidate, CorePlayManager.wrongWordList[i])
    end
    CorePlayManager.candidateNum = CorePlayManager.wrongWordNum
    
    s_CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.updateWordCandidate(isInsertTail)
    if isInsertTail then
        table.insert(CorePlayManager.wordCandidate, CorePlayManager.wordCandidate[1])
        table.remove(CorePlayManager.wordCandidate, 1)
    else
        table.remove(CorePlayManager.wordCandidate, 1)
        CorePlayManager.candidateNum = CorePlayManager.candidateNum - 1
    end
    
    s_CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.enterNewStudyChooseLayer()
    local newStudyChooseLayer = NewStudyChooseLayer.create()
    s_SCENE:replaceGameLayer(newStudyChooseLayer)
end

function CorePlayManager.enterNewStudySlideLayer()
    local newStudySlideLayer = NewStudySlideLayer.create()
    s_SCENE:replaceGameLayer(newStudySlideLayer)
end

function CorePlayManager.enterNewStudyRightLayer()
    local newStudyRightLayer = NewStudyRightLayer.create()
    s_SCENE:replaceGameLayer(newStudyRightLayer)
end

function CorePlayManager.enterNewStudyWrongLayer()
    local newStudyWrongLayer = NewStudyWrongLayer.create()
    s_SCENE:replaceGameLayer(newStudyWrongLayer)
end

function CorePlayManager.enterNewStudyMiddleLayer()
    local newStudyMiddleLayer = NewStudyMiddleLayer.create()
    s_SCENE:replaceGameLayer(newStudyMiddleLayer)
end

function CorePlayManager.enterNewStudySuccessLayer()
    local newStudySuccessLayer = NewStudySuccessLayer.create()
    s_SCENE:replaceGameLayer(newStudySuccessLayer)
end

function CorePlayManager.enterNewStudyOverLayer()
    local newStudyOverLayer = NewStudyOverLayer.create()
    s_SCENE:replaceGameLayer(newStudyOverLayer)
end

function CorePlayManager.enterNewStudyBookOverLayer()
    local newStudyBookOverLayer = NewStudyBookOverLayer.create()
    s_SCENE:replaceGameLayer(newStudyBookOverLayer)
end

function CorePlayManager.updateCurrentIndex()
    s_LocalDatabaseManager.addStudyWordsNum()
    CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
    
    s_CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.updateRightWordList(wordname)
    s_LocalDatabaseManager.addGraspWordsNum(1)

    table.insert(CorePlayManager.rightWordList, wordname)
    CorePlayManager.rightWordNum = CorePlayManager.rightWordNum + 1
    
    s_CorePlayManager.recordStudyStateIntoDB()
end

function CorePlayManager.updateWrongWordList(wordname)
    s_LocalDatabaseManager.addWrongWordBuffer(wordname)
    s_LocalDatabaseManager.printWrongWordBuffer()
    s_LocalDatabaseManager.printBossWord()
    
    table.insert(CorePlayManager.wrongWordList, wordname)
    CorePlayManager.wrongWordNum = CorePlayManager.wrongWordNum + 1
    
    s_CorePlayManager.recordStudyStateIntoDB()
end


-- new review boss
function CorePlayManager.getReviewBossCandidate() -- if not exist candidate will return nil
    return s_LocalDatabaseManager.getBossWordBeforeToday()
end

function CorePlayManager.getReviewBossCandidateToday()
    return s_LocalDatabaseManager.getBossWordBeforeToday()
end

function CorePlayManager.updateReviewBoss(bossID)
    if bossID > 0 then
        s_LocalDatabaseManager.updateBossWord(bossID)
        s_LocalDatabaseManager.printBossWord()
    end
end

function CorePlayManager.initNewReviewBossRewardAndTotalWord()
    CorePlayManager.reward = 0
    CorePlayManager.totalWord = 0
end

function CorePlayManager.initNewStudyReward()
    CorePlayManager.reward = 3
end

function CorePlayManager.initNewReviewBossLayer(candidate)

    
    if candidate == nil then
        CorePlayManager.bossID                  = -1
        CorePlayManager.typeIndex               = 0
        CorePlayManager.NewReviewLayerWordList  = s_BookWord[s_CURRENT_USER.bookKey]
        CorePlayManager.currentReviewIndex      = 1
        CorePlayManager.currentReward           = 3
        CorePlayManager.ReviewWordList          = {
            "quotation","drama","critical","observer","open",
            "progress","entitle","blank","honourable","single",
            "namely","perfume","matter","lump","thousand",
            "recorder","great","guest","spy","cousin"
                                                  }
        CorePlayManager.maxReviewWordCount      = #CorePlayManager.ReviewWordList
        CorePlayManager.rightReviewWordNum      = 0
    else
        CorePlayManager.bossID                  = candidate.bossID
        CorePlayManager.typeIndex               = candidate.typeIndex -- from 0 to 3
        CorePlayManager.wordList                = candidate.wordList -- wordlist format is like 'apple|pear|orange'

        CorePlayManager.NewReviewLayerWordList  = s_BookWord[s_CURRENT_USER.bookKey]
        CorePlayManager.currentReviewIndex      = 1
        CorePlayManager.currentReward           = 3
        CorePlayManager.ReviewWordList          = split(CorePlayManager.wordList, "|")
        CorePlayManager.maxReviewWordCount      = #CorePlayManager.ReviewWordList
        CorePlayManager.rightReviewWordNum      = 0
    end
    
    CorePlayManager.enterReviewBossMainLayer()
end


function CorePlayManager.updateReviewRewardAndTotalWord()
    local wordList = {}
    table.foreachi(CorePlayManager.ReviewWordList, function(i, v)
        if CorePlayManager.ReviewWordList[i] ~= "" then
            table.insert(wordList,CorePlayManager.ReviewWordList[i] )
        end
    end) 
    local wordListLen = table.getn(wordList)  
    CorePlayManager.reward = CorePlayManager.reward + CorePlayManager.currentReward 
    CorePlayManager.totalWord = CorePlayManager.totalWord + wordListLen
end

function CorePlayManager.minusReviewReward()
    CorePlayManager.currentReward = CorePlayManager.currentReward  - 1
end

function CorePlayManager.initReviewReward()
	CorePlayManager.currentReward = 3
end

function CorePlayManager.updateRightReviewWordNum()
    CorePlayManager.rightReviewWordNum = CorePlayManager.rightReviewWordNum + 1
end

function CorePlayManager.enterReviewBossMainLayer()
    local reviewBossMainLayer = ReviewBossMainLayer.create()
    s_SCENE:replaceGameLayer(reviewBossMainLayer)
end

function CorePlayManager.enterReviewBossHintLayer()
    local reviewBossHintLayer = ReviewBossHintLayer.create()
    s_SCENE:replaceGameLayer(reviewBossHintLayer)
end

function CorePlayManager.enterReviewBossSummaryLayer()
    local reviewBossSummaryLayer = ReviewBossSummaryLayer.create()
    s_SCENE:replaceGameLayer(reviewBossSummaryLayer)
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
    cc.SimpleAudioEngine:getInstance():stopMusic()
    
    if s_CURRENT_USER.tutorialStep == s_tutorial_study then
        CorePlayManager.newPlayerState = true
    else
        CorePlayManager.newPlayerState = false
    end
    
    if CorePlayManager.replayWrongWordState then
        CorePlayManager.currentWord = s_WordPool[CorePlayManager.wrongWordList[CorePlayManager.currentWordIndex]]
    else
        CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
    end
    
    if s_CURRENT_USER.currentSelectedChapterKey == "chapter0" then
        local studyLayer = StudyLayer.create()
        s_SCENE:replaceGameLayer(studyLayer)
    elseif s_CURRENT_USER.currentSelectedChapterKey == "chapter1" then
        local studyLayerII = StudyLayerII.create()
        s_SCENE:replaceGameLayer(studyLayerII)
    elseif s_CURRENT_USER.currentSelectedChapterKey == "chapter2" then
        local studyLayerIII = StudyLayerIII.create()
        s_SCENE:replaceGameLayer(studyLayerIII)
    else
        local studyLayerIII = StudyLayerIII.create()
        s_SCENE:replaceGameLayer(studyLayerIII)
    end
end

function CorePlayManager.leaveStudyLayer()
    s_logd("leave")
end

function CorePlayManager.enterTestLayer()
    s_SCENE.gameLayerState = s_test_game_state
    CorePlayManager.currentWord = s_WordPool[CorePlayManager.wordList[CorePlayManager.currentWordIndex]]
--    s_SCENE.gameLayerState = s_test_game_state
    if s_CURRENT_USER.currentSelectedChapterKey == "chapter0" then
        local testLayer = TestLayer.create()
        s_SCENE:replaceGameLayer(testLayer)
    elseif s_CURRENT_USER.currentSelectedChapterKey == "chapter1" then
        local testLayerII = TestLayerII.create()
        s_SCENE:replaceGameLayer(testLayerII)
    elseif s_CURRENT_USER.currentSelectedChapterKey == "chapter2" then
        local testLayerIII = TestLayerIII.create()
        s_SCENE:replaceGameLayer(testLayerIII)
    else
        local testLayerIII = TestLayerIII.create()
        s_SCENE:replaceGameLayer(testLayerIII)
    end
end

function CorePlayManager.leaveTestLayer()
--    s_SCENE.gameLayerState = s_normal_game_state
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
        s_CURRENT_USER.wordsCount = s_CURRENT_USER.wordsCount + 1
        if CorePlayManager.wordProficiency[i] == 0 then
            s_logd("word: "..CorePlayManager.wordList[i].." pro:0")
            s_LocalDatabaseManager.insertTable_DataWordProciency(CorePlayManager.wordList[i], 0)
        else
            s_CURRENT_USER.masterCount = s_CURRENT_USER.masterCount + 1
            s_logd("word: "..CorePlayManager.wordList[i].." pro:5")
            s_LocalDatabaseManager.insertTable_DataWordProciency(CorePlayManager.wordList[i], 5)
        end
    end

    saveUserToServer({['wordsCount']=s_CURRENT_USER.wordsCount, ['masterCount']=s_CURRENT_USER.masterCount})
end

function CorePlayManager.enterReviewBossLayer_special()
--    s_SCENE.gameLayerState = s_boss_game_state
    local levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentSelectedChapterKey,"level0")
    CorePlayManager.rbWordList = split(levelConfig.word_content, "|")
    local reviewBossLayer = ReviewBossLayer.create()
    s_SCENE:replaceGameLayer(reviewBossLayer)
--        local reviewBossLayerII = ReviewBossLayerII.create()
--        s_SCENE:replaceGameLayer(reviewBossLayerII)
--        local reviewBossLayerIII = ReviewBossLayerIII.create()
--        s_SCENE:replaceGameLayer(reviewBossLayerIII)
end

function CorePlayManager.enterReviewBossLayer()
--    s_SCENE.gameLayerState = s_boss_game_state
    local bossID = s_LocalDatabaseManager.getCurrentReviewBossID()
    CorePlayManager.rbWordList = s_LocalDatabaseManager.getRBWordList(bossID)
    if #CorePlayManager.rbWordList < 3 then
        return
    end

    if s_CURRENT_USER.currentSelectedChapterKey == "chapter0" then
        local reviewBossLayer = ReviewBossLayer.create()
        s_SCENE:replaceGameLayer(reviewBossLayer)
--        local reviewBossLayerII = ReviewBossLayerII.create()
--        s_SCENE:replaceGameLayer(reviewBossLayerII)
--        local reviewBossLayerIII = ReviewBossLayerIII.create()
--        s_SCENE:replaceGameLayer(reviewBossLayerIII)
    elseif s_CURRENT_USER.currentSelectedChapterKey == "chapter1" then
        local reviewBossLayerII = ReviewBossLayerII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerII)
    elseif s_CURRENT_USER.currentSelectedChapterKey == "chapter2" then
        local reviewBossLayerIII = ReviewBossLayerIII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerIII)
    else
        -- s_logd("system error")
        -- s_logd(s_CURRENT_USER.currentSelectedChapterKey)
        local reviewBossLayerIII = ReviewBossLayerIII.create()
        s_SCENE:replaceGameLayer(reviewBossLayerIII)
    end
end

function CorePlayManager.leaveReviewBossLayer()
--    s_SCENE.gameLayerState = s_normal_game_state
    --s_LocalDatabaseManager.updateReviewBossRecord(s_LocalDatabaseManager.getCurrentReviewBossID())
    s_SCENE.levelLayerState = s_review_boss_pass_state
    CorePlayManager.enterLevelLayer()
end

function CorePlayManager.enterIntroLayer()
    local IntroLayer = IntroLayer.create(false)
    s_SCENE:replaceGameLayer(IntroLayer)
end

function CorePlayManager.enterHomeLayer()
--    local testLayer = require('view.ChapterLayer')
--    local chapterLayer = testLayer.create()
--    s_SCENE:replaceGameLayer(chapterLayer)
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
end

function CorePlayManager.enterLevelLayer()
--    CorePlayManager.enterHomeLayer()
    local testLayer = require('view.ChapterLayer')
    local chapterLayer = testLayer.create()
    s_SCENE:replaceGameLayer(chapterLayer)
--    local levelLayer = LevelLayer.create()
--    s_SCENE:replaceGameLayer(levelLayer)
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
