require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.progress.ProgressBar")
local TapMat = require("view.mat.TapMat")
local SoundMark = require("view.study.SoundMark")
local WordDetailInfo = require("view.study.WordDetailInfo")
local StudyAlter = require("view.study.StudyAlter")
local TestAlter = require("view.test.TestAlter")


local StudyLayerII = class("StudyLayerII", function ()
    return cc.Layer:create()
end)

function StudyLayerII.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    local layer = StudyLayerII.new()

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local bigWidth
    
    local button_detail
    local button_detail_clicked
    local button_changeview
    local button_changeview_clicked
    local button_reddot
    local mat
    local soundMark
    
    local viewIndex= 1
    
    -- time
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
    
    local back = cc.Sprite:create("image/studyscene/studyII_back.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2 - 800)
    back:setScale(2.7)
    layer:addChild(back)
    bigWidth = back:getContentSize().width
    
    local back_bigchair = cc.Sprite:create("image/studyscene/studyII_back_bigchair.png")
    back_bigchair:setAnchorPoint(0.5,0)
    back_bigchair:setPosition(s_DESIGN_WIDTH/2, -290)
    layer:addChild(back_bigchair)
    
    local back_smallchair_left = cc.Sprite:create("image/studyscene/studyII_back_smallchair2.png")
    back_smallchair_left:setAnchorPoint(0,0)
    back_smallchair_left:setPosition(-(bigWidth-s_DESIGN_WIDTH)/2, 0)
    layer:addChild(back_smallchair_left)
    
    local back_smallchair_right = cc.Sprite:create("image/studyscene/studyII_back_smallchair2.png")
    back_smallchair_right:setFlippedX(true)
    back_smallchair_right:setAnchorPoint(1,0)
    back_smallchair_right:setPosition(bigWidth-(bigWidth-s_DESIGN_WIDTH)/2, 0)
    layer:addChild(back_smallchair_right)
    
    local progressBar = ProgressBar.create(false)
    progressBar:setPositionY(1060)
    layer:addChild(progressBar)
    
    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(s_DESIGN_WIDTH/2, 730)
    label_wordmeaningSmall:setScale(math.min(560/label_wordmeaningSmall:getContentSize().width, 1.5))
    layer:addChild(label_wordmeaningSmall)

    button_detail_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            if button_detail:getRotation() == 0 then
                if button_reddot then
                    button_detail:removeChild(button_reddot,true)
                    s_CorePlayManager.unfamiliarWord()
                end
            
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, -600))
                back_bigchair:runAction(action1)
                
                local action2 = cc.RotateTo:create(0.4,180)
                button_detail:runAction(action2)

                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                layer:runAction(cc.Sequence:create(action3, action4))
            else
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 0))
                back_bigchair:runAction(action1)

                local action2 = cc.RotateTo:create(0.4,0)
                button_detail:runAction(action2)

                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                layer:runAction(cc.Sequence:create(action3, action4))
            end
        end
    end

    button_changeview_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- button sound
            playSound(s_sound_buttonEffect)
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            if button_changeview:getTitleText() == "去划单词" then
                local change = function()
                    button_changeview:setTitleText("再看一次")
                    viewIndex = 3

                    local action1 = cc.MoveTo:create(0.5,cc.p(-bigWidth/2, 500))
                    soundMark:runAction(action1)

                    local action2 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 120))
                    mat:runAction(action2)

                    local action3 = cc.MoveTo:create(0.5,cc.p(layer:getContentSize().width+600, 930))
                    button_detail:runAction(action3)

                    local action4 = cc.DelayTime:create(0.5)
                    local action5 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                    layer:runAction(cc.Sequence:create(action4, action5))
                end
                change()
            else
                s_CorePlayManager.unfamiliarWord()
            
                button_changeview:setTitleText("去划单词")
                viewIndex = 2

                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, 500))
                soundMark:runAction(action1)

                local action2 = cc.MoveTo:create(0.5,cc.p(bigWidth/2*3, 120))
                mat:runAction(action2)

                local action3 = cc.MoveTo:create(0.5,cc.p(layer:getContentSize().width/2+140, 920))
                button_detail:runAction(action3)

                local action4 = cc.DelayTime:create(0.5)
                local action5 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                layer:runAction(cc.Sequence:create(action4, action5))
            end
        end
    end   
    
    local success = function()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        progressBar.rightStyle()

        local changeLayer = function()
            if s_CorePlayManager.replayWrongWordState then
                if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wrongWordList then
                    s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                    s_CorePlayManager.enterStudyLayer()
                else
                    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

                    local alter = TestAlter.createFromSecondAlter(2)
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
            else
                if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wordList then
                    s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
                    s_CorePlayManager.enterStudyLayer()
                else
                    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

                    local alter = StudyAlter.create(2)
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
            end
        end
        
        local endEffect = function()
            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2 - 800))
            local action2 = cc.ScaleTo:create(0.5, 2.7)
            local action3 = cc.Spawn:create(action1, action2)
            back:runAction(action3)
            
            local action4 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, -290))
            back_bigchair:runAction(action4)
            
            local action5 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, -s_DESIGN_HEIGHT))
            mat:runAction(action5)
            
            local action6 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT))
            button_changeview:runAction(action6)
            
            label_wordmeaningSmall:setVisible(false)
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
    mat:setPosition(bigWidth/2*3, 100)
    layer:addChild(mat)

    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false

    local onTouchBegan = function(touch, event)
        if viewIndex == 1 then     
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            local addWordDetailInfo = function()
                soundMark = SoundMark.create(wordName, wordSoundMarkAm, wordSoundMarkEn, 2)
                soundMark:setPosition(bigWidth/2, 500)
                back_bigchair:addChild(soundMark)
                
                button_detail = ccui.Button:create("image/button/button_arrow2.png", "image/button/button_arrow2.png", "")
                button_detail:setPosition(cc.p(layer:getContentSize().width/2+140, 920))
                button_detail:addTouchEventListener(button_detail_clicked)
                layer:addChild(button_detail)
                
                button_reddot = ccui.Button:create("image/button/dot_red.png", "image/button/dot_red.png", "")
                button_reddot:setPosition(button_detail:getContentSize().width, button_detail:getContentSize().height)
                button_reddot:setTitleText("1")
                button_reddot:setTitleFontSize(24)
                button_detail:addChild(button_reddot)

                button_changeview = ccui.Button:create("image/button/button_changeview21.png", "image/button/button_changeview22.png", "")
                button_changeview:setTitleText("去划单词")
                button_changeview:setTitleFontSize(30)
                button_changeview:setPosition(bigWidth/2, 50)
                button_changeview:addTouchEventListener(button_changeview_clicked)
                back_bigchair:addChild(button_changeview)
                
                local wordDetailInfo = WordDetailInfo.create(word, 2)
                wordDetailInfo:setPosition(back:getContentSize().width/2, 0)
                back:addChild(wordDetailInfo)
            end

            local movePanel = function()
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
                local action2 = cc.ScaleTo:create(0.5,1)
                local action3 = cc.Spawn:create(action1, action2)
                back:runAction(action3)
            
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 0))
                local action2 = cc.CallFunc:create(addWordDetailInfo)
                back_bigchair:runAction(cc.Sequence:create(action1, action2))
                viewIndex = 2

                local action3 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 920))
                local action4 = cc.ScaleTo:create(0.5, math.min(200/label_wordmeaningSmall:getContentSize().width, 1))
                label_wordmeaningSmall:runAction(cc.Spawn:create(action3, action4))
            end
            
            local action1 = cc.CallFunc:create(movePanel)
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

return StudyLayerII
