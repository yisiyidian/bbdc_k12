require("cocos.init")
require("common.global")

local listener = nil

local LoadingLayer = class("LoadingLayer", function ()
    return cc.Layer:create()
end)

function LoadingLayer.create()
    local layer = LoadingLayer.new()

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

    listener = cc.EventListenerTouchOneByOne:create()

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

function LoadingLayer.lockTouch()
    listener:setSwallowTouches(true)
end

function LoadingLayer.unlockTouch()
    listener:setSwallowTouches(false)
end

return LoadingLayer