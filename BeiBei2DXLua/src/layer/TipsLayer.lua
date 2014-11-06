require("Cocos2d")
require("Cocos2dConstants")

local BigAlter = require("view.alter.BigAlter")
local SmallAlter = require("view.alter.SmallAlter")

local TipsLayer = class("TipsLayer", function ()
    return cc.Layer:create()
end)

function TipsLayer.create()
    local layer = TipsLayer.new()
    return layer
end

function TipsLayer:showSmall(message)
    local smallAlter = SmallAlter.create(message)
    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    self:addChild(smallAlter)
    
    smallAlter.close = function()
        smallAlter:removeFromParent()
    end

    return smallAlter
end

return TipsLayer