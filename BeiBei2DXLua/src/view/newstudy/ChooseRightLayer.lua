require("cocos.init")
require("common.global")

local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  ChooseRightLayer = class("ChooseRightLayer", function ()
    return cc.Layer:create()
end)

function ChooseRightLayer.create()
    local layer = ChooseRightLayer.new()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function addStudyButton()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_study_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            print("study")
        end
    end

    local choose_study_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_study_button:setPosition(bigWidth/2-151, 153)
    choose_study_button:setTitleText("依然复习")
    choose_study_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_study_button:setTitleFontSize(32)
    choose_study_button:addTouchEventListener(click_study_button)
    return choose_study_button
end

local function addNextButton()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            print("next")
        end
    end

    local choose_next_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_next_button:setPosition(bigWidth/2+151, 153)
    choose_next_button:setTitleText("太简单了")
    choose_next_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_next_button:setTitleFontSize(32)
    choose_next_button:addTouchEventListener(click_next_button)
    return choose_next_button
end

function ChooseRightLayer:ctor()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
	
    self.currentWord = "apple"
    self.currentList = {"apple","banana","cat","dog","egg","floor"}

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    
    local progressBar = ProgressBar.create(#self.currentList, 0, "yellow")
    progressBar:setPosition(bigWidth/2+44, 1049)
    backColor:addChild(progressBar)
    
    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    self.lastWordAndTotalNumber.setNumber(9999)
    self.lastWordAndTotalNumber.setWord("apple",true)
    
    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)

    local detailInfo = DetailInfo.create(self.wordInfo[1])
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(bigWidth/2, 520)
    backColor:addChild(detailInfo)
    
    self.studyButton = addStudyButton()
    backColor:addChild(self.studyButton)
    
    self.nextButton = addNextButton()
    backColor:addChild(self.nextButton)
end

return ChooseRightLayer