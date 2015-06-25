-- 矩阵
local MatView = class("MatView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function MatView.create()
	return MatView.new()
end

function MatView:ctor()
	self.size = cc.p(0,0)
	self.coco = {}

	-- 初始化ui
	self:initUI()
end

function MatView:initUI()
	-- 砖块矩阵5*5
	-- 坐标（1，1）到坐标（5，5）

	local back = cc.Sprite:create()
	back:setPosition(cc.p(0,0))
	back:ignoreAnchorPointForPosition(false)
	back:setAncherPoint(0.5,0.5)
	self.back = back 
	self:addChild(self.back)

	for i=1,5 do
		for j=1,5 do

		end
	end
end

return MatView