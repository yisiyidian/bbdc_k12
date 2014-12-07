local NewStudyLayer     = require("view.newstudy.NewStudyLayer")


function JudgeColorAtTop(backGround)
    local word_mark 

    if current_state_judge == 1 then
        for i = 1,8 do
            if i > table.getn(wrongWordList) then
                if i == 1 then 
                    word_mark = cc.Sprite:create("image/newstudy/blue_begin.png")
                elseif i == 8 then 
                    word_mark = cc.Sprite:create("image/newstudy/blue_end.png")
                else
                    word_mark = cc.Sprite:create("image/newstudy/blue_mid.png")
                end
            else
                if i == 1 then 
                    word_mark = cc.Sprite:create("image/newstudy/yellow_begin.png")
                elseif i == 8 then 
                    word_mark = cc.Sprite:create("image/newstudy/yellow_end.png")
                else
                    word_mark = cc.Sprite:create("image/newstudy/yellow_mid.png")
                end 
            end

            if word_mark ~= nil then
                word_mark:setPosition(backGround:getContentSize().width * 0.5 + word_mark:getContentSize().width*1.1 * (i - 5),s_DESIGN_HEIGHT * 0.95)
                word_mark:ignoreAnchorPointForPosition(false)
                word_mark:setAnchorPoint(0,0.5)
                backGround:addChild(word_mark)
            end
        end
    else
        for i = 1,8 do
            if i > table.getn(wrongWordList_success_review) then
                if i == 1 then 
                    word_mark = cc.Sprite:create("image/newstudy/yellow_begin.png")
                elseif i == 8 then 
                    word_mark = cc.Sprite:create("image/newstudy/yellow_end.png")
                else
                    word_mark = cc.Sprite:create("image/newstudy/yellow_mid.png")
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

    end  
end

function PlayWordSoundAndAddSprite(backGround)

    local wordUs
    local wordEn
    local word_us_button
    local word_es_button

    local word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",48)
    word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.9)
    word:setColor(cc.c4b(0,0,0,255))
    word:ignoreAnchorPointForPosition(false)
    word:setAnchorPoint(0.5,0.5)
    backGround:addChild(word)

    local click_playsound = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound

        elseif eventType == ccui.TouchEventType.ended then

            playWordSound(NewStudyLayer_wordList_wordName)

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
            if Pronounce_Mark_US == 1 then          
                Pronounce_Mark_US = 0
                wordUs:setVisible(false)
                wordEn:setVisible(true)
                word_us_button:setVisible(false)
                word_es_button:setVisible(true)
            else
                Pronounce_Mark_US = 1
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

    if Pronounce_Mark_US == 0 then          

        wordUs:setVisible(false)
        wordEn:setVisible(true)
        word_us_button:setVisible(false)
        word_es_button:setVisible(true)
    else

        wordUs:setVisible(true)
        wordEn:setVisible(false)
        word_us_button:setVisible(true)
        word_es_button:setVisible(false)
    end
end

function HugeWordUnderColorSquare(backGround)
	local huge_word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",100)
    huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.9)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    backGround:addChild(huge_word)
        
    if string.len(huge_word:getString()) > 5  then
    huge_word:setSystemFontSize(24 * backGround:getContentSize().width / huge_word:getContentSize().width)
    end
    
    local onTouchBegan = function(touch, event)

        return true
    end


    local onTouchEnded = function(touch, event)
        local location = backGround:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(huge_word:getBoundingBox(), location) then
            UpdateCurrentWordFromTrue()
        end
    end


    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = backGround:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backGround)
end

function UpdateCurrentWordFromTrue()
    if current_state_judge == 1 then
        table.insert(rightWordList,NewStudyLayer_wordList_wordName)
        currentIndex_unjudge = currentIndex_unjudge + 1

        NewStudyLayer_wordList_currentWord           =   s_WordPool[NewStudyLayer_wordList[currentIndex_unjudge]]
        UpdateCurrentWordContent()

        if table.getn(wrongWordList) ==  maxWrongWordCount then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Mission)
            s_SCENE:replaceGameLayer(newStudyLayer)
        else
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end

    else

        table.insert(wrongWordList_success_review,NewStudyLayer_wordList_wordName)
        currentIndex_unreview = currentIndex_unreview + 1

        if table.getn(wrongWordList_success_review) ==  maxWrongWordCount then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Reward)
            s_SCENE:replaceGameLayer(newStudyLayer)
        else
            NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]
            UpdateCurrentWordContent()
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end

    end
end

function UpdateCurrentWordFromFalse()
    if current_state_judge == 1 then
    
        table.insert(wrongWordList,NewStudyLayer_wordList_wordName)
        currentIndex_unjudge = currentIndex_unjudge + 1

        NewStudyLayer_wordList_currentWord           =   s_WordPool[NewStudyLayer_wordList[currentIndex_unjudge]]

        UpdateCurrentWordContent()

        if table.getn(wrongWordList) == maxWrongWordCount  then
            local New_study_popup = require("view.newstudy.NewStudyPopup")
            local new_study_popup = New_study_popup.create()  
            s_SCENE:popup(new_study_popup)

            s_SCENE:callFuncWithDelay(2,function()
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Mission)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end)

        else
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    else
        table.insert(wrongWordList,NewStudyLayer_wordList_wordName)
        currentIndex_unreview = currentIndex_unreview + 1

        NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]

        UpdateCurrentWordContent()

        if table.getn(wrongWordList) == maxWrongWordCount  then

            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Reward)
            s_SCENE:replaceGameLayer(newStudyLayer)
        else
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end

    end
end

function UpdateCurrentWordContent()
    NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
    NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
    NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
    NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
    NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
    NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
    NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn
end

function RewardAdd(backGround)
    for i=1,3 do
        local diamond = cc.Sprite:create("image/newstudy/diamond.png")
        diamond:setPosition(backGround:getContentSize().width * 0.5 + diamond:getContentSize().width*3 * (i - 2),
            backGround:getContentSize().height * 0.2)
        diamond:ignoreAnchorPointForPosition(false)
        diamond:setAnchorPoint(0.5,0.5)
        diamond:setScale(2)
        backGround:addChild(diamond)  
    end
end

function ShowAnswerTrueBack(backGround)

   local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
   showAnswerStateBack:setPosition(backGround:getContentSize().width/2 * (-3), 768)
   backGround:addChild(showAnswerStateBack)

   local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
   sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
   showAnswerStateBack:addChild(sign)

   local right_wordname = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",60)
   right_wordname:setColor(cc.c4b(130,186,47,255))
   right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
   right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
   showAnswerStateBack:addChild(right_wordname)

   local action1 = cc.MoveTo:create(0.5,cc.p(backGround:getContentSize().width / 2, 768))
   showAnswerStateBack:runAction(action1)
end


function ShowAnswerFalseBack(backGround)
    local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_wrong_back.png")
    showAnswerStateBack:setPosition(backGround:getContentSize().width/2 *3, 768)
    backGround:addChild(showAnswerStateBack)

    local action = cc.MoveTo:create(0.5,cc.p(backGround:getContentSize().width/2, 768))
    showAnswerStateBack:runAction(action)

    local sign = cc.Sprite:create("image/testscene/testscene_wrong_x.png")
    sign:setPosition(showAnswerStateBack:getContentSize().width*0.1, showAnswerStateBack:getContentSize().height*0.45)
    showAnswerStateBack:addChild(sign)

    local right_wordname = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",60)
    right_wordname:setColor(cc.c4b(202,66,64,255))
    right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
    right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
    showAnswerStateBack:addChild(right_wordname)	
end

function CreateRandomWordList(parameters)
    
    local number = tostring(os.time() * currentIndex_unjudge * currentIndex_unreview * i)

    math.randomseed(number)  

    local randomNumber = math.random(1,table.getn(NewStudyLayer_wordList))

    local randMeaning = s_WordPool[NewStudyLayer_wordList[randomNumber]].wordMeaningSmall
    
    
end