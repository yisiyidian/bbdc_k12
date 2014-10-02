require("Cocos2d")
require("Cocos2dConstants")

local PopupLayer = class("PopupLayer", function ()
    return cc.Layer:create()
end)

function PopupLayer.create()
    local layer = PopupLayer.new()
    return layer
end

return PopupLayer