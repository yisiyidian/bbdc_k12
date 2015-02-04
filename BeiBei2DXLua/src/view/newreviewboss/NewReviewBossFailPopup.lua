local NewReviewBossFailPopup = class ("NewReviewBossFailPopup",function ()
    return cc.Layer:create()
end)

function NewReviewBossFailPopup.create(currentWordName,reviewWordList,number)
    AnalyticsFirst(ANALYTICS_FIRST_REVIEW_BOSS_RESULT, 'fail')

    local currentWord       = s_WordPool[currentWordName]
    local wordname          = currentWord.wordName
    local wordSoundMarkEn   = currentWord.wordSoundMarkEn
    local wordSoundMarkAm   = currentWord.wordSoundMarkAm
    local wordMeaningSmall  = currentWord.wordMeaningSmall
    local wordMeaning       = currentWord.wordMeaning
    local sentenceEn        = currentWord.sentenceEn
    local sentenceCn        = currentWord.sentenceCn
    local sentenceEn2       = currentWord.sentenceEn2
    local sentenceCn2       = currentWord.sentenceCn2

    local layer = NewReviewBossFailPopup.new()
    
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
            s_CorePlayManager.enterLevelLayer()
        end
    end
    
    local button_close = ccui.Button:create("image/popupwindow/closeButtonRed.png","image/popupwindow/closeButtonRed.png","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(back:getContentSize().width * 0.93 ,back:getContentSize().height * 0.88)
    button_close:setTitleFontSize(30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)
    

    local popup_title = cc.Label:createWithSystemFont("真遗憾！这个词：","",40)
    popup_title:setPosition(back:getContentSize().width *0.51,back:getContentSize().height *0.8)
    popup_title:setColor(cc.c4b(29,156,196,255))
    popup_title:ignoreAnchorPointForPosition(false)
    popup_title:setAnchorPoint(0.5,0.5)
    back:addChild(popup_title)
    
    local popup_word = cc.Label:createWithSystemFont(wordname,"",40)
    popup_word:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.7)
    popup_word:setColor(cc.c4b(0,0,0,255))
    popup_word:ignoreAnchorPointForPosition(false)
    popup_word:setAnchorPoint(0.5,0.5)
    back:addChild(popup_word)
    
    local popup_meaning = cc.Label:createWithSystemFont(wordMeaningSmall,"",40)
    popup_meaning:setPosition(back:getContentSize().width / 2,back:getContentSize().height *0.65)
    popup_meaning:setColor(cc.c4b(0,0,0,255))
    popup_meaning:ignoreAnchorPointForPosition(false)
    popup_meaning:setAnchorPoint(0.5,0.5)
    back:addChild(popup_meaning)
    
    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
            local NewReviewBossMainLayer = require("view.newreviewboss.NewReviewBossMainLayer")
            local newReviewBossMainLayer = NewReviewBossMainLayer.create(reviewWordList,number)
            s_SCENE:replaceGameLayer(newReviewBossMainLayer)
        end
    end
    
    local girl = sp.SkeletonAnimation:create("spine/bb_unhappy_public.json","spine/bb_unhappy_public.atlas",1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(back:getContentSize().width *0.33,back:getContentSize().height * 0.2)
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