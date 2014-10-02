require("Cocos2d")
require("Cocos2dConstants")

local HudLayer = class("HudLayer", function ()
    return cc.Layer:create()
end)

function HudLayer.create()
    local layer = HudLayer.new()
    return layer
end

return HudLayer