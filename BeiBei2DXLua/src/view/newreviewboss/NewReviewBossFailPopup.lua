local NewReviewBossFailPopup = class ("NewReviewBossFailPopup",function ()
    return cc.Layer:create()
end)

function NewReviewBossFailPopup.create()
    local layer = NewReviewBossFailPopup.new()
    
    local totol_boss_number = s_DATABASE_MGR:getTodayTotalBossNum()
    local current_boss_number = totol_boss_number - s_DATABASE_MGR:getTodayRemainBossNum() + 1
    
    if totol_boss_number == nil then
        totol_boss_number = 4
    end

    if current_boss_number == nil then
        current_boss_number = 4
    end
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local back = cc.Sprite:create("image/newreviewboss/backgroundtanchureviewboss1.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    layer:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
            local candidate = s_CorePlayManager.getReviewBossCandidate()
            s_CorePlayManager.initNewReviewBossLayer(candidate)
            s_CorePlayManager.enterReviewBossMainLayer()
        end
    end
    
    local button_close = ccui.Button:create("image/popupwindow/closeButtonRed.png","image/popupwindow/closeButtonRed.png","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(back:getContentSize().width * 0.93 ,back:getContentSize().height * 0.88)
    button_close:setTitleFontSize(30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)
    
    local boss_sprite = cc.Sprite:create("image/reviewbossscene/rb_fail.png")
    boss_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.75)
    boss_sprite:ignoreAnchorPointForPosition(false)
    boss_sprite:setAnchorPoint(0.5,0.5)
    back:addChild(boss_sprite)

    local popup_title = cc.Label:createWithSystemFont("贝贝豆消失了","",40)
    popup_title:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.6)
    popup_title:setColor(cc.c4b(39,127,182,255))
    popup_title:ignoreAnchorPointForPosition(false)
    popup_title:setAnchorPoint(0.5,0.5)
    back:addChild(popup_title)
    
    local popup_progress = cc.Label:createWithSystemFont("小结（"..current_boss_number.."/"..totol_boss_number..")","",32)
    popup_progress:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.55)
    popup_progress:setColor(cc.c4b(39,127,182,255))
    popup_progress:ignoreAnchorPointForPosition(false)
    popup_progress:setAnchorPoint(0.5,0.5)
    back:addChild(popup_progress)
    
    local popup_text = cc.Label:createWithSystemFont("你已答错3次","",28)
    popup_text:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.5)
    popup_text:setColor(cc.c4b(39,127,182,255))
    popup_text:ignoreAnchorPointForPosition(false)
    popup_text:setAnchorPoint(0.5,0.5)
    back:addChild(popup_text)
    
    
    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
            local candidate = s_CorePlayManager.getReviewBossCandidate()
            s_CorePlayManager.initNewReviewBossLayer(candidate)
            s_CorePlayManager.initReviewReward()
            s_CorePlayManager.enterReviewBossMainLayer()
        end
    end
    
    
    local girl = sp.SkeletonAnimation:create("spine/bb_unhappy_public.json","spine/bb_unhappy_public.atlas",1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(back:getContentSize().width *0.33,back:getContentSize().height * 0.15)
    back:addChild(girl)

    local button_goon = ccui.Button:create("image/newreviewboss/buttonreviewboss1nextend.png","","")
    button_goon:setScale9Enabled(true)
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.1)
    button_goon:setTitleText("重新挑战")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)

    
    return layer
end

return NewReviewBossFailPopup