require("Cocos2d")
require("Cocos2dConstants")

local DebugLayer = class("DebugLayer", function ()
    return cc.Layer:create()
end)



return DebugLayer