require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.progress.ProgressBar")
local FlipMat = require("view.mat.FlipMat")
local SoundMark = require("view.study.SoundMark")
local WordDetailInfo = require("view.study.WordDetailInfo")
local StudyAlter = require("view.study.StudyAlter")
local TestAlter = require("view.test.TestAlter")


local StudyLayerIII = class("StudyLayerIII", function ()
    return cc.Layer:create()
end)


function StudyLayerIII.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    local layer = StudyLayerIII.new()

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local viewIndex = 1

    local button_changeview
    local button_changeview_clicked
    local button_detail
    local button_detail_clicked

    local soundMark
    local mat

    local fingerClick
    local newplayerHintBack
    local label_wordmeaningSmall
    local guideOver = false

    local backImage = cc.Sprite:create("image/studyscene/background_zhuwanfa_disnaguan.png") 
    backImage:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backImage)
    
    local bigWidth = backImage:getContentSize().width

    local back_up = cc.Sprite:create("image/studyscene/frontground_zhuwanfa_disnaguan.png")
    back_up:ignoreAnchorPointForPosition(false)
    back_up:setAnchorPoint(0.5, 1)
    back_up:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT)
    layer:addChild(back_up)

    local back_down = cc.Sprite:create("image/studyscene/frongground_zhuwanfa_disanguan_green.png")
    back_down:ignoreAnchorPointForPosition(false)
    back_down:setAnchorPoint(0.5, 0)
    back_down:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(back_down)

    local money1 = cc.Sprite:create("image/studyscene/frongground_zhuwanfa_disanguan_money1.png")
    money1:ignoreAnchorPointForPosition(false)
    money1:setAnchorPoint(0, 0)
    money1:setPosition(-(bigWidth-s_DESIGN_WIDTH)/2, 0)
    layer:addChild(money1)
    
    local money2 = cc.Sprite:create("image/studyscene/frongground_zhuwanfa_disanguan_money2.png")
    money2:ignoreAnchorPointForPosition(false)
    money2:setAnchorPoint(1, 0)
    money2:setPosition(bigWidth-(bigWidth-s_DESIGN_WIDTH)/2, 0)
    layer:addChild(money2)

--    local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 1014))
--    local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 360))
--    local action3 = cc.CallFunc:create(newPlayerGuideInit)
--
--    back_up:runAction(action1)
--    back_down:runAction(cc.Sequence:create(action2, action3))

    local progressBar = ProgressBar.create(false)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)

    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(s_DESIGN_WIDTH/2, 696)
    label_wordmeaningSmall:setScale(math.min(560/label_wordmeaningSmall:getContentSize().width, 1.5))
    layer:addChild(label_wordmeaningSmall)

    button_detail_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_SCENE.touchEventBlockLayer.lockTouch()
            if button_detail:getRotation() == 0 then
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, -700))
                back_down:runAction(action1)

                local action2 = cc.RotateTo:create(0.4,180)
                button_detail:runAction(action2)

                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action3, action4))
            else
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 0))
                back_down:runAction(action1)

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

        local changeLayer = function()
            if s_CorePlayManager.replayWrongWordState then
                if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wrongWordList then
                    s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                    s_CorePlayManager.enterStudyLayer()
                else
                    s_SCENE.touchEventBlockLayer.unlockTouch()

                    local alter = TestAlter.createFromSecondAlter()
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
            else
                if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wordList then
                    s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                    s_CorePlayManager.enterStudyLayer()
                else
                    s_SCENE.touchEventBlockLayer.unlockTouch()

                    local alter = StudyAlter.create()
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
            end
        end

        local endEffect = function()
            local action4 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,936))
            local action5 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,900))
            back_up:runAction(action4)
            back_down:runAction(action5)

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
    --s_logd("new wrong")
    end
    if s_CorePlayManager.newPlayerState then
        mat = FlipMat.create(wordName,4,4,true)
    else
        mat = FlipMat.create(wordName,4,4,false)
    end
    mat:setPosition(s_DESIGN_WIDTH/2*3, 120)
    layer:addChild(mat)

    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false

    button_changeview_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            s_SCENE.touchEventBlockLayer.lockTouch()
            if button_changeview:getTitleText() == "去划单词" then
                local change = function()
                    button_changeview:setTitleText("再看一次")

                    local action1 = cc.MoveTo:create(0.5,cc.p(-bigWidth/2, 550))
                    soundMark:runAction(action1)

                    local action2 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 120))
                    mat:runAction(action2)

                    local action3 = cc.MoveTo:create(0.5,cc.p(layer:getContentSize().width+60, 930))
                    button_detail:runAction(action3)

                    local action4 = cc.DelayTime:create(0.5)
                    local action5 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                    layer:runAction(cc.Sequence:create(action4, action5))
                end

                if s_CorePlayManager.newPlayerState then
                    if not guideOver then
                        local action1 = cc.MoveTo:create(0.5, cc.p(-s_DESIGN_WIDTH/2, 300))
                        newplayerHintBack:runAction(action1)

                        local action2 = cc.MoveTo:create(0.5, cc.p(2*s_DESIGN_WIDTH-200, 10))
                        local action3 = cc.CallFunc:create(change)
                        fingerClick:runAction(cc.Sequence:create(action2, action3))
                    else
                        change()
                    end

                    guideOver = true
                else
                    change()
                end
            else
                button_changeview:setTitleText("去划单词")

                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, 550))
                soundMark:runAction(action1)

                local action2 = cc.MoveTo:create(0.5,cc.p(bigWidth/2*3, 120))
                mat:runAction(action2)

                local action3 = cc.MoveTo:create(0.5,cc.p(layer:getContentSize().width-60, 930))
                button_detail:runAction(action3)

                local action4 = cc.DelayTime:create(0.5)
                local action5 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action4, action5))
            end
        end
    end   

    local onTouchBegan = function(touch, event)
        s_logd("touch began")
        if viewIndex == 1 then     
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            local addWordDetailInfo = function()
                soundMark = SoundMark.create(wordName, wordSoundMarkAm, wordSoundMarkEn)
                soundMark:setPosition(bigWidth/2, 550)
                back_down:addChild(soundMark)

                button_detail = ccui.Button:create()
                button_detail:setTouchEnabled(true)
                button_detail:loadTextures("image/button/button_zhuwanfa_disnaguan.png", "", "")
                button_detail:setPosition(cc.p(s_DESIGN_WIDTH-60, 900))
                button_detail:addTouchEventListener(button_detail_clicked)
                backImage:addChild(button_detail)

                button_changeview = ccui.Button:create()
                button_changeview:setTouchEnabled(true)
                button_changeview:loadTextures("image/button/button_zhuwanfa_disnaguan_another.png", "", "")
                button_changeview:setTitleText("去划单词")
                button_changeview:setTitleFontSize(30)
                button_changeview:setPosition(bigWidth/2, 50)
                button_changeview:addTouchEventListener(button_changeview_clicked)
                back_down:addChild(button_changeview)

                local wordDetailInfo = WordDetailInfo.create(word)
                wordDetailInfo:setPosition(bigWidth/2, 0)
                backImage:addChild(wordDetailInfo)
            end

            local moveBack = function()
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 0))
                local action2 = cc.CallFunc:create(addWordDetailInfo)
                back_down:runAction(cc.Sequence:create(action1, action2))
                viewIndex = 2

                local action3 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 896))
                local action4 = cc.ScaleTo:create(0.5, math.min(200/label_wordmeaningSmall:getContentSize().width, 1))
                label_wordmeaningSmall:runAction(cc.Spawn:create(action3, action4))
            end

            if s_CorePlayManager.newPlayerState then
                local action1 = cc.MoveTo:create(0.5, cc.p(-s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
                local action2 = cc.Place:create(cc.p(-s_DESIGN_WIDTH/2, 300))
                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 300))
                newplayerHintBack:runAction(cc.Sequence:create(action1, action2, action3, action4))

                local action5 = cc.MoveTo:create(0.5, cc.p(2*s_DESIGN_WIDTH-200, 50))
                local action6 = cc.CallFunc:create(moveBack)
                local action7 = cc.Place:create(cc.p(2*s_DESIGN_WIDTH-200, 10))
                local action8 = cc.DelayTime:create(0.5)
                local action9 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 10))
                local action10 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                fingerClick:runAction(cc.Sequence:create(action5, action6, action7, action8,action9,action10))  
            else
                local action1 = cc.CallFunc:create(moveBack)
                local action2 = cc.DelayTime:create(0.5)
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                layer:runAction(cc.Sequence:create(action1, action2, action3))
            end 
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
    layer:addChild(pauseBtn,100)
    local Pause = require('view.Pause')
    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            layer:addChild(pauseLayer,1000)
            layer.layerPaused = true
            --director:getActionManager():resumeTargets(pausedTargets)

            --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    return layer
end

return StudyLayerIII
