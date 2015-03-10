require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  SlideCoconutLayer = class("SlideCoconutLayer", function ()
    return cc.Layer:create()
end)

function SlideCoconutLayer.create(word,wrongNum,wrongWordList,preWordName, preWordNameState)
    local layer = SlideCoconutLayer.new(word,wrongNum,wrongWordList)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function createRefreshButton()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_refresh_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            mat.forceFail()
        end
    end

    local refreshButton = ccui.Button:create("image/newstudy/refreshbegin.png","image/newstudy/refreshend.png","")
    refreshButton:setPosition(bigWidth * 0.9, 800)
    refreshButton:addTouchEventListener(click_refresh_button)
    return refreshButton  
end

local function createLastButton(word,wrongNum,wrongWordList,preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_before_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer 
            AnalyticsStudyLookBackWord()
            if wrongWordList == nil then
                chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum,nil,preWordName, preWordNameState)
            else
                chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum,wrongWordList)
            end
            s_SCENE:replaceGameLayer(chooseWrongLayer)  
        end
    end

    local choose_before_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_before_button:setPosition(bigWidth/2, 153)
    choose_before_button:setTitleText("偷看一眼")
    choose_before_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_before_button:setTitleFontSize(32)
    choose_before_button:addTouchEventListener(click_before_button)
    return choose_before_button  
end

function SlideCoconutLayer:ctor(word,wrongNum,wrongWordList,preWordName, preWordNameState)
    if s_CURRENT_USER.tutorialStep == s_tutorial_study then
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat1_3)
    end
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local isCollectLayer = true

    local backColor = BackLayer.create(97) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.currentWord = word

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    
    local color 
    if wrongWordList == nil then
        color = "blue"
    else
        color = "yellow"
    end
    
    local progressBar_total_number 

    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if #bossList == 1 then
        progressBar_total_number = 3
    else
        progressBar_total_number = s_max_wrong_num_everyday
    end

    self.progressBar = ProgressBar.create(progressBar_total_number, wrongNum, color)
    self.progressBar:setPosition(bigWidth/2+44, 1054)
    backColor:addChild(self.progressBar)

    
    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    local todayNumber = LastWordAndTotalNumber:getTodayNum()
    self.lastWordAndTotalNumber.setNumber(todayNumber)
    if wrongNum ~= 0  and preWordName ~= nil and wrongWordList == nil then
    self.lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end
    
    local word_meaning_label = cc.Label:createWithSystemFont(self.wordInfo[5],"",50)
    word_meaning_label:setPosition(bigWidth/2, 950)
    word_meaning_label:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(word_meaning_label)
    
    local size_big = backColor:getContentSize()
    local isNewPlayer = true
    if s_CURRENT_USER.slideNum == 1  then
        isNewPlayer = true
    else
        isNewPlayer = false
    end
    if wrongWordList ~= nil then
        mat = FlipMat.create(self.wordInfo[2],4,4,isNewPlayer,"coconut_light")
    else
        mat = FlipMat.create(self.wordInfo[2],4,4,isNewPlayer,"coconut_light",self.progressBar.indexPosition())
    end
    mat:setPosition(size_big.width/2, 160)
    backColor:addChild(mat)
    
    local success = function()
        playWordSound(self.currentWord) 
        local normal = function()  
            if s_CURRENT_USER.tutorialStep == s_tutorial_study then
               s_CURRENT_USER:setTutorialStep(s_tutorial_study + 1)
               s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_summary_boss)
            end
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
            showAnswerStateBack:setPosition(backColor:getContentSize().width *1.5, 768)
            showAnswerStateBack:ignoreAnchorPointForPosition(false)
            showAnswerStateBack:setAnchorPoint(0.5,0.5)
            backColor:addChild(showAnswerStateBack)

            local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
            sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
            showAnswerStateBack:addChild(sign)

            local right_wordname = cc.Label:createWithSystemFont(self.currentWord,"",60)
            right_wordname:setColor(cc.c4b(130,186,47,255))
            right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
            right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
            showAnswerStateBack:addChild(right_wordname)

            local action1 = cc.MoveTo:create(0.2,cc.p(backColor:getContentSize().width /2, 768))
            showAnswerStateBack:runAction(action1)

            self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()  
                if wrongWordList == nil then
                    if wrongNum == progressBar_total_number - 1 then
                        s_CURRENT_USER:addBeans(s_CURRENT_USER.beanRewardForCollect)
                        saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                        print('logInDatas')
                        print_lua_table(s_CURRENT_USER.logInDatas)
                        print('isCheckIn')
                        -- print(s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey))
                        if #s_CURRENT_USER.logInDatas > 0 and s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) then
                            s_CorePlayManager.leaveStudyModel(false)
                        else
                            local missionCompleteCircle = require('view.MissionCompleteCircle').create()
                            s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),cc.CallFunc:create(function ()
                                s_CorePlayManager.leaveStudyModel(false)    
                            end,{})))
                        end
                    else
                        s_CorePlayManager.leaveStudyModel(false)
                    end
                    
                           
                else
                    if wrongWordList[1] ~= nil then
                        local temp = wrongWordList[1]
                        table.insert(wrongWordList,temp)
                        table.remove(wrongWordList,1)
                    end                                   

                    local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
                    local blacksmithLayer = BlacksmithLayer.create(wrongWordList)
                    s_SCENE:replaceGameLayer(blacksmithLayer)
                end
            end)))
        end

        if s_CURRENT_USER.slideNum == 1 then
            local guideAlter = GuideAlter.create(0, "划词加强记忆", "用来加强用户记忆的步骤，可以强化你对生词的印象。")
            guideAlter:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2)
            s_SCENE:popup(guideAlter)

            guideAlter.know = function()
                s_CURRENT_USER.slideNum = 0
                saveUserToServer({['slideNum'] = s_CURRENT_USER.slideNum})
                normal()
            end
        else
            normal()
        end

    end
    
    mat.success = success
    mat.rightLock = true
    mat.wrongLock = false
    
    self.refreshButton = createRefreshButton()
    backColor:addChild(self.refreshButton)
    
    self.lastButton = createLastButton(word,wrongNum,wrongWordList,preWordName, preWordNameState)
    backColor:addChild(self.lastButton)
end

return SlideCoconutLayer