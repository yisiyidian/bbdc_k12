require("Cocos2d")
require("Cocos2dConstants")

local GameLayer = class("GameLayer", function ()
    return cc.Layer:create()
end)

function GameLayer.create()
    local layer = GameLayer.new()
    return layer
end

return GameLayer