require("Cocos2d")
require("Cocos2dConstants")

local BackgroundLayer = class("BackgroundLayer", function ()
	return cc.Layer:create()
end)

function BackgroundLayer.create()
    local layer = BackgroundLayer.new()
    return layer
end

return BackgroundLayer