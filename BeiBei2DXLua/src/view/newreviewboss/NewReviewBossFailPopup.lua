local Button                = require("view.button.longButtonInStudy")

local NewReviewBossFailPopup = class ("NewReviewBossFailPopup",function ()
    return cc.Layer:create()
end)

function NewReviewBossFailPopup.create(currentWordName,reviewWordList,number)
    AnalyticsFirst(ANALYTICS_FIRST_REVIEW_BOSS_RESULT, 'fail')

    local currentWord       = s_LocalDatabaseManager.getWordInfoFromWordName(currentWordName)
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

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
            local NewReviewBossMainLayer = require("view.newreviewboss.NewReviewBossMainLayer")
            local newReviewBossMainLayer = NewReviewBossMainLayer.create(reviewWordList,number)
            s_SCENE:replaceGameLayer(newReviewBossMainLayer)
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            closeAnimation()
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

    local showWord = string.gsub(wordname,"|"," ")
    
    local popup_word = cc.Label:createWithSystemFont(showWord,"",40)
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
    
    local button_func = function()
        playSound(s_sound_buttonEffect)
        closeAnimation()
    end
    
    local girl = sp.SkeletonAnimation:create("spine/bb_unhappy_public.json","spine/bb_unhappy_public.atlas",1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(back:getContentSize().width *0.33,back:getContentSize().height * 0.3)
    back:addChild(girl)

    local button_goon = Button.create("long","blue","重新挑战")
    button_goon.func = function ()
        button_func()
    end
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.2)
    back:addChild(button_goon)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                s_SCENE:removeAllPopups()
                local NewReviewBossMainLayer = require("view.newreviewboss.NewReviewBossMainLayer")
                local newReviewBossMainLayer = NewReviewBossMainLayer.create(reviewWordList,number)
                s_SCENE:replaceGameLayer(newReviewBossMainLayer)
            end)
            back:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    onAndroidKeyPressed(layer, function ()
        closeAnimation()
    end, function ()

    end)

    
    return layer
end

return NewReviewBossFailPopup