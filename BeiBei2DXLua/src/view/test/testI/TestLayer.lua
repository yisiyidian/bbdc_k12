require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.progress.ProgressBar")
local FlipMat = require("view.mat.FlipMat")
local StudyAlter = require("view.study.StudyAlter")
local TestAlter = require("view.test.TestAlter")

local TestLayer = class("TestLayer", function ()
    return cc.Layer:create()
end)


function TestLayer.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
   
    local layer = TestLayer.new()
    
    --add pause button
    local pauseBtn = ccui.Button:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    layer:addChild(pauseBtn,100)
    local Pause = require('view.Pause')
    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer:addChild(pauseLayer)
            s_SCENE.popupLayer.listener:setSwallowTouches(true)

            --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local  bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local button_changeview
    local button_changeview_clicked
    local button_detail
    local button_detail_clicked
    
    local mat
    local progress_back
    
    local playOver = false
    
    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(s_DESIGN_WIDTH/2, 896)
    layer:addChild(label_wordmeaningSmall)
    
    local cloud_up_y1   = 936
    local cloud_up_y2   = 1014
    local cloud_down_y1 = 900
    local cloud_down_y2 = 771

    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:ignoreAnchorPointForPosition(false)
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(s_DESIGN_WIDTH/2, cloud_up_y1)
    layer:addChild(cloud_up)

    local cloud_up_tail = cc.LayerColor:create(cc.c4b(38,158,220,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    cloud_up_tail:setAnchorPoint(0.5,0)
    cloud_up_tail:ignoreAnchorPointForPosition(false)  
    cloud_up_tail:setPosition(cloud_up:getContentSize().width/2,cloud_up:getContentSize().height)
    cloud_up:addChild(cloud_up_tail)
    
    local cloud_down = cc.Sprite:create("image/studyscene/studyscene_cloud_white_down.png")
    cloud_down:ignoreAnchorPointForPosition(false)
    cloud_down:setAnchorPoint(0.5, 0)
    cloud_down:setPosition(s_DESIGN_WIDTH/2, cloud_down_y1)
    layer:addChild(cloud_down)
    
    local cloud_down_tail = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    cloud_down_tail:setAnchorPoint(0.5,1)
    cloud_down_tail:ignoreAnchorPointForPosition(false)  
    cloud_down_tail:setPosition(cloud_up:getContentSize().width/2,0)
    cloud_down:addChild(cloud_down_tail)
    
    local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, cloud_up_y2))
    local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, cloud_down_y2))
    cloud_up:runAction(action1)
    cloud_down:runAction(action2)

    local beach = cc.Sprite:create("image/studyscene/studyscene_beach_down.png")
    beach:ignoreAnchorPointForPosition(false)
    beach:setAnchorPoint(0.5, 0)
    beach:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(beach)

    local size_big = cloud_down:getContentSize()

    local progressBar = ProgressBar.create(true)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)
    
    local success = function()
        playOver = true
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        
        s_CorePlayManager.answerRight()
        progressBar.rightStyle()
    
        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
        showAnswerStateBack:setPosition(s_DESIGN_WIDTH/2-bigWidth, 768)
        layer:addChild(showAnswerStateBack)
        
        local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
        sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
        showAnswerStateBack:addChild(sign)

        local right_wordname = cc.Label:createWithSystemFont(word.wordName,"",60)
        right_wordname:setColor(cc.c4b(130,186,47,255))
        right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
        right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
        showAnswerStateBack:addChild(right_wordname)
        
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 768))
        showAnswerStateBack:runAction(action1)
        
        local changeLayer = function()
            if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wordList then
                s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                s_CorePlayManager.enterTestLayer()
            else
                s_SCENE.touchEventBlockLayer.unlockTouch()

                local alter = TestAlter.createFromFirstAlter()
                alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                layer:addChild(alter)
            end
        end
        
        local endEffect = function()
            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, cloud_up_y1))
            cloud_up:runAction(action1)
            
            local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, cloud_down_y1))
            cloud_down:runAction(action2)
            
            local action3 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2+bigWidth, 768))
            showAnswerStateBack:runAction(action3)
            
            local action4 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            mat:runAction(action4)
            
            local action5 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            local action6 = cc.CallFunc:create(changeLayer)
            progress_back:runAction(cc.Sequence:create(action5,action6))
        end

        local action2 = cc.DelayTime:create(1)
        local action3 = cc.CallFunc:create(endEffect)
        layer:runAction(cc.Sequence:create(action2, action3))
    end

    local fail = function()   
        s_CorePlayManager.unfamiliarWord()
    end
    
    local timeOut = function()
        playOver = true
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

        progressBar.wrongStyle()
        s_CorePlayManager.unfamiliarWord()
        
        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_wrong_back.png")
        showAnswerStateBack:setPosition(s_DESIGN_WIDTH/2+bigWidth, 768)
        layer:addChild(showAnswerStateBack)
        
        local action = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 768))
        showAnswerStateBack:runAction(action)
        
        local sign = cc.Sprite:create("image/testscene/testscene_wrong_x.png")
        sign:setPosition(showAnswerStateBack:getContentSize().width*0.1, showAnswerStateBack:getContentSize().height*0.45)
        showAnswerStateBack:addChild(sign)
        
        local right_wordname = cc.Label:createWithSystemFont(word.wordName,"",60)
        right_wordname:setColor(cc.c4b(202,66,64,255))
        right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
        right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
        showAnswerStateBack:addChild(right_wordname)
        
        local changeLayer = function()
            if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wordList then
                s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                s_CorePlayManager.enterTestLayer()
            else
                s_SCENE.touchEventBlockLayer.unlockTouch()
                
                local alter = TestAlter.createFromFirstAlter()
                alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                layer:addChild(alter)
            end
        end
        
        local endEffect = function()
            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, cloud_up_y1))
            cloud_up:runAction(action1)

            local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, cloud_down_y1))
            cloud_down:runAction(action2)

            local action3 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2-bigWidth, 768))
            showAnswerStateBack:runAction(action3)

            local action4 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            mat:runAction(action4)

            local action5 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            local action6 = cc.CallFunc:create(changeLayer)
            progress_back:runAction(cc.Sequence:create(action5,action6))
        end

        local action1 = cc.DelayTime:create(1)
        local action2 = cc.CallFunc:create(endEffect)
        local action3 = cc.Sequence:create(action1,action2)
        layer:runAction(action3) 
    end

    mat = FlipMat.create(wordName,4,4,false,false)
    mat:setPosition(s_DESIGN_WIDTH/2, 100)
    layer:addChild(mat)

    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false

    progress_back = cc.Sprite:create("image/progress/progressB1.png")
    progress_back:setPosition(s_DESIGN_WIDTH/2, 100)
    layer:addChild(progress_back)
    
    local progress = cc.ProgressTimer:create(cc.Sprite:create("image/progress/progressF1.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getContentSize().width/2, progress_back:getContentSize().height/2)
    progress:setPercentage(100)
    progress_back:addChild(progress)
    
    
    if s_CorePlayManager.currentWordIndex == 1 then
        local readygo = sp.SkeletonAnimation:create("res/spine/readygo_diyiguan.json", "res/spine/readygo_diyiguan.atlas", 1)
        readygo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
        layer:addChild(readygo)
        readygo:addAnimation(0, 'animation', false)
        
        -- ready go "s_sound_ReadyGo"
        playSound(s_sound_ReadyGo)
    end
    
    local button_donotknow_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            timeOut()   
        end
    end
    
    
    local button_donotknow = nil

    local time = 0
    local update = function()    
        if playOver == false then
            local loss = 5.0/(15+0.5*string.len(s_CorePlayManager.currentWord.wordName))
            local current_percentage = progress:getPercentage()
            current_percentage = current_percentage - loss
            if current_percentage > 0 then
                progress:setPercentage(current_percentage)
            else
                progress:setPercentage(0)
                if mat.globalLock == false then
                    mat.globalLock = true
                    timeOut()
                end
            end
            
            if current_percentage <= 90 then
                if button_donotknow == nil then
                    button_donotknow = ccui.Button:create("image/testscene/testscene_donotkonw.png","","")
                    button_donotknow:setAnchorPoint(1,0.5)
                    button_donotknow:setPosition(bigWidth+button_donotknow:getContentSize().width,910)
                    button_donotknow:addTouchEventListener(button_donotknow_clicked)
                    backColor:addChild(button_donotknow)

                    local action = cc.MoveTo:create(0.5,cc.p(bigWidth,910))
                    button_donotknow:runAction(action)
                end
            end
        end
    end
    
    schedule(layer,update,0.05)
     
    return layer
end

return TestLayer
