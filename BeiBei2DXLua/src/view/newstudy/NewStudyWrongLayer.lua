require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyWrongLayer = class("NewStudyWrongLayer", function ()
    return cc.Layer:create()
end)

function NewStudyWrongLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH



    local layer = NewStudyWrongLayer.new()
    
    local wordUs
    local wordEn
    local word_us_button
    local word_es_button
    local word_mark 
    
    local current_word_sentence_before_wordName 
    local current_word_sentence_after_wordName
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    local pause_button = ccui.Button:create("image/newstudy/pause_button_begin.png","image/newstudy/pause_button_end.png","")
    pause_button:setPosition(s_LEFT_X + 150, s_DESIGN_HEIGHT - 50 )
    pause_button:ignoreAnchorPointForPosition(false)
    pause_button:setAnchorPoint(0,1)
    backGround:addChild(pause_button)    



    for i = 1,8 do
        if i >= currentIndex_unfamiliar then
            if i == 1 then 
                word_mark = cc.Sprite:create("image/newstudy/blue_begin.png")
            elseif i == 8 then 
                word_mark = cc.Sprite:create("image/newstudy/blue_end.png")
            else
                word_mark = cc.Sprite:create("image/newstudy/blue_mid.png")
            end
        else
            if i == 1 then 
                word_mark = cc.Sprite:create("image/newstudy/green_begin.png")
            elseif i == 8 then 
                word_mark = cc.Sprite:create("image/newstudy/green_end.png")
            else
                word_mark = cc.Sprite:create("image/newstudy/green_mid.png")
            end
        end

        if word_mark ~= nil then
            word_mark:setPosition(backGround:getContentSize().width * 0.5 + word_mark:getContentSize().width*1.1 * (i - 5),s_DESIGN_HEIGHT * 0.95)
            word_mark:ignoreAnchorPointForPosition(false)
            word_mark:setAnchorPoint(0,0.5)
            backGround:addChild(word_mark)
        end
    end

    local word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",48)
    word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.9)
    word:setColor(cc.c4b(0,0,0,255))
    word:ignoreAnchorPointForPosition(false)
    word:setAnchorPoint(0.5,0.5)
    backGround:addChild(word)

    local click_playsound = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)

        elseif eventType == ccui.TouchEventType.ended then

            playWordSound(wordName)

        end
    end

    local word_playsound_button = ccui.Button:create("image/newstudy/playsound_begin.png","image/newstudy/playsound_end.png","")
    word_playsound_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.9)
    word_playsound_button:ignoreAnchorPointForPosition(false)
    word_playsound_button:setAnchorPoint(0.5,0.5)
    word_playsound_button:addTouchEventListener(click_playsound)
    backGround:addChild(word_playsound_button) 

    local click_change = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)

        elseif eventType == ccui.TouchEventType.ended then
            if Pronounce_Mark == 1 then          
                Pronounce_Mark = 2
                wordUs:setVisible(false)
                wordEn:setVisible(true)
                word_us_button:setVisible(false)
                word_es_button:setVisible(true)
            else
                Pronounce_Mark = 1
                wordUs:setVisible(true)
                wordEn:setVisible(false)
                word_us_button:setVisible(true)
                word_es_button:setVisible(false)
            end
        end
    end

    wordUs = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordSoundMarkAm,"",42)
    wordUs:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.85)
    wordUs:setColor(cc.c4b(0,0,0,255))
    wordUs:ignoreAnchorPointForPosition(false)
    wordUs:setAnchorPoint(0.5,0.5)
    wordUs:setVisible(true)
    backGround:addChild(wordUs)

    wordEn =  cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordSoundMarkEn,"",42)
    wordEn:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.85)
    wordEn:setColor(cc.c4b(0,0,0,255))
    wordEn:ignoreAnchorPointForPosition(false)
    wordEn:setAnchorPoint(0.5,0.5)
    wordEn:setVisible(false)
    backGround:addChild(wordEn)

    word_us_button = ccui.Button:create("image/newstudy/us_button_begin.png","image/newstudy/us_button_end.png","")
    word_us_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.85)
    word_us_button:ignoreAnchorPointForPosition(false)
    word_us_button:setAnchorPoint(0.5,0.5)
    word_us_button:addTouchEventListener(click_change)
    word_us_button:setVisible(true)
    backGround:addChild(word_us_button)  

    word_es_button = ccui.Button:create("image/newstudy/es_button_begin.png","image/newstudy/es_button_end.png","")
    word_es_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.85)
    word_es_button:ignoreAnchorPointForPosition(false)
    word_es_button:setAnchorPoint(0.5,0.5)
    word_es_button:addTouchEventListener(click_change)
    word_es_button:setVisible(false)
    backGround:addChild(word_es_button)  


    local chineseMeaning = cc.Label:createWithSystemFont("中文释义","",40)
    chineseMeaning:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
    chineseMeaning:setColor(cc.c4b(124,157,208,255))
    chineseMeaning:ignoreAnchorPointForPosition(false)
    chineseMeaning:setAnchorPoint(0,0.5)
    backGround:addChild(chineseMeaning)

    local richtext = ccui.RichText:create()

    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(0.5,0.5)

    richtext:setContentSize(cc.size(backGround:getContentSize().width *0.7, 
        backGround:getContentSize().height *0.3))  

    local current_word_wordMeaning = CCLabelTTF:create (NewStudyLayer_wordList_wordMeaning,
        "Helvetica",32, cc.size(625, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_wordMeaning:setColor(cc.c4b(255,255,255,255))

    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
    richtext:pushBackElement(richElement1)                   
    richtext:setPosition(backGround:getContentSize().width *0.5, 
        backGround:getContentSize().height *0.5)
    richtext:setLocalZOrder(10)

    local exampleSentence = cc.Label:createWithSystemFont("例句","",40)
    exampleSentence:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.5)
    exampleSentence:setColor(cc.c4b(124,157,208,255))
    exampleSentence:ignoreAnchorPointForPosition(false)
    exampleSentence:setAnchorPoint(0,0.5)
    backGround:addChild(exampleSentence)

    
    local sentence_length = string.len(NewStudyLayer_wordList_sentenceEn)
    local wordName_begin_position,wordName_end_position = string.find(string.upper(NewStudyLayer_wordList_sentenceEn),string.upper(NewStudyLayer_wordList_wordName))
    
    current_word_sentence_before_wordName = string.sub(NewStudyLayer_wordList_sentenceEn,1,wordName_begin_position - 1)
    current_word_sentence_after_wordName = string.sub(NewStudyLayer_wordList_sentenceEn,wordName_end_position + 1,sentence_length)


    local current_word_sentence_before_wordName_label = CCLabelTTF:create (current_word_sentence_before_wordName,
        "Helvetica",32)
    current_word_sentence_before_wordName_label:setColor(cc.c4b(255,255,255,255))
    
    
--    local current_word_sentence_before_wordName_label = cc.Label:createWithSystemFont("qwertyuiop","",40)
--    current_word_sentence_before_wordName_label:setColor(cc.c4b(255,255,255,255))
    
--    local Achar = current_word_sentence_before_wordName_label:getLetter(1)
    
--    for i =1 , 5 do
--        print("current_word_sentence_before_wordName_label:getLetter"..i..current_word_sentence_before_wordName_label:getLetter(i))
--    end
--    local rotate = cc.RotateBy:create(2, 360)
--    local rot_4ever = cc.RepeatForever:create(rotate)
--    Achar:runAction(rot_4ever)


    local current_word_sentence_wordName_label = CCLabelTTF:create (NewStudyLayer_wordList_wordName,
        "Helvetica",32)
    current_word_sentence_wordName_label:setColor(cc.c4b(196,143,85,255))  

    local current_word_sentence_after_wordName_label = CCLabelTTF:create (current_word_sentence_after_wordName,
        "Helvetica",32)
    current_word_sentence_after_wordName_label:setColor(cc.c4b(255,255,255,255))

    local current_word_sentence_chinese_label = CCLabelTTF:create (NewStudyLayer_wordList_sentenceCn,
        "Helvetica",32)
    current_word_sentence_chinese_label:setColor(cc.c4b(255,255,255,255))
    
    

    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_before_wordName_label)   
    local richElement3 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_wordName_label)   
    local richElement4 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_after_wordName_label)  
    local richElement5 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_chinese_label)  
   
    


    if wordName_begin_position ~= 1 and wordName_end_position ~= sentence_length then
        
        richtext:pushBackElement(richElement2)      
        richtext:pushBackElement(richElement3)   
        richtext:pushBackElement(richElement4)    
        richtext:pushBackElement(richElement5)     
          
    elseif wordName_begin_position == 1 and wordName_end_position ~= sentence_length then
    
        richtext:pushBackElement(richElement3)   
        richtext:pushBackElement(richElement4)    
        richtext:pushBackElement(richElement5) 
            
    elseif wordName_begin_position ~= 1 and wordName_end_position == sentence_length then

        richtext:pushBackElement(richElement2)      
        richtext:pushBackElement(richElement3)      
        richtext:pushBackElement(richElement5)    
        
    elseif wordName_begin_position == 1 and wordName_end_position == sentence_length then
         
        richtext:pushBackElement(richElement3)      
        richtext:pushBackElement(richElement5) 
    end
    
    backGround:addChild(richtext) 

    local click_improve_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Slide)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end



    local spell_drill = cc.Label:createWithSystemFont("拼写强化训练>","",40)
    spell_drill:setPosition(backGround:getContentSize().width *0.13  , s_DESIGN_HEIGHT * 0.3)
    spell_drill:setColor(cc.c4b(124,157,208,255))
    spell_drill:ignoreAnchorPointForPosition(false)
    spell_drill:setAnchorPoint(0,0.5)
    backGround:addChild(spell_drill)
    
    local spell_position = cc.p(spell_drill:getPosition())
    local spell_size = spell_drill:getContentSize()
    
    local onTouchBegan = function(touch, event)

        return true
    end
    
    
    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(spell_drill:getBoundingBox(), location) then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Slide)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end


    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            currentIndex_unfamiliar = currentIndex_unfamiliar + 1
            
            NewStudyLayer_wordList_currentWord           =   s_WordPool[NewStudyLayer_wordList[currentIndex_unfamiliar]]
            NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
            NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
            NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
            NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
            NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
            NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
            NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn

            if currentIndex_unfamiliar ==  9 then
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Mission)
                s_SCENE:replaceGameLayer(newStudyLayer)
            else
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end
        end
    end

    local choose_next_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
    choose_next_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
    choose_next_button:ignoreAnchorPointForPosition(false)
    choose_next_button:setAnchorPoint(0.5,0.5)
    choose_next_button:addTouchEventListener(click_next_button)
    backGround:addChild(choose_next_button)  

    local choose_next_text = cc.Label:createWithSystemFont("下一个","",32)
    choose_next_text:setPosition(choose_next_button:getContentSize().width * 0.5,choose_next_button:getContentSize().height * 0.5)
    choose_next_text:setColor(cc.c4b(255,255,255,255))
    choose_next_text:ignoreAnchorPointForPosition(false)
    choose_next_text:setAnchorPoint(0.5,0.5)
    choose_next_button:addChild(choose_next_text)
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return NewStudyWrongLayer