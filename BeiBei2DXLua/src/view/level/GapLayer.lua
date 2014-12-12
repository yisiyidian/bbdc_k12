require("cocos.init")
require('common.global')

local s_layerHeight = 540

local GapLayer = class('GapLayer', function()
    local widget = ccui.Widget:create()
    widget:setContentSize(cc.size(s_MAX_WIDTH, s_layerHeight))
    return widget
end)

function GapLayer.create()
    local layer = GapLayer.new()
    return layer
end

function GapLayer:ctor()
    self:setAnchorPoint(0,0)
end

return GapLayer
