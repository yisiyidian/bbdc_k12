-- 修改文本的界面
-- Author: whe
-- Date: 2015-05-05 15:15:22
--
local InputNode = require("view.login.InputNode")

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
	title:setPosition(s_DESIGN_WIDTH*0.5,s_DESIGN_HEIGHT*0.9)
	self:addChild(title)
	self.title = title
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	self.btnReturn:setPosition(s_DESIGN_WIDTH*0.1,s_DESIGN_HEIGHT*0.9)
	self:addChild(self.btnReturn)
	--输入框
	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入",nil,nil,nil,nil,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	-- inputNode:openIME()
	local btnConfirm = ccui.Button:create("image/login/sl_button_confirm.png")
	btnConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	btnConfirm:addTouchEventListener(handler(self, self.onConfirmTouch))
	btnConfirm:setTitleText("确 定")
	btnConfirm:setTitleFontSize(36)
	self:addChild(btnConfirm)
end

--设置回调
--key s_CURRENT_USER里的键值
--data 	文本
--title 
--closeCallBack 关闭的回调  会触发移动 会触发render里的修改内容
--check 验证合法性的函数
function MoreInfoEditTextView:setData(key,data,title,closeCallBack,check)
	self.key = key
	self.data = data
	self.titleText = title
	self.closeCallBack = closeCallBack
	self.check = check
	--TODO 设置占位文本

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
	--验证文本合法性
	local text = self.inputNode:getText()
	if text == "" then
		s_TIPS_LAYER:showSmallWithOneButton("文本不能为空!")
		return
	end

	if self.check ~= nil then
		local result,tip = self.check(text)
		if not result then
			print("昵称格式不符合")
			print(tip)
			s_TIPS_LAYER:showSmallWithOneButton(tip)
			return
		end
	end

	--关闭回调
	--MoreInformationView里的onEditClose
	if self.closeCallBack ~= nil then
		self.closeCallBack(self.key,self.type,text)
	end
end


return MoreInfoEditTextView