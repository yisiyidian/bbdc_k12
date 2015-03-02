require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  MiddleLayer = class("MiddleLayer", function ()
    return cc.Layer:create()
end)

function MiddleLayer:ShakeFunction(k,times)
    local action1 = cc.MoveBy:create(0.05, cc.p(-5 * k,0))
    local action2 = cc.MoveBy:create(0.05, cc.p(10 * k,0))
    local action3 = cc.MoveBy:create(0.05, cc.p(-10 * k , 0))
    local action6 = cc.ScaleTo:create(0.05, 1.1)
    local action7 = cc.ScaleTo:create(0.05, 1)
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action6 ,action3, action7),times)
    local action5 = cc.MoveBy:create(0.05, cc.p(5 * k,0)) 
    local action = cc.Sequence:create(action1, action4, action5, nil)
    return action
end

function MiddleLayer.create()
    local layer = MiddleLayer.new()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function calculationAngle(point)
   return math.acos(point.x / math.sqrt(point.y * point.y + point.x * point.x) )
end

local function wordAnimation(endPoint,back1,back2)
    local wordList = {}
    local bossId = s_LocalDatabaseManager.getMaxBossID()
    local boss = s_LocalDatabaseManager.getBossInfo(bossId)
    for i=1, s_max_wrong_num_everyday do
        table.insert(wordList,boss.wrongWordList[i])
    end
    back1:runAction(MiddleLayer:ShakeFunction(1,1))
    back2:runAction(MiddleLayer:ShakeFunction(1,1))
    local wordLabel = {}
    for i=1, s_max_wrong_num_everyday do
        local rand = math.randomseed(os.time() * i)
        wordLabel[i] = cc.Label:createWithSystemFont(wordList[i],"",30)
        wordLabel[i]:setColor(cc.c4b(0,0,0,255))
        local beginPoint = cc.p(math.random(1,150) - 75,  math.random(1,25) + 200)
        wordLabel[i]:setPosition(endPoint.x + beginPoint.x, endPoint.y + beginPoint.y) 
        local angle = math.deg(calculationAngle(beginPoint))
        local randAngle = math.random(1,40) - 20 
        wordLabel[i]:setRotation(-angle + randAngle)
        wordLabel[i]:setVisible(false)
    end
    local time = 0
    local i = 1
    local function update(delta)
        time = time + delta
        if time * 10 > s_max_wrong_num_everyday + 1 then
            back1:unscheduleUpdate()
            back1:runAction(MiddleLayer:ShakeFunction(2,2))
            back2:runAction(MiddleLayer:ShakeFunction(2,2))
        elseif time * 10 > i then
            wordLabel[i]:setVisible(true)  
            wordLabel[i]:runAction(cc.MoveTo:create(0.3,cc.p(endPoint.x,endPoint.y - 50)))
            wordLabel[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.FadeOut:create(0.1)))
            i = i + 1
        end
    end
    back1:scheduleUpdateWithPriorityLua(update, 0)


    return wordLabel
end

local function createBeanSprite(bean)
    local beans = cc.Sprite:create('image/chapter/chapter0/beanBack.png')
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)

    local beanLabel = cc.Sprite:create('image/chapter/chapter0/bean.png')
    beanLabel:setPosition(beans:getContentSize().width/2 - 60, beans:getContentSize().height/2+5)
    beans:addChild(beanLabel)

    local beanCountLabel = cc.Label:createWithSystemFont(bean,'',33)
    beanCountLabel:setColor(cc.c3b(13, 95, 156))
    beanCountLabel:ignoreAnchorPointForPosition(false)
    beanCountLabel:setAnchorPoint(1,0)
    beanCountLabel:setPosition(90,2)
    beans:addChild(beanCountLabel,10)
    
    return beans
end

local function createNumberSprite(wrongNumber)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local figureback_main = cc.Sprite:create("image/newstudy/figurebackground.png")
    figureback_main:setPosition(bigWidth /2 + 100, 1000)
    figureback_main:setOpacity(0)

    local figureback_sub = cc.Sprite:create("image/newstudy/figurebackground.png")
    figureback_sub:setPosition(figureback_main:getContentSize().width / 2 ,figureback_main:getContentSize().height / 2)
    figureback_sub:setScale(0)
    figureback_main:addChild(figureback_sub)

    figureback_sub:runAction(cc.ScaleTo:create(1,1))

    local label_hint_part_one = cc.Label:createWithSystemFont("收集生词","",50)
    label_hint_part_one:setPosition(-20, 50)
    label_hint_part_one:ignoreAnchorPointForPosition(false)
    label_hint_part_one:setAnchorPoint(1,0.5)
    label_hint_part_one:setColor(cc.c4b(31,68,102,255))
    figureback_main:addChild(label_hint_part_one)

    local label_hint_part_two = cc.Label:createWithSystemFont("个","",50)
    label_hint_part_two:setPosition(110, 50)
    label_hint_part_two:ignoreAnchorPointForPosition(false)
    label_hint_part_two:setAnchorPoint(0,0.5)
    label_hint_part_two:setColor(cc.c4b(31,68,102,255))
    figureback_main:addChild(label_hint_part_two)

    local labelWordNum = cc.Label:createWithSystemFont(0,"",50)
    labelWordNum:setPosition(50,50)
    labelWordNum:setColor(cc.c4b(234,123,3,255))
    figureback_main:addChild(labelWordNum)
    
    local time = 0
    local function update(delta)
       time = time + delta
       if time <= 1 then
       elseif time <= 2 then
            labelWordNum:setString(math.floor(wrongNumber * (time - 1)))
       else
            labelWordNum:setString(wrongNumber)
            figureback_main:unscheduleUpdate()
       end
    end
    figureback_main:scheduleUpdateWithPriorityLua(update, 0)
    
    return figureback_main
end

local function createNextButton(getBean)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_level_popup_state = 1
            s_HUD_LAYER:removeChildByName('missionCompleteCircle')
            s_CURRENT_USER.beanRewardForIron = 3
            s_CorePlayManager.leaveStudyOverModel()
        end
    end

    local button_go = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button_go:setPosition(bigWidth/2, 153)
    button_go:setTitleText("趁热打铁")
    button_go:setTitleColor(cc.c4b(255,255,255,255))
    button_go:setTitleFontSize(32)
    button_go:addTouchEventListener(button_go_click)

    local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean:setPosition(button_go:getContentSize().width * 0.75,button_go:getContentSize().height * 0.5)
    button_go:addChild(bean)

    local rewardNumber = cc.Label:createWithSystemFont("+"..tostring(getBean),"",36)
    rewardNumber:setPosition(button_go:getContentSize().width * 0.85,button_go:getContentSize().height * 0.5)
    button_go:addChild(rewardNumber)

    return button_go
end

function MiddleLayer:ctor()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)

    s_SCENE.popupLayer.pauseBtn:setVisible(false)
    
    self.bean = s_CURRENT_USER:getBeans()
    self.beanSprite = createBeanSprite(self.bean)
    self:addChild(self.beanSprite)
    
    self.wrongNumber = s_max_wrong_num_everyday
    self.showNumber = createNumberSprite(self.wrongNumber)
    backColor:addChild(self.showNumber)
    
    local backBagSprite = cc.Sprite:create("image/newstudy/bagback.png")
    backBagSprite:setPosition(bigWidth * 0.6, 500)
    backColor:addChild(backBagSprite)
    
    local frontBagSprite = cc.Sprite:create("image/newstudy/bagfront.png")
    frontBagSprite:setPosition(bigWidth * 0.6 + 4, 510)
    frontBagSprite:ignoreAnchorPointForPosition(false)
    frontBagSprite:setAnchorPoint(0.5,1)
    frontBagSprite:setColor(cc.c4b(234,123,3,255))
    backColor:addChild(frontBagSprite,2)
    
    local point = cc.p(backBagSprite:getPositionX(),backBagSprite:getPositionY())
    
    local jumpWord = wordAnimation(point,backBagSprite,frontBagSprite)
    for i = 1 ,#jumpWord do
        backColor:addChild(jumpWord[i])	
    end

    local beibeiAnimation = sp.SkeletonAnimation:create("spine/collectword.json", "spine/collectword.atlas",1)
    beibeiAnimation:addAnimation(0, 'animation', false)
    beibeiAnimation:setPosition(bigWidth * 0.25, 300)
    backColor:addChild(beibeiAnimation)
    
    self.getBean = s_CURRENT_USER.beanRewardForCollect
    s_CURRENT_USER.beanRewardForCollect = 3
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
    
end

return MiddleLayer