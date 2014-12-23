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
    
    
--    local scrollViewTest = ScrollViewTest.create()
--    scrollViewTest:setAnchorPoint(0.5,0.5)
--    scrollViewTest:ignoreAnchorPointForPosition(false) 
--    scrollViewTest:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2*1.5)
--    layer:addChild(scrollViewTest)
    
    
    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(500, 0))

    local re1 = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, "I have an ", "", 28)
    local re2 = ccui.RichElementText:create(2, cc.c3b(255, 0,     0), 255, "apple", "", 28)
    local re3 = ccui.RichElementText:create(3, cc.c3b(255, 255, 255), 255, " on the desktop hahah jiu shi this apple.", "", 28)
    
    richText:pushBackElement(re1)
    richText:pushBackElement(re2)
    richText:pushBackElement(re3)

    richText:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    backColor:addChild(richText)

    print("rich text content size: "..richText:getContentSize().width.." "..richText:getContentSize().height)
    print("rich text content size: "..richText:getVirtualRendererSize().width.." "..richText:getVirtualRendererSize().height)
    
    return layer
end


return ZiaoangTest







