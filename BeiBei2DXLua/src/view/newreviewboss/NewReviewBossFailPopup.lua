require("view.newstudy.NewStudyConfigure")


local NewReviewBossFailPopup = class ("NewReviewBossFailPopup",function ()
    return cc.Layer:create()
end)

function NewReviewBossFailPopup.create()
    local layer = NewReviewBossFailPopup.new()
    
    local currentchapter
    local totalchapter
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local back = cc.Sprite:create("image/alter/alter_test1.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    layer:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local popup_title = cc.Label:createWithSystemFont("贝贝豆消失了","",40)
    popup_title:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.8)
    popup_title:setColor(LightBlueFont)
    popup_title:ignoreAnchorPointForPosition(false)
    popup_title:setAnchorPoint(0.5,0.5)
    back:addChild(popup_title)
    
    local popup_progress = cc.Label:createWithSystemFont("小结（4/4）","",32)
    popup_progress:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.7)
    popup_progress:setColor(LightBlueFont)
    popup_progress:ignoreAnchorPointForPosition(false)
    popup_progress:setAnchorPoint(0.5,0.5)
    back:addChild(popup_progress)
    
    local popup_text = cc.Label:createWithSystemFont("贝贝豆都消失了，请重新挑战关卡","",28)
    popup_text:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.6)
    popup_text:setColor(LightBlueFont)
    popup_text:ignoreAnchorPointForPosition(false)
    popup_text:setAnchorPoint(0.5,0.5)
    back:addChild(popup_text)
    
    for i=1,3 do
        local reward = cc.Sprite:create("image/newstudy/bean.png")
        reward:setPosition(back:getContentSize().width / 2 - reward:getContentSize().width * 2 * (i - 2),
            back:getContentSize().height / 2 )
        reward:ignoreAnchorPointForPosition(false)
        reward:setAnchorPoint(0.5,0.5)
        reward:setColor(WhiteFont)
        back:addChild(reward)  
    end
    
    local girl = sp.SkeletonAnimation:create("spine/bb_unhappy_public.json","spine/bb_unhappy_public.atlas",1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(back:getContentSize().width *0.33,back:getContentSize().height * 0.1)
    back:addChild(girl)

    local button_goon = ccui.Button:create("image/newreviewboss/playagainbegin.png","image/newreviewboss/playagainend.png","")
    button_goon:setPosition(back:getContentSize().width * 0.2,back:getContentSize().height * 0.2)
    button_goon:setTitleText("重玩")
    button_goon:setTitleFontSize(30)
--    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)

    
    return layer
end

return NewReviewBossFailPopup