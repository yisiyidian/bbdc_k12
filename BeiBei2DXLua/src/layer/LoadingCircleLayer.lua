require("Cocos2d")
require("Cocos2dConstants")

local LoadingCircleLayer = class("LoadingCircleLayer", function ()
    return cc.Layer:create()
end)

function LoadingCircleLayer.create()
    local layer = LoadingCircleLayer.new()
    return layer
end

return LoadingCircleLayer