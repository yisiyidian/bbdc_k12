local Button                = require("view.button.longButtonInStudy")

local GuidePopup = class("GuidePopup",function ()
	local layer = cc.Layer:create()
	return layer
end)

function GuidePopup.create()
    local layer = GuidePopup.new()
    return layer
end

function GuidePopup:ctor()
	self:initUI()
	-- 初始化UI
end

function GuidePopup:initUI()
	local back = cc.Sprite:create("image/guide/popup.png")
    back:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT *0.6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)

    local showBean = cc.Sprite:create("image/summarybossscene/been_complete_studys.png")
    showBean:setScale(0.5)
    showBean:setPosition(cc.p(self.back:getContentSize().width / 2,self.back:getContentSize().height *0.25))
    self.showBean = showBean
    self.back:addChild(self.showBean) 

    local showBeanNumber = cc.Label:createWithSystemFont("X 10","",30)
    showBeanNumber:setColor(cc.c4b(0,0,0,255))
    showBeanNumber:setPosition(cc.p(self.back:getContentSize().width * 0.6,self.back:getContentSize().height *0.25))
    self.showBeanNumber = showBeanNumber
    self.back:addChild(self.showBeanNumber)

    self.beans = cc.Sprite:create('image/chapter/chapter0/background_been_white.png')
    self.beans:setPosition(s_RIGHT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(self.beans) 

    self.beanCount = s_CURRENT_USER:getBeans()
    self.beanCountLabel = cc.Label:createWithSystemFont(self.beanCount,'',24)
    self.beanCountLabel:setColor(cc.c4b(0,0,0,255))
    self.beanCountLabel:ignoreAnchorPointForPosition(false)
    self.beanCountLabel:setPosition(self.beans:getContentSize().width * 0.65 , self.beans:getContentSize().height/2)
    self.beans:addChild(self.beanCountLabel)
    
    self.ButtonClick = function ()    end

    local button = Button.create("middle","blue","领取奖励")
    button:setPosition(self.back:getContentSize().width/2 ,100)
    button.func = function ()if self.ButtonClick ~= nil then self.ButtonClick() end end
    button:setScale(0)
    self.button = button
    self.back:addChild(self.button)

    local sign = cc.Sprite:create("image/guide/sign.png")
    sign:setPosition(self.back:getContentSize().width * 0.71,310)
    sign:setScale(5)
    sign:setOpacity(0)
    self.sign = sign
    self.back:addChild(self.sign)

    self:runButtonAction()
    self:runSignAction()
    self:runFingerAction()
end

function GuidePopup:runFingerAction()
    local action0 = cc.DelayTime:create(2)
    local action1 = cc.CallFunc:create(function ()
        local guideFingerView = require("view.guide.GuideFingerView").create()
        guideFingerView:setPosition(self.button:getContentSize().width *0.8,0)
        self.button:addChild(guideFingerView,3)
    end)
    self.button:runAction(cc.Sequence:create(action0,action1))
end

function GuidePopup:runButtonAction()
    local action0 = cc.DelayTime:create(2)
    local action1 = cc.ScaleTo:create(0.5,1)
    self.button:runAction(cc.Sequence:create(action0,action1))
end

function GuidePopup:runSignAction()
    local action0 = cc.DelayTime:create(2)
	local action1 = cc.ScaleTo:create(0.5,1)
	local action2 = cc.MoveBy:create(0.5,cc.p(0,40))
    local action3 = cc.FadeIn:create(0.5)
	local action10 = cc.EaseSineIn:create(action1)
	local action11 = cc.EaseSineIn:create(action2)
	self.sign:runAction(cc.Sequence:create(action0,cc.Spawn:create(action3,action10,action11)))
end

return GuidePopup