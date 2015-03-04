require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  EndLayer = class("EndLayer", function ()
    return cc.Layer:create()
end)

function EndLayer.create()
    local layer = EndLayer.new()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function createBeanSprite(bean)

    local beans = cc.Sprite:create("image/bean/beanNumber.png")
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-40)

    local been_number = cc.Label:createWithSystemFont(bean,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)

    return beans
end

local function createNextButton(getBean)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            --print("next")
            s_level_popup_state = 1
            s_HUD_LAYER:removeChildByName('missionCompleteCircle')
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_go =  Button.create("YES！")
    button_go:setPosition(bigWidth/2, 100)
    button_go:addTouchEventListener(button_go_click)

    local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean:setPosition(button_go:getContentSize().width * 0.75,button_go:getContentSize().height * 0.5)
    button_go:addChild(bean)

    local rewardNumber = cc.Label:createWithSystemFont("+"..tostring(getBean),"",36)
    rewardNumber:setPosition(button_go:getContentSize().width * 0.85,button_go:getContentSize().height * 0.5)
    button_go:addChild(rewardNumber)

    local action0 = cc.DelayTime:create(1)
    local action1 = cc.MoveBy:create(1,cc.p(-button_go:getContentSize().width * 0.25 + bigWidth/2 - 100 ,-button_go:getContentSize().height * 0.5 - 100 +s_DESIGN_HEIGHT-40)) 
    local action2 = cc.ScaleTo:create(0.1,0)
    bean:runAction(cc.Sequence:create(action0,action1,action2))  
    
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

    local label_hint = cc.Label:createWithSystemFont("任务完成！","",40)
    label_hint:setPosition(bigWidth/2, 1000)
    label_hint:setColor(cc.c4b(42,120,158,255))
    backColor:addChild(label_hint)

    local beibeiAnimation = sp.SkeletonAnimation:create("spine/bb_happy_public.json", 'spine/bb_happy_public.atlas',1)
    beibeiAnimation:addAnimation(0, 'animation', false)
    beibeiAnimation:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X-100, 320)

    local partical = cc.ParticleSystemQuad:create('image/studyscene/ribbon.plist')
    partical:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X, 700)
    backColor:addChild(partical)
    backColor:addChild(beibeiAnimation)

    self.getBean = s_CURRENT_USER.beanRewardForIron
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
    
    s_CURRENT_USER.beanRewardForIron = 3

    AnalyticsTasksFinished('NewStudySuccessLayer')
end

return EndLayer