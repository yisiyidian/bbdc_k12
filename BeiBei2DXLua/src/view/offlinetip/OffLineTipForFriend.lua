local OffLineTipForFriend = class("OffLineTipForFriend", function()
    return cc.Layer:create()
end)

function OffLineTipForFriend.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = OffLineTipForFriend.new()

    local backColor = cc.LayerColor:create(cc.c4b(234,247,254,255),bigWidth,50)
    backColor:setPosition(s_LEFT_X, 900)
    layer:addChild(backColor)

    local tipContent = "离线无法社交。"
    if not s_SERVER.hasSessionToken() then
        tipContent = '需要登录服务器后才能进入好友界面'
    end
    local tip = cc.Label:createWithSystemFont(tipContent,"",24)
    tip:setPosition(backColor:getContentSize().width / 2,backColor:getContentSize().height / 2)
    tip:setColor(cc.c4b(109,125,128,255))
    backColor:addChild(tip)

    backColor:setVisible(false)

    layer.setTrue = function ()
        backColor:setVisible(true)
        local action1 = cc.FadeIn:create(1)
        local action2 = cc.FadeOut:create(10)
        backColor:runAction(cc.Sequence:create(action1,action2))
        local action3 = cc.FadeIn:create(1)
        local action4 = cc.FadeOut:create(10)
        tip:runAction(cc.Sequence:create(action3,action4))
    end
    
    layer.setFalse = function ()
    	backColor:setVisible(false)
    end



    return layer
end

return OffLineTipForFriend