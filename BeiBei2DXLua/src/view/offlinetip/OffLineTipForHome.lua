local OffLineTipForHome = class("OffLineTipForHome", function()
    return cc.Layer:create()
end)

function OffLineTipForHome.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = OffLineTipForHome.new()

    local backColor = cc.LayerColor:create(cc.c4b(250,251,247,255),bigWidth,50)
    backColor:setPosition(s_LEFT_X, 415)
    backColor:setVisible(false)
    layer:addChild(backColor)

    local tip = cc.Label:createWithSystemFont("离线模式下不能登出游戏。","",24)
    tip:setPosition(backColor:getContentSize().width / 2,backColor:getContentSize().height / 2)
    tip:setColor(cc.c4b(109,125,128,255))
    backColor:addChild(tip)
    
    layer.set = function ()
        backColor:setVisible(not (backColor:isVisible())) 
    end


    return layer
end

return OffLineTipForHome