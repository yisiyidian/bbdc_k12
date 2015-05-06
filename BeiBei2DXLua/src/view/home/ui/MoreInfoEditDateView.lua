-- 修改日期的界面
-- Author: whe
-- Date: 2015-05-05 15:15:52
--
local MoreInfoEditDateView = class("MoreInfoEditDateView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)


function MoreInfoEditDateView:ctor()
	self:initUI()
end


function MoreInfoEditDateView:initUI()
	-- body
end

--设置回调
--data 日期 字符串类型  2015-01-30
--callback 回调
function MoreInfoEditDateView:setData(data,callback)
	self.data = data
	self.callback = callback
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


return MoreInfoEditDateView