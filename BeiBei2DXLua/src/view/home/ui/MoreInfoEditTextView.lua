-- 修改文本的界面
-- Author: whe
-- Date: 2015-05-05 15:15:22
--
local MoreInfoEditTextView = class("MoreInfoEditTextView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	layerHoldTouch(layer)
	return layer
end)

function MoreInfoEditTextView:ctor()
	self:initUI()
end

function MoreInfoEditTextView:initUI()
	self:setTouchEnabled(true)
	self:setSwallowsTouches(true)
	print("self:isSwallowTouches():"..tostring(self:isSwallowsTouches()))
	--标题
	local title = cc.Label:createWithSystemFont("修改信息","",60)
	title:setTextColor(cc.c3b(121,200,247))
	self.title = title
	-- self.title:setPosition(position)
	self:addChild(self.title)
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	-- self.btnReturn:setPosition(position)
	self:addChild(self.btnReturn)
end

--设置回调
--data 文本
--callback 修改完成的回调
function MoreInfoEditTextView:setData(data,callback)
	self.data = data
	self.callback = callback
end

--返回按钮点击
function MoreInfoEditTextView:onReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	if self.callback ~= nil then
		self.callback()
	end
end

return MoreInfoEditTextView