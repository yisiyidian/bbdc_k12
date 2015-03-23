local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")
local Pause             = require("view.newreviewboss.NewReviewBossPause")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newreviewboss.NewReviewBossWordInfo")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  NewReviewBossHintLayer = class("NewReviewBossHintLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossHintLayer.create(currentWordName)

    -- word info
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

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.2, cc.p(s_DESIGN_WIDTH/2*3, s_DESIGN_HEIGHT * 0.55))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            layer.close()  
        end)
        white_back:runAction(cc.Sequence:create(action2,action3))
    end
    
    local return_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            closeAnimation() 
        end
    end

    local return_button = Button.create("返回")
    return_button:setPosition(s_DESIGN_WIDTH / 2, 100)
    return_button:addTouchEventListener(return_click) 
    layer:addChild(return_button) 
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(white_back:getBoundingBox(),location) then
            closeAnimation() 
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

return NewReviewBossHintLayer