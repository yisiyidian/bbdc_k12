require("cocos.init")
require("common.global")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local GuessWrong        = require("view.newstudy.GuessWrongPunishPopup")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")
local Button                = require("view.button.longButtonInStudy")

local  BlacksmithLayer = class("BlacksmithLayer", function ()
    return cc.Layer:create()
end)

function BlacksmithLayer.create(wordlist,islandIndex)-- 如果是重玩，把岛屿编号传进去
    local layer = BlacksmithLayer.new(wordlist,islandIndex)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    return layer
end

function BlacksmithLayer:createOptions(randomNameArray,wordlist,position)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
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

    local button_func = function(button)
            local feedback 
            if button.tag == 1 then  
                playSound(s_sound_learn_true)
                feedback = cc.Sprite:create("image/newstudy/right.png")
            else  
                playSound(s_sound_learn_false)
                feedback = cc.Sprite:create("image/newstudy/wrong.png")
            end 
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
  
            feedback:setPosition(button:getContentSize().width * 0.8 ,button:getContentSize().height * 0.5)
            button:addChild(feedback)

            if button.tag == 1 then  
                local preWord = wordlist[1]
                table.remove(wordlist,1)
                local action1 = cc.DelayTime:create(0.1)
                local action2 = cc.MoveTo:create(0.3,cc.p(position , 1070 - button:getPositionY()))
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
                        if self.islandIndex ~= nil then
                            s_CorePlayManager.enterLevelLayer()
                            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                            return
                        end 
                        if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat3_1 then
                            s_CURRENT_USER:setTutorialStep(s_tutorial_study + 1)
                        end
                        AnalyticsForgeIron_LeaveLayer()
                        s_CURRENT_USER:addBeans(s_CURRENT_USER.beanRewardForIron)
                        saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                        if s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) then
                            s_CorePlayManager.leaveTestModel() 
                        else
                            local missionCompleteCircle = require('view.MissionCompleteCircle').create()
                            s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
                            button:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),cc.CallFunc:create(function ()
                                s_CorePlayManager.leaveTestModel()   
                            end,{})))
                        end
                        
                    else
                        AnalyticsStudyAnswerRight_strikeWhileHot()
                        local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
                        local blacksmithLayer = BlacksmithLayer.create(wordlist,self.islandIndex)
                        s_SCENE:replaceGameLayer(blacksmithLayer)
                    end

                end)))            
            else
                AnalyticsStudyGuessWrong_strikeWhileHot()
                local bean = s_CURRENT_USER.beanRewardForIron
                local total = 3
                
                if bean > 0 and self.islandIndex == nil then
                    local guessWrong = GuessWrong.create(bean,total)
                    s_SCENE:popup(guessWrong)
                    s_CURRENT_USER.beanRewardForIron = s_CURRENT_USER.beanRewardForIron - 1
                end

                local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
                local chooseWrongLayer = ChooseWrongLayer.create(wordlist[1],self.progressBar_total_number - #wordlist, wordlist,self.islandIndex)
                s_SCENE:replaceGameLayer(chooseWrongLayer)
            end
    end

    local choose_button = {}

    for i = 1 , 4 do
        choose_button[i] = Button.create("long","white") 
        choose_button[i]:setPosition(bigWidth/2, 319+(i-1)*135)
        if i == rightIndex then
            choose_button[i].tag = 1
        else
            choose_button[i].tag = 0
        end

        choose_button[i].func = function ()
            button_func(choose_button[i])
        end

        local choose_label = cc.Label:createWithSystemFont(wordMeaningTable[i],"",32)
        choose_label:setAnchorPoint(0,0.5)
        choose_label:setPosition(40, choose_button[i].button_front:getContentSize().height/2)
        choose_label:setColor(cc.c4b(98,124,148,255))
        choose_button[i].button_front:addChild(choose_label)
    end

    return choose_button
end

function BlacksmithLayer:createDontknow(wordlist)-- 传递参数
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local progressBar_total_number = getMaxWrongNumEveryLevel()
    
    local button_func = function()
        playSound(s_sound_buttonEffect)        
        AnalyticsStudyDontKnowAnswer_strikeWhileHot()
        AnalyticsFirst(ANALYTICS_FIRST_DONT_KNOW_STRIKEWHILEHOT, 'TOUCH')

        local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
        local chooseWrongLayer = ChooseWrongLayer.create(wordlist[1], progressBar_total_number - #wordlist, wordlist,self.islandIndex)
        s_SCENE:replaceGameLayer(chooseWrongLayer)            
    end

    local choose_dontknow_button = Button.create("long","blue","不认识") 
    choose_dontknow_button:setPosition(bigWidth/2, 100)
    choose_dontknow_button.func = function ()
        button_func()
    end

    return choose_dontknow_button
end

function BlacksmithLayer:ctor(wordlist,islandIndex)
    if islandIndex ~= nil then  
        self.islandIndex = islandIndex
    end
    AnalyticsForgeIron_EnterLayer()

    if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep <= s_smalltutorial_studyRepeat1_1 then
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat2_3 + 1)
    end

    if s_CURRENT_USER.k12SmallStep < s_K12_strikeIron then
        s_CURRENT_USER:setK12SmallStep(s_K12_strikeIron)
    end
    -- 打点
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT) 

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT + 45)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)
    
    local pauseBtn = PauseButton.create(CreatePauseFromStudy)
    pauseBtn:setPosition(0, s_DESIGN_HEIGHT)
    backColor:addChild(pauseBtn,100)    

    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.currentWord = wordlist[1]

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    self.randWord = CollectUnfamiliar:createRandWord(self.currentWord,4)

    self.progressBar_total_number = 0 

    if self.islandIndex ~= nil then
        local info = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
        self.progressBar_total_number = #info.wrongWordList
    else
        self.progressBar_total_number = s_CorePlayManager.wrongWordNum
    end

    self.progressBar = ProgressBar.create(self.progressBar_total_number, self.progressBar_total_number - #wordlist, "yellow")
    self.progressBar:setPosition(bigWidth/2+44, 1054)
    backColor:addChild(self.progressBar)

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 930)
    backColor:addChild(soundMark)
    self.soundMark = soundMark

    --词组
    local wordGroupLabel =  cc.Label:createWithSystemFont("XXXXXX123132123","",50)
    wordGroupLabel:setPosition(bigWidth/2, 925)
    wordGroupLabel:setColor(cc.c4b(0,0,0,255))
    backColor:addChild(wordGroupLabel)
    self.wordGroupLabel = wordGroupLabel

    --判断单词是否为词组 是词组的话显示此组本身 隐藏音标 反之 显示为空
    if string.find(self.currentWord, "|") ~= -1 then
        --不是词组 把XXXXXX123132123 改为空 音标显示
        self.wordGroupLabel:setString("")
        self.soundMark:setVisible(true)
    else
        --是词组 把XXXXXX123132123 改为显示词组 隐藏音标 隐藏单词 放大字体
        local word,count = string.gsub(self.currentWord,"|","")
        self.wordGroupLabel:setString(word)
        self.soundMark:setVisible(false)
    end

    self.options = self:createOptions(self.randWord,wordlist,self.progressBar.indexPosition())
    for i = 1, #self.options do
        backColor:addChild(self.options[i])
    end

    self.dontknow = self:createDontknow(wordlist)
    backColor:addChild(self.dontknow)

    local label_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",26)
    label_dontknow:setPosition(bigWidth/2, 220)
    label_dontknow:setColor(cc.c4b(37,158,227,255))
    backColor:addChild(label_dontknow)
end

return BlacksmithLayer