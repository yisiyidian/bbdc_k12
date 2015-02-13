require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  EndLayer = class("EndLayer", function ()
    return cc.Layer:create()
end)

function EndLayer.create()
    local layer = EndLayer.new()
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

local function createNextButton(getBean)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            print("next")
            s_HUD_LAYER:removeChildByName('missionCompleteCircle')
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_go = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button_go:setPosition(bigWidth/2, 153)
    button_go:setTitleText("YES！")
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

function EndLayer:ctor()
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

    local label_hint = cc.Label:createWithSystemFont("任务完成！","",50)
    label_hint:setPosition(bigWidth/2, 1000)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)

    local beibeiAnimation = sp.SkeletonAnimation:create("spine/bb_happy_public.json", 'spine/bb_happy_public.atlas',1)
    beibeiAnimation:addAnimation(0, 'animation', false)
    beibeiAnimation:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X-100, 220)

    local partical = cc.ParticleSystemQuad:create('image/studyscene/ribbon.plist')
    partical:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X, 600)
    backColor:addChild(partical)
    backColor:addChild(beibeiAnimation)

    self.getBean = s_CURRENT_USER.beanRewardForIron
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
    
    s_CURRENT_USER.beanRewardForIron = 3

    AnalyticsTasksFinished('NewStudySuccessLayer')
end

return EndLayer