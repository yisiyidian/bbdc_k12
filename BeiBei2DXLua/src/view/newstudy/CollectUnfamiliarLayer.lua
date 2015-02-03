require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local GuessWrong        = require("view.newstudy.GuessWrongPunishPopup")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 

local  CollectUnfamiliarLayer = class("CollectUnfamiliarLayer", function ()
    return cc.Layer:create()
end)

function CollectUnfamiliarLayer:createWordInfo(word) 
    local currentWord       = s_WordPool[word]
    local wordname          = currentWord.wordName
    local wordSoundMarkEn   = currentWord.wordSoundMarkEn
    local wordSoundMarkAm   = currentWord.wordSoundMarkAm
    local wordMeaningSmall  = currentWord.wordMeaningSmall
    local wordMeaning       = currentWord.wordMeaning
    local sentenceEn        = currentWord.sentenceEn
    local sentenceCn        = currentWord.sentenceCn
    local sentenceEn2       = currentWord.sentenceEn2
    local sentenceCn2       = currentWord.sentenceCn2
    
    return {currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,
        wordMeaning,sentenceEn,sentenceCn,sentenceEn2,sentenceCn2 }
end

function CollectUnfamiliarLayer:createRandWord(word)
    local randomNameArray  = {}
    table.insert(randomNameArray, word)
    local word1 = split(tostring(s_WordPool[word].wordMeaningSmall),"%.")
    local wordList = {}

    if word1[1] == "num" then
        wordList = {"thirty","eighty","fourteen","eight"}
    elseif word1[1] == "int" then 
        wordList = {"lord","please","oh","hey"}
    elseif word1[1] == "pron" then
        wordList = {"hers","which","our","something"}
    elseif word1[1] == "prep" then
        wordList = {"who","from","of","regarding"}
    elseif word1[1] == "conj" then
        wordList = {"whether","because","or","provided"}
    elseif word1[1] == "aux" then
        wordList = {"do","could","can","have"}
    elseif word1[1] == "art" then
        wordList = {"an","thirty","lord","who"}
    end
    
    if wordList ~= nil then
        for i = 1 ,3 do
            if word == wordList[i] then
                table.insert(randomNameArray, wordList[4])
            else
                table.insert(randomNameArray, wordList[i])
            end
        end
    end
    
    while 1 do
        if #randomNameArray >= 4 then
            break
        end 
        local randomIndex = math.random(1, #s_BookWord[s_CURRENT_USER.bookKey])
        local randomWord = s_BookWord[s_CURRENT_USER.bookKey][randomIndex]
        local isIn = 0
        for i = 1, #randomNameArray do
            if randomNameArray[i] == randomWord then
                isIn = 1
                break
            end
            local word1 = split(tostring(s_WordPool[word].wordMeaningSmall),"%.")
            local word2 = split(tostring(s_WordPool[randomWord].wordMeaningSmall),"%.")
            if word1[1] ~= word2[1] then
                isIn = 1
                break
            end
        end
        if isIn == 0 then
            table.insert(randomNameArray, randomWord)
        end
    end
    return randomNameArray
end

local function createOptions(randomNameArray,word,wrongNum)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
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
    
    local click_choose = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then  
--            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local feedback 
            if sender.tag == 1 then  
                feedback = cc.Sprite:create("image/newstudy/right.png")            
            else  
                feedback = cc.Sprite:create("image/newstudy/wrong.png")
            end    
            feedback:setPosition(sender:getContentSize().width * 0.8 ,sender:getContentSize().height * 0.5)
            sender:addChild(feedback)

            if sender.tag == 1 then  
                local action1 = cc.DelayTime:create(0.5)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    AnalyticsStudyAnswerRight()
                    local ChooseRightLayer = require("view.newstudy.ChooseRightLayer")
                    local chooseRightLayer = ChooseRightLayer.create(word,wrongNum)
                    s_SCENE:replaceGameLayer(chooseRightLayer)
                end)))            
            else
                local action1 = cc.DelayTime:create(0.5)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    AnalyticsStudyGuessWrong()
                    ---- minus beibei bean need to do
                    local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
                    local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum)
                    s_SCENE:replaceGameLayer(chooseWrongLayer)   
                end)))
            end

        end
    end
    
    local choose_button = {}
    
    for i = 1 , 4 do
        choose_button[i] = ccui.Button:create("image/newstudy/button_words_white_normal.png","image/newstudy/button_words_white_pressed.png","")
        choose_button[i]:setPosition(bigWidth/2, 319+(i-1)*135)
        if i == rightIndex then
            choose_button[i].tag = 1
        else
            choose_button[i].tag = 0
        end
        choose_button[i]:addTouchEventListener(click_choose)

        local choose_label = cc.Label:createWithSystemFont(wordMeaningTable[i],"",32)
        choose_label:setAnchorPoint(0,0.5)
        choose_label:setPosition(40, choose_button[i]:getContentSize().height/2)
        choose_label:setColor(cc.c4b(98,124,148,255))
        choose_button[i]:addChild(choose_label)
    end
    
    return choose_button
end

local function createDontknow(word,wrongNum)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsStudyDontKnowAnswer()  
            AnalyticsFirst(ANALYTICS_FIRST_DONT_KNOW, 'TOUCH')
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum)
            s_SCENE:replaceGameLayer(chooseWrongLayer)          
        end
    end

    local choose_dontknow_button = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    choose_dontknow_button:setPosition(bigWidth/2, 153)
    choose_dontknow_button:setTitleText("不认识")
    choose_dontknow_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_dontknow_button:setTitleFontSize(32)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)
    
    return choose_dontknow_button
end

function CollectUnfamiliarLayer.create(word,wrongNum)
    local layer = CollectUnfamiliarLayer.new(word,wrongNum)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    return layer
end

function CollectUnfamiliarLayer:ctor(word,wrongNum)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.currentWord = word

    self.wordInfo = self:createWordInfo(self.currentWord)
    self.randWord = self:createRandWord(self.currentWord)
    
    local progressBar = ProgressBar.create(s_max_wrong_num_everyday, wrongNum, "blue")
    progressBar:setPosition(bigWidth/2+44, 1049)
    backColor:addChild(progressBar)
    
    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    self.lastWordAndTotalNumber.setNumber(9999)
    self.lastWordAndTotalNumber.setWord("apple",true)
    
    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)
    
    self.options = createOptions(self.randWord,word,wrongNum)
    for i = 1, #self.options do
        backColor:addChild(self.options[i])
    end
    
    self.dontknow = createDontknow(word,wrongNum)
    backColor:addChild(self.dontknow)
    
    local label_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",26)
    label_dontknow:setPosition(bigWidth/2, 220)
    label_dontknow:setColor(cc.c4b(37,158,227,255))
    backColor:addChild(label_dontknow)
end

return CollectUnfamiliarLayer