-- 修改日期的界面
-- Author: whe
-- Date: 2015-05-05 15:15:52
--
local InputNode = require("view.login.InputNode")

local MoreInfoEditDateView = class("MoreInfoEditDateView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	layerHoldTouch(layer) --让触摸事件不向下穿透,相当于让本层layer模态
	return layer
end)

function MoreInfoEditDateView:ctor()
	self:initUI()
end

--
function MoreInfoEditDateView:initUI()
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
	
	--输入框 年份
	local inputNodeYear = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入年份",nil,nil,nil,nil,11)
	inputNodeYear:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNodeYear)
	self.inputNodeYear = inputNodeYear
	--输入框 月份
	local inputNodeMonth = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入月份",nil,nil,nil,nil,11)
	inputNodeMonth:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	self:addChild(inputNodeMonth)
	self.inputNodeMonth = inputNodeMonth
	--日期
	local inputNodeDay = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入日期",nil,nil,nil,nil,11)
	inputNodeDay:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 400)
	self:addChild(inputNodeDay)
	self.inputNodeDay = inputNodeDay

	local btnConfirm = ccui.Button:create("image/login/sl_button_confirm.png")
	btnConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 500)
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
function MoreInfoEditDateView:setData(key,data,title,closeCallBack,check)
	self.key = key
	self.data = data
	self.titleText = title
	self.closeCallBack = closeCallBack
	self.check = check

	self.title:setString("修改"..self.titleText)
end

--确定按钮触摸
function MoreInfoEditDateView:onConfirmTouch(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	local year = self.inputNodeYear:getText()	--年
	local month = self.inputNodeMonth:getText()	--月
	local day = self.inputNodeDay:getText()		--日

	if year == "" then
		s_TIPS_LAYER:showSmallWithOneButton("年份不能为空！")
		return
	end
	if month == "" then
		s_TIPS_LAYER:showSmallWithOneButton("月份不能为空！")
		return
	end
	if day == "" then
		s_TIPS_LAYER:showSmallWithOneButton("日期不能为空！")
		return
	end

	if year:match("^%d%d%d%d$") then
		local y = tonumber(year)
		local nowYear = tonumber(os.data("%Y",os.time()))
		if y > nowYear or y < 1900 then
			s_TIPS_LAYER:showSmallWithOneButton("无效的年份")	
		end
	else
		s_TIPS_LAYER:showSmallWithOneButton("年份格式不正确")
	end
	
	--TODO
end



return MoreInfoEditDateView