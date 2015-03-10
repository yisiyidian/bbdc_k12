require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  ChooseCollectWordLayer = class("ChooseCollectWordLayer", function ()
    return cc.Layer:create()
end)

local function createKnow(word,wrongNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local click_know_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local CollectUnfamiliarLayer = require("view.newstudy.CollectUnfamiliarLayer")
            local collectUnfamiliarLayer = CollectUnfamiliarLayer.create(word, wrongNum, preWordName, preWordNameState)
            s_SCENE:replaceGameLayer(collectUnfamiliarLayer)
        end
    end

    local choose_know_button = ccui.Button:create("image/newstudy/button_study_know.png","image/newstudy/button_study_know.png","")
    choose_know_button:setPosition(bigWidth/2, 245)
    choose_know_button:ignoreAnchorPointForPosition(false)
    choose_know_button:setAnchorPoint(0.5,0)
    choose_know_button:addTouchEventListener(click_know_button)

    local knowLabel = cc.Label:createWithSystemFont("太熟悉了","",30)
    knowLabel:setPosition(choose_know_button:getContentSize().width / 2, choose_know_button:getContentSize().height / 2)
    knowLabel:ignoreAnchorPointForPosition(false)
    knowLabel:setAnchorPoint(0.5,0.5)
    knowLabel:setColor(cc.c4b(58,185,224,255))
    choose_know_button:addChild(knowLabel)

    local todayNumber = LastWordAndTotalNumber:getTodayNum()
    local progressLabel = cc.Label:createWithSystemFont(todayNumber,"",38)
    progressLabel:setPosition(choose_know_button:getContentSize().width *0.8, choose_know_button:getContentSize().height / 2)
    progressLabel:ignoreAnchorPointForPosition(false)
    progressLabel:setAnchorPoint(0.5,0.5)
    progressLabel:setColor(cc.c4b(58,185,224,255))
    choose_know_button:addChild(progressLabel)
    
    return choose_know_button
end

local function createDontknow(word,wrongNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum,nil,preWordName, preWordNameState)
            s_SCENE:replaceGameLayer(chooseWrongLayer)          
        end
    end

    local choose_dontknow_button = ccui.Button:create("image/newstudy/button_study_unknow.png","image/newstudy/button_study_unknow_pressed.png","")
    choose_dontknow_button:setPosition(bigWidth/2, 400)
    choose_dontknow_button:ignoreAnchorPointForPosition(false)
    choose_dontknow_button:setAnchorPoint(0.5,0)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)

    local total_number = getMaxWrongNumEveryLevel()

    local unknowLabel = cc.Label:createWithSystemFont("不认识","",30)
    unknowLabel:setPosition(choose_dontknow_button:getContentSize().width / 2, choose_dontknow_button:getContentSize().height / 2)
    unknowLabel:ignoreAnchorPointForPosition(false)
    unknowLabel:setAnchorPoint(0.5,0.5)
    unknowLabel:setColor(cc.c4b(255,255,255,255))
    choose_dontknow_button:addChild(unknowLabel)

    local progressLabel = cc.Label:createWithSystemFont(wrongNum.."/"..total_number,"",38)
    progressLabel:setPosition(choose_dontknow_button:getContentSize().width *0.8, choose_dontknow_button:getContentSize().height / 2)
    progressLabel:ignoreAnchorPointForPosition(false)
    progressLabel:setAnchorPoint(0.5,0.5)
    progressLabel:setColor(cc.c4b(255,255,255,255))
    choose_dontknow_button:addChild(progressLabel)

    local beibei_bag = cc.Sprite:create("image/newstudy/daizi_study_unknow.png")
    beibei_bag:setPosition(choose_dontknow_button:getContentSize().width*0.125,choose_dontknow_button:getContentSize().height*0.5)
    choose_dontknow_button:addChild(beibei_bag)

    return choose_dontknow_button
end

local function createLoading(interpretation)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
  
    local circleSprite = cc.Sprite:create("image/newstudy/loading_3s_study.png")
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    layer:setContentSize(circleSprite:getContentSize().width,circleSprite:getContentSize().height)
    layer:setPosition(bigWidth/2, 615)
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(0.5,0.5)
    
    local meaningLabel = cc.Label:createWithSystemFont(interpretation,"",40)
    meaningLabel:setPosition(layer:getContentSize().width / 2, layer:getContentSize().height / 2)
    meaningLabel:ignoreAnchorPointForPosition(false)
    meaningLabel:setAnchorPoint(0.5,0.5)
    meaningLabel:setVisible(false)
    meaningLabel:setColor(cc.c4b(0,0,0,255))
    
    circleSprite:setPosition(layer:getContentSize().width / 2, layer:getContentSize().height / 2)
    circleSprite:ignoreAnchorPointForPosition(false)
    circleSprite:setAnchorPoint(0.5,0.5)
    
    layer:addChild(meaningLabel)
    layer:addChild(circleSprite)
    
    local forceToEnd = function ()
    	circleSprite:runAction(cc.FadeOut:create(0.1))
        meaningLabel:setVisible(true)
    end
    
    local function onTouchBegan(touch, event)
        return true
    end
    
    local function onTouchEnded(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(circleSprite:getBoundingBox(),location) then
        forceToEnd()
        end
    end


    local action1 = cc.RotateBy:create(3,180 * 3)
    local action2 = cc.CallFunc:create(function() forceToEnd() end)
    circleSprite:runAction(cc.Sequence:create(action1,action2))

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

function ChooseCollectWordLayer.create(wordName, wrongWordNum, preWordName, preWordNameState)
    local layer = ChooseCollectWordLayer.new(wordName, wrongWordNum, preWordName, preWordNameState)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    return layer
end

function ChooseCollectWordLayer:ctor(wordName, wrongWordNum, preWordName, preWordNameState)
    if s_CURRENT_USER.tutorialStep == s_tutorial_study then
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat1_1)
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)

    self.currentWord = wordName
    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)

    local progressBar_total_number = getMaxWrongNumEveryLevel()

    local progressBar = ProgressBar.create(progressBar_total_number, wrongWordNum, "blue")
    progressBar:setPosition(bigWidth/2+44, 1054)
    backColor:addChild(progressBar,2)

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    local todayNumber = LastWordAndTotalNumber:getTodayNum()
    self.lastWordAndTotalNumber.setNumber(todayNumber)
    if preWordName ~= nil then
        self.lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)
    
    self.circle = createLoading(self.wordInfo[5])
    backColor:addChild(self.circle) 
    
    self.iknow = createKnow(wordName,wrongWordNum, preWordName, preWordNameState)
    backColor:addChild(self.iknow)

    self.dontknow = createDontknow(wordName,wrongWordNum, preWordName, preWordNameState)
    backColor:addChild(self.dontknow)
end

return ChooseCollectWordLayer