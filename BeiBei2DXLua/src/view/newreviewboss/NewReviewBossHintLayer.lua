local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")
local Pause             = require("view.newreviewboss.NewReviewBossPause")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newreviewboss.NewReviewBossWordInfo")

local  NewReviewBossHintLayer = class("NewReviewBossHintLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossHintLayer.create(currentWordName)

    -- word info
--    local currentWordName   = s_CorePlayManager.ReviewWordList[s_CorePlayManager.currentReviewIndex]
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
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local type = s_CorePlayManager.typeIndex

    local layer = NewReviewBossHintLayer.new()
   
    local return_button
    local white_back
    local line_y

    layer.close  = function ()
    	
    end
    
    white_back = cc.Sprite:create("image/newreviewboss/backgroundreviewboss1tishi.png")
    white_back:setPosition(s_DESIGN_WIDTH/2*2, s_DESIGN_HEIGHT * 0.55)
    white_back:ignoreAnchorPointForPosition(false)
    white_back:setAnchorPoint(0.5,0.5)
    layer:addChild(white_back)
    
    local soundMark = SoundMark.create(wordname, wordSoundMarkEn, wordSoundMarkAm)
    soundMark:setPosition(white_back:getContentSize().width/2, white_back:getContentSize().height * 0.85 )  
    white_back:addChild(soundMark)
    
    local detailInfo = DetailInfo.create(currentWord)
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(white_back:getContentSize().width/2, white_back:getContentSize().height * 0.4 )
    white_back:addChild(detailInfo)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55))
    local action2 = cc.EaseBackOut:create(action1)
    white_back:runAction(action2)
    
    local return_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            local action2 = cc.MoveTo:create(0.2, cc.p(s_DESIGN_WIDTH/2*3, s_DESIGN_HEIGHT * 0.55))
            white_back:runAction(action2)
        elseif eventType == ccui.TouchEventType.ended then
            layer.close()  
        end
    end

    local return_button = ccui.Button:create("image/newreviewboss/buttonreviewboss1nextend.png","","")
    return_button:setScale9Enabled(true)
    return_button:setPosition(s_DESIGN_WIDTH / 2, 100)
    return_button:ignoreAnchorPointForPosition(false)
    return_button:setAnchorPoint(0.5,0)
    return_button:addTouchEventListener(return_click)
    return_button:setScale9Enabled(true)
    layer:addChild(return_button) 

    local return_label = cc.Label:createWithSystemFont("返回","",36)
    return_label:setPosition(return_button:getContentSize().width * 0.5,return_button:getContentSize().height * 0.5)
    return_label:setColor(cc.c4b(255,255,255,255))
    return_label:ignoreAnchorPointForPosition(false)
    return_label:setAnchorPoint(0.5,0.5)
    return_button:addChild(return_label)
    
    return layer
end

return NewReviewBossHintLayer