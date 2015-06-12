require("cocos.init")

local SmallAlter = require("view.alter.SmallAlter")
local SmallAlterWithOneButton = require("view.alter.SmallAlterWithOneButton")
local OfflineTip = require('view.offlinetip.OfflineTip')

local TipsLayer = class("TipsLayer", function ()
    return cc.Layer:create()
end)

function TipsLayer.create()
    local layer = TipsLayer.new()
    layer.offlinetip = '网络链接失败，请检查网络状态'
    layer.offlineOrNoSessionTokenTip = '网络链接失败或者当前账号未登录，请检查网络状态或者重新登录'
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
    self.bg:setVisible(true)
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

function TipsLayer:showSmallWithOneButton(message, confirmFunc, btnMsg)
    self.listener:setSwallowTouches(true)
    self.bg:setVisible(true)
    self:setVisible(true)

    local smallAlter = SmallAlterWithOneButton.create(message, btnMsg)
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

    return smallAlter
end

function TipsLayer:showTip(content)
    if self:getChildrenCount() > 1 then return end
    
    self.bg:setVisible(false)
    self:setVisible(true)
    local layer = self
    local tip
    tip = OfflineTip.create(content, function ()
        tip:removeFromParent()
        layer:setVisible(false)
    end)
    self:addChild(tip)
    tip.show()
end

return TipsLayer
