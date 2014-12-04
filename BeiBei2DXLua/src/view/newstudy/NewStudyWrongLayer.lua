require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyWrongLayer = class("NewStudyWrongLayer", function ()
    return cc.Layer:create()
end)

function NewStudyWrongLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local wordList              =   {"apple", "many", "where", "happy", "go", "sad", "at", "moon", "table", "desk"}
    local currentIndex          =   1
    local currentWord           =   s_WordPool[wordList[currentIndex]]

    local wordName              =   currentWord.wordName
    local wordSoundMarkEn       =   currentWord.wordSoundMarkEn
    local wordSoundMarkAm       =   currentWord.wordSoundMarkAm
    local wordMeaning           =   currentWord.wordMeaning
    local wordMeaningSmall      =   currentWord.wordMeaningSmall
    local sentenceEn            =   currentWord.sentenceEn
    local sentenceCn            =   currentWord.sentenceCn


    local layer = NewStudyWrongLayer.new()
    
    local wordUs
    local wordEn
    local word_us_button
    local word_es_button

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

    local word_mark 

    for i = 1,8 do
        if i == 1 then 
            word_mark = cc.Sprite:create("image/newstudy/blue_begin.png")
        elseif i == 8 then 
            word_mark = cc.Sprite:create("image/newstudy/blue_end.png")
        else
            word_mark = cc.Sprite:create("image/newstudy/blue_mid.png")
        end

        if word_mark ~= nil then
            word_mark:setPosition(backGround:getContentSize().width * 0.5 + word_mark:getContentSize().width*1.1 * (i - 5),s_DESIGN_HEIGHT * 0.95)
            word_mark:ignoreAnchorPointForPosition(false)
            word_mark:setAnchorPoint(0,0.5)
            backGround:addChild(word_mark)
        end
    end

    local word = cc.Label:createWithSystemFont(wordName,"",48)
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

    wordUs = cc.Label:createWithSystemFont(wordSoundMarkAm,"",42)
    wordUs:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.85)
    wordUs:setColor(cc.c4b(0,0,0,255))
    wordUs:ignoreAnchorPointForPosition(false)
    wordUs:setAnchorPoint(0.5,0.5)
    wordUs:setVisible(true)
    backGround:addChild(wordUs)

    wordEn =  cc.Label:createWithSystemFont(wordSoundMarkEn,"",42)
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

--    local word_Meaning = cc.Label:createWithSystemFont("xxxxxxxxxxxxxxxxxx","",40)
--    word_Meaning:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.6)
--    word_Meaning:setColor(cc.c4b(255,255,255,255))
--    word_Meaning:ignoreAnchorPointForPosition(false)
--    word_Meaning:setAnchorPoint(0,0.5)
--    backGround:addChild(word_Meaning)
    
    local richtext = ccui.RichText:create()

    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(0.5,0.5)

    richtext:setContentSize(cc.size(backGround:getContentSize().width *0.7, 
        backGround:getContentSize().height *0.3))  

    local current_word_wordMeaning = CCLabelTTF:create (wordMeaning,
        "Helvetica",32, cc.size(625, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_wordMeaning:setColor(cc.c4b(255,255,255,255))

    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
    richtext:pushBackElement(richElement1)                   
    richtext:setPosition(backGround:getContentSize().width *0.5, 
        backGround:getContentSize().height *0.5)
    richtext:setLocalZOrder(10)


    backGround:addChild(richtext) 

    local exampleSentence = cc.Label:createWithSystemFont("例句","",40)
    exampleSentence:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.5)
    exampleSentence:setColor(cc.c4b(124,157,208,255))
    exampleSentence:ignoreAnchorPointForPosition(false)
    exampleSentence:setAnchorPoint(0,0.5)
    backGround:addChild(exampleSentence)

    local word_exampleSentence = cc.Label:createWithSystemFont("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx","",40)
    word_exampleSentence:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.42)
    word_exampleSentence:setColor(cc.c4b(152,183,227,255))
    word_exampleSentence:ignoreAnchorPointForPosition(false)
    word_exampleSentence:setAnchorPoint(0,0.5)
    backGround:addChild(word_exampleSentence)


    local click_improve_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Slide)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end

    local choose_drill_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
    choose_drill_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.3)
    choose_drill_button:ignoreAnchorPointForPosition(false)
    choose_drill_button:setAnchorPoint(0.5,0.5)
    choose_drill_button:addTouchEventListener(click_improve_button)
    backGround:addChild(choose_drill_button)  


    local spell_drill = cc.Label:createWithSystemFont("拼写强化训练>","",40)
    spell_drill:setPosition(choose_drill_button:getContentSize().width * 0.5,choose_drill_button:getContentSize().height * 0.5)
    spell_drill:setColor(cc.c4b(124,157,208,255))
    spell_drill:ignoreAnchorPointForPosition(false)
    spell_drill:setAnchorPoint(0.5,0.5)
    choose_drill_button:addChild(spell_drill)



    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
            s_SCENE:replaceGameLayer(newStudyLayer)
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

    return layer
end

return NewStudyWrongLayer