require("cocos.init")
require("common.global")

local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  ChooseWrongLayer = class("ChooseRightLayer", function ()
    return cc.Layer:create()
end)

function ChooseWrongLayer.create(word,wrongNum)
    local layer = ChooseWrongLayer.new(word,wrongNum)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function addNextButton(word,wrongNum)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            print("word6 =="..word)
            print("wrongNum"..wrongNum)
            local SlideCoconutLayer = require("view.newstudy.SlideCoconutLayer")
            local slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum)
            s_SCENE:replaceGameLayer(slideCoconutLayer)
        end
    end

    local choose_next_button = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    choose_next_button:setPosition(bigWidth/2, 153)
    choose_next_button:setTitleText("下一步")
    choose_next_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_next_button:setTitleFontSize(32)
    choose_next_button:addTouchEventListener(click_next_button)  
    return choose_next_button
end

function ChooseWrongLayer:ctor(word,wrongNum)
    print("word5 =="..word)
    print("wrongNum"..wrongNum)
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

    self.nextButton = addNextButton(word,wrongNum)
    backColor:addChild(self.nextButton)
end

return ChooseWrongLayer