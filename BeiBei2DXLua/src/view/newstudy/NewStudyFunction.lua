function JudgeColorAtTop(backGround)
    local word_mark 
    local sufferNumber = s_DATABASE_MGR.countLastNewStudyLayerSufferTables()
    local testNumber = s_DATABASE_MGR.countFormerNewStudyLayerTestTables()
    local testTableIsNil =   s_DATABASE_MGR:selectFormerNewStudyLayerTestTables()   
    local testIndex =  FindIndex(testTableIsNil)
    
    if testIndex == 0 then
        for i = 1,maxWrongWordCount do
            if i >  sufferNumber then
                    word_mark = cc.Sprite:create("image/newstudy/blueball.png")
            else
                    word_mark = cc.Sprite:create("image/newstudy/yellowball.png")
            end

            if word_mark ~= nil then
                word_mark:setPosition(backGround:getContentSize().width * 0.5 + word_mark:getContentSize().width*1.1 * (i - maxWrongWordCount / 2 - 1),s_DESIGN_HEIGHT * 0.93)
                word_mark:ignoreAnchorPointForPosition(false)
                word_mark:setAnchorPoint(0,0.5)
                backGround:addChild(word_mark)
            end
        end
    else
        for i = 1,maxWrongWordCount do
            if i > testNumber then
                word_mark = cc.Sprite:create("image/newstudy/greenball.png")
            else
                word_mark = cc.Sprite:create("image/newstudy/yellowball.png")
            end

            if word_mark ~= nil then
                word_mark:setPosition(backGround:getContentSize().width * 0.5 - word_mark:getContentSize().width*1.1 * (i - maxWrongWordCount / 2 ),s_DESIGN_HEIGHT * 0.93)
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
    local change_mark_button
    local label_in_change_button

    local word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",48)
    word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.85)
    word:setColor(cc.c4b(0,0,0,255))
    word:ignoreAnchorPointForPosition(false)
    word:setAnchorPoint(0.5,0.5)
    backGround:addChild(word)

    local click_playsound = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        -- button sound          
          playSound(s_sound_buttonEffect) 
        elseif eventType == ccui.TouchEventType.ended then
            playWordSound(NewStudyLayer_wordList_wordName)
        end
    end


    local word_playsound_button = ccui.Button:create("image/newstudy/light_orange.png","image/newstudy/deep_orange.png","")
    word_playsound_button:setPosition(backGround:getContentSize().width /2 - word:getContentSize().width / 2  - 40  , s_DESIGN_HEIGHT * 0.85)
    word_playsound_button:ignoreAnchorPointForPosition(false)
    word_playsound_button:setAnchorPoint(0.5,0.5)
    word_playsound_button:addTouchEventListener(click_playsound)
    backGround:addChild(word_playsound_button) 
    
    local horn_on_button = cc.Sprite:create("image/newstudy/horn.png")
    horn_on_button:setPosition(word_playsound_button:getContentSize().width * 0.5,word_playsound_button:getContentSize().height * 0.5)
    word_playsound_button:addChild(horn_on_button)
    
    

    local click_change = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)

        elseif eventType == ccui.TouchEventType.ended then
            if Pronounce_Mark_US == 1 then          
                Pronounce_Mark_US = 0
                wordUs:setVisible(false)
                wordEn:setVisible(true)
                label_in_change_button:setString("ES")
            else
                Pronounce_Mark_US = 1
                wordUs:setVisible(true)
                wordEn:setVisible(false)
                label_in_change_button:setString("US")
            end
        end
    end

    wordUs = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordSoundMarkAm,"",42)
    wordUs:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.8)
    wordUs:setColor(cc.c4b(0,0,0,255))
    wordUs:ignoreAnchorPointForPosition(false)
    wordUs:setAnchorPoint(0.5,0.5)
    wordUs:setVisible(true)
    backGround:addChild(wordUs)

    wordEn =  cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordSoundMarkEn,"",42)
    wordEn:setPosition(backGround:getContentSize().width /2 ,s_DESIGN_HEIGHT * 0.8)
    wordEn:setColor(cc.c4b(0,0,0,255))
    wordEn:ignoreAnchorPointForPosition(false)
    wordEn:setAnchorPoint(0.5,0.5)
    wordEn:setVisible(false)
    backGround:addChild(wordEn)

    change_mark_button = ccui.Button:create("image/newstudy/light_green.png","image/newstudy/deep_green.png","")
    change_mark_button:setPosition(backGround:getContentSize().width /2 - word:getContentSize().width / 2  - 40, s_DESIGN_HEIGHT * 0.8)
    change_mark_button:ignoreAnchorPointForPosition(false)
    change_mark_button:setAnchorPoint(0.5,0.5)
    change_mark_button:addTouchEventListener(click_change)
    backGround:addChild(change_mark_button)  

    label_in_change_button = cc.Label:createWithSystemFont("US","",20)
    label_in_change_button:setPosition(change_mark_button:getContentSize().width /2  , change_mark_button:getContentSize().height /2 )
    label_in_change_button:setColor(cc.c4b(255,255,255,255))
    change_mark_button:addChild(label_in_change_button)

    if Pronounce_Mark_US == 0 then          
        wordUs:setVisible(false)
        wordEn:setVisible(true)
        label_in_change_button:setString("ES")
    else
        wordUs:setVisible(true)
        wordEn:setVisible(false)
        label_in_change_button:setString("US")
    end
end

function HugeWordUnderColorSquare(backGround)
	local huge_word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",48)
    huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.85)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    backGround:addChild(huge_word)
        
--    if string.len(huge_word:getString()) > 5  then
--    huge_word:setSystemFontSize(24 * backGround:getContentSize().width / huge_word:getContentSize().width)
--    end
    
    local onTouchBegan = function(touch, event)
        playSound(s_sound_buttonEffect) 
        return true
    end


    local onTouchEnded = function(touch, event)
        local location = backGround:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(huge_word:getBoundingBox(), location) then
            s_DATABASE_MGR.insertNewStudyLayerFamiliarTables(NewStudyLayer_wordList_wordName)
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
    FindWord()
    local testTableIsNil =   s_DATABASE_MGR:selectFormerNewStudyLayerTestTables()   

    if current_state_judge == 1 then
        NewStudyLayer_State = NewStudyLayer_State_Choose
        local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
        s_SCENE:replaceGameLayer(newStudyLayer)
    else
        if  testTableIsNil == 0 then
            NewStudyLayer_State = NewStudyLayer_State_Reward
            local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
            s_SCENE:replaceGameLayer(newStudyLayer)
        else
            NewStudyLayer_State = NewStudyLayer_State_Choose
            local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end
end

function UpdateCurrentWordFromFalse()
    FindWord()
    local testTableIsNil =   s_DATABASE_MGR:selectFormerNewStudyLayerTestTables()   

    if current_state_judge == 1 then

        if testTableIsNil == 0  then
            NewStudyLayer_State = NewStudyLayer_State_Choose
            local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
            s_SCENE:replaceGameLayer(newStudyLayer) 
        else
            local New_study_popup = require("view.newstudy.NewStudyPopup")
            local new_study_popup = New_study_popup.create()  
            s_SCENE:popup(new_study_popup)

            s_SCENE:callFuncWithDelay(2.5,function()
                NewStudyLayer_State = NewStudyLayer_State_Mission
                local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
                s_SCENE:replaceGameLayer(newStudyLayer)
            end)

        end
    else

       if testTableIsNil == 0  then  
            NewStudyLayer_State = NewStudyLayer_State_Reward
            local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
            s_SCENE:replaceGameLayer(newStudyLayer)
        else
            NewStudyLayer_State = NewStudyLayer_State_Choose
            local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
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
        local diamond = cc.Sprite:create("image/newstudy/bean.png")
        diamond:setPosition(backGround:getContentSize().width * 0.5 + diamond:getContentSize().width*3 * (i - 2),
            backGround:getContentSize().height * 0.28)
        diamond:ignoreAnchorPointForPosition(false)
        diamond:setAnchorPoint(0.5,0.5)
        diamond:setScale(2)
        backGround:addChild(diamond)  
    end
end

function ShowAnswerTrueBack(sender)

   local showAnswerStateBack = cc.Sprite:create("image/newstudy/righttip.png")
    showAnswerStateBack:setPosition(sender:getContentSize().width/2 * (-3), sender:getContentSize().height/2)
   sender:addChild(showAnswerStateBack)

--   local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
--   sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
--   showAnswerStateBack:addChild(sign)
--
--   local right_wordname = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",60)
--   right_wordname:setColor(cc.c4b(130,186,47,255))
--   right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
--   right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
--   showAnswerStateBack:addChild(right_wordname)

    local action = cc.MoveTo:create(0.5,cc.p(sender:getContentSize().width *0.8, sender:getContentSize().height/2))
    showAnswerStateBack:runAction(action)
end


function ShowAnswerFalseBack(sender)
    local showAnswerStateBack = cc.Sprite:create("image/newstudy/wrongtip.png")
    showAnswerStateBack:setPosition(sender:getContentSize().width/2 *3, sender:getContentSize().height/2 )
    sender:addChild(showAnswerStateBack)

    local action = cc.MoveTo:create(0.5,cc.p(sender:getContentSize().width *0.8, sender:getContentSize().height/2))
    showAnswerStateBack:runAction(action)

--    local sign = cc.Sprite:create("image/testscene/testscene_wrong_x.png")
--    sign:setPosition(showAnswerStateBack:getContentSize().width*0.1, showAnswerStateBack:getContentSize().height*0.45)
--    showAnswerStateBack:addChild(sign)
--
--    local right_wordname = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",60)
--    right_wordname:setColor(cc.c4b(202,66,64,255))
--    right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
--    right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
--    showAnswerStateBack:addChild(right_wordname)	
end

function AddPauseButton(backGround)
    local pause_button = ccui.Button:create("image/newstudy/pause_button_begin.png","image/newstudy/pause_button_end.png","")
    pause_button:setPosition(s_LEFT_X + 150, s_DESIGN_HEIGHT  )
    pause_button:ignoreAnchorPointForPosition(false)
    pause_button:setAnchorPoint(0,1)
    backGround:addChild(pause_button) 	
end

function FindIndex(word)
    if word == 0 then
        return 0
    else
        local index
        table.foreachi(NewStudyLayer_wordList, function(i, v) 
            if v == word then
                index = i
            end                
        end)  
        if index == nil then
        return 0
        else
        return index
        end
    end
end

function FindWord()
    local testTableIsNil =   s_DATABASE_MGR:selectFormerNewStudyLayerTestTables()   
    print("testTableIsNil is "..testTableIsNil)

    if testTableIsNil == 0 then
        if NewStudyLayer_State == 1 then
            -- test table = nil

            local lastFamiliarWord = s_DATABASE_MGR:selectLastNewStudyLayerFamiliarTables()
            local lastUnfamiliarWord = s_DATABASE_MGR:selectLastNewStudyLayerUnfamiliarTables()
            local lastSufferWord = s_DATABASE_MGR:selectLastNewStudyLayerSufferTables()

            local lastFamiliarIndex =  FindIndex(lastFamiliarWord)
            local lastUnfamiliarIndex = FindIndex(lastUnfamiliarWord)
            local lastSufferIndex = FindIndex(lastSufferWord)

            print("lastFamiliarIndex is "..lastFamiliarIndex.."over")
            print("lastUnfamiliarIndex is "..lastUnfamiliarIndex.."over")
            print("lastSufferIndex is "..lastSufferIndex.."over")

            local lastIndex = lastFamiliarIndex

            if lastIndex < lastUnfamiliarIndex then
                lastIndex = lastUnfamiliarIndex
            end

            if lastIndex < lastSufferIndex then
                lastIndex = lastSufferIndex
            end

            print("lastIndex is "..lastIndex)

            local nowIndex = lastIndex + 1
            currentIndex_unjudge = nowIndex
            NewStudyLayer_wordList_currentWord     =   s_WordPool[NewStudyLayer_wordList[nowIndex]]

        end

    else
        if NewStudyLayer_State == 1 then
            --update current_state_judge = study
            current_state_judge = 0
            local formerIndex = FindIndex(testTableIsNil)
            print("formerIndex is "..formerIndex.." over")
            local nowIndex = formerIndex
            NewStudyLayer_wordList_currentWord     =   s_WordPool[NewStudyLayer_wordList[nowIndex]]

            --        NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]
        end
    end

    if NewStudyLayer_wordList_currentWord ~= nil then
        UpdateCurrentWordContent()
    end
end


