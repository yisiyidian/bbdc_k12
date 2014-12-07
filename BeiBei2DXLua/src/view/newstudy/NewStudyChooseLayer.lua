require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

require("view.newstudy.NewStudyFunction")
require("view.newstudy.NewStudyConfigure")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")


local  NewStudyChooseLayer = class("NewStudyChooseLayer", function ()
    return cc.Layer:create()
end)


function NewStudyChooseLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local layer = NewStudyChooseLayer.new()

    local choose_button
    
    local word_list_table = {}
    
    local i = 1
    
--    if current_state_judge == 1 then
--        word_list_table = {currentIndex_unjudge,0,0,0}   
--        
--        local case1 = word_list_table[1] - word_list_table[2]
--        local case2 = word_list_table[2] - word_list_table[3]
--        local case3 = word_list_table[3] - word_list_table[4]
--        local case4 = word_list_table[1] - word_list_table[3]
--        local case5 = word_list_table[2] - word_list_table[4]
--        local case6 = word_list_table[1] - word_list_table[4]
--        
--        while case1 * case2 * case3 * case4 * case5 * case6  == 0 do
--            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
--
--            math.randomseed(number)  
--            
--            word_list_table[2] = math.random(1,table.getn(NewStudyLayer_wordList))
--
--            i = i + 1
--            
--            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
--
--            math.randomseed(number)  
--
--            word_list_table[3] = math.random(1,table.getn(NewStudyLayer_wordList))
--            
--            i = i + 1
--            
--            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
--
--            math.randomseed(number)  
--
--            word_list_table[4] = math.random(1,table.getn(NewStudyLayer_wordList))
--  
--            table.foreachi(word_list_table, print)
--        end     
--        
--        
--    else
--        word_list_table = {currentIndex_unreview,0,0,0}
--    end
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)
    
    JudgeColorAtTop(backGround)

    local pause_button = ccui.Button:create("image/newstudy/pause_button_begin.png","image/newstudy/pause_button_end.png","")
    pause_button:setPosition(s_LEFT_X + 150, s_DESIGN_HEIGHT - 50 )
    pause_button:ignoreAnchorPointForPosition(false)
    pause_button:setAnchorPoint(0,1)
    backGround:addChild(pause_button) 
    
    PlayWordSoundAndAddSprite(backGround)     


    local illustrate_know = cc.Label:createWithSystemFont("如果认识该单词请选出正确释义","",32)
    illustrate_know:setPosition(backGround:getContentSize().width *0.15,s_DESIGN_HEIGHT * 0.68)
    illustrate_know:setColor(SilverFont)
    illustrate_know:ignoreAnchorPointForPosition(false)
    illustrate_know:setAnchorPoint(0 ,0.5)
    backGround:addChild(illustrate_know)
    
    local click_choose = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)

        elseif eventType == ccui.TouchEventType.ended then
            if current_state_judge == 1 then
                if sender:getName() == NewStudyLayer_wordList_wordMeaningSmall then
                
                    ShowAnswerTrueBack(backGround)
                    
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                    
                    s_SCENE:callFuncWithDelay(1,function()
                        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_True)
                        s_SCENE:replaceGameLayer(newStudyLayer)
                        
                        s_SCENE.touchEventBlockLayer.unlockTouch()
                    end)
                

                else
                
                    ShowAnswerFalseBack(backGround)       

                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                    
                    s_SCENE:callFuncWithDelay(1,function()
                        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
                        s_SCENE:replaceGameLayer(newStudyLayer)
                        
                        s_SCENE.touchEventBlockLayer.unlockTouch()
                    end)
                    
                end
            else
                if sender:getName() == NewStudyLayer_wordList_wordMeaningSmall then
                
                    ShowAnswerTrueBack(backGround)
                    
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                    
                    s_SCENE:callFuncWithDelay(1,function()
                        UpdateCurrentWordFromTrue()
                        
                        s_SCENE.touchEventBlockLayer.unlockTouch()
                    end)
                else
                
                    ShowAnswerFalseBack(backGround)
                    
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                    s_SCENE:callFuncWithDelay(1,function()
                        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
                        s_SCENE:replaceGameLayer(newStudyLayer)
                        
                        s_SCENE.touchEventBlockLayer.unlockTouch()
                    end)
                end
            end
        end
    end

    for i = 1 , 4 do
        if i == 1 then
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
        else
            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)

            math.randomseed(number)  
            
            local randomNumber = math.random(1,table.getn(NewStudyLayer_wordList))
--            print("randomNumber is"..randomNumber)
            
            local randMeaning = s_WordPool[NewStudyLayer_wordList[randomNumber]].wordMeaningSmall
--            print("randMeaaning is"..randMeaning)
            
            choose_button = ccui.Button:create("image/newstudy/white_begin.png","image/newstudy/white_end.png","")
            choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.71 - 0.11 * i))
            choose_button:ignoreAnchorPointForPosition(false)
            choose_button:setAnchorPoint(0.5,0.5)
            choose_button:setName(randMeaning)
            choose_button:addTouchEventListener(click_choose)
            backGround:addChild(choose_button)  

            local choose_text = cc.Label:createWithSystemFont(randMeaning,"",32)
            choose_text:setColor(cc.c4b(0,0,0,255))
            choose_text:setPosition(50 ,choose_button:getContentSize().height * 0.5 )
            choose_text:ignoreAnchorPointForPosition(false)
            choose_text:setAnchorPoint(0,0.5)
            choose_button:addChild(choose_text)  
        end

    end
    
--        for i = 1 , 4 do
--            choose_button = ccui.Button:create("image/newstudy/white_begin.png","image/newstudy/white_end.png","")
--            choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.71 - 0.11 * i))
--            choose_button:ignoreAnchorPointForPosition(false)
--            choose_button:setAnchorPoint(0.5,0.5)
--            choose_button:setName(s_WordPool[NewStudyLayer_wordList[word_list_table[i]]].wordMeaningSmall)
--            choose_button:addTouchEventListener(click_choose)
--            backGround:addChild(choose_button)  
--
--            local choose_text = cc.Label:createWithSystemFont(s_WordPool[NewStudyLayer_wordList[word_list_table[i]]].wordMeaningSmall,"",32)
--            choose_text:setColor(cc.c4b(0,0,0,255))
--            choose_text:setPosition(50 ,choose_button:getContentSize().height * 0.5 )
--            choose_text:ignoreAnchorPointForPosition(false)
--            choose_text:setAnchorPoint(0,0.5)
--            choose_button:addChild(choose_text)  
--        end

    local illustrate_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",32)
    illustrate_dontknow:setPosition(backGround:getContentSize().width *0.15,s_DESIGN_HEIGHT * 0.18)
    illustrate_dontknow:setColor(SilverFont)
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

    --image/newstudy/brown_end.png
    local choose_dontknow_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
--    choose_dontknow_button:setScale9Enabled(true)
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