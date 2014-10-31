require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")

ccbLevelLayer = ccbLevelLayer or {}
ccb['chapter1'] = ccbLevelLayer

-- chapter 2
ccbLevelLayer2 = ccbLevelLayer2 or {}
ccb['chapter2'] = ccbLevelLayer2

local LevelLayer = class("LevelLayer", function()
    return cc.Layer:create()
end)


function LevelLayer.create()
    local layer = LevelLayer.new()
    return layer
end

function LevelLayer:ctor()
    -- initialize chapter 1
    ccbLevelLayer['onLevelButtonClicked'] = self.onLevelButtonClicked
    local proxy = cc.CCBProxy:create()
    local contentNode1  = CCBReaderLoad("res/ccb/chapter1.ccbi", proxy, ccbLevelLayer)
    ccbLevelLayer['contentNode1'] = contentNode1;
    
    ccbLevelLayer['levelSet'] = contentNode1:getChildByTag(5)
    for i = 1, #ccbLevelLayer['levelSet']:getChildren() do
        ccbLevelLayer['levelSet']:getChildren()[i]:setName('levelButton'..(ccbLevelLayer['levelSet']:getChildren()[i]:getTag()))
        print(ccbLevelLayer['levelSet']:getChildren()[i]:getName())
    end
    
    local chapter1Title = cc.Sprite:create('ccb/ccbResources/chapter_level/tittle_xuanxiaoguan1_background_adorn1.png')
    chapter1Title:setAnchorPoint(0, 0.5)
    chapter1Title:setPosition(0, 2800)
    contentNode1:addChild(chapter1Title)    
    -- initialize chapter 2
    ccbLevelLayer2['onLevelButtonClicked'] = self.onLevelButtonClicked
    local proxy2 = cc.CCBProxy:create()
    local contentNode2  = CCBReaderLoad("res/ccb/chapter2.ccbi", proxy, ccbLevelLayer)
    ccbLevelLayer2['contentNode'] = contentNode2;

    ccbLevelLayer2['levelSet'] = contentNode2:getChildByTag(5)
    for i = 1, #ccbLevelLayer2['levelSet']:getChildren() do
        ccbLevelLayer2['levelSet']:getChildren()[i]:setName('levelButton'..(ccbLevelLayer2['levelSet']:getChildren()[i]:getTag()))
        print(ccbLevelLayer2['levelSet']:getChildren()[i]:getName())
    end
    
    local chapter2Title = cc.Sprite:create('ccb/ccbResources/chapter_level/tittle_xuanxiaoguan2_losangles.png')
    chapter2Title:setAnchorPoint(0, 0.5)
    chapter2Title:setPosition(0, 2450)
    contentNode2:addChild(chapter2Title) 
    --local buttonNode = cc.ControlButton:create('ccb/ccbResources/chapter_level/background_xuanxiaoguan2_head_coveredbycloud_1.png')
    --buttonNode:setPosition(100,100)
    --self:addChild(buttonNode)
    local scrollViewNode = cc.ScrollView:create() 
    -- scroll view scroll
    local function scrollViewDidScroll()
        print 'scrollview did scroll'
    end
    
    local function scrollViewDidZoom()
        print 'scrollview did zoom'
    end
    
    if nil ~= scrollViewNode then
        scrollViewNode:setViewSize(cc.size(s_DESIGN_WIDTH, s_DESIGN_HEIGHT))
        scrollViewNode:setPosition(0,0)
        contentNode2:setContentSize(856,5397)
        scrollViewNode:ignoreAnchorPointForPosition(true)
        scrollViewNode:setContainer(contentNode2)
        --contentNode:setAnchorPoint(0.5,0.5)
--        contentNode2:setContentSize(500,1000)
        contentNode1:setPosition(0,2470)
        --contentNode2:addChild(contentNode)
        contentNode2:addChild(contentNode1)
        --scrollViewNode:scrollToPercentHorizontal(14,0,true)
        --scrollViewNode:setContentOffset(100)
        
        local position = contentNode1:getContentSize()
        s_logd('contentSize:%f,%f',position.width,position.height)
        scrollViewNode:updateInset()
        scrollViewNode:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
        scrollViewNode:setBounceable(false)
        
        --scrollViewNode:setDelegate()
        scrollViewNode:setClippingToBounds(true)
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