require "common.global"

local IntroLayer             = require("view.login.IntroLayer")
local HomeLayer              = require("view.home.HomeLayer")
local BookLayer              = require("view.book.BookLayer")
local EducationLayer         = require("view.book.EducationSelect")
local DownloadLayer          = require("view.book.DownloadLayer")
local FriendLayer            = require("view.friend.FriendLayer") 


local CorePlayManager = {}


function CorePlayManager.initTotalPlay()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()

    CorePlayManager.currentBossID = nil
    for i = 1, #bossList do
        local boss = bossList[i]
        -- print("boss info")
        -- print(boss.bossID)
        -- print(boss.coolingDay)
        if boss.typeIndex >= 4 and boss.typeIndex <= 7 then
            if boss.coolingDay == 0 then
                CorePlayManager.currentBossID = boss.bossID
                break
            else
                -- pass
            end
        elseif boss.typeIndex == 8 then
            -- pass
        else
            CorePlayManager.currentBossID = boss.bossID
            break
        end
    end

    if CorePlayManager.currentBossID == nil then
        -- pass all
    else
        -- exist boss
    end

    CorePlayManager.currentBoss            = s_LocalDatabaseManager.getBossInfo(CorePlayManager.currentBossID)
    CorePlayManager.currentTypeIndex       = CorePlayManager.currentBoss.typeIndex
    CorePlayManager.currentRightWordList   = CorePlayManager.currentBoss.rightWordList
    CorePlayManager.currentWrongWordList   = CorePlayManager.currentBoss.wrongWordList 
    
    CorePlayManager.BookWordList          = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex          = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum          = #CorePlayManager.currentWrongWordList

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
    else
        -- over model
        CorePlayManager.initOverModel()
    end
end


function CorePlayManager.initStudyModel()
    CorePlayManager.BookWordList          = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex          = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum          = #CorePlayManager.currentWrongWordList

    CorePlayManager.preWordName           = CorePlayManager.BookWordList[CorePlayManager.currentIndex-1]
    CorePlayManager.preWordNameState      = s_LocalDatabaseManager.getPrevWordState()

    -- local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
    -- CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum, CorePlayManager.preWordName, CorePlayManager.preWordNameState)
    CorePlayManager.leaveStudyModel(false)
end

-- TODO remove study-related function

function CorePlayManager.enterStudyModel(wordName, wrongWordNum, preWordName, preWordNameState)
    if wordName == nil then
        -- book over
        -- TODO
    else
        if preWordName ~= nil then
            print("preWordName: "..preWordName)
            if preWordNameState then
                print("preWordNameState: true")
            else
                print("preWordNameState: false")
            end
        end
        
        local ChooseCollectWordLayer = require("view.newstudy.ChooseCollectWordLayer")
        local chooseCollectWordLayer = ChooseCollectWordLayer.create(wordName, wrongWordNum, preWordName, preWordNameState)
        s_SCENE:replaceGameLayer(chooseCollectWordLayer)
    end
end

function CorePlayManager.leaveStudyModel(state)
    if state == true then
        print('answer right')
        s_LocalDatabaseManager.addRightWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
        s_LocalDatabaseManager.addStudyWordsNum()
        s_LocalDatabaseManager.addGraspWordsNum(1)

        CorePlayManager.preWordName           = CorePlayManager.BookWordList[CorePlayManager.currentIndex-1]
        CorePlayManager.preWordNameState      = true

        local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
        CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum, CorePlayManager.preWordName, CorePlayManager.preWordNameState)
    else
        print('answer wrong' .. tostring(CorePlayManager.currentIndex))
        local current_total_number = getMaxWrongNumEveryLevel()
        for i=1,current_total_number do
            local isNewBossBirth = s_LocalDatabaseManager.addWrongWord(CorePlayManager.currentIndex)
            s_LocalDatabaseManager.printBossWord()
            CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
            s_LocalDatabaseManager.addStudyWordsNum()

            CorePlayManager.wrongWordNum = CorePlayManager.wrongWordNum + 1

            CorePlayManager.preWordName           = CorePlayManager.BookWordList[CorePlayManager.currentIndex-1]
            CorePlayManager.preWordNameState      = false

            if isNewBossBirth then
                -- do collect enough words
                CorePlayManager.enterStudyOverModel()
            -- else
            --     -- do not collect enough words
            --     local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
            --     CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum, CorePlayManager.preWordName, CorePlayManager.preWordNameState)
            end
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
    CorePlayManager.enterTestModel(CorePlayManager.currentWrongWordList)
end

function CorePlayManager.enterTestModel(wordlist)
    local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
    local blacksmithLayer = BlacksmithLayer.create(wordlist)
    s_SCENE:replaceGameLayer(blacksmithLayer)
end

function CorePlayManager.leaveTestModel()
    s_LocalDatabaseManager.updateUnitState(CorePlayManager.currentUnitID)
    print("CorePlayManager.currentUnitID"..CorePlayManager.currentUnitID)
    local MiddleLayer = require("view.newstudy.EndLayer")
    local middleLayer = MiddleLayer.create()
    s_SCENE:replaceGameLayer(middleLayer)
end

function CorePlayManager.initReviewModel()
    -- if currentWrongWordList == nil,boss cant be exist,but boss is over there,so add boss word
    if CorePlayManager.currentWrongWordList == nil or #CorePlayManager.currentWrongWordList == 0 then
        CorePlayManager.enterReviewModel(CorePlayManager.currentRightWordList)
    else
        CorePlayManager.enterReviewModel(CorePlayManager.currentWrongWordList)
    end
end

function CorePlayManager.enterReviewModel(wordlist)
    local NewReviewBossMainLayer = require("view.newreviewboss.NewReviewBossMainLayer")
    local newReviewBossMainLayer = NewReviewBossMainLayer.create(wordlist)
    s_SCENE:replaceGameLayer(newReviewBossMainLayer)
end

function CorePlayManager.leaveReviewModel(state)
    if state then
        s_LocalDatabaseManager.updateUnitState(CorePlayManager.currentUnitID)
        local SuccessLayer = require("view.newreviewboss.SuccessLayer")
        local successLayer = SuccessLayer.create()
        s_SCENE:replaceGameLayer(successLayer)
    else
        -- do nothing
        CorePlayManager.enterLevelLayer()
    end
    
end

function CorePlayManager.initSummaryModel()
    CorePlayManager.enterSummaryModel(CorePlayManager.currentWrongWordList)
end

function CorePlayManager.enterSummaryModel(wordlist)
    local SummaryBossLayer = require('view.summaryboss.NewSummaryBossLayer')
    local summaryBossLayer = SummaryBossLayer.create()
    s_SCENE:replaceGameLayer(summaryBossLayer) 
end

function CorePlayManager.leaveSummaryModel(state)
    if state then
        s_LocalDatabaseManager.updateUnitState(CorePlayManager.currentUnitID)
    else
        -- do nothing
    end
    -- CorePlayManager.enterLevelLayer()
end


-- function CorePlayManager.enterIntroLayer()
--     local IntroLayer = IntroLayer.create(false)
--     s_SCENE:replaceGameLayer(IntroLayer)
-- end

function CorePlayManager.enterHomeLayer()

    -- local DramaLayer = require("view.home.DramaLayer")
    -- local dramaLayer = DramaLayer.create()
    -- s_SCENE:replaceGameLayer(dramaLayer)
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
end

--进入完善信息界面
function CorePlayManager.enterMoreInfomationView()
    
end

function CorePlayManager.enter()

end


function CorePlayManager.enterStoryLayer()
    local StoryLayer = require('view.level.StoryLayer')
    local storyLayer = StoryLayer.create(1)
    s_SCENE:replaceGameLayer(storyLayer)
end

function CorePlayManager.enterLevelLayer()
    local ChapterLayer = require('view.ChapterLayer')
    local chapterLayer = ChapterLayer.create()
    CorePlayManager.chapterLayer = chapterLayer
    s_SCENE:replaceGameLayer(chapterLayer)
end

function CorePlayManager.enterBookLayer(education)
    local bookLayer = BookLayer.create(education)
    s_SCENE:replaceGameLayer(bookLayer)
end

function CorePlayManager.enterEducationLayer()
    print("进入选择教育程度界面：EducationSelect.lua")
    local educationLayer = EducationLayer.create()
    s_SCENE:replaceGameLayer(educationLayer)
end

function CorePlayManager.enterDownloadLayer(bookKey)
    local downloadLayer = DownloadLayer.create(bookKey)
    s_SCENE:replaceGameLayer(downloadLayer)
end

function CorePlayManager.enterFriendLayer()
    local friendLayer = FriendLayer.create()
    s_SCENE:replaceGameLayer(friendLayer)
end

function CorePlayManager.enterFriendView()
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
    homeLayer:showFriendView()
end

function CorePlayManager.enterSettingView()
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
    homeLayer:showSettingView()
end

function CorePlayManager.enterShopView()
    local homeLayer = HomeLayer.create()
    s_SCENE:replaceGameLayer(homeLayer)
    homeLayer:changeViewToFriendOrShop("ShopLayer")
end


function CorePlayManager.enterGuideScene(index,parent)
    local GuideView = require ("view.guide.GuideView")
    local guideView = GuideView.create(index)
    parent:addChild(guideView,2)
end

function CorePlayManager.initTotalUnitPlay()
    -- check current unit count 
    print('enterunitplay')
    local maxID = s_LocalDatabaseManager.getMaxUnitID()
    if maxID == 0 then -- empty
        -- print('####test init unit info')
        s_LocalDatabaseManager.initUnitInfo(1)
    end
    local unitList = s_LocalDatabaseManager.getAllUnitInfo()
    -- print('all unit list size:'..#unitList)

    CorePlayManager.currentUnitID = nil
    for i = 1, #unitList do
        local unit = unitList[i]
        if unit.unitState >= 1 and unit.unitState <= 4 then
            if unit.coolingDay == 0 then
                CorePlayManager.currentUnitID = unit.unitID
                break
            else
                -- pass
            end
        elseif unit.unitState >= 5 then
            -- pass
        else
            CorePlayManager.currentUnitID = unit.unitID
            break
        end
    end

    if CorePlayManager.currentUnitID == nil then
        -- pass all
    else
        -- exist boss
    end
    print('currentUnitID:'..CorePlayManager.currentUnitID)
    CorePlayManager.currentUnit            = s_LocalDatabaseManager.getUnitInfo(CorePlayManager.currentUnitID)
    print_lua_table(CorePlayManager.currentUnit)
    CorePlayManager.currentUnitState       = CorePlayManager.currentUnit.unitState
    -- CorePlayManager.currentRightWordList   = CorePlayManager.currentUnit.rightWordList
    CorePlayManager.currentWrongWordList   = CorePlayManager.currentUnit.wrongWordList 
    
    CorePlayManager.BookUnitWordList       = s_BookUnitWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex           = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum           = #CorePlayManager.currentWrongWordList

    -- if     CorePlayManager.currentUnitState == 0 then
    --     -- study   model
    --     CorePlayManager.initStudyModel()

    if CorePlayManager.currentUnitState == 0 then
        -- summary model
        CorePlayManager.initSummaryModel()
    elseif CorePlayManager.currentUnitState >= 1 and CorePlayManager.currentUnitState <= 4 then
        -- review model
        CorePlayManager.initSummaryModel()
    -- else
        -- over model
        --CorePlayManager.initOverModel()
    end
end

return CorePlayManager
