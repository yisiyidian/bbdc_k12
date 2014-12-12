require("cocos.init")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyWrongLayer = class("NewStudyWrongLayer", function ()
    return cc.Layer:create()
end)

function NewStudyWrongLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH



    local layer = NewStudyWrongLayer.new()
    
    local current_word_sentence_before_wordName 
    local current_word_sentence_after_wordName
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    AddPauseButton(backGround)  

    JudgeColorAtTop(backGround) 

    PlayWordSoundAndAddSprite(backGround)     


    local chineseMeaning = cc.Label:createWithSystemFont("中文释义","",32)
    chineseMeaning:setPosition(backGround:getContentSize().width *0.18,s_DESIGN_HEIGHT * 0.68)
    chineseMeaning:setColor(SilverFont)
    chineseMeaning:ignoreAnchorPointForPosition(false)
    chineseMeaning:setAnchorPoint(0,0.5)
    backGround:addChild(chineseMeaning)

    local richtext = ccui.RichText:create()

    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(cc.p(0.5,0.5))

    richtext:setContentSize(cc.size(backGround:getContentSize().width *0.65, 
        backGround:getContentSize().height *0.3))  

    local current_word_wordMeaning = cc.LabelTTF:create (NewStudyLayer_wordList_wordMeaning,
        "Helvetica",32, cc.size(550, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_wordMeaning:setColor(cc.c4b(255,255,255,255))

    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
    richtext:pushBackElement(richElement1)                   
    richtext:setPosition(backGround:getContentSize().width *0.5, 
        backGround:getContentSize().height *0.5)
    richtext:setLocalZOrder(10)

    local exampleSentence = cc.Label:createWithSystemFont("例句","",32)
    exampleSentence:setPosition(backGround:getContentSize().width *0.18,s_DESIGN_HEIGHT * 0.5)
    exampleSentence:setColor(SilverFont)
    exampleSentence:ignoreAnchorPointForPosition(false)
    exampleSentence:setAnchorPoint(0,0.5)
    backGround:addChild(exampleSentence)
    
    local current_word_sentence = cc.LabelTTF:create (NewStudyLayer_wordList_sentenceEn..NewStudyLayer_wordList_sentenceCn,
        "Helvetica",32, cc.size(550, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_sentence:setColor(cc.c4b(255,255,255,255))

    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence)                           
    richtext:pushBackElement(richElement2) 
   
   ----need improvement
    
--    local sentence_length = string.len(NewStudyLayer_wordList_sentenceEn)
--    local wordName_begin_position,wordName_end_position = string.find(string.upper(NewStudyLayer_wordList_sentenceEn),string.upper(NewStudyLayer_wordList_wordName))
--    
--    current_word_sentence_before_wordName = string.sub(NewStudyLayer_wordList_sentenceEn,1,wordName_begin_position - 1)
--    current_word_sentence_after_wordName = string.sub(NewStudyLayer_wordList_sentenceEn,wordName_end_position + 1,sentence_length)
--
--
    --    local current_word_sentence_before_wordName_label = cc.LabelTTF:create (current_word_sentence_before_wordName,
--        "Helvetica",32)
--    current_word_sentence_before_wordName_label:setColor(cc.c4b(255,255,255,255))
--
--
    --    local current_word_sentence_wordName_label = cc.LabelTTF:create (NewStudyLayer_wordList_wordName,
--        "Helvetica",32)
--    current_word_sentence_wordName_label:setColor(cc.c4b(196,143,85,255))  
--
    --    local current_word_sentence_after_wordName_label = cc.LabelTTF:create (current_word_sentence_after_wordName,
--        "Helvetica",32)
--    current_word_sentence_after_wordName_label:setColor(cc.c4b(255,255,255,255))
--
    --    local current_word_sentence_chinese_label = cc.LabelTTF:create (NewStudyLayer_wordList_sentenceCn,
--        "Helvetica",32)
--    current_word_sentence_chinese_label:setColor(cc.c4b(255,255,255,255))
--    
--
--    
--    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_before_wordName_label)   
--    local richElement3 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_wordName_label)   
--    local richElement4 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_after_wordName_label)  
--    local richElement5 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_chinese_label)  
--   
--    
--
--
--    if wordName_begin_position ~= 1 and wordName_end_position ~= sentence_length then
--        
--        richtext:pushBackElement(richElement2)      
--        richtext:pushBackElement(richElement3)   
--        richtext:pushBackElement(richElement4)    
--        richtext:pushBackElement(richElement5)     
--          
--    elseif wordName_begin_position == 1 and wordName_end_position ~= sentence_length then
--    
--        richtext:pushBackElement(richElement3)   
--        richtext:pushBackElement(richElement4)    
--        richtext:pushBackElement(richElement5) 
--            
--    elseif wordName_begin_position ~= 1 and wordName_end_position == sentence_length then
--
--        richtext:pushBackElement(richElement2)      
--        richtext:pushBackElement(richElement3)      
--        richtext:pushBackElement(richElement5)    
--        
--    elseif wordName_begin_position == 1 and wordName_end_position == sentence_length then
--         
--        richtext:pushBackElement(richElement3)      
--        richtext:pushBackElement(richElement5) 
--    end
    
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



    local spell_drill = cc.Label:createWithSystemFont("拼写强化训练>","",32)
    spell_drill:setPosition(backGround:getContentSize().width *0.18  , s_DESIGN_HEIGHT * 0.3)
    spell_drill:setColor(SilverFont)
    spell_drill:ignoreAnchorPointForPosition(false)
    spell_drill:setAnchorPoint(0,0.5)
    backGround:addChild(spell_drill)
    
    local underline = cc.LayerColor:create(cc.c4b(124,157,208,255), spell_drill:getContentSize().width, 2)
    underline:setPosition(backGround:getContentSize().width *0.18  , s_DESIGN_HEIGHT * 0.3 - spell_drill:getContentSize().height * 0.5)
    underline:ignoreAnchorPointForPosition(false)
    underline:setAnchorPoint(0,0.5)
    backGround:addChild(underline)
    
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
        
            UpdateCurrentWordFromFalse()

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