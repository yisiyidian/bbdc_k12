


local ProgressBar       = require("view.newstudy.NewStudyProgressBar")

local  NewReviewBossHintLayer = class("NewReviewBossHintLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossHintLayer.create()

    -- word info
    local currentWordName   = s_CorePlayManager.ReviewWordList[s_CorePlayManager.currentReviewIndex]
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

    local layer = NewReviewBossHintLayer.new()

    layer.close  = function ()
    	
    end

    local backGround = cc.Sprite:create("image/newreviewboss/newreviewboss_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)
    
    local onTouchBegan = function(touch, event)
        playSound(s_sound_buttonEffect) 
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(backGround:getBoundingBox(), location) then
           layer.close()
        end
    end

    for i=1,3 do
        local reward = cc.Sprite:create("image/newstudy/bean.png")
        reward:setPosition(backGround:getContentSize().width - reward:getContentSize().width * (i + 2),
            backGround:getContentSize().height)
        reward:ignoreAnchorPointForPosition(false)
        reward:setAnchorPoint(0.5,1)
        backGround:addChild(reward)  
    end
    
    local rbProgressBar = ProgressBar.create(s_CorePlayManager.maxReviewWordCount,s_CorePlayManager.currentReviewIndex - 1,"red")
    rbProgressBar:setPosition(backGround:getContentSize().width/2, s_DESIGN_HEIGHT * 0.95)
    backGround:addChild(rbProgressBar)
    
    local huge_word = cc.Label:createWithSystemFont(wordname,"",48)
    huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.85)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    backGround:addChild(huge_word)
    
    local hint_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            layer.close()               
        end
    end
    
    local hint_button = ccui.Button:create("image/newreviewboss/hintbuttonbegin.png","image/newreviewboss/hintbuttonend.png","")
    hint_button:setPosition(backGround:getContentSize().width - 150, s_DESIGN_HEIGHT * 0.85 )
    hint_button:ignoreAnchorPointForPosition(false)
    hint_button:setAnchorPoint(1,0.5)
    hint_button:addTouchEventListener(hint_click)
    backGround:addChild(hint_button) 
    
    local hint_label = cc.Label:createWithSystemFont("提示","",24)
    hint_label:setPosition(hint_button:getContentSize().width / 2,hint_button:getContentSize().height / 2)
    hint_label:setColor(cc.c4b(255,255,255,255))
    hint_label:ignoreAnchorPointForPosition(false)
    hint_label:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_label)
    
    local blue_line = cc.LayerColor:create(cc.c4b(49,188,251,255), 10, 300)  
    blue_line:setAnchorPoint(0.5,1)
    blue_line:ignoreAnchorPointForPosition(false)
    blue_line:setPosition(hint_button:getContentSize().width/2,hint_button:getContentSize().height/2)
    blue_line:setLocalZOrder(hint_button:getLocalZOrder() - 1)
    hint_button:addChild(blue_line)
    
    local blue_back = cc.Sprite:create("image/newreviewboss/blueback.png")
    blue_back:setPosition(backGround:getContentSize().width / 2,backGround:getContentSize().height * 0.38)
    blue_back:ignoreAnchorPointForPosition(false)
    blue_back:setAnchorPoint(0.5,0.5)
    backGround:addChild(blue_back)
    
    local wordSoundMarkAm = cc.Label:createWithSystemFont(wordSoundMarkAm,"",32)
    wordSoundMarkAm:setPosition(blue_back:getContentSize().width *0.1,blue_back:getContentSize().height * 0.9)
    wordSoundMarkAm:setColor(cc.c4b(0,0,0,255))
    wordSoundMarkAm:ignoreAnchorPointForPosition(false)
    wordSoundMarkAm:setAnchorPoint(0,0.5)
    blue_back:addChild(wordSoundMarkAm)
    
    local chineseMeaning = cc.Label:createWithSystemFont("中文释义","",32)
    chineseMeaning:setPosition(blue_back:getContentSize().width *0.1,blue_back:getContentSize().height * 0.8)
    chineseMeaning:setColor(cc.c4b(0,0,0,255))
    chineseMeaning:ignoreAnchorPointForPosition(false)
    chineseMeaning:setAnchorPoint(0,0.5)
    blue_back:addChild(chineseMeaning)

    local richtext = ccui.RichText:create()

    local current_word_wordMeaning = cc.LabelTTF:create (wordMeaning,
        "Helvetica",30, cc.size(blue_back:getContentSize().width *0.8, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_wordMeaning:setColor(cc.c4b(0,0,0,255))

    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           

    local exampleSentence = cc.Label:createWithSystemFont("例句","",32)
    exampleSentence:setPosition(blue_back:getContentSize().width *0.1,blue_back:getContentSize().height * 0.5)
    exampleSentence:setColor(cc.c4b(0,0,0,255))
    exampleSentence:ignoreAnchorPointForPosition(false)
    exampleSentence:setAnchorPoint(0,0.5)
    blue_back:addChild(exampleSentence)

    local current_word_sentence = cc.LabelTTF:create (sentenceEn..sentenceCn..sentenceEn2..sentenceCn2,
        "Helvetica",30, cc.size(blue_back:getContentSize().width *0.8, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_sentence:setColor(cc.c4b(0,0,0,255))

    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence)       
    
    richtext:pushBackElement(richElement1) 
    richtext:pushBackElement(richElement2) 
    richtext:setContentSize(cc.size(blue_back:getContentSize().width *0.8, 
        blue_back:getContentSize().height *0.3)) 
    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(cc.p(0.5,0.5))
    richtext:setPosition(blue_back:getContentSize().width *0.5, 
        blue_back:getContentSize().height *0.6)
    richtext:setLocalZOrder(10)                    

    blue_back:addChild(richtext) 
    
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backGround)
    
    return layer
end

return NewReviewBossHintLayer