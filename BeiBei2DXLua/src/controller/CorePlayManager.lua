require "common.global"

local IntroLayer             = require("view.login.IntroLayer")
local HomeLayer              = require("view.home.HomeLayer")
local BookLayer              = require("view.book.BookLayer")
local EducationLayer         = require("view.book.EducationSelect")
local DownloadLayer          = require("view.book.DownloadLayer")
local FriendLayer            = require("view.friend.FriendLayer") 


local CorePlayManager = {}

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
    s_BattleManager:enterBattleView(CorePlayManager.currentUnit)
    --CorePlayManager.enterSummaryModel(CorePlayManager.currentWrongWordList)
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

function CorePlayManager.enterStoryLayer()
    local StoryLayer = require('view.level.StoryLayer')
    local storyLayer = StoryLayer.create(1)
    s_SCENE:replaceGameLayer(storyLayer)
end

function CorePlayManager.enterLevelLayer()
    local ChapterLayer = require('view.ChapterLayer')
    local chapterLayer = ChapterLayer.create()
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
