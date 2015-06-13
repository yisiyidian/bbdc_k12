-- 引导手指
-- by 侯琪
-- 2015年06月06日16:18:28

local GuideFingerView = class("GuideFingerView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function GuideFingerView.create()
    local layer = GuideFingerView.new()
    return layer
end

function GuideFingerView:ctor()
	local finger = cc.Sprite:create()
	self.finger = finger
	self:addChild(self.finger)
	local action1 = cc.DelayTime:create(0.4)
	local action2 = cc.CallFunc:create(function ()
		self.finger:setTexture("image/newstudy/qian.png")
	end)
	local action3 = cc.DelayTime:create(0.4)
	local action4 = cc.CallFunc:create(function ()
		self.finger:setTexture("image/newstudy/hou.png")
	end)
	local action = cc.Sequence:create(action1,action2,action3,action4)
	self.finger:runAction(cc.RepeatForever:create(action))
end

return GuideFingerView