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
    local sliderView = SliderView.create(s_DESIGN_WIDTH,s_DESIGN_HEIGHT,2 * s_DESIGN_HEIGHT)
    self:addChild(sliderView) 

    local backColor = cc.LayerColor:create(cc.c4b(190,220,209,255), s_DESIGN_WIDTH, 2 * s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT)
    sliderView.scrollView:addChild(backColor) 
    
    
end

return ScrollViewTest