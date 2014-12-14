require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.progress.ProgressBar")
local TapMat = require("view.mat.TapMat")
local SoundMark = require("view.study.SoundMark")
local WordDetailInfo = require("view.study.WordDetailInfo")
local StudyAlter = require("view.study.StudyAlter")
local TestAlter = require("view.test.TestAlter")


local StudyLayerIV = class("StudyLayerIV", function ()
    return cc.Layer:create()
end)

function StudyLayerIV.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    local layer = StudyLayerIV.new()

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local viewIndex = 1
    
    local time = 0
    local view1_time = 0
    local view2_time = 0
    local view3_time = 0
    local update = function()
        time = time + 1
        if viewIndex == 1 then
            view1_time = view1_time + 1
        elseif viewIndex == 2 then
            view2_time = view2_time + 1
            if view2_time >= 5 then
                s_CorePlayManager.unfamiliarWord()
            end
        elseif viewIndex == 3 then
            view3_time = view3_time + 1
        end
    end
    schedule(layer,update,1)

    local button_changeview
    local button_changeview_clicked
    local button_detail
    local button_detail_clicked

    local soundMark
    local wordDetailInfo
    local mat

    local label_wordmeaningSmall
    
    local meaning_y1  = 696
    local meaning_y2  = 896
    local mountain_y1 = 400
    local mountain_y2 = 770
    local mountain_y3 = 0
    local soundMark_y = -300
    local button_y    = -700
    local mat_y       = 80
    local detail_x1   = s_DESIGN_WIDTH - 120
    local detail_x2   = s_DESIGN_WIDTH + 120
    local detail_y    = 900
    
    local backColor = cc.LayerColor:create(cc.c4b(170,205,243,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    local mountain = cc.Sprite:create("image/studyscene/background1_huadanci4_mountain.png")
    mountain:ignoreAnchorPointForPosition(false)
    mountain:setAnchorPoint(0.5, 0)
    mountain:setPosition(s_DESIGN_WIDTH/2, mountain_y1)
    layer:addChild(mountain)
    
    local bigWidth = mountain:getContentSize().width
    
    local mountain_tail = cc.LayerColor:create(cc.c4b(97,137,189,255), mountain:getContentSize().width, s_DESIGN_HEIGHT)  
    mountain_tail:setAnchorPoint(0.5,1)
    mountain_tail:ignoreAnchorPointForPosition(false)  
    mountain_tail:setPosition(mountain:getContentSize().width/2, 0)
    mountain:addChild(mountain_tail)

    local progressBar = ProgressBar.create(false)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)

    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(s_DESIGN_WIDTH/2, meaning_y1)
    label_wordmeaningSmall:setScale(math.min(560/label_wordmeaningSmall:getContentSize().width, 1.5))
    layer:addChild(label_wordmeaningSmall)

    button_detail_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE.touchEventBlockLayer.lockTouch()
            if button_detail:getRotation() == 0 then
                s_CorePlayManager.unfamiliarWord()
                
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 0))
                mountain:runAction(action1)

                local action2 = cc.RotateTo:create(0.4,180)
                button_detail:runAction(action2)

                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action3, action4))
            else
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 770))
                mountain:runAction(action1)

                local action2 = cc.RotateTo:create(0.4,0)
                button_detail:runAction(action2)

                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action3, action4))
            end
        end
    end

    local success = function()
        s_SCENE.touchEventBlockLayer.lockTouch()
        progressBar.rightStyle()
        playWordSound(wordName)
        
        local changeLayer = function()
            if s_CorePlayManager.replayWrongWordState then
                if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wrongWordList then
                    s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                    s_CorePlayManager.enterStudyLayer()
                else
                    s_SCENE.touchEventBlockLayer.unlockTouch()

                    local alter = TestAlter.createFromSecondAlter(1)
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
            else
                if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wordList then
                    s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                    s_CorePlayManager.enterStudyLayer()
                else
                    s_SCENE.touchEventBlockLayer.unlockTouch()

                    local alter = StudyAlter.create(1)
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
            end
        end

        local endEffect = function()
            label_wordmeaningSmall:removeFromParent()
            wordDetailInfo:removeFromParent()
        
            local action5 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,mountain_y1))
            mountain:runAction(action5)

            local action6 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            mat:runAction(action6)

            local action7 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            button_changeview:runAction(action7)
        end

        local action1 = cc.DelayTime:create(1)
        local action2 = cc.CallFunc:create(endEffect)
        local action3 = cc.DelayTime:create(0.5)
        local action4 = cc.CallFunc:create(changeLayer)
        local action5 = cc.Sequence:create(action1,action2,action3,action4)
        layer:runAction(action5)
    end

    local fail = function()
        s_CorePlayManager.unfamiliarWord()
    end
    
    mat = TapMat.create(wordName,4,4)
    mat:setPosition(s_DESIGN_WIDTH/2*3, 80)
    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false
    layer:addChild(mat)

    button_changeview_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- button sound
            playSound(s_sound_buttonEffect)
            s_SCENE.touchEventBlockLayer.lockTouch()
            if button_changeview:getTitleText() == "去划单词" then
                button_changeview:setTitleText("再看一次")
                viewIndex = 3

                local action1 = cc.MoveTo:create(0.5,cc.p(-bigWidth/2, soundMark_y))
                soundMark:runAction(action1)

                local action2 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, mat_y))
                mat:runAction(action2)

                local action3 = cc.MoveTo:create(0.5,cc.p(detail_x2, detail_y))
                button_detail:runAction(action3)

                local action4 = cc.DelayTime:create(0.5)
                local action5 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action4, action5))
            else
                s_CorePlayManager.unfamiliarWord()
            
                button_changeview:setTitleText("去划单词")
                viewIndex = 2

                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, soundMark_y))
                soundMark:runAction(action1)

                local action2 = cc.MoveTo:create(0.5,cc.p(bigWidth/2*3, mat_y))
                mat:runAction(action2)

                local action3 = cc.MoveTo:create(0.5,cc.p(detail_x1, detail_y))
                button_detail:runAction(action3)

                local action4 = cc.DelayTime:create(0.5)
                local action5 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action4, action5))
            end
        end
    end   

    local onTouchBegan = function(touch, event)
        if viewIndex == 1 then     
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            local addWordDetailInfo = function()
                soundMark = SoundMark.create(wordName, wordSoundMarkAm, wordSoundMarkEn, 1)
                soundMark:setPosition(bigWidth/2, soundMark_y)
                mountain:addChild(soundMark)
                
                button_changeview = ccui.Button:create()
                button_changeview:setTouchEnabled(true)
                button_changeview:loadTextures("image/button/button_zhuwanfa_disnaguan_another.png", "image/button/button_zhuwanfa_disnaguan_another.png", "")
                button_changeview:setTitleText("去划单词")
                button_changeview:setTitleFontSize(30)
                button_changeview:setPosition(bigWidth/2, button_y)
                button_changeview:addTouchEventListener(button_changeview_clicked)
                mountain:addChild(button_changeview)

                button_detail = ccui.Button:create()
                button_detail:setTouchEnabled(true)
                button_detail:loadTextures("image/button/button_zhuwanfa_disnaguan.png", "image/button/button_zhuwanfa_disnaguan.png", "")
                button_detail:setPosition(cc.p(detail_x1, detail_y))
                button_detail:addTouchEventListener(button_detail_clicked)
                backColor:addChild(button_detail)

                wordDetailInfo = WordDetailInfo.create(word, 1)
                wordDetailInfo:setPosition(s_DESIGN_WIDTH/2, 0)
                backColor:addChild(wordDetailInfo)
            end

            local moveBack = function()
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, mountain_y2))
                local action2 = cc.CallFunc:create(addWordDetailInfo)
                mountain:runAction(cc.Sequence:create(action1, action2))
                viewIndex = 2

                local action3 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, meaning_y2))
                local action4 = cc.ScaleTo:create(0.5, math.min(200/label_wordmeaningSmall:getContentSize().width, 1))
                label_wordmeaningSmall:runAction(cc.Spawn:create(action3, action4))
            end
            
            local action1 = cc.CallFunc:create(moveBack)
            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            layer:runAction(cc.Sequence:create(action1, action2, action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
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

    return layer
end

return StudyLayerIV
