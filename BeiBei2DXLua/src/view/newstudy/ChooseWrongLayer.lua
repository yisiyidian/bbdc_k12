require("cocos.init")
require("common.global")

local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local TotalWrongWordTip = require("view.newstudy.TotalWrongWordTip")
local Button                = require("view.button.longButtonInStudy")
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")

local  ChooseWrongLayer = class("ChooseRightLayer", function ()
    return cc.Layer:create()
end)

function ChooseWrongLayer.create(word,wrongNum,wrongWordList,islandIndex)
    local layer = ChooseWrongLayer.new(word,wrongNum,wrongWordList,islandIndex)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

function ChooseWrongLayer:addNextButton(word,wrongNum,wrongWordList)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local function button_func()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        playSound(s_sound_buttonEffect)
        local SlideCoconutLayer = require("view.newstudy.SlideCoconutLayer")
        local slideCoconutLayer
        if wrongWordList == nil then
            AnalyticsFirst(ANALYTICS_FIRST_SWIPE_WORD, 'TOUCH')
            slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum)
        else
            AnalyticsFirst(ANALYTICS_FIRST_SWIPE_WORD_STRIKEWHILEHOT, 'TOUCH')
            slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum,wrongWordList,self.islandIndex)
        end
        s_SCENE:replaceGameLayer(slideCoconutLayer)
    end

    local choose_next_button = Button.create("long","blue","下一步") 
    choose_next_button:setPosition(bigWidth/2, 100)
    choose_next_button.func = function ()
        button_func()
    end

    return choose_next_button
end

function ChooseWrongLayer:ctor(word,wrongNum,wrongWordList,islandIndex)
    if islandIndex ~= nil then
        self.islandIndex = islandIndex
    end

    if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat1_2 then
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat1_2 + 1)
    end

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

    self.currentWord = word

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    
    local color 
    if wrongWordList == nil then
        color = "blue"
    else
        color = "yellow"
    end
    
    local progressBar_total_number 

    if self.islandIndex ~= nil then
        local info = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
        progressBar_total_number = #info.wrongWordList
    else
        progressBar_total_number = s_CorePlayManager.wrongWordNum
    end

    local progressBar = ProgressBar.create(progressBar_total_number, wrongNum, color)
    progressBar:setPosition(bigWidth/2+44, 1054)
    if wrongWordList ~= nil then
       backColor:addChild(progressBar,2)
    end

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)

    self.totalWrongWordTip = TotalWrongWordTip.create()
    backColor:addChild(self.totalWrongWordTip,1)
    local todayNumber = TotalWrongWordTip:getCurrentLevelWrongNum()
    
    if wrongWordList == nil then
        self.totalWrongWordTip.setNumber(todayNumber + 1)
    end

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)
    self.soundMark = soundMark


    --词组
    local wordGroupLabel =  cc.Label:createWithSystemFont("XXXXXX123132123","",50)
    wordGroupLabel:setPosition(bigWidth/2, 925)
    wordGroupLabel:setColor(cc.c4b(0,0,0,255))
    backColor:addChild(wordGroupLabel)
    self.wordGroupLabel = wordGroupLabel


    local a,b = string.find(self.currentWord, "|") 
    if a == nil then
        --不是词组 把XXXXXX123132123 改为空 音标显示
        self.wordGroupLabel:setString("")
        self.soundMark:setVisible(true)
    else
        --是词组 把XXXXXX123132123 改为显示词组 隐藏音标 隐藏单词 放大字体
        local word,count = string.gsub(self.currentWord,"|","")
        self.wordGroupLabel:setString(word)
        self.soundMark:setVisible(false)
    end

    local detailInfo = DetailInfo.create(self.wordInfo[1])
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(bigWidth/2, 520)
    backColor:addChild(detailInfo)

    self.nextButton = self:addNextButton(word,wrongNum,wrongWordList,status)
    backColor:addChild(self.nextButton)
end

return ChooseWrongLayer