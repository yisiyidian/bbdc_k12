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
    
    local onTouchMoved = function(touch, event)
    end
    
    local onTouchEnded = function(touch, event)
    end
    
    self.listener = cc.EventListenerTouchOneByOne:create()
    
    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)

    self.listener:setSwallowTouches(false)
end

return PopupLayer