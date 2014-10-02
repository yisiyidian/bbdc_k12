require("Cocos2d")
require("Cocos2dConstants")

local TouchEventBlockLayer = class("TouchEventBlockLayer", function ()
    return cc.Layer:create()
end)



return TouchEventBlockLayer