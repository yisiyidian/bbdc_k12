require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")

ccbLevelLayer = ccbLevelLayer or {}
ccb['chapter1'] = ccbLevelLayer

local LevelLayer = class("LevelLayer", function()
    return cc.Layer:create()
end)

function LevelLayer.create()
    local layer = LevelLayer.new()
    layer:loadCCB()
    return layer
end

function LevelLayer:loadCCB()
    s_logd("hello, CCB")
    ccbLevelLayer['onLevelButtonClicked'] = self.onLevelButtonClicked
    local proxy = cc.CCBProxy:create()
    local contentNode  = CCBReaderLoad("res/ccb/chapter1.ccbi", proxy, ccbLogInSignUpLayer)
    --self:addChild(node)
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
        scrollViewNode:setPosition(cc.p(0,0))
        --scrollViewNode:setAnchorPoint(0.5,0)
        scrollViewNode:setContainer(contentNode)
        scrollViewNode:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self:addChild(scrollViewNode)
    end
    

end

function LevelLayer:onLevelButtonClicked()
    s_logd("click level")
end
return LevelLayer