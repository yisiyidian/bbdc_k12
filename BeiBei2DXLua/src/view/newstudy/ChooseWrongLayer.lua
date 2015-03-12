require("cocos.init")
require("common.global")

local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local TotalWrongWordTip = require("view.newstudy.TotalWrongWordTip")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  ChooseWrongLayer = class("ChooseRightLayer", function ()
    return cc.Layer:create()
end)

function ChooseWrongLayer.create(word,wrongNum,wrongWordList)
    local layer = ChooseWrongLayer.new(word,wrongNum,wrongWordList)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function addNextButton(word,wrongNum,wrongWordList)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local SlideCoconutLayer = require("view.newstudy.SlideCoconutLayer")
            local slideCoconutLayer
            if wrongWordList == nil then
                AnalyticsFirst(ANALYTICS_FIRST_SWIPE_WORD, 'TOUCH')
                slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum)
            else
                AnalyticsFirst(ANALYTICS_FIRST_SWIPE_WORD_STRIKEWHILEHOT, 'TOUCH')
                slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum,wrongWordList)
            end

            s_SCENE:replaceGameLayer(slideCoconutLayer)
        end
    end

    local choose_next_button = Button.create("下一步")
    choose_next_button:setPosition(bigWidth/2, 100)
    choose_next_button:addTouchEventListener(click_next_button)  

    return choose_next_button
end

function ChooseWrongLayer:ctor(word,wrongNum,wrongWordList)
    if s_CURRENT_USER.tutorialStep == s_tutorial_study then
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat1_2)
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(45) 
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
    
    local progressBar_total_number = getMaxWrongNumEveryLevel()

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

    local detailInfo = DetailInfo.create(self.wordInfo[1])
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(bigWidth/2, 520)
    backColor:addChild(detailInfo)

    self.nextButton = addNextButton(word,wrongNum,wrongWordList)
    backColor:addChild(self.nextButton)
end

return ChooseWrongLayer