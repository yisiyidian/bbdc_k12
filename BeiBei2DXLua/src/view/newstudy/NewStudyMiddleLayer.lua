require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")

local  NewStudyMiddleLayer = class("NewStudyMiddleLayer", function ()
    return cc.Layer:create()
end)

function NewStudyMiddleLayer.create()
    --pause music
    cc.SimpleAudioEngine:getInstance():pauseMusic()

    -- word info
    local currentWordName   = s_CorePlayManager.NewStudyLayerWordList[s_CorePlayManager.currentIndex]
    local currentWord       = s_WordPool[currentWordName]
    local wordname          = currentWord.wordName
    local wordSoundMarkEn   = currentWord.wordSoundMarkEn
    local wordSoundMarkAm   = currentWord.wordSoundMarkAm
    local wordMeaningSmall  = currentWord.wordMeaningSmall
    local wordMeaning       = currentWord.wordMeaning
    local sentenceEn        = currentWord.sentenceEn
    local sentenceCn        = currentWord.sentenceCn
    local sentenceEn2       = currentWord.sentenceEn2
    local sentenceCn2       = currentWord.sentenceCn2

    local totalWordNum      = #s_CorePlayManager.NewStudyLayerWordList


    -- ui 
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = NewStudyMiddleLayer.new()

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local label_hint = cc.Label:createWithSystemFont("20个生词get!","",50)
    label_hint:setPosition(bigWidth/2, 1000)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)

    local circle = cc.Sprite:create("image/newstudy/yellow_circle.png")
    circle:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
    backColor:addChild(circle)
    
    local number = cc.Label:createWithSystemFont("+20","",60)
    number:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    number:setColor(cc.c4b(98,124,148,255))
    circle:addChild(number)
    
    local label_hint2 = cc.Label:createWithSystemFont("快速过一遍这些生词\n可以得到任务奖励哦","",36)
    label_hint2:setPosition(bigWidth/2, 300)
    label_hint2:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint2)
    
    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterNewStudyChooseLayer()
        end
    end

    local button_go = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button_go:setPosition(bigWidth/2, 153)
    button_go:setTitleText("趁热打铁")
    button_go:setTitleColor(cc.c4b(255,255,255,255))
    button_go:setTitleFontSize(32)
    button_go:addTouchEventListener(button_go_click)
    backColor:addChild(button_go) 

    return layer
end

return NewStudyMiddleLayer