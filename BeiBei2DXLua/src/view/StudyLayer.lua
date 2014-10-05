require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

ProgressBar = require("view.ProgressBar")
FlipMat = require("view.FlipMat")

local StudyLayer = class("StudyLayer", function ()
    return cc.Layer:create()
end)


function StudyLayer.create()
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
   
    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(size.width/2, size.height)
    layer:addChild(cloud_up)

    local cloud_down = cc.Sprite:create("image/studyscene/studyscene_cloud_white_down.png")
    cloud_down:setAnchorPoint(0.5, 0)
    cloud_down:setPosition(size.width/2, 0)
    layer:addChild(cloud_down)

    local beach = cc.Sprite:create("image/studyscene/studyscene_beach_down.png")
    beach:setAnchorPoint(0.5, 0)
    beach:setPosition(size.width/2, 0)
    layer:addChild(beach)

    local progressBar = ProgressBar.create(2,2)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)


    local button_pronounce = ccui.Button:create()
    button_pronounce:setTouchEnabled(true)
    button_pronounce:loadTextures("image/button/soundButton1.png", "", "")
    button_pronounce:setPosition(cc.p(cloud_down:getContentSize().width/2-100, 700))
    cloud_down:addChild(button_pronounce)
    
    local button_wordname = ccui.Button:create()
    button_wordname:setTouchEnabled(true)
    button_wordname:setTitleText(wordName)
    button_wordname:setTitleFontSize(80)
    button_wordname:setTitleColor(cc.c4b(0,0,0,255))
    button_wordname:setPosition(cc.p(cloud_down:getContentSize().width/2+100, 700))
    cloud_down:addChild(button_wordname)
    
    
    local button_country = ccui.Button:create()
    button_country:setTouchEnabled(true)
    button_country:loadTextures("image/button/USButton1.png", "", "")
    button_country:setTitleText("US")
    button_country:setTitleFontSize(30)
    button_country:setPosition(cc.p(cloud_down:getContentSize().width/2-100, 600))
    cloud_down:addChild(button_country)
    
    local button_soundmark = ccui.Button:create()
    button_soundmark:setTouchEnabled(true)
    button_soundmark:setTitleText(wordSoundMarkAm)
    button_soundmark:setTitleFontSize(40)
    button_soundmark:setTitleColor(cc.c4b(0,0,0,255))
    button_soundmark:setPosition(cc.p(cloud_down:getContentSize().width/2+100, 600))
    cloud_down:addChild(button_soundmark)
    
    local button_detail = ccui.Button:create()
    button_detail:setTouchEnabled(true)
    button_detail:loadTextures("image/button/button_arrow.png", "", "")
    button_detail:setPosition(cc.p(layer:getContentSize().width-60, 930))
    layer:addChild(button_detail)
    
    local button_changeview = ccui.Button:create()
    button_changeview:setTouchEnabled(true)
    button_changeview:loadTextures("image/button/button_huadanci__dianji.png", "", "")
    button_changeview:setTitleText("去划单词")
    button_changeview:setTitleFontSize(30)
    button_changeview:setPosition(cc.p(layer:getContentSize().width/2, 100))
    layer:addChild(button_changeview)

    local mat = FlipMat.create("apple",4,4)
    --mat:setPosition(layer:getContentSize().width,0)
    mat:setPosition(400,0)
    layer:addChild(mat)
    
    local aaa = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            print("按下按钮")
        elseif eventType == ccui.TouchEventType.moved then
            print("按下按钮移动")
        elseif eventType == ccui.TouchEventType.ended then
            print("放开按钮")
        elseif eventType == ccui.TouchEventType.canceled then
            print("取消点击")
        end
    end
    
--    button_changeview:addTouchEventListener(aaa)
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