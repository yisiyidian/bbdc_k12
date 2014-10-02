require("Cocos2d")
require("Cocos2dConstants")

local BackgroundLayer = class("BackgroundLayer", function ()
	return cc.Layer:create()
end)



return BackgroundLayer