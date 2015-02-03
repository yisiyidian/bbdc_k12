require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local GuessWrong        = require("view.newstudy.GuessWrongPunishPopup")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  BlacksmithLayer = class("BlacksmithLayer", function ()
    return cc.Layer:create()
end)

function BlacksmithLayer.create(wordlist,index)
    local layer = BlacksmithLayer.new(wordlist,index)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    return layer
end

local function createOptions(randomNameArray,wordlist)
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
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local feedback 
            if sender.tag == 1 then  
                feedback = cc.Sprite:create("image/newstudy/right.png")            
            else  
                feedback = cc.Sprite:create("image/newstudy/wrong.png")
            end    
            feedback:setPosition(sender:getContentSize().width * 0.8 ,sender:getContentSize().height * 0.5)
            sender:addChild(feedback)

            if sender.tag == 1 then  
                table.remove(wordlist,1)
                local action1 = cc.DelayTime:create(0.5)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    if #wordlist == 0 then
                        s_CorePlayManager.leaveTestModel()
                    else
                        AnalyticsStudyAnswerRight_strikeWhileHot()
                        local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
                        local blacksmithLayer = BlacksmithLayer.create(wordlist)
                        s_SCENE:replaceGameLayer(blacksmithLayer)
                    end

                end)))            
            else
                local action1 = cc.DelayTime:create(0.5)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    AnalyticsStudyGuessWrong_strikeWhileHot()
                    local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
                    local chooseWrongLayer = ChooseWrongLayer.create(wordlist[1],s_max_wrong_num_everyday - #wordlist,wordlist)
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

local function createDontknow(wordlist)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsStudyDontKnowAnswer_strikeWhileHot()
            AnalyticsFirst(ANALYTICS_FIRST_DONT_KNOW_STRIKEWHILEHOT, 'TOUCH')
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(wordlist[1],s_max_wrong_num_everyday - #wordlist,wordlist)
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

function BlacksmithLayer:ctor(wordlist)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.currentWord = wordlist[1]

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    self.randWord = CollectUnfamiliar:createRandWord(self.currentWord)

    local progressBar = ProgressBar.create(s_max_wrong_num_everyday, s_max_wrong_num_everyday - #wordlist, "yellow")
    progressBar:setPosition(bigWidth/2+44, 1049)
    backColor:addChild(progressBar)

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    self.lastWordAndTotalNumber.setNumber(9999)
    self.lastWordAndTotalNumber.setWord("apple",true)

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)

    self.options = createOptions(self.randWord,wordlist)
    for i = 1, #self.options do
        backColor:addChild(self.options[i])
    end

    self.dontknow = createDontknow(wordlist)
    backColor:addChild(self.dontknow)

    local label_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",26)
    label_dontknow:setPosition(bigWidth/2, 220)
    label_dontknow:setColor(cc.c4b(37,158,227,255))
    backColor:addChild(label_dontknow)
end

return BlacksmithLayer