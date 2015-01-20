local LastWordAndTotalNumberTip = class("LastWordAndTotalNumberTip", function()
    return cc.Layer:create()
end)

function LastWordAndTotalNumberTip.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local todayNumber = 9999

    local layer = LastWordAndTotalNumberTip.new()

    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255),bigWidth,50)
    backColor:setPosition(s_LEFT_X, 800)
    layer:addChild(backColor)
    
    local richtext1 = ccui.RichText:create()
    local richElement1 = ccui.RichElementText:create(1,cc.c3b(41, 110, 146),255,"今已学习：","Helvetica",26)  
    local richElement2 = ccui.RichElementText:create(2,cc.c3b(252, 128, 0),255,todayNumber,"Helvetica",26)  
    local richElement3 = ccui.RichElementText:create(3,cc.c3b(41, 110, 146),255," 个","Helvetica",26)                           
    richtext1:pushBackElement(richElement1) 
    richtext1:pushBackElement(richElement2) 
    richtext1:pushBackElement(richElement3) 
    richtext1:setContentSize(cc.size(backColor:getContentSize().width,50)) 
    richtext1:ignoreContentAdaptWithSize(false)
    richtext1:ignoreAnchorPointForPosition(false)
    richtext1:setAnchorPoint(cc.p(0,0.5))
    richtext1:setPosition(-300,0)     
--    backColor:addChild(richtext1)
    
--    local lastButton = ccui.Button:create("image/newstudy/lastbutton.png","","")
--    lastButton:setPosition(float,float)


    return layer
end

return LastWordAndTotalNumberTip