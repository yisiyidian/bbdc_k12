require "common.global"

local InputNode         = require("src.view.login.InputNode")
local ScrollViewTest    = require("view.ScrollviewTest")

local ZiaoangTest = class("ZiaoangTest", function()
    return cc.Layer:create()
end)

function ZiaoangTest.create()
    local layer = ZiaoangTest.new()
    
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    
    local scrollViewTest = ScrollViewTest.create()
    scrollViewTest:setAnchorPoint(0.5,0.5)
    scrollViewTest:ignoreAnchorPointForPosition(false) 
    scrollViewTest:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2*1.5)
    layer:addChild(scrollViewTest)
    

    
    return layer
end


return ZiaoangTest







