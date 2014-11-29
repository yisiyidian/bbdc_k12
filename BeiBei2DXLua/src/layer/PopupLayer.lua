require("Cocos2d")
require("Cocos2dConstants")

local PopupLayer = class("PopupLayer", function ()
    return cc.Layer:create()
end)

function PopupLayer.create()
    local layer = PopupLayer.new()
    return layer
end

function PopupLayer:ctor()
    local onTouchBegan = function(touch, event)
        return true
    end    
    self.isOtherAlter = false
    
    local onTouchMoved = function(touch, event)
    end
    
    local onTouchEnded = function(touch, event)
    end
    
    self.layerpaused = false
    self.listener = cc.EventListenerTouchOneByOne:create()
    
    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)

    self.listener:setSwallowTouches(false)
end

function PopupLayer:addBackground()
    local bg = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    bg:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(bg)
end

function PopupLayer:setPauseBtnEnabled(var)
    if self.pauseBtn ~=nil then
        self.pauseBtn:setTouchEnabled(var)
    end
end
return PopupLayer