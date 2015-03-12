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

local function createKnow(word)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local rubbish_bag
    local progressLabel
    local knowLabel
    local wordLabel
    local choose_know_button

    local function labelAnimation()
        wordLabel:setVisible(true)
        local action3 = cc.JumpTo:create(0.4,cc.p(choose_know_button:getContentSize().width*0.125,choose_know_button:getContentSize().height * 0.8),
            choose_know_button:getContentSize().height /2 + 150,1)
        local action4 = cc.ScaleTo:create(0.5,0)      
        wordLabel:runAction(cc.Sequence:create(action3))
        wordLabel:runAction(cc.Sequence:create(action4))
    end

    local function bagAnimation()
        local action5 = cc.ScaleTo:create(0.1, 1.4,0.8)
        local action6 = cc.ScaleTo:create(0.1, 1,1.3)
        local action7 = cc.ScaleTo:create(0.1, 1.4,0.8)
        local action8 = cc.ScaleTo:create(0.1, 1,1.3)
        local action9 = cc.ScaleTo:create(0.1, 1,1)
        local action = cc.Sequence:create(action5,action6,action7,action8,action9)
        rubbish_bag:runAction(action)
    end

    choose_know_button = cc.Sprite:create("image/newstudy/button_study_know.png")
    choose_know_button:ignoreAnchorPointForPosition(false)
    choose_know_button:setAnchorPoint(0.5,0.5)
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    layer:setContentSize(choose_know_button:getContentSize().width,choose_know_button:getContentSize().height)
    layer:setPosition(bigWidth/2, 245)
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(0.5,0.5)
    layer:addChild(choose_know_button)
    
    choose_know_button:setPosition(layer:getContentSize().width/2,layer:getContentSize().height/2)
    
    rubbish_bag = cc.Sprite:create("image/newstudy/button_study_know_rubbish.png")
    rubbish_bag:setPosition(choose_know_button:getContentSize().width*0.125,choose_know_button:getContentSize().height*0.5)
    choose_know_button:addChild(rubbish_bag)

    knowLabel = cc.Label:createWithSystemFont("太熟悉了","",30)
    knowLabel:enableOutline(cc.c4b(58,185,224,255),1)
    knowLabel:setPosition(choose_know_button:getContentSize().width / 2, choose_know_button:getContentSize().height / 2)
    knowLabel:ignoreAnchorPointForPosition(false)
    knowLabel:setAnchorPoint(0.5,0.5)
    knowLabel:setColor(cc.c4b(58,185,224,255))
    choose_know_button:addChild(knowLabel)

    local todayNumber = LastWordAndTotalNumber:getCurrentLevelRightNum()
    progressLabel = cc.Label:createWithSystemFont(todayNumber,"",38)
    progressLabel:setPosition(choose_know_button:getContentSize().width *0.8, choose_know_button:getContentSize().height / 2)
    progressLabel:ignoreAnchorPointForPosition(false)
    progressLabel:setAnchorPoint(0.5,0.5)
    progressLabel:enableOutline(cc.c4b(58,185,224,255),1)
    progressLabel:setColor(cc.c4b(58,185,224,255))
    choose_know_button:addChild(progressLabel)

    wordLabel = cc.Label:createWithTTF(word,'font/CenturyGothic.ttf',64)
    wordLabel:setColor(cc.c4b(31,68,102,255))
    wordLabel:setPosition(choose_know_button:getContentSize().width /2 ,choose_know_button:getContentSize().height /2 + 630)
    choose_know_button:addChild(wordLabel)
    wordLabel:setVisible(false)
    
    local function onTouchBegan(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(choose_know_button:getBoundingBox(),location) then
            playSound(s_sound_buttonEffect)  
            rubbish_bag:setTexture("image/newstudy/button_study_know_rubbish_pressed.png")  
            choose_know_button:setTexture("image/newstudy/button_study_know_pressed.png")   
            knowLabel:setColor(cc.c4b(127,239,255,255))
            progressLabel:setColor(cc.c4b(127,239,255,255))
            knowLabel:enableOutline(cc.c4b(127,239,255,255),1)
            progressLabel:enableOutline(cc.c4b(127,239,255,255),1)
        end
        return true
    end

    local function onTouchEnded(touch, event)            
        choose_know_button:setTexture("image/newstudy/button_study_know.png")  
        rubbish_bag:setTexture("image/newstudy/button_study_know_rubbish.png")
        knowLabel:setColor(cc.c4b(58,185,224,255))
        progressLabel:setColor(cc.c4b(58,185,224,255))
        progressLabel:enableOutline(cc.c4b(58,185,224,255),1)
        knowLabel:enableOutline(cc.c4b(58,185,224,255),1)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(choose_know_button:getBoundingBox(),location) then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local action1 = cc.DelayTime:create(0.35) 
            local action2 = cc.DelayTime:create(1)
            choose_know_button:runAction(cc.Sequence:create(cc.CallFunc:create(function ()
                labelAnimation()
            end),
            action1,
            cc.CallFunc:create(function ()
                bagAnimation()
            end),
            action2,
            cc.CallFunc:create(function ()
                s_CorePlayManager.leaveStudyModel(true)
            end)))  
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer
end

local function createDontknow(word,wrongNum)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local beibei_bag
    local wordLabel
    local progressLabel
    local choose_dontknow_button
    local lightSprite
    local total_number = getMaxWrongNumEveryLevel()

    local function labelAnimation()
        wordLabel:setVisible(true)
        local action3 = cc.JumpTo:create(0.4,cc.p(choose_dontknow_button:getContentSize().width*0.125,choose_dontknow_button:getContentSize().height * 0.8),
            choose_dontknow_button:getContentSize().height /2 + 150,1)
        local action4 = cc.ScaleTo:create(0.5,0)      
        wordLabel:runAction(cc.Sequence:create(action3))
        wordLabel:runAction(cc.Sequence:create(action4))
    end

    local function bagAnimation()
        local action10 = cc.MoveBy:create(0.05, cc.p(0,-5))
        local action5 = cc.ScaleTo:create(0.1, 1.6,0.8)
        local action6 = cc.ScaleTo:create(0.1, 1,1.4)
        local action7 = cc.ScaleTo:create(0.1, 1.1,0.8)
        local action8 = cc.ScaleTo:create(0.1, 1,1.1)
        local action11 = cc.MoveBy:create(0.05, cc.p(0,5))
        local action9 = cc.ScaleTo:create(0.1, 1,1)
        local action = cc.Sequence:create(action10,action5,action6,action7,action8,action11,action9)
        beibei_bag:runAction(action)
    end

    local function progressAnimation()
        local action5 = cc.ScaleTo:create(0.2, 1.5)
        local action6 = cc.ScaleTo:create(0.2, 1)
        local action7 = cc.Sequence:create(action5, action6)
        progressLabel:runAction(action7)
        progressLabel:setString((wrongNum+1).." / "..total_number)  
        
        local action8 = cc.ScaleTo:create(0.2,3)
        local action9 = cc.ScaleTo:create(0.2,0)
        local action10 = cc.FadeOut:create(0.4)
        local action  = cc.Sequence:create(action8,action9)
        lightSprite:runAction(action)   
        lightSprite:runAction(action10)   
    end
    
    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local action1 = cc.DelayTime:create(0.25) 
            local action2 = cc.DelayTime:create(1)
            local action3 = cc.DelayTime:create(1) 
            sender:runAction(cc.Sequence:create(cc.CallFunc:create(function ()
                labelAnimation()
            end),
            action1,
            cc.CallFunc:create(function ()
                bagAnimation()
            end),
            action2,
            cc.CallFunc:create(function ()
                progressAnimation()
            end),
            action3,
            cc.CallFunc:create(function ()
                local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
                local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum)
                s_SCENE:replaceGameLayer(chooseWrongLayer) 
            end)))         
        end
    end

    choose_dontknow_button = ccui.Button:create("image/newstudy/button_study_unknow.png","image/newstudy/button_study_unknow_pressed.png","")
    choose_dontknow_button:setPosition(bigWidth/2, 400)
    choose_dontknow_button:ignoreAnchorPointForPosition(false)
    choose_dontknow_button:setAnchorPoint(0.5,0)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)

    local unknowLabel = cc.Label:createWithSystemFont("不认识","",30)
    unknowLabel:enableOutline(cc.c4b(255,255,255,255),1)
    unknowLabel:setPosition(choose_dontknow_button:getContentSize().width / 2, choose_dontknow_button:getContentSize().height / 2)
    unknowLabel:ignoreAnchorPointForPosition(false)
    unknowLabel:setAnchorPoint(0.5,0.5)
    unknowLabel:setColor(cc.c4b(255,255,255,255))
    choose_dontknow_button:addChild(unknowLabel)
    
    lightSprite = cc.Sprite:create("image/newstudy/liangguang_study.png")
    lightSprite:setPosition(choose_dontknow_button:getContentSize().width *0.8, choose_dontknow_button:getContentSize().height / 2)
    lightSprite:ignoreAnchorPointForPosition(false)
    lightSprite:setAnchorPoint(0.5,0.5)
    lightSprite:setScale(0)
    choose_dontknow_button:addChild(lightSprite)
    
    progressLabel = cc.Label:createWithSystemFont(wrongNum.." / "..total_number,"",38)
    progressLabel:setPosition(choose_dontknow_button:getContentSize().width *0.8, choose_dontknow_button:getContentSize().height / 2)
    progressLabel:ignoreAnchorPointForPosition(false)
    progressLabel:setAnchorPoint(0.5,0.5)
    progressLabel:setColor(cc.c4b(255,255,255,255))
    progressLabel:enableOutline(cc.c4b(255,255,255,255),1)
    choose_dontknow_button:addChild(progressLabel)

    beibei_bag = cc.Sprite:create("image/newstudy/daizi_study_unknow.png")
    beibei_bag:setPosition(choose_dontknow_button:getContentSize().width*0.125,choose_dontknow_button:getContentSize().height*0.5)
    choose_dontknow_button:addChild(beibei_bag)

    wordLabel = cc.Label:createWithTTF(word,'font/CenturyGothic.ttf',64)
    wordLabel:setColor(cc.c4b(31,68,102,255))
    wordLabel:setPosition(choose_dontknow_button:getContentSize().width /2 ,choose_dontknow_button:getContentSize().height /2 + 475)
    choose_dontknow_button:addChild(wordLabel)
    wordLabel:setVisible(false)
 
    return choose_dontknow_button
end

local function createLoading(interpretation)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
  
    local circleSprite = cc.Sprite:create("image/newstudy/loading_3s_study.png")
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    layer:setContentSize(circleSprite:getContentSize().width,circleSprite:getContentSize().height)
    layer:setPosition(bigWidth/2, 660)
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

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)

    if preWordName ~= nil then
        self.lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)
    
    self.circle = createLoading(self.wordInfo[5])
    backColor:addChild(self.circle) 
    
    self.iknow = createKnow(wordName)
    backColor:addChild(self.iknow)

    self.dontknow = createDontknow(wordName,wrongWordNum)
    backColor:addChild(self.dontknow)
end

return ChooseCollectWordLayer