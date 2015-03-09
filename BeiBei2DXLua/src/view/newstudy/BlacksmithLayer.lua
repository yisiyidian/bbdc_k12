require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local GuessWrong        = require("view.newstudy.GuessWrongPunishPopup")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  BlacksmithLayer = class("BlacksmithLayer", function ()
    return cc.Layer:create()
end)

function BlacksmithLayer.create(wordlist,index)
    local layer = BlacksmithLayer.new(wordlist,index)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    return layer
end

function BlacksmithLayer:createOptions(randomNameArray,wordlist,position)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local progressBar_total_number 
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if #bossList == 1 then
        progressBar_total_number = 3
    else
        progressBar_total_number = s_max_wrong_num_everyday
    end 
    
    local wordMeaningTable= {}
    for i = 1, 4 do
        local name = randomNameArray[i]
        local meaning = s_LocalDatabaseManager.getWordInfoFromWordName(name).wordMeaningSmall
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
                local action1 = cc.DelayTime:create(0.1)
                local action2 = cc.MoveTo:create(0.3,cc.p(position , 1070 - sender:getPositionY()))
                local action3 = cc.ScaleTo:create(0.1,0)
                local action4 = cc.DelayTime:create(0.3)
                feedback:runAction(cc.Sequence:create(action1,action2,action3,               
                  cc.CallFunc:create(function()
                     self.progressBar.addOne()
               end),               
                  cc.CallFunc:create(function()
                  if #wordlist == 0 then
                    self.progressBar:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
                  end
               end),
                  action4,
                  cc.CallFunc:create(function()
                    if #wordlist == 0 then
                        s_CURRENT_USER:addBeans(s_CURRENT_USER.beanRewardForIron)
                        saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                        if s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) then
                            s_CorePlayManager.leaveTestModel() 
                        else
                            local missionCompleteCircle = require('view.MissionCompleteCircle').create()
                            s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
                            sender:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),cc.CallFunc:create(function ()
                                s_CorePlayManager.leaveTestModel()   
                            end,{})))
                        end
                        
                    else
                        AnalyticsStudyAnswerRight_strikeWhileHot()
                        local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
                        local blacksmithLayer = BlacksmithLayer.create(wordlist)
                        s_SCENE:replaceGameLayer(blacksmithLayer)
                    end

                end)))            
            else
                local action1 = cc.DelayTime:create(0.3)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    AnalyticsStudyGuessWrong_strikeWhileHot()
                    local bean = s_CURRENT_USER.beanRewardForIron
                    local total = 3
                    if bean > 0 then
                        local guessWrong = GuessWrong.create(bean,total)
                        s_SCENE:popup(guessWrong)
                        s_CURRENT_USER.beanRewardForIron = s_CURRENT_USER.beanRewardForIron - 1
                    end
                    local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
                    local chooseWrongLayer = ChooseWrongLayer.create(wordlist[1],progressBar_total_number - #wordlist,wordlist)
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
        choose_label:setPosition(40, choose_button[i]:getContentSize().height/2 + 4)
        choose_label:setColor(cc.c4b(98,124,148,255))
        choose_button[i]:addChild(choose_label)
    end

    return choose_button
end

local function createDontknow(wordlist)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local progressBar_total_number 
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if #bossList == 1 then
        progressBar_total_number = 3
    else
        progressBar_total_number = s_max_wrong_num_everyday
    end 

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsStudyDontKnowAnswer_strikeWhileHot()
            AnalyticsFirst(ANALYTICS_FIRST_DONT_KNOW_STRIKEWHILEHOT, 'TOUCH')
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(wordlist[1],progressBar_total_number - #wordlist,wordlist)
            s_SCENE:replaceGameLayer(chooseWrongLayer)            
        end
    end

    local choose_dontknow_button = Button.create("不认识")
    choose_dontknow_button:setPosition(bigWidth/2, 100)
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
    self.randWord = CollectUnfamiliar:createRandWord(self.currentWord,4)

    local progressBar_total_number 

    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if #bossList == 1 then
        progressBar_total_number = 3
    else
        progressBar_total_number = s_max_wrong_num_everyday
    end

    self.progressBar = ProgressBar.create(progressBar_total_number, progressBar_total_number - #wordlist, "yellow")
    self.progressBar:setPosition(bigWidth/2+44, 1054)
    backColor:addChild(self.progressBar)

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    local todayNumber = LastWordAndTotalNumber:getTodayNum()
    self.lastWordAndTotalNumber.setNumber(todayNumber)


    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 925)
    backColor:addChild(soundMark)

    self.options = self:createOptions(self.randWord,wordlist,self.progressBar.indexPosition())
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