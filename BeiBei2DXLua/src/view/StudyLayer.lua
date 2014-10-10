require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.ProgressBar")
local FlipMat = require("view.FlipMat")
local SoundMark = require("view.SoundMark")


local StudyLayer = class("StudyLayer", function ()
    return cc.Layer:create()
end)


function StudyLayer.create()
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

    local layer = StudyLayer.new()

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), size.width, size.height)    
    layer:addChild(backColor)
    
    
    local button_changeview
    local button_changeview_clicked
    local button_detail
    local button_detail_clicked
   
    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:ignoreAnchorPointForPosition(false)
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(size.width/2, size.height)
    layer:addChild(cloud_up)

    local cloud_down = cc.Sprite:create("image/studyscene/studyscene_cloud_white_down.png")
    cloud_down:ignoreAnchorPointForPosition(false)
    cloud_down:setAnchorPoint(0.5, 0)
    cloud_down:setPosition(size.width/2, 0)
    layer:addChild(cloud_down)

    local beach = cc.Sprite:create("image/studyscene/studyscene_beach_down.png")
    beach:ignoreAnchorPointForPosition(false)
    beach:setAnchorPoint(0.5, 0)
    beach:setPosition(size.width/2, 0)
    layer:addChild(beach)
    
    local size_big = cloud_down:getContentSize()

    local progressBar = ProgressBar.create(2,2)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)

    local soundMark = SoundMark.create(wordName, wordSoundMarkAm, wordSoundMarkEn)
    soundMark:setPosition(size_big.width/2, 600)
    cloud_down:addChild(soundMark)
    
    button_detail_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if button_detail:getRotation() == 0 then
                local action1 = cc.MoveTo:create(0.5,cc.p(size.width/2, -700))
                cloud_down:runAction(action1)
            
                local action2 = cc.RotateTo:create(0.4,180)
                button_detail:runAction(action2)
            else
                local action1 = cc.MoveTo:create(0.5,cc.p(size.width/2, 0))
                cloud_down:runAction(action1)

                local action2 = cc.RotateTo:create(0.4,0)
                button_detail:runAction(action2)
            end
        end
    end
    
    button_detail = ccui.Button:create()
    button_detail:setTouchEnabled(true)
    button_detail:loadTextures("image/button/button_arrow.png", "", "")
    button_detail:setPosition(cc.p(layer:getContentSize().width-60, 930))
    button_detail:addTouchEventListener(button_detail_clicked)
    layer:addChild(button_detail)
    
    local mat = FlipMat.create("apple",4,4)
    mat:setPosition(size_big.width/2*3, 100)
    cloud_down:addChild(mat)
    
    button_changeview_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if button_changeview:getTitleText() == "去划单词" then
                button_changeview:setTitleText("再看一次")

                local action1 = cc.MoveTo:create(0.5,cc.p(-size_big.width/2, 600))
                soundMark:runAction(action1)
            
                local action2 = cc.MoveTo:create(0.5,cc.p(size_big.width/2, 100))
                mat:runAction(action2)
                
                local action3 = cc.MoveTo:create(0.5,cc.p(layer:getContentSize().width+60, 930))
                button_detail:runAction(action3)
            else
                button_changeview:setTitleText("去划单词")

                local action1 = cc.MoveTo:create(0.5,cc.p(size_big.width/2, 600))
                soundMark:runAction(action1)

                local action2 = cc.MoveTo:create(0.5,cc.p(size_big.width/2*3, 100))
                mat:runAction(action2)
                
                local action3 = cc.MoveTo:create(0.5,cc.p(layer:getContentSize().width-60, 930))
                button_detail:runAction(action3)
            end
        end
    end

    button_changeview = ccui.Button:create()
    button_changeview:setTouchEnabled(true)
    button_changeview:loadTextures("image/button/button_huadanci__dianji.png", "", "")
    button_changeview:setTitleText("去划单词")
    button_changeview:setTitleFontSize(30)
    button_changeview:setPosition(size_big.width/2, 100)
    button_changeview:addTouchEventListener(button_changeview_clicked)
    cloud_down:addChild(button_changeview)
    
    
--
--    local onTouchBegan = function(touch, event)
--        print("touch began")
--        --s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
--        --s_CorePlayManager.enterStudyLayer()
--    end
--    
--    local onTouchMoved = function(touch, event)
--        print("touch moved")
--    end
--    
--    local onTouchEnded = function(touch, event)
--        print("touch ended")
--    end
--    
--    local listener = cc.EventListenerTouchOneByOne:create()
--   
--    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
--    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
--    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
--    local eventDispatcher = layer:getEventDispatcher()
--    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return StudyLayer