local OfflineTip = class("OfflineTip", function()
    return cc.Layer:create()
end)

function OfflineTip.create(content, onHide)
    content = content or ''

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = OfflineTip.new()

    local backColor = cc.LayerColor:create(cc.c4b(234,247,254,255),bigWidth,50)
    backColor:setPosition(s_LEFT_X, -100)
    layer:addChild(backColor)

    local tip = cc.Label:createWithSystemFont(content, "", 24)
    tip:setPosition(backColor:getContentSize().width / 2,backColor:getContentSize().height / 2)
    tip:setColor(cc.c4b(109,125,128,255))
    backColor:addChild(tip)
    
    backColor:setVisible(false)
    
    layer.show = function ()
        backColor:setVisible(true)
        local action1 = cc.FadeIn:create(1)
        local action2 = cc.FadeOut:create(10)
        backColor:runAction(cc.Sequence:create(action1,action2))
        local action3 = cc.FadeIn:create(1)
        local action4 = cc.FadeOut:create(10)
        if onHide then
            tip:runAction(cc.Sequence:create(action3, action4, cc.CallFunc:create(onHide)))
        else
            tip:runAction(cc.Sequence:create(action3, action4))
        end
    end

    return layer
end

return OfflineTip