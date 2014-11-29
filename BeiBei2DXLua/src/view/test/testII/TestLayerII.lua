require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.progress.ProgressBar")
local TapMat = require("view.mat.TapMat")
local TestAlter = require("view.test.TestAlter")


local TestLayerII = class("TestLayerII", function ()
    return cc.Layer:create()
end)

function TestLayerII.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    local layer = TestLayerII.new()
    
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

    local bigWidth
    
    local screenWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local mat
    local playOver = false

    local back = cc.Sprite:create("image/studyscene/studyII_back.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(back)
    bigWidth = back:getContentSize().width

    local back_bigchair = cc.Sprite:create("image/studyscene/studyII_back_bigchair.png")
    back_bigchair:setAnchorPoint(0.5,0)
    back_bigchair:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(back_bigchair)

    local back_smallchair = cc.Sprite:create("image/studyscene/studyII_back_smallchair.png")
    back_smallchair:setAnchorPoint(0.5,0)
    back_smallchair:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(back_smallchair)
    
    local progressBar = ProgressBar.create(true)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)

    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(s_DESIGN_WIDTH/2, 920)
    layer:addChild(label_wordmeaningSmall)

    local success = function()
        playOver = true
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

        s_CorePlayManager.answerRight()
        progressBar.rightStyle()

        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
        showAnswerStateBack:setPosition(-s_DESIGN_WIDTH/2, 768)
        layer:addChild(showAnswerStateBack)

        local action = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 768))
        showAnswerStateBack:runAction(action)

        local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
        sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
        showAnswerStateBack:addChild(sign)

        local right_wordname = cc.Label:createWithSystemFont(word.wordName,"",60)
        right_wordname:setColor(cc.c4b(130,186,47,255))
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

        local action1 = cc.DelayTime:create(1)
        local action2 = cc.CallFunc:create(changeLayer)
        local action3 = cc.Sequence:create(action1,action2)
        layer:runAction(action3) 
    end

    local fail = function()
        s_CorePlayManager.unfamiliarWord()
    end

    mat = TapMat.create(wordName,4,4)
    mat:setPosition(s_DESIGN_WIDTH/2, 80)
    layer:addChild(mat)

    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false
    
    local timeOut = function()
        playOver = true
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

        progressBar.wrongStyle()
        s_CorePlayManager.unfamiliarWord()

        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_wrong_back.png")
        showAnswerStateBack:setPosition(s_DESIGN_WIDTH/2*3, 768)
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

        local action1 = cc.DelayTime:create(1)
        local action2 = cc.CallFunc:create(changeLayer)
        local action3 = cc.Sequence:create(action1,action2)
        layer:runAction(action3) 
    end
    
    if s_CorePlayManager.currentWordIndex == 1 then
        local readygo = sp.SkeletonAnimation:create("res/spine/readygo_diyiguan.json", "res/spine/readygo_diyiguan.atlas", 1)
        readygo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
        layer:addChild(readygo)
        readygo:addAnimation(0, 'animation', false)
        
        -- ready go "s_sound_ReadyGo"
        playSound(s_sound_ReadyGo)
    end
    
    local progress_back = cc.Sprite:create("image/progress/progressB1.png")
    progress_back:setPosition(s_DESIGN_WIDTH/2, 100)
    layer:addChild(progress_back)
    
    local progress = cc.ProgressTimer:create(cc.Sprite:create("image/progress/progressF1.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(100)
    layer:addChild(progress)
    
    local button_donotknow = nil

    local button_donotknow_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            timeOut()   
            -- button sound
            playSound(s_sound_buttonEffect)
        end
    end

    local time = 0
    local update = function()
        --time = time + 0.05

        if playOver == false then
            local loss = 5.0/(15+0.5*string.len(s_CorePlayManager.currentWord.wordName))
            --local loss = 5.0/5
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
                    button_donotknow:setPosition(screenWidth+button_donotknow:getContentSize().width,910)
                    button_donotknow:addTouchEventListener(button_donotknow_clicked)
                    back:addChild(button_donotknow)
                    
                    local action = cc.MoveTo:create(0.5,cc.p(screenWidth,910))
                    button_donotknow:runAction(action)
                end
            end
        end
    end

    schedule(layer,update,0.05)
    

    return layer
end

return TestLayerII
