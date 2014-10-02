require("Cocos2d")
require("Cocos2dConstants")

local TipsLayer = class("TipsLayer", function ()
    return cc.Layer:create()
end)

function TipsLayer.create()
    local layer = TipsLayer.new()
    return layer
end

return TipsLayer