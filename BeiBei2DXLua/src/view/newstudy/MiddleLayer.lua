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

function MiddleLayer.create()
    local layer = MiddleLayer.new()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
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
    local figureback = cc.Sprite:create("image/newstudy/figurebackground.png")
    figureback:setPosition(bigWidth /2 + 100, 1000)

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

    local labelWordNum = cc.Label:createWithSystemFont(wrongNumber,"",50)
    labelWordNum:setPosition(50,50)
    labelWordNum:setColor(cc.c4b(234,123,3,255))
    figureback:addChild(labelWordNum)
    
    
    
    return figureback
end

local function createNextButton(getBean)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_CURRENT_USER.beanReward = 3
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
    
    self.bean = s_CURRENT_USER:getBeans()
    self.beanSprite = createBeanSprite(self.bean)
    self:addChild(self.beanSprite)
    
    self.wrongNumber = s_max_wrong_num_everyday
    self.showNumber = createNumberSprite(self.wrongNumber)
    backColor:addChild(self.showNumber)
    
    local label_come_on = cc.Label:createWithSystemFont("贝贝给你加油","",50)
    label_come_on:setPosition(bigWidth/2, 700)
    label_come_on:setColor(cc.c4b(234,123,3,255))
    backColor:addChild(label_come_on)

    local beibeiAnimation = sp.SkeletonAnimation:create("spine/bb_hello_public.json", 'spine/bb_hello_public.atlas',1)
    beibeiAnimation:addAnimation(0, 'animation', false)
    beibeiAnimation:setPosition(bigWidth/2, 270)
    backColor:addChild(beibeiAnimation)
    
    self.getBean = s_CURRENT_USER.beanReward
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
    
end

return MiddleLayer