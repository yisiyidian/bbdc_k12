


local NewReviewBossSuccessPopup = class ("NewReviewBossSuccessPopup",function ()
    return cc.Layer:create()
end)

function NewReviewBossSuccessPopup.create()
    local layer = NewReviewBossSuccessPopup.new()

    local currentchapter
    local totalchapter

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/alter/alter_test1.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    layer:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local popup_title = cc.Label:createWithSystemFont("完成复习","",40)
    popup_title:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.85)
    popup_title:setColor(cc.c4b(39,127,182,255))
    popup_title:ignoreAnchorPointForPosition(false)
    popup_title:setAnchorPoint(0.5,0.5)
    back:addChild(popup_title)

    local popup_total_review = cc.Label:createWithSystemFont("复习单词","",32)
    popup_total_review:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.75)
    popup_total_review:setColor(cc.c4b(39,127,182,255))
    popup_total_review:ignoreAnchorPointForPosition(false)
    popup_total_review:setAnchorPoint(0.5,0.5)
    back:addChild(popup_total_review)

    local popup_complete_review = cc.Label:createWithSystemFont("完全复习","",32)
    popup_complete_review:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.7)
    popup_complete_review:setColor(cc.c4b(39,127,182,255))
    popup_complete_review:ignoreAnchorPointForPosition(false)
    popup_complete_review:setAnchorPoint(0.5,0.5)
    back:addChild(popup_complete_review)
    
    local popup_reward_review = cc.Label:createWithSystemFont("获得贝贝豆","",32)
    popup_reward_review:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.65)
    popup_reward_review:setColor(cc.c4b(39,127,182,255))
    popup_reward_review:ignoreAnchorPointForPosition(false)
    popup_reward_review:setAnchorPoint(0.5,0.5)
    back:addChild(popup_reward_review)

    local girl = sp.SkeletonAnimation:create("spine/bb_happy_public.json","spine/bb_happy_public.atlas",1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(back:getContentSize().width *0.33,back:getContentSize().height * 0.25)
    back:addChild(girl)
    
    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then

            local level = require('view.LevelLayer')
            local layer = level.create()
            s_SCENE.popupLayer.listener:setSwallowTouches(false)
            s_SCENE.popupLayer:removeAllChildren()
            s_SCENE:replaceGameLayer(layer)

        end
    end

    local button_goon = ccui.Button:create("image/newreviewboss/nextgroupbegin.png","image/newreviewboss/nextgroupend.png","")
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.2)
    button_goon:setTitleText("确定")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)


    return layer
end

return NewReviewBossSuccessPopup