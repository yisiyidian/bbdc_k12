require("cocos.init")

local SmallAlter = require("view.alter.SmallAlter")


local HudLayer = class("HudLayer", function ()
    return cc.Layer:create()
end)

ccbPopupWindow = ccbPopupWindow or {}

function HudLayer.create()
    local layer = HudLayer.new()   
    return layer
end






return HudLayer