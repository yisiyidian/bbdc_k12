require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")

local  NewStudySuccessLayer = class("NewStudySuccessLayer", function ()
    return cc.Layer:create()
end)

function NewStudySuccessLayer.create()

    AnalyticsFirst(ANALYTICS_FIRST_FINISH, 'SHOW')

    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    local beanNum = s_CorePlayManager.reward - s_CorePlayManager.ordinalNum
    if s_CorePlayManager.reward - s_CorePlayManager.ordinalNum >= 0 then
        s_CURRENT_USER:addBeans(beanNum)
    else
        beanNum = 0
    end

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
    local layer = NewStudySuccessLayer.new()

    local backColor = BackLayer.create(45)
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    backColor.progressBar:removeFromParent()
    
    local beans = cc.Sprite:create('image/chapter/chapter0/beanBack.png')
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    layer:addChild(beans)

    local beanLabel = cc.Sprite:create('image/chapter/chapter0/bean.png')
    beanLabel:setPosition(beans:getContentSize().width/2 - 60, beans:getContentSize().height/2+5)
    beans:addChild(beanLabel)
    
    local beanCountLabel = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',33)
    beanCountLabel:setColor(cc.c3b(13, 95, 156))
    beanCountLabel:ignoreAnchorPointForPosition(false)
    beanCountLabel:setAnchorPoint(1,0)
    beanCountLabel:setPosition(80,2)
    beans:addChild(beanCountLabel,10)
    
    local wrongWordNum = s_CorePlayManager.wrongWordNum

    local label_hint = cc.Label:createWithSystemFont("任务完成！","",50)
    label_hint:setPosition(bigWidth/2, 1000)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)
    
    local beibeiAnimation
    beibeiAnimation = sp.SkeletonAnimation:create("spine/bb_happy_public.json", 'spine/bb_happy_public.atlas',1)
    beibeiAnimation:addAnimation(0, 'animation', false)
    beibeiAnimation:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X-100, 220)

    local partical = cc.ParticleSystemQuad:create('image/studyscene/ribbon.plist')
    partical:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X, 600)
    layer:addChild(partical)
    layer:addChild(beibeiAnimation)

--    local circle = cc.Sprite:create("image/newstudy/yellow_circle_small.png")
--    circle:setPosition(bigWidth/2, 900)
--    backColor:addChild(circle)
--
--    local number = cc.Label:createWithSystemFont("+"..wrongWordNum,"",60)
--    number:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
--    number:setColor(cc.c4b(248,227,106,255))
--    circle:addChild(number)
--
--    local label_hint2 = cc.Label:createWithSystemFont("恭喜你完成今天的学习任务","",36)
--    label_hint2:setPosition(bigWidth/2, 700)
--    label_hint2:setColor(cc.c4b(31,68,102,255))
--    backColor:addChild(label_hint2)
--
--    local girl = sp.SkeletonAnimation:create("res/spine/bb_happy_public.json", "res/spine/bb_happy_public.atlas", 1)
--    girl:setPosition(bigWidth/2 - 80, 250)
--    backColor:addChild(girl)      
--    girl:addAnimation(0, 'animation', true)

    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_go = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button_go:setPosition(bigWidth/2, 153)
    button_go:setTitleText("YES！")
    button_go:setTitleColor(cc.c4b(255,255,255,255))
    button_go:setTitleFontSize(32)
    button_go:addTouchEventListener(button_go_click)
    backColor:addChild(button_go)

    local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean:setPosition(button_go:getContentSize().width * 0.75,button_go:getContentSize().height * 0.5)
    button_go:addChild(bean)

    local rewardNumber = cc.Label:createWithSystemFont("+"..tostring(beanNum),"",36)
    rewardNumber:setPosition(button_go:getContentSize().width * 0.85,button_go:getContentSize().height * 0.5)
    button_go:addChild(rewardNumber)

    AnalyticsTasksFinished('NewStudySuccessLayer')
    
    return layer
end

return NewStudySuccessLayer