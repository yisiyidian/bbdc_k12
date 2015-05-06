-- 性别选择界面
-- Author: whe
-- Date: 2015-05-05 15:15:35
--

local MoreInfoEditSexView = class("MoreInfoEditSexView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)


function MoreInfoEditSexView:ctor()
	self:initUI()
end


function MoreInfoEditSexView:initUI()
	self:setTouchEnabled(true)
	self:setSwallowsTouches(true)
	--标题
	local title = cc.Label:createWithSystemFont("修改信息","",60)
	title:setTextColor(cc.c3b(121,200,247))
	title:setPosition(s_DESIGN_WIDTH*0.5,s_DESIGN_HEIGHT*0.9)
	self:addChild(title)
	self.title = title
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	self.btnReturn:setPosition(s_DESIGN_WIDTH*0.1,s_DESIGN_HEIGHT*0.9)
	self:addChild(self.btnReturn)
	
	local btnConfirm = ccui.Button:create("image/login/sl_button_confirm.png")
	btnConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	btnConfirm:addTouchEventListener(handler(self, self.onConfirmTouch))
	btnConfirm:setTitleText("确 定")
	btnConfirm:setTitleFontSize(36)
	self:addChild(btnConfirm)
end

--设置回调
--data  性别数据 0 女  1 男
function MoreInfoEditSexView:setData(key,data,title,closeCallBack,check)
	self.key = key
	self.data = data
	self.titleText = title
	self.closeCallBack = closeCallBack
	self.check = check
	self.title:setString("修改"..self.titleText)
end

--返回按钮点击
function MoreInfoEditTextView:onReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	if self.closeCallBack ~= nil then
		self.closeCallBack()
	end
end
--确定按钮点击
function MoreInfoEditTextView:onConfirmTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	

	-- local text = self.inputNode:getText()
	-- if text == "" then
	-- 	s_TIPS_LAYER:showSmallWithOneButton("文本不能为空!")
	-- 	return
	-- end

	-- if self.check ~= nil then
	-- 	local result,tip = self.check(text)
	-- 	if not result then
	-- 		s_TIPS_LAYER:showSmallWithOneButton(tip)
	-- 		return
	-- 	end
	-- end

	-- if self.closeCallBack ~= nil then
	-- 	self.closeCallBack(self.key,self.type,text)
	-- end
end


return MoreInfoEditSexView