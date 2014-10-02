require("Cocos2d")
require("Cocos2dConstants")

local DebugLayer = class("DebugLayer", function ()
    return cc.Layer:create()
end)

function DebugLayer.create()
    local layer = DebugLayer.new()
    
    layer.debugInfo = cc.Label:createWithSystemFont("DEBUG", "Helvetica", 24)
    layer.debugInfo:setAnchorPoint(cc.p(0,0))
    layer:addChild(layer.debugInfo)
    
    return layer
end

return DebugLayer