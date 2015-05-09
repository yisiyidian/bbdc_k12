--帐号注册界面
--玩家首次登陆的时候会触发显示
--在个人信息界面也会触发

--统一流程去管理
--在一个view下实现多步操作

--返回按钮、标题、提示文本是公用的 输入框，下一步按钮是在每个函数里各自定义的

--self.debug = true 开启调试模式，调试模式不会向手机发送验证码，手机号码和验证码随便输入

--输入框封装
local InputNode = require("view.login.InputNode")

local RegisterAccountView = class("RegisterAccountView",function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)

--标志
-- IconShow = false

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
function RegisterAccountView:ctor(step)
	self:init(step)
	self.debug = true
end

function RegisterAccountView:showErrorIcon()
	if self.errorIcon == nil then
		local errorIcon = cc.Sprite:create("image/login/error_zhuce.png")
		errorIcon:setPosition(0.5 * s_DESIGN_WIDTH - 100,s_DESIGN_HEIGHT * 0.9 - 90)
		self:addChild(errorIcon)
		self.errorIcon = errorIcon
	else
		self.errorIcon:setVisible(true)
	end
end

function RegisterAccountView:hideErrorICON()
	if self.errorIcon then
		self.errorIcon:setVisible(false)
	end
end

--初始化各个view
function RegisterAccountView:init(step)
	self.views = {}
	self.curStep = step or 1
	self.phoneNumber = ""
	--初始化UI
	--标题 “注册”
	local title = cc.Label:createWithSystemFont("注 册","",60)
	title:setTextColor(cc.c3b(110,182,240))
	title:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9)
	self.title = title
	self:addChild(title)
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back2.png")
	btnReturn:setPosition(0.1*s_DESIGN_WIDTH,0.93*s_DESIGN_HEIGHT)
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self:addChild(btnReturn)
	--tip 注册可以和更多好友一起背单词
	local tip = cc.Label:createWithSystemFont("注册可以和更多好友一起背单词","",26)
	tip:setTextColor(cc.c3b(118,123,124))
	tip:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 60)
	self.tip = tip
	self:addChild(tip)
	--alert tip 提示文本 提示应该输入什么
	local alertTip = cc.Label:createWithSystemFont(" ","",20)
	alertTip:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 90)
	alertTip:setTextColor(cc.c3b(140, 139, 139))
	self.alertTip = alertTip
	self:addChild(alertTip)
	--进入第一步
	self:goStep(self.curStep)
end

--返回按钮点击
function RegisterAccountView:onReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	self.curStep = self.curStep - 1
	--在HomeLayer里赋值的close函数 临时函数
	if self.curStep == 0 then
		print("从注册界面返回")
		sender:setEnabled(false)
		self:endRegister()
	else
		self:goStep(self.curStep)
	end
end

--前往第几步
--step 步骤索引
function RegisterAccountView:goStep(step,...)
	local args = {...}
	self:resetView()
	self.alertTip:setString("")
	--处理UI切换
	if step == RegisterAccountView.STEP_1 then
		self:showInputPhoneNumber(args)-----------------注册：输入手机号
	elseif step == RegisterAccountView.STEP_2 then
		self:showInputSmsCode(args)---------------------注册：输入短信验证码
	elseif step == RegisterAccountView.STEP_3 then
		self:showChooseSex(args)------------------------注册：选择性别
	elseif step == RegisterAccountView.STEP_4 then
		self:showInputNickName(args)--------------------注册：输入昵称
	elseif step == RegisterAccountView.STEP_5 then
		self:showInputPwd(args)-------------------------注册：输入密码
	elseif step == RegisterAccountView.STEP_6 then
		self:showLoginView(args)------------------------登陆界面
	elseif step == RegisterAccountView.STEP_7 then
		self:showModifyPwdView(args)--------------------修改密码
	elseif step == RegisterAccountView.STEP_8 then
		self:showModifyPwdBySMSCode(args)---------------重置密码
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

	local btnPhoneNumberOK = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnPhoneNumberOK:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 330)
	btnPhoneNumberOK:addTouchEventListener(handler(self, self.onTouchPhoneNumberOK))
	btnPhoneNumberOK:setTitleText("下一步")
	btnPhoneNumberOK:setTitleFontSize(36)
	self:addChild(btnPhoneNumberOK)
	self.views[#self.views+1] = btnPhoneNumberOK

	self.alertTip:setString("输入手机号码")
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
		
		if not self.debug then
			self:requestSMSCode(phoneNumber)
		end
		--跳转到输入验证码的界面 直接跳过去
		self.curStep = self.curStep + 1
		self:goStep(self.curStep,60) --60秒
	else
		--不是手机号码
		s_TIPS_LAYER:showSmallWithOneButton("请输入有效的手机号码！")
	end
end

--显示输入验证码的界面
function RegisterAccountView:showInputSmsCode(args)
	local countDown = args and tonumber(args[1]) or 0
	print("countDown:"..countDown)

	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入验证码",nil,nil,nil,nil,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode

	local btnSMSCodeOK = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnSMSCodeOK:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 330)
	btnSMSCodeOK:addTouchEventListener(handler(self, self.onTouchSMSCodeOK))
	btnSMSCodeOK:setTitleText("下一步")
	btnSMSCodeOK:setTitleFontSize(36)
	self:addChild(btnSMSCodeOK)
	self.views[#self.views+1] = btnSMSCodeOK

	--重试按钮 点击重新请求验证码 间隔60S
	local btnRetry = ccui.Button:create("image/login/login_50s_send.png")
	btnRetry:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 460)
	btnRetry:addTouchEventListener(handler(self, self.onRetrySMSTouch))
	btnRetry:setTitleColor(cc.c3b(153,168,181))
	btnRetry:setTitleText("60秒重新发送")
	btnRetry:setTitleFontSize(36)
	btnRetry:setTouchEnabled(false)
	self:addChild(btnRetry)
	self.btnRetry = btnRetry
	self.views[#self.views+1] = btnRetry

	if countDown ~= 0 then
		--倒计时 请求验证码
		self:startSMSTick(countDown)
	end

	self.alertTip:setString("输入验证码")
end

--开始倒计时
function RegisterAccountView:startSMSTick(countDown)
	if countDown ~= 0 then
		--倒计时 请求验证码
		self.countDown = countDown
		print(self.scheduler)
		if self.scheduler == nil then
			self.scheduler = cc.Director:getInstance():getScheduler()
			self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.SMSCodeTick),1,false)
			self.btnRetry:loadTextureNormal("image/login/login_50s_send.png",ccui.TextureResType.localType)
			self.btnRetry:setTitleText(tostring(self.countDown).."秒重新发送")
		end
	end
end

--倒计时调用
function RegisterAccountView:SMSCodeTick()
	self.countDown = self.countDown - 1
	if self.countDown == 0 then
		self.scheduler:unscheduleScriptEntry(self.schedulerID)
		self.scheduler = nil
		self.schedulerID = nil
		
		if self.btnRetry and not tolua.isnull(self.btnRetry) then
			self.btnRetry:setTouchEnabled(true)
			self.btnRetry:setTitleText("")
			--换按钮皮肤
			self.btnRetry:loadTextureNormal("image/login/button_sendagain_zhuce.png",ccui.TextureResType.localType)
		end
	else
		if self.btnRetry and not tolua.isnull(self.btnRetry) then
			self.btnRetry:setTitleText(tostring(self.countDown).."秒重新发送")
		end
	end
end

--重新请求验证码按钮触摸
function RegisterAccountView:onRetrySMSTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	if not self.debug then
		self:requestSMSCode(self.phoneNumber)
	end

	self:startSMSTick(50)
end

function RegisterAccountView:onTouchSMSCodeOK(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local SMSCode = self.inputNode:getText()
	if string.find(SMSCode,"^%d%d%d%d%d%d$") then
		self.SMSCode = SMSCode
		--验证网络状况
		if not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then
        	s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        	return
        end
		--向服务器请求验证 验证码
		if not self.debug then
			self:verifySMSCode(self.phoneNumber,self.SMSCode)
		else
			self.curStep = self.curStep + 1
			self:goStep(self.curStep)
		end
	else
		--验证码无效
		s_TIPS_LAYER:showSmallWithOneButton("请输入有效的验证码！")
		
		
	end
end

--显示选择性别的界面
function RegisterAccountView:showChooseSex()
	self.alertTip:setString("")
	local girlImg = "image/login/gril_head.png"
	local boyImg = "image/login/boy_head.png"

	local headImg = cc.Sprite:create(boyImg)
	--local headImg = cc.Sprite:create("image/homescene/setup_head.png")
	headImg:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self.views[#self.views + 1] = headImg
	self.headImg = headImg
	self:addChild(headImg)
	--checkbox回调
	local chkCallBack = function (self,sender,eventType)
		local checkName = sender:getName()
		local state = eventType == 0 or false
		print("eventType:"..eventType)
		if eventType == ccui.CheckBoxEventType.selected then
			print("eventType:"..eventType)
		elseif eventType == ccui.CheckBoxEventType.unselected then
			print("eventType:"..eventType)
		end
		print("checkName:"..checkName)
		if checkName == "Male" and state then
			print("禁用自己："..checkName)
			self.headImg:setTexture(boyImg)
			self.checkBoxMale:setTouchEnabled(false) --禁用自己
			self.checkBoxFeMale:setTouchEnabled(true) --启用另外一个
			self.checkBoxFeMale:setSelected(false)
		elseif checkName == "Female" and state then
			self.headImg:setTexture(girlImg)
			self.checkBoxMale:setTouchEnabled(true) --启用另外一个
			self.checkBoxFeMale:setTouchEnabled(false) --禁用自己
			self.checkBoxMale:setSelected(false)
		end
	end

	--性别复选框 男
	local checkBoxMale = ccui.CheckBox:create()
	checkBoxMale:setTouchEnabled(false)
	checkBoxMale:setName("Male")
	checkBoxMale:loadTextures(
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal press
		"image/login/button_boygirl_zhuce.png",--normal active
		"image/login/button_boygirl_gray_zhuce_unpressed.png",-- normal disable
		"image/login/button_boygirl_gray_zhuce_unpressed.png"--active disable
		)
	checkBoxMale:addEventListener(handler(self, chkCallBack))
	checkBoxMale:setPosition(0.5 * s_DESIGN_WIDTH - 100,s_DESIGN_HEIGHT*0.6 - 50)
	checkBoxMale:setSelected(true)	--默认选中
	self.checkBoxMale = checkBoxMale
	self:addChild(checkBoxMale)
	self.views[#self.views+1] = checkBoxMale

	local labelMan = cc.Label:createWithSystemFont("♂ 男","",30)
	labelMan:setPosition(checkBoxMale:getContentSize().width/2,checkBoxMale:getContentSize().height/2)
	checkBoxMale:addChild(labelMan)
	--女
	local checkBoxFeMale = ccui.CheckBox:create()
	checkBoxFeMale:setTouchEnabled(true)
	checkBoxFeMale:setName("Female")
	checkBoxFeMale:loadTextures(
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal press
		"image/login/button_boygirl_zhuce.png",--normal active
		"image/login/button_boygirl_gray_zhuce_unpressed.png",-- normal disable
		"image/login/button_boygirl_gray_zhuce_unpressed.png"--active disable
		)
	checkBoxFeMale:addEventListener(handler(self, chkCallBack))
	checkBoxFeMale:setPosition(0.5 * s_DESIGN_WIDTH + 100,s_DESIGN_HEIGHT*0.6 - 50)
	self.checkBoxFeMale = checkBoxFeMale
	self:addChild(checkBoxFeMale)
	self.views[#self.views+1] = checkBoxFeMale

	local labelWomen = cc.Label:createWithSystemFont("♀ 女","",30)
	labelWomen:setPosition(checkBoxFeMale:getContentSize().width/2,checkBoxFeMale:getContentSize().height/2)
	checkBoxFeMale:addChild(labelWomen)

	local btnSexOK = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnSexOK:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.6 - 180)
	btnSexOK:addTouchEventListener(handler(self, self.onTouchSexOK))
	btnSexOK:setTitleText("下一步")
	btnSexOK:setTitleFontSize(36)
	self:addChild(btnSexOK)
	self.views[#self.views+1] = btnSexOK

	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
end

--选择性别确定
function RegisterAccountView:onTouchSexOK(sender,eventType)
	--获取性别 女0  男1
	self.sex = self.checkBoxFeMale:isSelected() and 0 or 1
	self.curStep = self.curStep + 1
	self:goStep(self.curStep)
end

--显示输入昵称
function RegisterAccountView:showInputNickName()
	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入昵称",nil,nil,nil,nil,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode

	local btnNickName = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnNickName:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 330)
	btnNickName:addTouchEventListener(handler(self, self.onTouchNickNameOK))
	btnNickName:setTitleText("下一步")
	btnNickName:setTitleFontSize(36)
	self:addChild(btnNickName)
	self.views[#self.views+1] = btnNickName
end

--昵称按钮触摸事件
function RegisterAccountView:onTouchNickNameOK(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	--验证昵称合法性
	local nickName = self.inputNode:getText()
	if nickName == "" then
		s_TIPS_LAYER:showSmallWithOneButton("昵称不能为空！")
		return
	end

	--昵称合法
	self.nickName =  nickName

	self.curStep = self.curStep + 1
	self:goStep(self.curStep)
end

--显示输入密码的界面
function RegisterAccountView:showInputPwd()
	self.alertTip:setString("输入密码")

	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","请设置密码",nil,nil,nil,true,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	
	local inputNodeV = InputNode.new("image/signup/shuru_bbchildren_white.png","请确认密码",nil,nil,nil,true,11)
	inputNodeV:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 330)
	self:addChild(inputNodeV)
	self.inputNodeV = inputNodeV
	self.views[#self.views+1] = inputNodeV
	
	-- cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)
	local btnRegister = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnRegister:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 460)
	btnRegister:addTouchEventListener(handler(self, self.onTouchRegister))
	btnRegister:setTitleText("完成注册")
	btnRegister:setTitleFontSize(36)
	self:addChild(btnRegister)
	self.views[#self.views+1] = btnRegister
end

--注册Touch点击
function RegisterAccountView:onTouchRegister(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	local pwd = self.inputNode:getText()
	local pwdVerify = self.inputNodeV:getText()

	if pwd == "" or pwdVerify == "" then
		s_TIPS_LAYER:showSmallWithOneButton("密码不能为空！")
		return
	elseif pwd ~= pwdVerify then
		s_TIPS_LAYER:showSmallWithOneButton("两次密码不一致！")
		return
	elseif not validatePassword(pwd) then
		--密码不合规范
		s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))
	else
		-- do nothing
	end

	--注册
	self:register(self.phoneNumber,pwd,self.nickName)
end

--显示登陆界面
function RegisterAccountView:showLoginView( ... )
	self.title:setString("登 录")
	self.tip:setString("登录可以和更多好友一起背单词")

	local inputNodeID = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入手机号",nil,nil,nil,false,11)
	inputNodeID:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 170)
	self:addChild(inputNodeID)
	self.inputNodeID = inputNodeID
	inputNodeID:openIME()
	self.views[#self.views+1] = inputNodeID
	
	local inputNodePwd = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入密码",nil,nil,nil,true,11)
	inputNodePwd:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	self:addChild(inputNodePwd)
	self.inputNodePwd = inputNodePwd
	self.views[#self.views+1] = inputNodePwd

	local btnLogin = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnLogin:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 430)
	btnLogin:addTouchEventListener(handler(self, self.onLoginTouch))
	btnLogin:setTitleText("登 录")
	btnLogin:setTitleFontSize(36)
	self:addChild(btnLogin)
	self.views[#self.views+1] = btnLogin
end

--登陆按钮点击事件
function RegisterAccountView:onLoginTouch(sender,eventType)
	local id 	= self.inputNodeID:getText()
	local pwd 	= self.inputNodePwd:getText()

	if id == "" or pwd == "" then
		s_TIPS_LAYER:showSmallWithOneButton("帐号和密码不能为空！")
		return
	end

	--验证密码
	if validatePassword(pwd) == false then
        s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))
        return
    end

	--验证id是手机还是用户名
	--区分类型 然后走两个不同的登录接口
	if string.find(id,"^1[3|4|5|8][0-9]%d%d%d%d%d%d%d%d$") then
		--手机号码登陆
		s_O2OController.logInOnline(id, pw , true)
	else
		--username登陆
		if validateUsername(id) == false then
        	s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR))
        	return
    	end
		--登陆
    	s_O2OController.logInOnline(id, pwd)
	end
end

--显示修改密码界面
function RegisterAccountView:showModifyPwdView( ... )
	
end

--显示密码找回界面
--通过手机验证码 重置密码
--TODO要想实现手机验证码重置密码，必须验证手机号，验证码是注册的时候，服务器自动发的，目前服务器没开手机号码验证，开启之后会自动发短信
function RegisterAccountView:showModifyPwdBySMSCode( ... )
	
end

--------------------------------API-------------------

--请求手机验证码
--phoneNumber 	电话号码
function RegisterAccountView:requestSMSCode(phoneNumber)
	print("请求验证码")
	if not self.debug then
		cx.CXAvos:getInstance():requestSMSCode(phoneNumber)
	end
end

--验证手机验证码
function RegisterAccountView:verifySMSCode(phoneNumber,smsCode)
	print("验证手机验证码："..phoneNumber.." code:"..smsCode)
	showProgressHUD('', true)
	if not self.debug then
		cx.CXAvos:getInstance():verifySMSCode(phoneNumber, smsCode,handler(self, self.onVerifySMSCodeCallBack))
	end
end
--验证手机验证码  返回回调
--error 	错误消息
--errorCode 错误号
function RegisterAccountView:onVerifySMSCodeCallBack(error,errorCode)
	hideProgressHUD(true)
	if errorCode~= 0 then
		s_TIPS_LAYER:showSmallWithOneButton(error)
	else
		self.curStep = self.curStep + 1
		--60秒之后再重试
		self:goStep(self.curStep)
	end
end

--开始注册
--phoneNumber 	就是手机号码
--pwd 			密码
--nickName 		昵称
function RegisterAccountView:register(phoneNumber,pwd,nickName)
	print("电话号码:"..phoneNumber)
	print("密码:"..pwd)
	print("昵称:"..nickName)
	print("请求注册....")
	showProgressHUD('', true)

	s_UserBaseServer.updateLoginInfo(nickName,pwd,phoneNumber,handler(self,self.onRegisterCallBack))
end

--注册返回 回调
--nickName 		昵称
--pwd 			密码
--phoneNumber 	就是手机号码
--error 错误信息
--error 错误号
function RegisterAccountView:onRegisterCallBack(nickName,pwd,phoneNumber,error,errorCode)
	hideProgressHUD(true)
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
	if errorCode ~= 0 then
		s_TIPS_LAYER:showSmallWithOneButton(error)
		return
	end
	self:endRegister(true)
end

--结束注册
--state是否是注册成功
function RegisterAccountView:endRegister(state)
	print("结束注册 注册成功 进入游戏")
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
	--登陆
	print("s_O2OController.logInOnline id:"..s_CURRENT_USER.username)
	print("s_O2OController.logInOnline pwd:"..s_CURRENT_USER.password)

	if self.scheduler then 
		self.scheduler:unscheduleScriptEntry(self.schedulerID)
		self.scheduler = nil
		self.schedulerID = nil
	end

	if state then
		s_SCENE:removeAllPopups()
		s_O2OController.logInOnline(s_CURRENT_USER.username, s_CURRENT_USER.password)
	else
		if self.close ~= nil then
			print("回调close")
			self.close()
		else
			s_SCENE:removeAllPopups()
			print("s_SCENE:removeAllPopups")
		end
	end
end

--重置界面
function RegisterAccountView:resetView()
	for k,v in pairs(self.views) do
		v:removeFromParent()
	end

	self.views = {}
end

return RegisterAccountView

