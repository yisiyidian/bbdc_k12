require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")

local LevelLayer = class("LevelLayer", function()
    return cc.Layer:create()
end)

local player
local levelLayerI

function LevelLayer.create()
    local layer = LevelLayer.new()
    return layer
end

function LevelLayer:levelStateManager()
    -- test
    --s_SCENE.levelLayerState = s_normal_level_state
    --s_CURRENT_USER:initLevels()
    -- TODO Check Review boss state
    local reviewBossId = s_DATABASE_MGR.getCurrentReviewBossID()
    if reviewBossId ~= -1 then
        -- check whether current level is passed
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        if levelData.stars > 0 then
            if s_SCENE.levelLayerState ~= s_review_boss_appear_state 
                and s_SCENE.levelLayerState ~= s_review_boss_pass_state then
                if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
                    levelLayerI:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
                end
                s_SCENE.levelLayerState = s_review_boss_appear_state
            end
        end
    end
    -- TODO switch state
    if s_SCENE.levelLayerState == s_normal_level_state then
        print(s_SCENE.levelLayerState)
       
    elseif s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
        -- lock screen and plot animation
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        s_SCENE:callFuncWithDelay(3.9, function()
            s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
        end)
        -- plot star animation
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        levelLayerI:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
        
        -- save and update level data
        s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        -- plot unlock next level animation
        levelLayerI:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
        -- plot player animation
        s_SCENE:callFuncWithDelay(1.3,function()
            local targetPosition = levelLayerI:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(0.8, targetPosition)
            player:runAction(action)      
        end)
        
        -- update level state and plot popup(call on level button clicked)
        if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
            s_SCENE:callFuncWithDelay(4,function()
                levelLayerI:onLevelButtonClicked(s_CURRENT_USER.currentLevelKey)
            end)
        end
        s_SCENE.levelLayerState = s_normal_level_state
        
        -- TODO CHECK level index valid
        
        s_SCENE:callFuncWithDelay(3,function()
            local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(1, cc.p(currentLevelButton:getPosition()))
            player:runAction(action)
        end
        )
     elseif s_SCENE.levelLayerState == s_review_boss_appear_state then
        levelLayerI:plotReviewBossAppearOnLevel('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
     elseif s_SCENE.levelLayerState == s_review_boss_pass_state then

        -- save and update level data
        s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        -- plot unlock level animation
        levelLayerI:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
        -- plot player animation
        s_SCENE:callFuncWithDelay(1.3,function()
            local targetPosition = levelLayerI:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(0.8, targetPosition)
            player:runAction(action)      
        end)

        -- update level state and plot popup(call on level button clicked)
        if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
            s_SCENE:callFuncWithDelay(4,function()
                levelLayerI:onLevelButtonClicked(s_CURRENT_USER.currentLevelKey)
            end)
        end
        s_SCENE.levelLayerState = s_normal_level_state
     end
     s_CURRENT_USER:updateDataToServer()
end

function LevelLayer:ctor()
    
    local levelStypeI = require('view.level.LevelLayerI')
    levelLayerI = levelStypeI.create()
    
    -- plot player position
    local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName(s_CURRENT_USER.currentLevelKey)
    local image = 'image/chapter_level/gril_head.png'
    player = cc.MenuItemImage:create(image,image,image)
    player:setEnabled(false)
    player:setPosition(currentLevelButton:getPosition())
    player:setScale(0.5)
    levelLayerI.ccbLevelLayerI['levelSet']:addChild(player, 5)
    
    -- level layer state manager
    self:levelStateManager()
    local scrollViewNode = ccui.ScrollView:create() 
    -- scroll view scroll
    local function scrollViewDidScroll()
        print 'scrollview did scroll'
        print(scrollViewNode:getPosition())
    end
    
    local function scrollViewDidZoom()
        print 'scrollview did zoom'
    end
    
    if nil ~= scrollViewNode then
        local fullWidth = levelLayerI:getContentSize().width
        scrollViewNode:setPosition((s_DESIGN_WIDTH - fullWidth) / 2, 0)

        scrollViewNode:setContentSize(fullWidth, s_DESIGN_HEIGHT)
        scrollViewNode:setInnerContainerSize(cc.size(fullWidth, levelLayerI:getContentSize().height))  
        scrollViewNode:addChild(levelLayerI) 
        scrollViewNode:setTouchEnabled(true)
        self:addChild(scrollViewNode)
    end
    
    playMusic(s_sound_bgm1,true)
    
end

function LevelLayer:onLevelButtonClicked()
    local PopupNormalLevel = require('popup.PopupSummarySuccess')
    local popLayer = PopupNormalLevel.create()
--    popLayer:setAnchorPoint(0.5,0.5)
    s_SCENE:popup(popLayer)
 --popupLayer:setPosition(100,100)
 --s_SCENE:popup(popupLayer)
--    local levelName = 'levelButton'..self
--    local selectedLevelButton = ccbLevelLayer['levelSet']:getChildByName(levelName)
--    print(selectedLevelButton:getPosition())
--
--    --local test = cc.MenuItemSprite:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/background_xuanxiaoguan2_head_coveredbycloud_1.png'))
--    selectedLevelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/background_xuanxiaoguan2_head_coveredbycloud_1.png'))
end
return LevelLayer