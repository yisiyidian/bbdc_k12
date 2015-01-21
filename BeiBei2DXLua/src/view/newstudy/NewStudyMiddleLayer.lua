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
    
    s_CorePlayManager.initNewStudyReward()

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
--    backColor.progressBar = ProgressBar.create(s_CorePlayManager.maxWrongWordCount, s_CorePlayManager.wrongWordNum, "yellow")
--    backColor.progressBar:setPosition(bigWidth/2+44, 1099)
--    backColor:addChild(backColor.progressBar)
--    
--    backColor.progressBar.hint = function()
--        local guideAlter = GuideAlter.create(0, "生词进度条", "代表你今天生词积攒任务的完成进度")
--        guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
--        backColor:addChild(guideAlter)
--    end

    local beans = cc.Sprite:create('image/chapter/chapter0/beanBack.png')
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    layer:addChild(beans)
        
    local beanLabel = cc.Sprite:create('image/chapter/chapter0/bean.png')
    beanLabel:setPosition(beans:getContentSize().width/2 - 60, beans:getContentSize().height/2+5)
    beans:addChild(beanLabel)

    local beanCountLabel = cc.Label:createWithSystemFont(s_CURRENT_USER.beans,'',33)
    beanCountLabel:setColor(cc.c3b(13, 95, 156))
    beanCountLabel:ignoreAnchorPointForPosition(false)
    beanCountLabel:setAnchorPoint(1,0)
    beanCountLabel:setPosition(80,2)
    beans:addChild(beanCountLabel,10)

    local wrongWordNum = s_CorePlayManager.wrongWordNum

    local figureback = cc.Sprite:create("image/newstudy/figurebackground.png")
    figureback:setPosition(bigWidth /2 + 100, 1000)
    backColor:addChild(figureback)
    
    local label_hint_part_one = cc.Label:createWithSystemFont("收集生词","",50)
    label_hint_part_one:setPosition(-20, 50)
    label_hint_part_one:ignoreAnchorPointForPosition(false)
    label_hint_part_one:setAnchorPoint(1,0.5)
    label_hint_part_one:setColor(cc.c4b(31,68,102,255))
    figureback:addChild(label_hint_part_one)
    
    local label_hint_part_two = cc.Label:createWithSystemFont("个","",50)
    label_hint_part_two:setPosition(110, 50)
    label_hint_part_two:ignoreAnchorPointForPosition(false)
    label_hint_part_two:setAnchorPoint(0,0.5)
    label_hint_part_two:setColor(cc.c4b(31,68,102,255))
    figureback:addChild(label_hint_part_two)
    
    local labelWordNum = cc.Label:createWithSystemFont("0","",50)
    labelWordNum:setPosition(50,50)
    labelWordNum:setColor(cc.c4b(234,123,3,255))
    figureback:addChild(labelWordNum)

    AnalyticsFirst(ANALYTICS_FIRST_GOT_ENOUGH_UNKNOWN_WORDS, tostring(wrongWordNum))

    local label_come_on = cc.Label:createWithSystemFont("贝贝给你加油","",50)
    label_come_on:setPosition(bigWidth/2, 600)
    label_come_on:setColor(cc.c4b(234,123,3,255))
    backColor:addChild(label_come_on)
    
    
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
    
    local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean:setPosition(button_go:getContentSize().width * 0.75,button_go:getContentSize().height * 0.5)
    button_go:addChild(bean)
    
    local rewardNumber = cc.Label:createWithSystemFont("+3","",36)
    rewardNumber:setPosition(button_go:getContentSize().width * 0.85,button_go:getContentSize().height * 0.5)
    button_go:addChild(rewardNumber)
    
    print_lua_table(s_CorePlayManager.wrongWordList)
    
    local time = 0
    local function update(delta)
        time = time + delta
        if tonumber(labelWordNum:getString()) < wrongWordNum  then
            labelWordNum:setString(math.ceil(time * wrongWordNum / 2))
        else
           layer:unscheduleUpdate()
        end  

    end
    layer:scheduleUpdateWithPriorityLua(update, 0)

    return layer
end

return NewStudyMiddleLayer