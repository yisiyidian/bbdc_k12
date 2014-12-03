require("Cocos2d")
require("Cocos2dConstants")

require("common.global")


local NewStudyLayer = class("NewStudyLayer", function ()
    return cc.Layer:create()
end)

NewStudyLayer_State_Choose = "NewStudyLayer_State_Choose"
NewStudyLayer_State_True = "NewStudyLayer_State_True"
NewStudyLayer_State_Wrong = "NewStudyLayer_State_Wrong"
NewStudyLayer_State_Slide = "NewStudyLayer_State_Slide"
NewStudyLayer_State_Mission = "NewStudyLayer_State_Mission"
NewStudyLayer_State_Reward = "NewStudyLayer_State_Reward"


function NewStudyLayer.create(viewstate)
    local layer = NewStudyLayer.new(viewstate)

    s_WordPool = s_DATA_MANAGER.loadAllWords()

    -- fake data, you can add if not enough
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
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH


    
    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    --TODO for houqi:
    -- code about new study layer
    -- record right word list and wrong word list
    -- end if 20 wrong words have been generate
    local rightWordList         = {}
    local wrongWordList         = {}
    local maxWrongWordCount     = 20
    
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    backColor:addChild(backGround)
    
    local pause_button = ccui.Button:create("image/newstudy/pause_button.png","image/newstudy/pause_button.png","")
    pause_button:setPosition(s_LEFT_X + 150, s_DESIGN_HEIGHT - 50 )
    pause_button:ignoreAnchorPointForPosition(false)
    pause_button:setAnchorPoint(0,1)
    backGround:addChild(pause_button)    
    
    for i = 1,8 do
        local word_mark = cc.Sprite:create("image/newstudy/blue_mid.png")
        word_mark:setPosition(backGround:getContentSize().width * 0.5 + word_mark:getContentSize().width*1.1 * (i - 5),s_DESIGN_HEIGHT * 0.95)
        word_mark:ignoreAnchorPointForPosition(false)
        word_mark:setAnchorPoint(0,0.5)
        backGround:addChild(word_mark)
    end
    
    --NewStudyLayer_State_Choose
    if viewstate == NewStudyLayer_State_Choose then
    
        local word = cc.Label:createWithSystemFont("word","",48)
        word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.9)
        word:setColor(cc.c4b(0,0,0,255))
        word:ignoreAnchorPointForPosition(false)
        word:setAnchorPoint(0.5,0.5)
        backGround:addChild(word)
        
        local word_playsound_button = ccui.Button:create("image/newstudy/playsound.png","image/newstudy/playsound.png","")
        word_playsound_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.9)
        word_playsound_button:ignoreAnchorPointForPosition(false)
        word_playsound_button:setAnchorPoint(0.5,0.5)
        backGround:addChild(word_playsound_button)  

        local wordEn = cc.Label:createWithSystemFont("xxxx","",42)
        wordEn:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.85)
        wordEn:setColor(cc.c4b(0,0,0,255))
        wordEn:ignoreAnchorPointForPosition(false)
        wordEn:setAnchorPoint(0.5,0.5)
        backGround:addChild(wordEn)
        
        local word_us_button =  ccui.Button:create("image/newstudy/us_button.png","image/newstudy/us_button.png","")
        word_us_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.85)
        word_us_button:ignoreAnchorPointForPosition(false)
        word_us_button:setAnchorPoint(0.5,0.5)
        backGround:addChild(word_us_button)  

        local illustrate_know = cc.Label:createWithSystemFont("如果认识该单词请选出正确释义","",32)
        illustrate_know:setPosition(backGround:getContentSize().width *0.15,s_DESIGN_HEIGHT * 0.68)
        illustrate_know:setColor(cc.c4b(124,157,208,255))
        illustrate_know:ignoreAnchorPointForPosition(false)
        illustrate_know:setAnchorPoint(0 ,0.5)
        backGround:addChild(illustrate_know)
      
        for i = 1 , 4 do
            local choose_button = ccui.Button:create("image/newstudy/white.png","image/newstudy/white.png","")
            choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.71 - 0.11 * i))
            choose_button:ignoreAnchorPointForPosition(false)
            choose_button:setAnchorPoint(0.5,0.5)
            backGround:addChild(choose_button)  
            
            local choose_text = cc.Label:createWithSystemFont("xxxxxxxxxx","",32)
            choose_text:setColor(cc.c4b(0,0,0,255))
            choose_text:setPosition(50 ,choose_button:getContentSize().height * 0.5 )
            choose_text:ignoreAnchorPointForPosition(false)
            choose_text:setAnchorPoint(0,0.5)
            choose_button:addChild(choose_text)  
        end

        local illustrate_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",32)
        illustrate_dontknow:setPosition(backGround:getContentSize().width *0.15,s_DESIGN_HEIGHT * 0.18)
        illustrate_dontknow:setColor(cc.c4b(124,157,208,255))
        illustrate_dontknow:ignoreAnchorPointForPosition(false)
        illustrate_dontknow:setAnchorPoint(0 ,0.5)
        backGround:addChild(illustrate_dontknow)
        
        local click_dontknow_button = function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                -- button sound
                playSound(s_sound_buttonEffect)        
            elseif eventType == ccui.TouchEventType.ended then
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_True)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end
        end
        
        local choose_dontknow_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
        choose_dontknow_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
        choose_dontknow_button:ignoreAnchorPointForPosition(false)
        choose_dontknow_button:setAnchorPoint(0.5,0.5)
        choose_dontknow_button:addTouchEventListener(click_dontknow_button)
        backGround:addChild(choose_dontknow_button)  

        local choose_dontknow_text = cc.Label:createWithSystemFont("不认识","",32)
        choose_dontknow_text:setPosition(50,choose_dontknow_button:getContentSize().height * 0.5)
        choose_dontknow_text:setColor(cc.c4b(255,255,255,255))
        choose_dontknow_text:ignoreAnchorPointForPosition(false)
        choose_dontknow_text:setAnchorPoint(0 ,0.5)
        choose_dontknow_button:addChild(choose_dontknow_text)
        
    --NewStudyLayer_State_True
    elseif viewstate == NewStudyLayer_State_True then
        
        local huge_word = cc.Label:createWithSystemFont("这里是自适应的字体","",48)
        huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.8)
        huge_word:setColor(cc.c4b(0,0,0,255))
        huge_word:ignoreAnchorPointForPosition(false)
        huge_word:setAnchorPoint(0.5,0.5)
        backGround:addChild(huge_word)
        
        local word = cc.Label:createWithSystemFont("word","",40)
        word:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.50)
        word:setColor(cc.c4b(191,181,46,255))
        word:ignoreAnchorPointForPosition(false)
        word:setAnchorPoint(0,0.5)
        backGround:addChild(word)
        
        local illustrate_word = cc.Label:createWithSystemFont("这个单词对你而言太熟悉了，所以你希\n望放弃对他的复习，如果确实如此，\n请点击单词将它收入你的词库吧","",36)
        illustrate_word:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.40)
        illustrate_word:setColor(cc.c4b(255,255,255,255))
        illustrate_word:ignoreAnchorPointForPosition(false)
        illustrate_word:setAnchorPoint(0,0.5)
        backGround:addChild(illustrate_word)
        
        local backColor_second = cc.LayerColor:create(cc.c4b(131,162,206,255), backGround:getContentSize().width *0.7,200)  
        backColor_second:setAnchorPoint(0.5,0.5)
        backColor_second:ignoreAnchorPointForPosition(false)
        backColor_second:setPosition(backGround:getContentSize().width *0.5,s_DESIGN_HEIGHT*0.25)
        backGround:addChild(backColor_second) 
        
        local current_word_text = cc.Label:createWithSystemFont("当前单词","",40)
        current_word_text:setPosition(backColor_second:getContentSize().width *0.05,backColor_second:getContentSize().height *0.9)
        current_word_text:setColor(cc.c4b(255,255,255,255))
        current_word_text:ignoreAnchorPointForPosition(false)
        current_word_text:setAnchorPoint(0,0.5)
        backColor_second:addChild(current_word_text)
        
        local current_word_word = cc.Label:createWithSystemFont("word","",40)
        current_word_word:setPosition(backColor_second:getContentSize().width *0.05 + current_word_text:getContentSize().width ,
                              backColor_second:getContentSize().height *0.9)
        current_word_word:setColor(cc.c4b(255,255,255,255))
        current_word_word:ignoreAnchorPointForPosition(false)
        current_word_word:setAnchorPoint(0,0.5)
        backColor_second:addChild(current_word_word)   
        
        local current_word_name = cc.Label:createWithSystemFont("word","",40)
        current_word_name:setPosition(backColor_second:getContentSize().width *0.05 + current_word_text:getContentSize().width ,
            backColor_second:getContentSize().height *0.9)
        current_word_name:setColor(cc.c4b(191,181,46,255))
        current_word_name:ignoreAnchorPointForPosition(false)
        current_word_name:setAnchorPoint(0,0.5)
        backColor_second:addChild(current_word_name)   
        
        local current_word_MarkEn = cc.Label:createWithSystemFont("音标","",40)
        current_word_MarkEn:setPosition(backColor_second:getContentSize().width *0.05 + current_word_text:getContentSize().width + current_word_name:getContentSize().width,
            backColor_second:getContentSize().height *0.9)
        current_word_MarkEn:setColor(cc.c4b(255,255,255,255))
        current_word_MarkEn:ignoreAnchorPointForPosition(false)
        current_word_MarkEn:setAnchorPoint(0,0.5)
        backColor_second:addChild(current_word_MarkEn)   
    
        local current_word_wordMeaning = cc.Label:createWithSystemFont("xxxxxxxxxxxxxxxxxxxxxxxxx","",40)
        current_word_wordMeaning:setPosition(backColor_second:getContentSize().width *0.05,
            backColor_second:getContentSize().height *0.7)
        current_word_wordMeaning:setColor(cc.c4b(152,183,227,255))
        current_word_wordMeaning:ignoreAnchorPointForPosition(false)
        current_word_wordMeaning:setAnchorPoint(0,0.5)
        backColor_second:addChild(current_word_wordMeaning)   
        
        local click_study_button = function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                -- button sound
                playSound(s_sound_buttonEffect)        
            elseif eventType == ccui.TouchEventType.ended then
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end
        end
        
        local choose_study_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
        choose_study_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
        choose_study_button:ignoreAnchorPointForPosition(false)
        choose_study_button:setAnchorPoint(0.5,0.5)
        choose_study_button:addTouchEventListener(click_study_button)
        backGround:addChild(choose_study_button)  

        local choose_study_text = cc.Label:createWithSystemFont("我依然想复习该单词","",32)
        choose_study_text:setPosition(choose_study_button:getContentSize().width * 0.5,choose_study_button:getContentSize().height * 0.5)
        choose_study_text:setColor(cc.c4b(255,255,255,255))
        choose_study_text:ignoreAnchorPointForPosition(false)
        choose_study_text:setAnchorPoint(0.5,0.5)
        choose_study_button:addChild(choose_study_text)
        
    --NewStudyLayer_State_Wrong
    elseif viewstate == NewStudyLayer_State_Wrong then
    
        local word = cc.Label:createWithSystemFont("word","",48)
        word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.9)
        word:setColor(cc.c4b(0,0,0,255))
        word:ignoreAnchorPointForPosition(false)
        word:setAnchorPoint(0.5,0.5)
        backGround:addChild(word)

        local word_playsound_button = ccui.Button:create("image/newstudy/playsound.png","image/newstudy/playsound.png","")
        word_playsound_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.9)
        word_playsound_button:ignoreAnchorPointForPosition(false)
        word_playsound_button:setAnchorPoint(0.5,0.5)
        backGround:addChild(word_playsound_button)  

        local wordEn = cc.Label:createWithSystemFont("xxxx","",42)
        wordEn:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.85)
        wordEn:setColor(cc.c4b(0,0,0,255))
        wordEn:ignoreAnchorPointForPosition(false)
        wordEn:setAnchorPoint(0.5,0.5)
        backGround:addChild(wordEn)

        local word_us_button =  ccui.Button:create("image/newstudy/us_button.png","image/newstudy/us_button.png","")
        word_us_button:setPosition(backGround:getContentSize().width /2 + word:getContentSize().width  , s_DESIGN_HEIGHT * 0.85)
        word_us_button:ignoreAnchorPointForPosition(false)
        word_us_button:setAnchorPoint(0.5,0.5)
        backGround:addChild(word_us_button)  
        
        local chineseMeaning = cc.Label:createWithSystemFont("中文释义","",40)
        chineseMeaning:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
        chineseMeaning:setColor(cc.c4b(124,157,208,255))
        chineseMeaning:ignoreAnchorPointForPosition(false)
        chineseMeaning:setAnchorPoint(0,0.5)
        backGround:addChild(chineseMeaning)
        
        local word_Meaning = cc.Label:createWithSystemFont("xxxxxxxxxxxxxxxxxx","",40)
        word_Meaning:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.6)
        word_Meaning:setColor(cc.c4b(255,255,255,255))
        word_Meaning:ignoreAnchorPointForPosition(false)
        word_Meaning:setAnchorPoint(0,0.5)
        backGround:addChild(word_Meaning)
        
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
        
    
    
    --NewStudyLayer_State_Slide
    elseif viewstate == NewStudyLayer_State_Slide then 
    
        local huge_word = cc.Label:createWithSystemFont("这里是自适应的字体","",48)
        huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.8)
        huge_word:setColor(cc.c4b(0,0,0,255))
        huge_word:ignoreAnchorPointForPosition(false)
        huge_word:setAnchorPoint(0.5,0.5)
        backGround:addChild(huge_word)
        
        local slide_word_label = cc.Label:createWithSystemFont("回忆并划出刚才的单词","",40)
        slide_word_label:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
        slide_word_label:setColor(cc.c4b(124,157,208,255))
        slide_word_label:ignoreAnchorPointForPosition(false)
        slide_word_label:setAnchorPoint(0,0.5)
        backGround:addChild(slide_word_label)
        
        for i = 1 , 4 do
            for k = 1 , 4 do
                local slide_button = ccui.Button:create("image/newstudy/click_undo.png","image/newstudy/click_do.png","")
                slide_button:setPosition(backGround:getContentSize().width * 0.5 + slide_button:getContentSize().width*1.1 * (i - 3),
                    backGround:getContentSize().height * 0.5 + slide_button:getContentSize().height * 1.1 * (k - 3))
                slide_button:ignoreAnchorPointForPosition(false)
                slide_button:setAnchorPoint(0,0.5)
                backGround:addChild(slide_button)  
            end
        end
        
        local click_before_button = function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                -- button sound
                playSound(s_sound_buttonEffect)        
            elseif eventType == ccui.TouchEventType.ended then
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end
        end

        local choose_before_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
        choose_before_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
        choose_before_button:ignoreAnchorPointForPosition(false)
        choose_before_button:setAnchorPoint(0.5,0.5)
        choose_before_button:addTouchEventListener(click_before_button)
        backGround:addChild(choose_before_button)  

        local choose_before_text = cc.Label:createWithSystemFont("偷偷看一眼","",32)
        choose_before_text:setPosition(choose_before_button:getContentSize().width * 0.5,choose_before_button:getContentSize().height * 0.5)
        choose_before_text:setColor(cc.c4b(255,255,255,255))
        choose_before_text:ignoreAnchorPointForPosition(false)
        choose_before_text:setAnchorPoint(0.5,0.5)
        choose_before_button:addChild(choose_before_text)

    --NewStudyLayer_State_Mission
    elseif viewstate == NewStudyLayer_State_Mission then
    
        local unfamiliar_label = cc.Label:createWithSystemFont("已完成20个生词","",40)
        unfamiliar_label:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
        unfamiliar_label:setColor(cc.c4b(124,157,208,255))
        unfamiliar_label:ignoreAnchorPointForPosition(false)
        unfamiliar_label:setAnchorPoint(0,0.5)
        backGround:addChild(unfamiliar_label)
        
        local click_mission_button = function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                -- button sound
                playSound(s_sound_buttonEffect)        
            elseif eventType == ccui.TouchEventType.ended then
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end
        end

        local choose_mission_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
        choose_mission_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
        choose_mission_button:ignoreAnchorPointForPosition(false)
        choose_mission_button:setAnchorPoint(0.5,0.5)
        choose_mission_button:addTouchEventListener(click_mission_button)
        backGround:addChild(choose_mission_button)  

        local choose_mission_text = cc.Label:createWithSystemFont("趁热打铁","",32)
        choose_mission_text:setPosition(choose_before_button:getContentSize().width * 0.5,choose_before_button:getContentSize().height * 0.5)
        choose_mission_text:setColor(cc.c4b(255,255,255,255))
        choose_mission_text:ignoreAnchorPointForPosition(false)
        choose_mission_text:setAnchorPoint(0.5,0.5)
        choose_mission_button:addChild(choose_mission_text) 
        
    --NewStudyLayer_State_Reward
    elseif viewstate == NewStudyLayer_State_Reward then
    end

    
    
    
    return layer
end



return NewStudyLayer
