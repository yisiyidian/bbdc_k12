require("cocos.init")
require("common.global")

local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  ChooseWrongLayer = class("ChooseRightLayer", function ()
    return cc.Layer:create()
end)

CreateWrongLayer_From_CollectWord = 1
CreateWrongLayer_From_Iron = 2

function ChooseWrongLayer.create(word,wrongNum,preWordName, preWordNameState,fromWhere,wrongWordList)
    local layer = ChooseWrongLayer.new(word,wrongNum,wrongWordList)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function addNextButton(word,wrongNum,preWordName, preWordNameState,fromWhere,wrongWordList)
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
                slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum,preWordName, preWordNameState,fromWhere,wrongWordList)
            else
                AnalyticsFirst(ANALYTICS_FIRST_SWIPE_WORD_STRIKEWHILEHOT, 'TOUCH')
                slideCoconutLayer = SlideCoconutLayer.create(word,wrongNum,preWordName, preWordNameState,fromWhere,wrongWordList)
            end

            s_SCENE:replaceGameLayer(slideCoconutLayer)
        end
    end

    local choose_next_button = Button.create("下一步")
    choose_next_button:setPosition(bigWidth/2, 100)
    choose_next_button:addTouchEventListener(click_next_button)  

    return choose_next_button
end

function ChooseWrongLayer:ctor(word,wrongNum,preWordName, preWordNameState,fromWhere,wrongWordList)

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

    local progressBar_total_number 

    if s_CURRENT_USER.islandIndex == 0 then
        progressBar_total_number = s_max_wrong_num_first_island
    else
        progressBar_total_number = s_max_wrong_num_everyday
    end

    local progressBar = ProgressBar.create(progressBar_total_number, wrongNum, color)
    progressBar:setPosition(bigWidth/2+44, 1049)
    backColor:addChild(progressBar,2)

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    local todayNumber = LastWordAndTotalNumber:getCurrentLevelNum()
    self.lastWordAndTotalNumber.setNumber(todayNumber)
    if wrongNum ~= 0  and preWordName ~= nil and wrongWordList == nil then
    self.lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 925)  
    backColor:addChild(soundMark)

    local detailInfo = DetailInfo.create(self.wordInfo[1])
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(bigWidth/2, 520)
    backColor:addChild(detailInfo)

    self.nextButton = addNextButton(word,wrongNum,wrongWordList,preWordName, preWordNameState)
    backColor:addChild(self.nextButton)
end

return ChooseWrongLayer