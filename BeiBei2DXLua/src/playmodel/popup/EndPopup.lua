-- 根据通关条件不同，显示不同的结束面板

local EndPopup = class ("EndPopup",function ()
	return cc.Layer:create()
end)

local function EndPopup:ctor(type)
	self.type = type

	self:initUI()
end

local function EndPopup:initUI()
	local back = cc.Sprite:create()
	back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)

    
end

return EndPopup