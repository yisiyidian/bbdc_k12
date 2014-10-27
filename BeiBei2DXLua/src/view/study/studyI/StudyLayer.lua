require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.progress.ProgressBar")
local FlipMat = require("view.mat.FlipMat")
local SoundMark = require("view.study.SoundMark")
local WordDetailInfo = require("view.study.WordDetailInfo")
local StudyAlter = require("view.study.StudyAlter")
local TestAlter = require("view.test.TestAlter")


local StudyLayer = class("StudyLayer", function ()
    return cc.Layer:create()
end)


function StudyLayer.create()
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

    local layer = StudyLayer.new()

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
    local button_reddot
    
    local soundMark
    local mat
    
    local fingerClick
    local newplayerHintBack
    local label_wordmeaningSmall
    local guideOver = false
    
    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
   
    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:ignoreAnchorPointForPosition(false)
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(s_DESIGN_WIDTH/2, 936)
    layer:addChild(cloud_up)
    
    local cloud_up_tail = cc.LayerColor:create(cc.c4b(38,158,220,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    cloud_up_tail:setAnchorPoint(0.5,0)
    cloud_up_tail:ignoreAnchorPointForPosition(false)  
    cloud_up_tail:setPosition(cloud_up:getContentSize().width/2,cloud_up:getContentSize().height)
    cloud_up:addChild(cloud_up_tail)

    local cloud_down = cc.Sprite:create("image/studyscene/studyscene_cloud_white_down.png")
    cloud_down:ignoreAnchorPointForPosition(false)
    cloud_down:setAnchorPoint(0.5, 0)
    cloud_down:setPosition(s_DESIGN_WIDTH/2, 900)
    layer:addChild(cloud_down)
    
    local cloud_down_tail = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    cloud_down_tail:setAnchorPoint(0.5,1)
    cloud_down_tail:ignoreAnchorPointForPosition(false)  
    cloud_down_tail:setPosition(cloud_up:getContentSize().width/2,0)
    cloud_down:addChild(cloud_down_tail)

    local beach = cc.Sprite:create("image/studyscene/studyscene_beach_down.png")
    beach:ignoreAnchorPointForPosition(false)
    beach:setAnchorPoint(0.5, 0)
    beach:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(beach)
    
    
    local newPlayerGuideInit = function()
        if s_CorePlayManager.newPlayerState then
            newplayerHintBack = cc.Sprite:create("image/studyscene/global_jianjieyindaobeijing_chuxian.png")
            newplayerHintBack:setPosition(-s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
            layer:addChild(newplayerHintBack)

            newplayerHintLabel = cc.Label:createWithSystemFont("点击云层，查看英文","",36)
            newplayerHintLabel:setColor(cc.c4b(0,0,0,255))
            newplayerHintLabel:setPosition(newplayerHintBack:getContentSize().width/2, newplayerHintBack:getContentSize().height/2)
            newplayerHintBack:addChild(newplayerHintLabel)
            
            fingerClick = sp.SkeletonAnimation:create("res/spine/yindaoye_shoudonghua_dianji.json", "res/spine/yindaoye_shoudonghua_dianji.atlas", 1)
            fingerClick:setPosition(2*s_DESIGN_WIDTH-200, 50)
            layer:addChild(fingerClick)
            fingerClick:addAnimation(0, 'animation', true)
            
            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
            local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH-200, 50))
            local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            
            newplayerHintBack:runAction(action1)
            fingerClick:runAction(cc.Sequence:create(action2, action3))
        else
            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        end
    end
      
    local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 1014))
    local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 360))
    local action3 = cc.CallFunc:create(newPlayerGuideInit)

    cloud_up:runAction(action1)
    cloud_down:runAction(cc.Sequence:create(action2, action3))
    
    
      
    local size_big = cloud_down:getContentSize()

    local progressBar = ProgressBar.create(false)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)
    
    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(s_DESIGN_WIDTH/2, 696)
    label_wordmeaningSmall:setScale(math.min(560/label_wordmeaningSmall:getContentSize().width, 1.5))
    backColor:addChild(label_wordmeaningSmall)
    
    button_detail_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_SCENE.touchEventBlockLayer.lockTouch()
            if button_detail:getRotation() == 0 then
                if button_reddot then
                    button_detail:removeChild(button_reddot,true)
                end
                
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 0))
                cloud_down:runAction(action1)
            
                local action2 = cc.RotateTo:create(0.4,180)
                button_detail:runAction(action2)
                
                local action3 = cc.DelayTime:create(0.5)
                local action4 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action3, action4))
            else
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 771))
                cloud_down:runAction(action1)

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
            cloud_up:runAction(action4)
            cloud_down:runAction(action5)
        
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
    mat:setPosition(size_big.width/2*3, 120)
    layer:addChild(mat)
    
    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false
    
    button_changeview_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_SCENE.touchEventBlockLayer.lockTouch()
            if button_changeview:getTitleText() == "去划单词" then
                local change = function()
                    button_changeview:setTitleText("再看一次")

                    local action1 = cc.MoveTo:create(0.5,cc.p(-size_big.width/2, -200))
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

                local action1 = cc.MoveTo:create(0.5,cc.p(size_big.width/2, -200))
                soundMark:runAction(action1)

                local action2 = cc.MoveTo:create(0.5,cc.p(size_big.width/2*3, 120))
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
        if viewIndex == 1 then     
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                   
            local addWordDetailInfo = function()
                soundMark = SoundMark.create(wordName, wordSoundMarkAm, wordSoundMarkEn)
                soundMark:setPosition(size_big.width/2, -200)
                cloud_down:addChild(soundMark)
                
                button_detail = ccui.Button:create()
                button_detail:setTouchEnabled(true)
                button_detail:loadTextures("image/button/button_arrow.png", "", "")
                button_detail:setPosition(cc.p(layer:getContentSize().width-60, 930))
                button_detail:addTouchEventListener(button_detail_clicked)
                backColor:addChild(button_detail)
                
                button_reddot = ccui.Button:create()
                button_reddot:setTouchEnabled(true)
                button_reddot:loadTextures("image/button/dot_red.png", "", "")
                button_reddot:setPosition(button_detail:getContentSize().width, button_detail:getContentSize().height)
                button_reddot:setTitleText("1")
                button_reddot:setTitleFontSize(24)
                button_detail:addChild(button_reddot)
                
                button_changeview = ccui.Button:create()
                button_changeview:setTouchEnabled(true)
                button_changeview:loadTextures("image/button/button_huadanci__dianji.png", "", "")
                button_changeview:setTitleText("去划单词")
                button_changeview:setTitleFontSize(30)
                button_changeview:setPosition(size_big.width/2, -660)
                button_changeview:addTouchEventListener(button_changeview_clicked)
                cloud_down:addChild(button_changeview)
                
                local wordDetailInfo = WordDetailInfo.create(word)
                wordDetailInfo:setPosition(s_DESIGN_WIDTH/2, 0)
                backColor:addChild(wordDetailInfo)
            end
            
            local moveCloud = function()
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 771))
                local action2 = cc.CallFunc:create(addWordDetailInfo)
                cloud_down:runAction(cc.Sequence:create(action1, action2))
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
                local action6 = cc.CallFunc:create(moveCloud)
                local action7 = cc.Place:create(cc.p(2*s_DESIGN_WIDTH-200, 10))
                local action8 = cc.DelayTime:create(0.5)
                local action9 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2, 10))
                local action10 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                fingerClick:runAction(cc.Sequence:create(action5, action6, action7, action8,action9,action10))  
            else
                local action1 = cc.CallFunc:create(moveCloud)
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

    return layer
end

return StudyLayer
