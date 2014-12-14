require("cocos.init")
require('anysdkConst')

local DebugLayer = class("DebugLayer", function ()
    return cc.Layer:create()
end)

function DebugLayer.create()
    local layer = DebugLayer.new()
    
    layer.debugInfo = cc.Label:createWithSystemFont("DEBUG:V:"..s_APP_VERSION, "Helvetica", 24)
    layer.debugInfo:setAnchorPoint(cc.p(0, 1))
    layer.debugInfo:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)
    layer:addChild(layer.debugInfo)

    layer.debugInfo2 = cc.Label:createWithSystemFont("DEBUG:V:"..s_APP_VERSION, "Helvetica", 24)
    layer.debugInfo2:setTextColor(cc.c4b(0, 0, 0, 255))
    layer.debugInfo2:setAnchorPoint(cc.p(0, 1))
    layer.debugInfo2:setPosition(s_LEFT_X + 1, s_DESIGN_HEIGHT - 1)
    layer:addChild(layer.debugInfo2)

    layer:scheduleUpdateWithPriorityLua(function (dt)
        local str = getAppVersionDebugInfo()
        layer.debugInfo:setString(str)
        layer.debugInfo2:setString(str)
    end, 0)
    
    return layer
end

return DebugLayer