require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyChooseLayer = class("NewStudyChooseLayer", function ()
    return cc.Layer:create()
end)

function NewStudyChooseLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local layer = NewStudyChooseLayer.new()
    
    local wordUs
    local wordEn
    local word_us_button
    local word_es_button
    
    local choose_button
    
    
    
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
    


    local illustrate_know = cc.Label:createWithSystemFont("如果认识该单词请选出正确释义","",32)
    illustrate_know:setPosition(backGround:getContentSize().width *0.15,s_DESIGN_HEIGHT * 0.68)
    illustrate_know:setColor(cc.c4b(124,157,208,255))
    illustrate_know:ignoreAnchorPointForPosition(false)
    illustrate_know:setAnchorPoint(0 ,0.5)
    backGround:addChild(illustrate_know)
    
    local click_choose = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)

        elseif eventType == ccui.TouchEventType.ended then
         
            if sender:getName() == NewStudyLayer_wordList_wordMeaningSmall then
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_True)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end

        end
    end

    for i = 1 , 4 do
        choose_button = ccui.Button:create("image/newstudy/white_begin.png","image/newstudy/white_end.png","")
        choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.71 - 0.11 * i))
        choose_button:ignoreAnchorPointForPosition(false)
        choose_button:setAnchorPoint(0.5,0.5)
        choose_button:setName(NewStudyLayer_wordList_wordMeaningSmall)
        choose_button:addTouchEventListener(click_choose)
        backGround:addChild(choose_button)  

        local choose_text = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordMeaningSmall,"",32)
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
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
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
    
    return layer
end

return NewStudyChooseLayer