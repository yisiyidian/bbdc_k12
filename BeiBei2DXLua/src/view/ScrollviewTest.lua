require("cocos.init")
require("common.global")

local ScrollViewTest = class("ScrollViewTest", function()
    return cc.Layer:create()
end)

function ScrollViewTest.create()
    local layer = ScrollViewTest.new()
    return layer
end

function ScrollViewTest:ctor()

    local SliderView = require("view.SliderView")
    local sliderView = SliderView.create(s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2,2 * s_DESIGN_HEIGHT)
    self:addChild(sliderView)

    local backColor = cc.Layer:create()
    backColor:setContentSize(s_DESIGN_WIDTH, 2 * s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT)
    sliderView.scrollView:addChild(backColor)
    
    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:ignoreAnchorPointForPosition(false)
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(s_DESIGN_WIDTH/2, 936)
    backColor:addChild(cloud_up)
end

return ScrollViewTest