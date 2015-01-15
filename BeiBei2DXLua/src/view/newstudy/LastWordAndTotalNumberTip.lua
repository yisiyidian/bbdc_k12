local LastWordAndTotalNumberTip = class("LastWordAndTotalNumberTip", function()
    return cc.Layer:create()
end)

function LastWordAndTotalNumberTip.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = LastWordAndTotalNumberTip.new()

--    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255),bigWidth,50)
--    backColor:setPosition(0, 800)
--    layer:addChild(backColor)
--    
--    local richtext1 = ccui.RichText:create()
--
--    local totalNumber_first = cc.LabelTTF:create ("今天已学习：",
--        "Helvetica",26, cc.size(180, 50), cc.TEXT_ALIGNMENT_LEFT)
--    totalNumber_first:setColor(cc.c4b(0,0,0,255))
--    local totalNumber_second = cc.LabelTTF:create ("50",
--        "Helvetica",26, cc.size(40, 50), cc.TEXT_ALIGNMENT_LEFT)
--    totalNumber_second:setColor(cc.c4b(0,0,0,255))
--    local totalNumber_third = cc.LabelTTF:create ("个",
--        "Helvetica",26, cc.size(20, 50), cc.TEXT_ALIGNMENT_LEFT)
--    totalNumber_third:setColor(cc.c4b(0,0,0,255))
--    
--    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,totalNumber_first)  
--    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,totalNumber_second)  
--    local richElement3 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,totalNumber_third)                           
--    richtext1:pushBackElement(richElement1) 
--    richtext1:pushBackElement(richElement2) 
--    richtext1:pushBackElement(richElement3) 
--    richtext1:setContentSize(cc.size(backColor:getContentSize().width,50)) 
--    richtext1:ignoreContentAdaptWithSize(true)
--    richtext1:ignoreAnchorPointForPosition(false)
--    richtext1:setAnchorPoint(cc.p(0,0.5))
--    richtext1:setPosition(0,0)
--    richtext1:setLocalZOrder(10)       
--    backColor:addChild(richtext1)
--    
--    local richtext2 = ccui.RichText:create()
--
--    local totalNumber_first = cc.LabelTTF:create ("今天已学习：",
--        "Helvetica",26, cc.size(180, 50), cc.TEXT_ALIGNMENT_RIGHT)
--    totalNumber_first:setColor(cc.c4b(0,0,0,255))
--    local totalNumber_second = cc.LabelTTF:create ("50",
--        "Helvetica",26, cc.size(40, 50), cc.TEXT_ALIGNMENT_RIGHT)
--    totalNumber_second:setColor(cc.c4b(0,0,0,255))
--    local totalNumber_third = cc.LabelTTF:create ("个",
--        "Helvetica",26, cc.size(20, 50), cc.TEXT_ALIGNMENT_RIGHT)
--    totalNumber_third:setColor(cc.c4b(0,0,0,255))
--
--    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,totalNumber_first)  
--    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,totalNumber_second)  
--    local richElement3 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,totalNumber_third)                           
--    richtext2:pushBackElement(richElement1) 
--    richtext2:pushBackElement(richElement2) 
--    richtext2:pushBackElement(richElement3) 
--    richtext2:setContentSize(cc.size(backColor:getContentSize().width,50)) 
--    richtext2:ignoreContentAdaptWithSize(true)
--    richtext2:ignoreAnchorPointForPosition(false)
--    richtext2:setAnchorPoint(cc.p(1,0.5))
--    richtext2:setPosition(backColor:getContentSize().width,0)
--    richtext2:setLocalZOrder(10)       
--    backColor:addChild(richtext2)




    return layer
end

return LastWordAndTotalNumberTip