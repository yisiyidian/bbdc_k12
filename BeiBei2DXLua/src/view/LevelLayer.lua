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
    s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
    -- TODO Check Review boss state
    
    -- TODO switch state
    if s_SCENE.levelLayerState == s_normal_level_state then
        print(s_SCENE.levelLayerState)
       
    elseif s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
        -- lock screen and plot animation
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        s_SCENE:callFuncWithDelay(2, function()
            s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
        end)
        -- plot star animation
        s_CURRENT_USER:setUserLevelDataOfStars('Chapter'..s_CURRENT_USER.currentChapterIndex,'level'..s_CURRENT_USER.currentLevelIndex,2)
        local levelData = s_CURRENT_USER:getUserLevelData('Chapter'..s_CURRENT_USER.currentChapterIndex,'level'..s_CURRENT_USER.currentLevelIndex)
        levelLayerI:plotStarAnimation(s_CURRENT_USER.currentLevelIndex, levelData.stars)
        
        -- 
        s_CURRENT_USER.currentLevelIndex = s_CURRENT_USER.currentLevelIndex + 1
        s_CURRENT_USER:setUserLevelDataOfUnlocked('Chapter'..s_CURRENT_USER.currentChapterIndex, 'level'..s_CURRENT_USER.currentLevelIndex)
        -- update level state and plot popup(call on level button clicked)
        s_SCENE.levelLayerState = s_normal_level_state
--        s_SCENE:callFuncWithDelay(10,function()
--            levelLayerI:onLevelButtonClicked(s_CURRENT_USER.currentLevelIndex)
--        end)
        
        -- TODO CHECK level index valid
        
        --print('start_run')
        s_SCENE:callFuncWithDelay(3,function()
            local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName('level'..s_CURRENT_USER.currentLevelIndex)
            local action = cc.MoveTo:create(1, cc.p(currentLevelButton:getPosition()))
            player:runAction(action)
        end
        )

--        local scheduler = require('framework.scheduler')
--        levelLayerI:onLevelButtonClicked(4)
        
        
    elseif s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
        -- update level state  
        print(s_SCENE.levelLayerState)
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
        
        print('0000000000000000000000')
      local levelStypeI = require('view.level.LevelLayerI')
      levelLayerI = levelStypeI.create()
      --self:addChild(levelLayer1)
      
      -- plot player position
      local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName('level'..s_CURRENT_USER.currentLevelIndex)
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