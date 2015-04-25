--帐号注册界面
--玩家首次登陆的时候会触发显示
--在个人信息界面也会触发

--统一流程去管理
--在一个view下实现多步操作

--输入框封装
local InputNode = require("view.login.InputNode")


local RegisterAccountView = class("RegisterAccountView",function()
	local layout = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	--layout:ignoreAnchorPointForPosition(false)
	--layout:setPosition(0.5 * s_DESIGN_WIDTH,0)
	return layout
end)

--首次登陆执行的流程
RegisterAccountView.STEP_1 = 1 	--输入手机号
RegisterAccountView.STEP_2 = 2	--输入验证码
RegisterAccountView.STEP_3 = 3	--选择性别
RegisterAccountView.STEP_4 = 4	--输入昵称
RegisterAccountView.STEP_5 = 5	--输入密码

RegisterAccountView.STEP_6 = 6	--登陆
RegisterAccountView.STEP_7 = 7	--修改密码
RegisterAccountView.STEP_8 = 8	--密码找回


--构造
function RegisterAccountView:ctor()
	self:init()
end

--初始化各个view
function RegisterAccountView:init()
	self.views = {}
	self.curStep = 1
	self.phoneNumber = ""
	--初始化UI

	--标题 “注册”
	local title = cc.Label:createWithSystemFont("注 册","",60)
	title:setTextColor(cc.c3b(121,200,247))
	title:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9)
	self:addChild(title)
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:setPosition(0.1*s_DESIGN_WIDTH,0.9*s_DESIGN_HEIGHT)
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self:addChild(btnReturn)
	--tip 注册可以和更多好友一起背单词
	local tip = cc.Label:createWithSystemFont("注册可以和更多好友一起背单词","",26)
	tip:setTextColor(cc.c3b(115,115,115))
	tip:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 60)
	self.tip = tip
	self:addChild(tip)
	--alert tip 错误提示文本
	local alertTip = cc.Label:createWithSystemFont(" ","",26)
	alertTip:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 90)
	self.alertTip = alertTip
	self:addChild(alertTip)

	--[[
	local alertICON = cc.Sprite:create("")
	alertICON:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 30)
	self.alertICON = alertICON
	self:addChild(alertICON)
	]]
	--进入第一步
	self:goStep(self.curStep)
end

--返回按钮点击
function RegisterAccountView:onReturnClick(sender,eventType)
	-- body
	if eventType == ccui.TouchEventType.ended then
		--在HomeLayer里赋值的close函数 临时函数
		print("从注册界面返回")
		sender:setEnabled(false)
		self.close()
	end
end

--前往第几步
--step 步骤索引
function RegisterAccountView:goStep(step,...)
	local args = {...}
	self:resetView()
	--处理UI切换
	if step == RegisterAccountView.STEP_1 then
		self:showInputPhoneNumber(args)
	elseif step == RegisterAccountView.STEP_2 then
		self:showInputSmsCode(args)
	elseif step == RegisterAccountView.STEP_3 then
		self:showChooseSex(args)
	elseif step == RegisterAccountView.STEP_4 then
		self:showInputPwd(args)
	end
end

--------------------------------UI-------------------
--image/login/white_shurukuang_zhuce.png
--image/signup/shuru_bbchildren_white.png
--image/login/sl_username.png
--image/login/sl_password.png

--显示输入手机号码的界面
function RegisterAccountView:showInputPhoneNumber()
	--手机号码输入
	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入您的手机号",nil,nil,nil,nil,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	-- cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)

	local btnPhoneNumberOK = ccui.Button:create("image/login/sl_button_confirm.png")
	btnPhoneNumberOK:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	btnPhoneNumberOK:addTouchEventListener(handler(self, self.onTouchPhoneNumberOK))
	btnPhoneNumberOK:setTitleText("下一步")
	btnPhoneNumberOK:setTitleFontSize(36)
	self:addChild(btnPhoneNumberOK)
	self.views[#self.views+1] = btnPhoneNumberOK
end

--电话号码输入OK
function RegisterAccountView:onTouchPhoneNumberOK(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	-- 验证手机号码^1[3|4|5|8][0-9]%d%d%d%d%d%d%d%d$
	local phoneNumber = self.inputNode:getText()
	if string.find(phoneNumber,"^1[3|4|5|8][0-9]%d%d%d%d%d%d%d%d$") then
		--是手机号码
		self.phoneNumber = phoneNumber
		self:requestSMSCode(phoneNumber)
		--跳转到输入验证码的界面
		self.curStep = self.curStep + 1
		self:goStep(self.curStep)
	else
		--不是手机号码
		--TODO icon
		self.alertTip:setTextColor(cc.c3b(220, 57, 8))
		self.alertTip:setString("请输入有效的手机号码！")
	end
end


--显示输入验证码的界面
function RegisterAccountView:showInputSmsCode(args)
	local countDown
	if args ~= nil then
	end

	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入验证码",nil,nil,nil,nil,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	-- cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)

	local btnSMSCodeOK = ccui.Button:create("image/login/sl_button_confirm.png")
	btnSMSCodeOK:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	btnSMSCodeOK:addTouchEventListener(handler(self, self.onTouchSMSCodeOK))
	btnSMSCodeOK:setTitleText("下一步")
	btnSMSCodeOK:setTitleFontSize(36)
	self:addChild(btnSMSCodeOK)
	self.views[#self.views+1] = btnSMSCodeOK
end

function RegisterAccountView:onTouchSMSCodeOK(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	local SMSCode = self.inputNode:getText()
	if string.find(SMSCode,"^%d%d%d%d%d%d$") then
		--是手机号码
		self.SMSCode = SMSCode
		--向服务器请求验证 验证码
		self:verifySMSCode(self.phoneNumber,self.SMSCode)
		-- self:requestSMSCode(SMSCode)
		--跳转到输入验证码的界面
		self.curStep = self.curStep + 1
		self:goStep(self.curStep)
	else
		--不是手机号码
		--TODO icon
		self.alertTip:setTextColor(cc.c3b(220, 57, 8))
		self.alertTip:setString("请输入有效的验证码！")
	end
end

--显示选择性别的界面
function RegisterAccountView:showChooseSex()

end

--显示输入密码的界面
function RegisterAccountView:showInputPwd()
	
end


--------------------------------API-------------------

--结束注册
function RegisterAccountView:endRegister()
	-- body
end

--请求手机验证码
--phoneNumber 	电话号码
function RegisterAccountView:requestSMSCode(phoneNumber)
	print("请求验证码")
	--TODO test 
	--cx.CXAvos:getInstance():requestSMSCode(phoneNumber)
	--这里是木有回调的
end

--验证手机验证码
function RegisterAccountView:verifySMSCode(phoneNumber,smsCode)
	print("验证手机验证码："..phoneNumber.." code:"..smsCode)
	cx.CXAvos:getInstance():verifySMSCode(phoneNumber, smsCode,handler(self, self.onVerifySMSCodeCallBack))
end
--验证手机验证码  返回回调
function RegisterAccountView:onVerifySMSCodeCallBack(error,errorCode)
	dump(error,"错误信息")
	dump(errorCode,"错误码")
	if errorCode~= 0 then
		--有错误
		self.alertTip:setString(error..":"..errorCode)
	else
		self.curStep = self.curStep + 1
		self:goStep(self.curStep)
	end
end

--开始注册
function RegisterAccountView:register()
	
end

--注册返回 回调
function RegisterAccountView:onRegisterCallBack()
	
end

--重置界面
function RegisterAccountView:resetView()
	for k,v in pairs(self.views) do
		v:removeFromParent()
	end

	self.views = {}
end

return RegisterAccountView

