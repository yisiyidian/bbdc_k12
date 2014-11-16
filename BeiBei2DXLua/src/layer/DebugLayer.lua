require("Cocos2d")
require("Cocos2dConstants")
require('anysdkConst')

local DebugLayer = class("DebugLayer", function ()
    return cc.Layer:create()
end)

function DebugLayer.create()
    local layer = DebugLayer.new()
    
    layer.debugInfo = cc.Label:createWithSystemFont("DEBUG:", "Helvetica", 24)
    layer.debugInfo:setAnchorPoint(cc.p(0, 1))
    layer.debugInfo:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)
    layer:addChild(layer.debugInfo)

    layer:scheduleUpdateWithPriorityLua(function (dt)
        if AgentManager ~= nil then
            layer.debugInfo:setString(AgentManager:getInstance():getChannelId())
        end
    end, 0)
    
    return layer
end

return DebugLayer