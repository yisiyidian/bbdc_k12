require("cocos.init")
require("common.global")

local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  SuccessLayer = class("SuccessLayer", function ()
    return cc.Layer:create()
end)

function SuccessLayer.create(number)
    local layer = SuccessLayer.new(number)
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
            s_HUD_LAYER:removeChildByName('missionCompleteCircle')
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_go = Button.create("OK！")
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

function SuccessLayer:ctor(number)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(127,239,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setAnchorPoint(0.5,0.5)
    self:addChild(backColor)

    self.bean = s_CURRENT_USER:getBeans()
    self.beanSprite = createBeanSprite(self.bean)
    self:addChild(self.beanSprite)
    
    local label_hint = cc.Label:createWithSystemFont("打败复习怪物！","",50)
    label_hint:setPosition(backColor:getContentSize().width / 2, 900)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)
    
    local waveSprite = cc.Sprite:create("image/newreviewboss/wave.png")
    waveSprite:setPosition(backColor:getContentSize().width / 2,0)
    waveSprite:ignoreAnchorPointForPosition(false)
    waveSprite:setAnchorPoint(0.5,0)
    backColor:addChild(waveSprite)
    
    local hammerSprite = cc.Sprite:create("image/newreviewboss/hammer.png")
    hammerSprite:setPosition(waveSprite:getContentSize().width / 2,waveSprite:getContentSize().height * 0.6)
    hammerSprite:ignoreAnchorPointForPosition(false)
    hammerSprite:setAnchorPoint(0.5,0.5)
    waveSprite:addChild(hammerSprite)

    self.getBean = 3
    if number ~= nil then
    self.getBean = number
    end
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
    s_CURRENT_USER.beanRewardForCollect             = 3
    s_CURRENT_USER.beanRewardForIron                = 3

end

return SuccessLayer