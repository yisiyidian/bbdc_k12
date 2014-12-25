require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")

local  NewStudyChooseLayer = class("NewStudyChooseLayer", function ()
    return cc.Layer:create()
end)

function NewStudyChooseLayer.create()
    --pause music
    cc.SimpleAudioEngine:getInstance():pauseMusic()

    -- word info
    local currentWordName
    if s_CorePlayManager.isStudyModel() then
        currentWordName = s_CorePlayManager.NewStudyLayerWordList[s_CorePlayManager.currentIndex]
    else
        currentWordName = s_CorePlayManager.wordCandidate[1]
    end
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
    local randomNameArray  = {}
    table.insert(randomNameArray, currentWordName)
    while 1 do
        if #randomNameArray >= 4 then
            break
        end
        local randomIndex = math.random(1, totalWordNum)
        local randomWord = s_CorePlayManager.NewStudyLayerWordList[randomIndex]
        local isIn = 0
        for i = 1, #randomNameArray do
            if randomNameArray[i] == randomWord then
                isIn = 1
                break
            end
        end
        if isIn == 0 then
            table.insert(randomNameArray, randomWord)
        end
    end
    
    local wordMeaningTable= {}
    for i = 1, 4 do
        local name = randomNameArray[i]
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
    
    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    local soundMark = SoundMark.create(wordname, wordSoundMarkEn, wordSoundMarkAm)
    soundMark:setPosition(bigWidth/2, 960)  
    backColor:addChild(soundMark)

    local click_choose = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then            
            local feedback 
            if sender.tag == 1 then
                feedback = cc.Sprite:create("image/newstudy/righttip.png")
            else
                feedback = cc.Sprite:create("image/newstudy/falsetip.png")
            end    
            feedback:setPosition(sender:getContentSize().width * 0.8 ,sender:getContentSize().height * 0.5)
            sender:addChild(feedback)
            
            s_SCENE:callFuncWithDelay(0.5,function()  
                if sender.tag == 1 then
                    if s_CorePlayManager.isStudyModel() then
                        s_CorePlayManager.enterNewStudyRightLayer()
                    else
                        s_CorePlayManager.updateWordCandidate(false)
                        
                        if s_CorePlayManager.candidateNum == 0 then
                            s_CorePlayManager.checkInOverModel()
                            s_CorePlayManager.enterNewStudySuccessLayer()
                        else
                            s_CorePlayManager.enterNewStudyChooseLayer()
                        end
                    end
                else
                    if s_CorePlayManager.isStudyModel() then
                        s_CorePlayManager.enterNewStudyWrongLayer()
                    else
                        s_CorePlayManager.enterNewStudyWrongLayer()
                    end
                end   
            end)
        end
    end

    for i = 1 , 4 do
        local choose_button = ccui.Button:create("image/newstudy/button_words_white_normal.png","image/newstudy/button_words_white_pressed.png","")
        choose_button:setPosition(bigWidth/2, 319+(i-1)*135)
        if i == rightIndex then
            choose_button.tag = 1
        else
            choose_button.tag = 0
        end
        choose_button:addTouchEventListener(click_choose)
        backColor:addChild(choose_button)
                
        local choose_label = cc.Label:createWithSystemFont(wordMeaningTable[i],"",32)
        choose_label:setAnchorPoint(0,0.5)
        choose_label:setPosition(40, choose_button:getContentSize().height/2)
        choose_label:setColor(cc.c4b(98,124,148,255))
        choose_button:addChild(choose_label)
    end

    local label_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",26)
    label_dontknow:setPosition(bigWidth/2, 220)
    label_dontknow:setColor(cc.c4b(37,158,227,255))
    backColor:addChild(label_dontknow)

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then            
            if s_CorePlayManager.isStudyModel() then
                s_CorePlayManager.enterNewStudyWrongLayer()
            else
                s_CorePlayManager.enterNewStudyWrongLayer()
            end
        end
    end

    local choose_dontknow_button = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    choose_dontknow_button:setPosition(bigWidth/2, 153)
    choose_dontknow_button:setTitleText("不认识")
    choose_dontknow_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_dontknow_button:setTitleFontSize(32)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)
    backColor:addChild(choose_dontknow_button)  
    
    return layer
end

return NewStudyChooseLayer