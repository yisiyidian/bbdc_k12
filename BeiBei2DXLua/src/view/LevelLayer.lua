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
    print(s_SCENE.levelLayerState..'!!!!!!!!!!!!!!')
    -- TODO Check Review boss state
    
    -- TODO switch state
    if s_SCENE.levelLayerState == s_normal_level_state then
        print(s_SCENE.levelLayerState)
       
    elseif s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
        print(s_SCENE.levelLayerState)
        -- update level state and plot popup(call on level button clicked)
        -- TODO CHECK level index valid
        --s_CURRENT_USER.currentLevelIndex = s_CURRENT_USER.currentLevelIndex + 1
        --s_CURRENT_USER:setUserLevelDataOfUnlocked('Chapter'..s_CURRENT_USER.currentChapterIndex, 'level'..s_CURRENT_USER.currentLevelIndex)
        local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName('level2')
        local action = cc.MoveTo:create(1, cc.p(currentLevelButton:getPosition()))
        print('start_run')
        player:runAction(action)
--        local scheduler = require('framework.scheduler')
--        levelLayerI:onLevelButtonClicked(4)
        
        
    elseif s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
        -- update level state  
        print(s_SCENE.levelLayerState)
    end
end

function LevelLayer:ctor()
    -- initialize chapter 1
--    self.ccbLevelLayer1 = {}  
--    self.ccbLevelLayer1['onLevelButtonClicked'] = self.onLevelButtonClicked
--    
--    self.ccb = {}
--    self.ccb['chapter1'] = ccbLevelLayer1
--    local proxy1 = cc.CCBProxy:create()
--    local contentNode1  = CCBReaderLoad("res/ccb/chapter1.ccbi", proxy1, self.ccbLevelLayer1, self.ccb)
--    self.ccbLevelLayer1['contentNode1'] = contentNode1;
--    
--    self.ccbLevelLayer1['levelSet'] = contentNode1:getChildByTag(5) -- level node
--    for i = 1, #self.ccbLevelLayer1['levelSet']:getChildren() do
--        self.ccbLevelLayer1['levelSet']:getChildren()[i]:setName('levelButton'..(self.ccbLevelLayer1['levelSet']:getChildren()[i]:getTag()))
--        print(self.ccbLevelLayer1['levelSet']:getChildren()[i]:getName())
--    end
    
--    local chapterTitle1 = cc.Sprite:create('ccb/ccbResources/chapter_level/tittle_xuanxiaoguan1_background_adorn1.png')
--    chapterTitle1:setAnchorPoint(0, 0.5)
--    chapterTitle1:setPosition(0, 2800)
--    contentNode1:addChild(chapterTitle1) 
      local levelStypeI = require('view.level.LevelLayerI')
      levelLayerI = levelStypeI.create()
      --self:addChild(levelLayer1)
      local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName('level1')
      local image = 'image/chapter_level/gril_head.png'
      player = cc.MenuItemImage:create(image,image,image)
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
    local scrollViewNode = cc.ScrollView:create() 
    -- scroll view scroll
    local function scrollViewDidScroll()
        print 'scrollview did scroll'
        print(scrollViewNode:getPosition())
    end
    
    local function scrollViewDidZoom()
        print 'scrollview did zoom'
    end
    
    if nil ~= scrollViewNode then
        scrollViewNode:setViewSize(cc.size(s_DESIGN_WIDTH, s_DESIGN_HEIGHT))
        scrollViewNode:setPosition(0,0)
        --contentNode2:setContentSize(856,5397)
        scrollViewNode:ignoreAnchorPointForPosition(true)
        scrollViewNode:setContainer(levelLayerI)
        scrollViewNode:setContentOffset(cc.vertex2F(0,-1500), false)
        --scrollViewNode:setSizePercent(50)
        --contentNode:setAnchorPoint(0.5,0.5)
--        contentNode2:setContentSize(500,1000)
        --contentNode1:setPosition(0,2470)
        --contentNode2:addChild(contentNode)
        --contentNode2:addChild(contentNode1)
        --scrollViewNode:scrollToPercentVertical(14,0,true)
        --scrollViewNode:setContentOffset(100)
        
--        local position = contentNode1:getContentSize()
--        s_logd('contentSize:%f,%f',position.width,position.height)
        scrollViewNode:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        scrollViewNode:setBounceable(true)
        scrollViewNode:setClippingToBounds(true)
        scrollViewNode:updateInset()
        scrollViewNode:setDelegate()

        --scrollViewNode:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
        --scrollViewNode:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
        self:addChild(scrollViewNode)
    end
    
    

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