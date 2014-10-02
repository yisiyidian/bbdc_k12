require("Cocos2d")
require("Cocos2dConstants")

local TouchEventBlockLayer = class("TouchEventBlockLayer", function ()
    return cc.Layer:create()
end)

function TouchEventBlockLayer.create()
    local layer = TouchEventBlockLayer.new()
    return layer
end

return TouchEventBlockLayer