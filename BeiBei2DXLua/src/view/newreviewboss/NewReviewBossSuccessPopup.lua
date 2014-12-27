local NewReviewBossSuccessPopup = class ("NewReviewBossSuccessPopup",function ()
    return cc.Layer:create()
end)

function NewReviewBossSuccessPopup.create()
    local layer = NewReviewBossSuccessPopup.new()

    local currentchapter
    local totalchapter
    
    local reward = s_CorePlayManager.reward
    local totalWord = s_CorePlayManager.totalWord
    
    if reward == nil then
    reward = 12
    end
    
    if totalWord == nil then 
    totalWord = 80
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/newreviewboss/backgroundtanchureviewboss1.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    layer:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local boss_sprite = cc.Sprite:create("image/reviewbossscene/rb_success.png")
    boss_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height * 0.75)
    boss_sprite:ignoreAnchorPointForPosition(false)
    boss_sprite:setAnchorPoint(0.5,0.5)
    back:addChild(boss_sprite)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then

            --            local level = require('view.LevelLayer')
            --            local layer = level.create()
            s_SCENE.popupLayer.listener:setSwallowTouches(false)
            s_SCENE.popupLayer:removeAllChildren()
--            s_SCENE:replaceGameLayer(layer)

            s_CorePlayManager.enterHomeLayer()

        end
    end

    local button_close = ccui.Button:create("image/popupwindow/closeButtonRed.png","image/popupwindow/closeButtonRed.png","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(back:getContentSize().width * 0.93 ,back:getContentSize().height * 0.88)
    button_close:setTitleFontSize(30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)


    local popup_title = cc.Label:createWithSystemFont("打跑复习怪兽","",40)
    popup_title:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.6)
    popup_title:setColor(cc.c4b(39,127,182,255))
    popup_title:ignoreAnchorPointForPosition(false)
    popup_title:setAnchorPoint(0.5,0.5)
    back:addChild(popup_title)

    local popup_total_review = cc.Label:createWithSystemFont("复习单词","",32)
    popup_total_review:setPosition(back:getContentSize().width *0.4,back:getContentSize().height *0.55)
    popup_total_review:setColor(cc.c4b(39,127,182,255))
    popup_total_review:ignoreAnchorPointForPosition(false)
    popup_total_review:setAnchorPoint(0.5,0.5)
    back:addChild(popup_total_review)

    local popup_total_number = cc.Label:createWithSystemFont(totalWord.."个","",32)
    popup_total_number:setPosition(back:getContentSize().width *0.6,back:getContentSize().height *0.55)
    popup_total_number:setColor(cc.c4b(228,78,0,255))
    popup_total_number:ignoreAnchorPointForPosition(false)
    popup_total_number:setAnchorPoint(0.5,0.5)
    back:addChild(popup_total_number)
    
    local popup_reward_review = cc.Label:createWithSystemFont("获得贝贝豆","",32)
    popup_reward_review:setPosition(back:getContentSize().width *0.4,back:getContentSize().height *0.5)
    popup_reward_review:setColor(cc.c4b(39,127,182,255))
    popup_reward_review:ignoreAnchorPointForPosition(false)
    popup_reward_review:setAnchorPoint(0.5,0.5)
    back:addChild(popup_reward_review)
    
    local popup_reward_number = cc.Label:createWithSystemFont(reward.."个","",32)
    popup_reward_number:setPosition(back:getContentSize().width *0.6,back:getContentSize().height *0.5)
    popup_reward_number:setColor(cc.c4b(228,78,0,255))
    popup_reward_number:ignoreAnchorPointForPosition(false)
    popup_reward_number:setAnchorPoint(0.5,0.5)
    back:addChild(popup_reward_number)

    local girl = sp.SkeletonAnimation:create("spine/bb_happy_public.json","spine/bb_happy_public.atlas",1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(back:getContentSize().width *0.33,back:getContentSize().height * 0.15)
    back:addChild(girl)
    
    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then

--            local level = require('view.LevelLayer')
--            local layer = level.create()
            s_SCENE.popupLayer.listener:setSwallowTouches(false)
            s_SCENE.popupLayer:removeAllChildren()
            
            s_CorePlayManager.enterHomeLayer()

        end
    end

    local button_goon = ccui.Button:create("image/newreviewboss/buttonreviewboss1nextend.png","image/newreviewboss/buttonreviewboss1nextend.png","")
    button_goon:setScale9Enabled(true)
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.1)
    button_goon:setTitleText("完成复习")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)


    return layer
end

return NewReviewBossSuccessPopup