require("cocos.init")

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
    word_list_table = {currentIndex_unjudge,1,1,1}

    local case = {}
    case = {word_list_table[1] - word_list_table[2],
    word_list_table[2] - word_list_table[3],
    word_list_table[3] - word_list_table[4],
    word_list_table[1] - word_list_table[3],
    word_list_table[2] - word_list_table[4],
    word_list_table[1] - word_list_table[4]}
    
    local word_meaning_table = {}
    
    local i = 1
    
   if current_state_judge == 1 then
       while case[1] *  case[2] * case[3] *case[4] * case[5] *case[6] == 0 do

            word_list_table = {currentIndex_unjudge,1,1,1}  
             
            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
            math.randomseed(number)  
            word_list_table[2] = math.random(1,table.getn(NewStudyLayer_wordList))
            i = i + 1
            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)

            math.randomseed(number)  
            word_list_table[3] = math.random(1,table.getn(NewStudyLayer_wordList))
            i = i + 1

            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
            math.randomseed(number)  
            word_list_table[4] = math.random(1,table.getn(NewStudyLayer_wordList))

            case[1] = word_list_table[1] - word_list_table[2]
            case[2] = word_list_table[2] - word_list_table[3]
            case[3] = word_list_table[3] - word_list_table[4]
            case[4] = word_list_table[1] - word_list_table[3]
            case[5] = word_list_table[2] - word_list_table[4]
            case[6] = word_list_table[1] - word_list_table[4]
       end       
       
        word_meaning_table = {s_WordPool[NewStudyLayer_wordList[word_list_table[1]]].wordMeaningSmall,
            s_WordPool[NewStudyLayer_wordList[word_list_table[2]]].wordMeaningSmall,
            s_WordPool[NewStudyLayer_wordList[word_list_table[3]]].wordMeaningSmall,
            s_WordPool[NewStudyLayer_wordList[word_list_table[4]]].wordMeaningSmall}           
   else
        word_list_table = {currentIndex_unreview,1,1,1}      
        while  case[1] *  case[2] * case[3] *case[4] * case[5] *case[6] == 0 do
            
            word_list_table = {table.foreachi(NewStudyLayer_wordList, function(i, v) 
                if s_WordPool[wrongWordList[currentIndex_unreview]].wordMeaningSmall == s_WordPool[NewStudyLayer_wordList[i]].wordMeaningSmall then
                    return i
                end 
            end) ,1,1,1}   

            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
            math.randomseed(number)  
            word_list_table[2] = math.random(1,table.getn(NewStudyLayer_wordList))
            i = i + 1
            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)

            math.randomseed(number)  
            word_list_table[3] = math.random(1,table.getn(NewStudyLayer_wordList))
            i = i + 1

            local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)
            math.randomseed(number)  
            word_list_table[4] = math.random(1,table.getn(NewStudyLayer_wordList))

            case[1] = word_list_table[1] - word_list_table[2]
            case[2] = word_list_table[2] - word_list_table[3]
            case[3] = word_list_table[3] - word_list_table[4]
            case[4] = word_list_table[1] - word_list_table[3]
            case[5] = word_list_table[2] - word_list_table[4]
            case[6] = word_list_table[1] - word_list_table[4]
       end

        word_meaning_table = {s_WordPool[wrongWordList[word_list_table[1]]].wordMeaningSmall,
            s_WordPool[NewStudyLayer_wordList[word_list_table[2]]].wordMeaningSmall,
            s_WordPool[NewStudyLayer_wordList[word_list_table[3]]].wordMeaningSmall,
            s_WordPool[NewStudyLayer_wordList[word_list_table[4]]].wordMeaningSmall,}
   end
   
   
   local sortFunc = function(a, b) return b < a end
   table.sort(word_meaning_table, sortFunc)
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)
    
    JudgeColorAtTop(backGround)

    AddPauseButton(backGround)
    
    PlayWordSoundAndAddSprite(backGround)     


    local illustrate_know = cc.Label:createWithSystemFont("如果认识该单词请选出正确释义","",26)
    illustrate_know:setPosition(backGround:getContentSize().width *0.5,s_DESIGN_HEIGHT * 0.7)
    illustrate_know:setColor(WhiteFont)
    illustrate_know:ignoreAnchorPointForPosition(false)
    illustrate_know:setAnchorPoint(0.5 ,0.5)
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
                    s_DATABASE_MGR.insertNewStudyLayerSufferTables(NewStudyLayer_wordList_wordName)
                    
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

--     for i = 1 , 4 do
--         if i == 1 then
--             choose_button = ccui.Button:create("image/newstudy/white_begin.png","image/newstudy/white_end.png","")
--             choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.71 - 0.11 * i))
--             choose_button:ignoreAnchorPointForPosition(false)
--             choose_button:setAnchorPoint(0.5,0.5)
--             choose_button:setName(NewStudyLayer_wordList_wordMeaningSmall)
--             choose_button:addTouchEventListener(click_choose)
--             backGround:addChild(choose_button)  

--             local choose_text = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordMeaningSmall,"",32)
--             choose_text:setColor(cc.c4b(0,0,0,255))
--             choose_text:setPosition(50 ,choose_button:getContentSize().height * 0.5 )
--             choose_text:ignoreAnchorPointForPosition(false)
--             choose_text:setAnchorPoint(0,0.5)
--             choose_button:addChild(choose_text)  
--         else
--             local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)

--             math.randomseed(number)  
            
--             local randomNumber = math.random(1,table.getn(NewStudyLayer_wordList))
-- --            print("randomNumber is"..randomNumber)
            
--             local randMeaning = s_WordPool[NewStudyLayer_wordList[randomNumber]].wordMeaningSmall
-- --            print("randMeaaning is"..randMeaning)
            
--             choose_button = ccui.Button:create("image/newstudy/white_begin.png","image/newstudy/white_end.png","")
--             choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.71 - 0.11 * i))
--             choose_button:ignoreAnchorPointForPosition(false)
--             choose_button:setAnchorPoint(0.5,0.5)
--             choose_button:setName(randMeaning)
--             choose_button:addTouchEventListener(click_choose)
--             backGround:addChild(choose_button)  

--             local choose_text = cc.Label:createWithSystemFont(randMeaning,"",32)
--             choose_text:setColor(cc.c4b(0,0,0,255))
--             choose_text:setPosition(50 ,choose_button:getContentSize().height * 0.5 )
--             choose_text:ignoreAnchorPointForPosition(false)
--             choose_text:setAnchorPoint(0,0.5)
--             choose_button:addChild(choose_text)  
--         end

--     end
    
       for i = 1 , 4 do
           choose_button = ccui.Button:create("image/newstudy/white_begin.png","image/newstudy/white_end.png","")
           choose_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * (0.75 - 0.12 * i))
           choose_button:ignoreAnchorPointForPosition(false)
           choose_button:setAnchorPoint(0.5,0.5)
           choose_button:setName(word_meaning_table[i])
           choose_button:addTouchEventListener(click_choose)
           backGround:addChild(choose_button)  

           local choose_text = cc.Label:createWithSystemFont(word_meaning_table[i],"",32)
           choose_text:setColor(LightBlueFont)
           choose_text:setPosition(50 ,choose_button:getContentSize().height * 0.5 )
           choose_text:ignoreAnchorPointForPosition(false)
           choose_text:setAnchorPoint(0,0.5)
           choose_button:addChild(choose_text)  
       end

    local illustrate_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",26)
    illustrate_dontknow:setPosition(backGround:getContentSize().width * 0.5 ,s_DESIGN_HEIGHT * 0.18)
    illustrate_dontknow:setColor(WhiteFont)
    illustrate_dontknow:ignoreAnchorPointForPosition(false)
    illustrate_dontknow:setAnchorPoint(0.5 ,0.5)
    backGround:addChild(illustrate_dontknow)

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_DATABASE_MGR.insertNewStudyLayerSufferTables(NewStudyLayer_wordList_wordName)
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end


    local choose_dontknow_button = ccui.Button:create("image/newstudy/orange_begin.png","image/newstudy/orange_end.png","")
--    choose_dontknow_button:setScale9Enabled(true)
    choose_dontknow_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.12)
    choose_dontknow_button:ignoreAnchorPointForPosition(false)
    choose_dontknow_button:setAnchorPoint(0.5,0.5)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)
    backGround:addChild(choose_dontknow_button)  

    local choose_dontknow_text = cc.Label:createWithSystemFont("不认识","",40)
    choose_dontknow_text:setPosition(choose_dontknow_button:getContentSize().width * 0.5,choose_dontknow_button:getContentSize().height * 0.5)
    choose_dontknow_text:setColor(DeepBlueFont)
    choose_dontknow_text:ignoreAnchorPointForPosition(false)
    choose_dontknow_text:setAnchorPoint(0.5 ,0.5)
    choose_dontknow_button:addChild(choose_dontknow_text)
    
    return layer
end

return NewStudyChooseLayer