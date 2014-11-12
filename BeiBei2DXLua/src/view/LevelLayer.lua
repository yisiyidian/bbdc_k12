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
    s_SCENE.levelLayerState = s_normal_level_state
    --s_CURRENT_USER:initLevels()
    -- TODO Check Review boss state
    local reviewBossId = s_DATABASE_MGR.getCurrentReviewBossID()
    if reviewBossId ~= -1 then
        -- check whether current level is passed
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        if levelData.stars > 0 then
        
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
        
        -- plot unlock next level animation
        levelLayerI:plotUnlockNextLevelAnimation()
        
        -- save and update level data
        --s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        --s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)

        -- plot star animation
        --levelLayerI:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
        
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
        
     end
end

function LevelLayer:ctor()

--        for i = 1, #s_CURRENT_USER.levels do
--        s_CURRENT_USER.levels[i].chapterKey = string.gsub(s_CURRENT_USER.levels[i].chapterKey,'Chapter','chapter')
--            s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.levels[i],
--                    function(api,result)
--                    end,
--                    function(api, code, message, description)
--                    end) 
--        end
        
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
--    -- initialize chapter 2
--    ccbLevelLayer2['onLevelButtonClicked'] = self.onLevelButtonClicked
--    local proxy2 = cc.CCBProxy:create()
--    local contentNode2  = CCBReaderLoad("res/ccb/chapter2.ccbi", proxy, ccbLevelLayer)
--    ccbLevelLayer2['contentNode'] = contentNode2;
--
--    ccbLevelLayer2['levelSet'] = contentNode2:getChildByTag(5)
--    for i = 1, #ccbLevelLayer2['levelSet']:getChildren() do
--        ccbLevelLayer2['levelSet']:getChildren()[i]:setName('levelButton'..(ccbLevelLayer2['levelSet']:getChildren()[i]:getTag()))
--        print(ccbLevelLayer2['levelSet']:getChildren()[i]:getName())
--    end
--    
--    local chapter2Title = cc.Sprite:create('ccb/ccbResources/chapter_level/tittle_xuanxiaoguan2_losangles.png')
--    chapter2Title:setAnchorPoint(0, 0.5)
--    chapter2Title:setPosition(0, 2450)
--    contentNode2:addChild(chapter2Title) 
    --local buttonNode = cc.ControlButton:create('ccb/ccbResources/chapter_level/background_xuanxiaoguan2_head_coveredbycloud_1.png')
    --buttonNode:setPosition(100,100)
    --self:addChild(buttonNode)
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
        --scrollViewNode:setIn(cc.size(s_DESIGN_WIDTH, s_DESIGN_HEIGHT))
        scrollViewNode:setPosition((s_DESIGN_WIDTH - fullWidth) / 2, 0)

        --contentNode2:setContentSize(856,5397)
        --scrollViewNode:ignoreAnchorPointForPosition(true)
        --scrollViewNode:setContainer(levelLayerI)
        scrollViewNode:setContentSize(fullWidth, s_DESIGN_HEIGHT)
        --scrollViewNode:setContentOffset(cc.vertex2F(0,-1500), false)
        --scrollViewNode:setSizePercent(50)
        --contentNode:setAnchorPoint(0.5,0.5)
--        contentNode2:setContentSize(500,1000)
        --contentNode1:setPosition(0,2470)
        --contentNode2:addChild(contentNode)
        --contentNode2:addChild(contentNode1)
        --scrollViewNode:scrollToPercentVertical(14,0,true)
        --scrollViewNode:setContentOffset(100)
        scrollViewNode:setInnerContainerSize(cc.size(fullWidth, levelLayerI:getContentSize().height))  
        scrollViewNode:addChild(levelLayerI) 
        scrollViewNode:setTouchEnabled(true)
--        local position = contentNode1:getContentSize()
--        s_logd('contentSize:%f,%f',position.width,position.height)
        --scrollViewNode:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        --scrollViewNode:setBounceable(true)
        --scrollViewNode:setClippingToBounds(true)
        --scrollViewNode:updateInset()
        --scrollViewNode:setDelegate()

        --scrollViewNode:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
        --scrollViewNode:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
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