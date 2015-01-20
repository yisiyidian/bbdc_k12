local GuessWrongPunishPopup = class ("GuessWrongPunishPopup",function ()
    return cc.Layer:create()
end)

function GuessWrongPunishPopup.create(reward)
    local layer = GuessWrongPunishPopup.new(reward)
    return layer
end

function GuessWrongPunishPopup:ctor(reward)

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/newstudy/infopopup.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    self:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    self.button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
            s_CorePlayManager.enterNewStudyWrongLayer()
        end
    end  

    local button_goon = ccui.Button:create("image/newstudy/button_ok.png","","")
    button_goon:setScale9Enabled(true)
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.1)
    button_goon:setTitleText("确定")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(self.button_goon_clicked)
    back:addChild(button_goon)
end

return GuessWrongPunishPopup