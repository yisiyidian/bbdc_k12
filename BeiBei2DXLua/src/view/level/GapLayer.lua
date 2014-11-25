require('common.global')
require('Cocos2d')
require('Cocos2dConstants')

local GapLayer = class('GapLayer', function()
    return ccui.Button:create('image/chapter_level/chapter2_upGap.png','image/chapter_level/chapter2_upGap.png','image/chapter_level/chapter2_upGap.png')
end)

function GapLayer.create()
    local layer = GapLayer.new()
    return layer
end

function GapLayer:ctor()
    self:setAnchorPoint(0,0)
end

return GapLayer
