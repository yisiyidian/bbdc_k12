require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local ProgressBar       = require("view.newstudy.NewStudyProgressBar")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")

local  NewStudyMiddleLayer = class("NewStudyMiddleLayer", function ()
    return cc.Layer:create()
end)

function NewStudyMiddleLayer.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    s_CURRENT_USER:addBeans(3)
    
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
    
    backColor.progressBar:removeFromParent()
    backColor.progressBar = ProgressBar.create(s_CorePlayManager.maxWrongWordCount, s_CorePlayManager.wrongWordNum, "yellow")
    backColor.progressBar:setPosition(bigWidth/2+44, 1099)
    backColor:addChild(backColor.progressBar)
    
    backColor.progressBar.hint = function()
        local guideAlter = GuideAlter.create(0, "生词进度条", "代表你今天生词积攒任务的完成进度")
        guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
        backColor:addChild(guideAlter)
    end

    local wrongWordNum = s_CorePlayManager.wrongWordNum

    local label_hint = cc.Label:createWithSystemFont(wrongWordNum.."个生词get!","",50)
    label_hint:setPosition(bigWidth/2, 1000)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)

    AnalyticsFirst(ANALYTICS_FIRST_GOT_ENOUGH_UNKNOWN_WORDS, tostring(wrongWordNum))

    local circle = cc.Sprite:create("image/newstudy/yellow_circle.png")
    circle:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
    backColor:addChild(circle)
    
    local number = cc.Label:createWithSystemFont("+"..wrongWordNum,"",60)
    number:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    number:setColor(cc.c4b(98,124,148,255))
    circle:addChild(number)
    
    local label_hint2 = cc.Label:createWithSystemFont("获得奖励：","",36)
    label_hint2:setPosition(170, 320)
    label_hint2:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint2)
    
    local bean1 = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean1:setPosition(bigWidth/2-100, 250)
    backColor:addChild(bean1)
    
    local bean2 = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean2:setPosition(bigWidth/2, 250)
    backColor:addChild(bean2)
    
    local bean3 = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean3:setPosition(bigWidth/2+100, 250)
    backColor:addChild(bean3)
    
    
    
    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsFirst(ANALYTICS_FIRST_STUDY_STRIKEWHILEHOT, 'TOUCH')
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