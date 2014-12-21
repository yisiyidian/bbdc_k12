require("cocos.init")

require("common.global")

require("view.newstudy.NewStudyFunction")
require("view.newstudy.NewStudyConfigure")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
local SoundMark         = require("view/newstudy/NewStudySoundMark")


local  NewStudyChooseLayer = class("NewStudyChooseLayer", function ()
    return cc.Layer:create()
end)


function NewStudyChooseLayer.create()
    -- word info
    local currentWordName   = s_CorePlayManager.NewStudyLayerWordList[s_CorePlayManager.currentIndex]
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

    local totalWordNum      = #s_CorePlayManager.NewStudyLayerWordList
    
    math.randomseed(os.time())
    local randomIndexArray  = {}
    table.insert(randomIndexArray, s_CorePlayManager.currentIndex)
    while 1 do
        if #randomIndexArray >= 4 then
            break
        end
        local randomIndex = math.random(1, totalWordNum)
        local isIn = 0
        for i = 1, #randomIndexArray do
            if randomIndexArray[i] == randomIndex then
                isIn = 1
                break
            end
        end
        if isIn == 0 then
            table.insert(randomIndexArray, randomIndex)
        end
    end
    
    local wordMeaningTable= {}
    for i = 1, 4 do
        local name = s_CorePlayManager.NewStudyLayerWordList[randomIndexArray[i]]
        local meaning = s_WordPool[name].wordMeaningSmall
        table.insert(wordMeaningTable, meaning)
    end
    
    local rightIndex = math.random(1, 4)
    local tmp = wordMeaningTable[1]
    wordMeaningTable[1] = wordMeaningTable[rightIndex]
    wordMeaningTable[rightIndex] = tmp
        
    -- ui 
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = NewStudyChooseLayer.new()
    local choose_button
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)
    
    JudgeColorAtTop(backGround)

    AddPauseButton(backGround)
    
--    PlayWordSoundAndAddSprite(backGround)
    local soundMark = SoundMark.create(wordname, wordSoundMarkEn, wordSoundMarkAm)
    soundMark:setPosition(backGround:getContentSize().width *0.5, s_DESIGN_HEIGHT * 0.8)  
    backGround:addChild(soundMark)


    local illustrate_know = cc.Label:createWithSystemFont("如果认识该单词请选出正确释义","",26)
    illustrate_know:setPosition(backGround:getContentSize().width *0.5,s_DESIGN_HEIGHT * 0.7)
    illustrate_know:setColor(WhiteFont)
    illustrate_know:ignoreAnchorPointForPosition(false)
    illustrate_know:setAnchorPoint(0.5 ,0.5)
    backGround:addChild(illustrate_know)
    
    FindWord()
    
    local click_choose = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)

        elseif eventType == ccui.TouchEventType.ended then
            if current_state_judge == 1 then
                if sender:getName() == NewStudyLayer_wordList_wordMeaningSmall then                
                    ShowAnswerTrueBack(sender)
                    if s_CURRENT_USER.newstudytruelayerMask == 1 then
                        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()                  
                        s_SCENE:callFuncWithDelay(1,function()
                            s_DATABASE_MGR.insertNewStudyLayerFamiliarTables(NewStudyLayer_wordList_wordName)
                            UpdateCurrentWordFromTrue()                     
                            s_SCENE.touchEventBlockLayer.unlockTouch()
                        end)
                    else
                        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                        s_SCENE:callFuncWithDelay(1,function()
                            NewStudyLayer_State = NewStudyLayer_State_True
                            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
                            s_SCENE:replaceGameLayer(newStudyLayer)
                            s_SCENE.touchEventBlockLayer.unlockTouch()
                        end)
                    end
                else
                    s_DATABASE_MGR.insertNewStudyLayerSufferTables(NewStudyLayer_wordList_wordName)   
                    s_DATABASE_MGR.insertNewStudyLayerGroupTables(NewStudyLayer_wordList_wordName)            
                    ShowAnswerFalseBack(sender)       
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()                    
                    s_SCENE:callFuncWithDelay(1,function()
                        NewStudyLayer_State = NewStudyLayer_State_Wrong
                        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
                        s_SCENE:replaceGameLayer(newStudyLayer)                       
                        s_SCENE.touchEventBlockLayer.unlockTouch()
                    end)               
                end
            else
                if sender:getName() == NewStudyLayer_wordList_wordMeaningSmall then  
                    s_DATABASE_MGR.deleteNewStudyLayerTestTables(NewStudyLayer_wordList_wordName)               
                    ShowAnswerTrueBack(sender)                   
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()                  
                    s_SCENE:callFuncWithDelay(1,function()
         
                        UpdateCurrentWordFromTrue()                     
                        s_SCENE.touchEventBlockLayer.unlockTouch()
                    end)
                else            
                    s_DATABASE_MGR.updateNewStudyLayerTestTables(NewStudyLayer_wordList_wordName)
                    ShowAnswerFalseBack(sender)                    
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                    s_SCENE:callFuncWithDelay(1,function()
                        NewStudyLayer_State = NewStudyLayer_State_Wrong
                        local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
                        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
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
           choose_button:setName(wordMeaningTable[i])
           choose_button:addTouchEventListener(click_choose)
           backGround:addChild(choose_button)  

           local choose_text = cc.Label:createWithSystemFont(wordMeaningTable[i],"",32)
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
            if current_state_judge == 1 then
            s_DATABASE_MGR.insertNewStudyLayerSufferTables(NewStudyLayer_wordList_wordName)
            s_DATABASE_MGR.insertNewStudyLayerGroupTables(NewStudyLayer_wordList_wordName)
            else
            s_DATABASE_MGR.updateNewStudyLayerTestTables(NewStudyLayer_wordList_wordName)           
            end
            NewStudyLayer_State = NewStudyLayer_State_Wrong
            local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
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