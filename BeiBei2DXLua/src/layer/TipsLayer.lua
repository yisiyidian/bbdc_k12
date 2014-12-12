require("cocos.init")

local BigAlter = require("view.alter.BigAlter")
local SmallAlter = require("view.alter.SmallAlter")

local TipsLayer = class("TipsLayer", function ()
    return cc.Layer:create()
end)

function TipsLayer.create()
    local layer = TipsLayer.new()
    return layer
end

function TipsLayer:ctor()
    self:setVisible(false)

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end
    
    local onTouchMoved = function(touch, event)
        --s_logd("touch moved on block layer")
    end
    
    local onTouchEnded = function(touch, event)
        --s_logd("touch ended on block layer")
    end
    
    self.listener = cc.EventListenerTouchOneByOne:create()
    
    self.listener:registerScriptHandler( onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler( onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler( onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
    self.listener:setSwallowTouches(false)

    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    self.bg:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(self.bg)
end

function TipsLayer:showSmall(message, confirmFunc, cancelFunc)
    self.listener:setSwallowTouches(true)
    self:setVisible(true)

    local smallAlter = SmallAlter.create(message)
    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    self:addChild(smallAlter)

    local layer = self
    local closeTip = function ()
        smallAlter:removeFromParent()
        layer.listener:setSwallowTouches(false)
        layer:setVisible(false)
    end

    smallAlter.affirm = function()
        if confirmFunc ~= nil then confirmFunc() end
        closeTip()
    end
    
    smallAlter.close = function()
        if cancelFunc ~= nil then cancelFunc() end
        closeTip()
    end

    return smallAlter
end

return TipsLayer
