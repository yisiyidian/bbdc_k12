local GuessWrongPunishPopup = class ("GuessWrongPunishPopup",function ()
    return cc.Layer:create()
end)

function GuessWrongPunishPopup.create(currentReward,totalReward)
    local layer = GuessWrongPunishPopup.new(currentReward,totalReward)
    return layer
end

function GuessWrongPunishPopup:ctor(currentReward,totalReward)

    if currentReward == nil then
        currentReward = 3
    end
    
    if totalReward == nil then
        totalReward = 3
    end
    
    s_CorePlayManager.reward = s_CorePlayManager.reward - 1

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/newstudy/guesswrong.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    self:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local text = cc.Label:createWithSystemFont("瞎猜是会有惩罚的！","",30)
    text:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.8)
    text:setColor(cc.c4b(84,107,140,255))
    back:addChild(text)
    
    for i = 1,totalReward do
        local bean = cc.Sprite:create("image/newstudy/bean.png")
        bean:setPosition(back:getContentSize().width * (0.3 +  ( 3 - totalReward) * 0.1 + (i - 1) * 0.2),back:getContentSize().height * 0.5)
        bean:setName("bean"..i)
        back:addChild(bean)
    end
    
    for i = currentReward,totalReward do
        local bean = back:getChildByName("bean"..i)
        bean:setTexture("image/newstudy/badbean.png")
    end

    local sprite = back:getChildByName("bean"..currentReward)
    local animation = sp.SkeletonAnimation:create("spine/fuxiboss_bea_dispare.json", "spine/fuxiboss_bea_dispare.atlas", 1)
    animation:setPosition(sprite:getContentSize().width / 2, 0)
    sprite:addChild(animation)      
    animation:addAnimation(0, 'oudupus2', false)

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
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.2)
    button_goon:setTitleText("再也不乱猜了～")
    button_goon:setTitleFontSize(20)
    button_goon:addTouchEventListener(self.button_goon_clicked)
    back:addChild(button_goon)
end

return GuessWrongPunishPopup