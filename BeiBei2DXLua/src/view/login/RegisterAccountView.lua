--帐号注册界面 玩家首次登陆的时候会触发显示 在个人信息界面也会触发
--在一个view下实现多步操作
--返回按钮、标题、提示文本是公用的 输入框，下一步按钮是在每个函数里各自定义的
--self.debug = true 开启调试模式，调试模式不会向手机发送验证码，手机号码和验证码随便输入

local InputNode 		= require("view.login.InputNode") --输入框封装
local MissionConfig 	= require("model.mission.MissionConfig") --任务的配置数据
local RegisterAccountView = class("RegisterAccountView",function()
	local layer = cc.Layer:create()
	layerHoldTouch(layer)
	return layer
end)

RegisterAccountView.STEP_1 = 1 	--输入手机号
RegisterAccountView.STEP_2 = 2	--输入验证码
RegisterAccountView.STEP_3 = 3	--选择性别
RegisterAccountView.STEP_4 = 4	--输入昵称
RegisterAccountView.STEP_5 = 5	--输入密码

RegisterAccountView.STEP_6 = 6	--登陆
RegisterAccountView.STEP_7 = 7	--修改密码
RegisterAccountView.STEP_8 = 8	--密码找回

RegisterAccountView.STEP_9 = 9  --新登陆 输入密码

RegisterAccountView.STEP_10 = 10 --选择登陆方式的界面 有注册和登陆2个按钮

RegisterAccountView.STEP_11 = 11 --进入游戏之后 输入手机号    验证手机号码

RegisterAccountView.PWD = 'bbdc123#'

function RegisterAccountView:ctor(step,canclose)
	self.debug = false
	self.direction = ""--"left" "right" 移动方向
	self.uistack = {} --UI的栈,里边保存UI流程序号,UI显示的参数  Android返回键用
	self.curBtn = nil --当前的输入按钮
	self.phoneNumber = ""
	if step ~= "canclose" and step ~= RegisterAccountView.STEP_10 then
  		self:init(step,canclose)
  	elseif step == RegisterAccountView.STEP_10 then
  		--显示选择登陆方式界面
  		self:showIntroView()
		self.uistack[#self.uistack + 1] = {step,{}} --参数入栈
  	else
  		self.canclose = true
      	self:init()
  	end
end

function RegisterAccountView:init(step,args)
	self.inited = true
	self.views = {}
	self.curStep = step or 1 --step 默认是1
	self.phoneNumber = ""
	local bigWidth = s_DESIGN_WIDTH + 2 * s_DESIGN_OFFSET_WIDTH
    local bigHeight = 1.0*s_DESIGN_HEIGHT
	local initColor = cc.LayerColor:create(cc.c4b(220,233,239,255), bigWidth, s_DESIGN_HEIGHT)
    initColor:setAnchorPoint(0.5,0.5)
    initColor:ignoreAnchorPointForPosition(false)  
    initColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    initColor:setTouchEnabled(false)
    self:addChild(initColor)
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
	self.btnReturn = btnReturn
	self:addChild(btnReturn)
	--alert tip 提示文本 提示应该输入什么
	local alertTip = cc.Label:createWithSystemFont(" ","",26)
	alertTip:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 100)
	alertTip:setTextColor(cc.c3b(140, 139, 139))
	self.alertTip = alertTip
	self:addChild(alertTip)
	--进入第一步
	self:goStep(self.curStep,args)
end
--返回按钮点击
function RegisterAccountView:onReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	--返回introlayer 或者结束登陆 修改密码流程
	--从栈里弹出来上一步的参数
	local cmd = self.uistack[#self.uistack - 1]
	if cmd then
    	self.uistack[#self.uistack] = nil
		self.uistack[#self.uistack] = nil
		self.curStep 	= cmd[1]
		local data 		= cmd[2]
	    if type(data) == "table" and #data == 0 then
	      	data = nil
	    end
    	self.direction = "right"
		self:goStep(self.curStep,data)
	elseif self.curStep == RegisterAccountView.STEP_2 and self.smsMode == "verify" then
		self.direction = "right"
		self.curStep = RegisterAccountView.STEP_11
		self:goStep(self.curStep,{})
	else
		sender:setEnabled(false)
		self:endRegister()
	end
end
--前往指定步骤
--step 步骤索引
function RegisterAccountView:goStep(step,...)
	if not self.inited then  --初始化UI
		self:init(step,...)
		return
	end
	local args = {...}
	self.uistack[#self.uistack + 1] = {step,args} --参数入栈
	--处理老的UI
	self:moveOut(self.direction)
	
	self.alertTip:setString("")
	--处理UI切换
	if step == RegisterAccountView.STEP_1 then
		self:showInputPhoneNumber(args)-----------------注册：输入手机号
	elseif step == RegisterAccountView.STEP_2 then
		self:showInputSmsCode(args,"verify")------------注册：输入短信验证码 验证手机号码有效性  登陆进入游戏完成之后 再弹出验证
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
	elseif step == RegisterAccountView.STEP_9 then
		self:showInputSmsCode(args,"smslogin")---------------------登陆：输入短信验证码 用短信验证码登陆
	elseif step == RegisterAccountView.STEP_10 then
		self:showIntroView()
	elseif step == RegisterAccountView.STEP_11 then
		self:showInputPhoneNumber(args,"logined_verify") --登陆之后 验证手机号码
	end
	--处理新的UI 从外部移入
	self:moveIn(self.direction)
end
--重置界面
function RegisterAccountView:resetView()
	for k,v in pairs(self.views) do
		v:removeFromParent()
	end
	self.views = {}
end
--把当前的view 从中间移出去
--direction  方向  left right
function RegisterAccountView:moveOut(direction)
	local detx = 0 --偏移量
	if direction == "left" then
		detx =  -s_DESIGN_WIDTH
	elseif direction == "right" then
		detx =  s_DESIGN_WIDTH
	end

	for key,view in pairs(self.views) do
		if detx ~= 0 then
			local posx,posy = view:getPosition()
			local newPos =  cc.p(posx + detx,posy)
			local moveto = cc.MoveTo:create(0.3,newPos)
			local callback = cc.CallFunc:create(function()
	            view:removeFromParent()
	        end)
	        view:runAction(cc.Sequence:create(moveto,callback))
    	else
    		view:removeFromParent()
    	end
	end
	self.views = {}
end
--从两侧移进来
--direction  方向  left right
function RegisterAccountView:moveIn(direction)
	local detx = 0 --偏移量
	if direction == "left" then
		detx =  s_DESIGN_WIDTH
	elseif direction == "right" then
		detx =  -s_DESIGN_WIDTH
	end

	for key,view in pairs(self.views) do
		if detx ~= 0 then
			local posx,posy = view:getPosition()
			local newPos =  cc.p(posx + detx,posy)
			view:setPosition(newPos.x,newPos.y)
			local moveto = cc.MoveTo:create(0.3,cc.p(posx,posy))
			local callback = cc.CallFunc:create(function()
	            -- view:removeFromParent()
	        end)
	        view:runAction(cc.Sequence:create(moveto,callback))
    	else
    		-- view:removeFromParent()
    	end
	end
end

--------------------------------UI-------------------输入手机号码-------------------------------------------------------------------------------------------------------
--显示输入手机号码的界面
function RegisterAccountView:showInputPhoneNumber(args,type)
	self.processType = type
	--手机号码输入
	local inputNode = InputNode.new("image/signup/shuru_bbchildren_gray.png","image/signup/shuru_bbchildren_white.png","请输入手机号",handler(self,self.ProcessPhoneInput),nil,nil,nil,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH, s_DESIGN_HEIGHT * 0.8 - 200)
	inputNode:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	self.alertTip:setString("输入您的手机号码")
	self.title:setString("登陆/注册")
	--让返回按钮不可点
	if self.canclose then
		self.btnReturn:setVisible(true)
		self.btnReturn:setTouchEnabled(true)
  	else
    	self.btnReturn:setVisible(false)
 		self.btnReturn:setTouchEnabled(false)
	end
	if self.processType ~= "logined_verify" then
		--其他登陆方式
		local btnOtherLogin = ccui.Button:create("image/login/blank_btn.png")
		btnOtherLogin:setPosition(0.8 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 460)
		btnOtherLogin:setTitleColor(cc.c3b(153,168,181))
		btnOtherLogin:setTitleText("其他登陆方式")
		btnOtherLogin:setTitleFontSize(20)
		btnOtherLogin:addTouchEventListener(handler(self, self.onOtherLogin))
		self:addChild(btnOtherLogin)
		self.btnOtherLogin = btnOtherLogin
		self.views[#self.views+1] = btnOtherLogin
		--游客登陆
		local btnGuestLogin = ccui.Button:create("image/login/blank_btn.png")
		btnGuestLogin:setPosition(0.2 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 460)
		btnGuestLogin:setTitleColor(cc.c3b(153,168,181))
		btnGuestLogin:setTitleText("游客登陆")
		btnGuestLogin:setTitleFontSize(20)
		btnGuestLogin:addTouchEventListener(handler(self, self.onGuestLogin))
		self:addChild(btnGuestLogin)
		self.btnGuestLogin = btnGuestLogin
		self.views[#self.views+1] = btnGuestLogin
	end

	if args[1] == "fromIntro" then
		self.title:setString("登陆")
	end

	--下一步按钮  三角的
	local btnPhoneNumberOK = ccui.Button:create("image/shop/button_back2.png")
	btnPhoneNumberOK:setPosition(0.8 * s_DESIGN_WIDTH, s_DESIGN_HEIGHT * 0.8 - 200)
	btnPhoneNumberOK:setScaleX(-1)
	btnPhoneNumberOK:addTouchEventListener(handler(self, self.onTouchPhoneNumberOK))
	self.btnPhoneNumberOK = btnPhoneNumberOK
	self.btnPhoneNumberOK:setVisible(false)
	self.btnPhoneNumberOK:setTouchEnabled(false)
	self.curBtn = self.btnPhoneNumberOK --绑定到curBtn
	self.views[#self.views+1] = btnPhoneNumberOK
	self:addChild(btnPhoneNumberOK)
end

function RegisterAccountView:onOtherLogin(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	print("其他登陆方式")---直接转到帐号密码登陆界面
	self.curStep = RegisterAccountView.STEP_6
	self.direction = "left"
	self.canclose = true
	self:goStep(self.curStep)
end

function RegisterAccountView:onGuestLogin(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	print("其他登陆方式")
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
	s_SCENE:removeAllPopups()
end
--电话号码输入OK
function RegisterAccountView:onTouchPhoneNumberOK(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local phoneNumber = self.inputNode:getText()--验证手机号码^1[3|4|5|8][0-9]%d%d%d%d%d%d%d%d$
	if string.find(phoneNumber,"^1[3|4|5|8][0-9]%d%d%d%d%d%d%d%d$") then  --是手机号码
		self.phoneNumber = phoneNumber
		if not self.debug then
			self:verifyPhoneNumber(phoneNumber)--查询手机号码是否存在
		else
			self.curStep = RegisterAccountView.STEP_2--跳转到输入验证码的界面 直接跳过去
			self.direction = "left"
			self:goStep(self.curStep) --60秒
		end
	else
		--不是手机号码
		s_TIPS_LAYER:showSmallWithOneButton("请输入有效的手机号码！")
	end
end
--验证手机号码是否有效
function RegisterAccountView:verifyPhoneNumber(phoneNumber)
	isPhoneNumberExist(phoneNumber, handler(self, self.onVerifyPhoneNumberBack))
end
--验证手机号码回调
function RegisterAccountView:onVerifyPhoneNumberBack(data,error)
	dump(data,"查询手机号码返回")
	if data.count > 0 then
		-- 1、
		-- 已被注册的手机号码 未验证的 要验证
		-- 验证之后 直接通过手机号码 + 默认密码登陆
		-- 2、
		-- 已注册 已验证的手机号码,调用短信验证码登陆
		-- 此后的登陆,通过手机号码 + 默认密码登陆
		if not data.verify and self.smsMode ~= "verify" then
			--  已被注册的手机号码 未验证的 要验证
			--	转到输入密码的界面
			--	让用户输入密码 登陆
			
			self.curStep = RegisterAccountView.STEP_6 --输入密码的界面
			self.direction = "left"
			self:goStep(self.curStep,self.phoneNumber)
		
		else
			-- 已注册 已验证的手机号码,调用短信验证码登陆
			-- 转到输入登陆验证码的界面
			if not self.debug then
				if self.smsMode == "verify" then
					self:requestVerifySMSCode(self.phoneNumber)
					self.curStep = RegisterAccountView.STEP_2
				else
					self:requestLoginSMSCode(self.phoneNumber)
					self.curStep = RegisterAccountView.STEP_9
				end
			end
			
			self.direction = "left"
			self:goStep(self.curStep)
		end
	elseif self.processType == "logined_verify" then
		--登陆之后的验证
		if not self.nickName then
			self.nickName = "Guest"
		end
		self:register(self.phoneNumber,RegisterAccountView.PWD,self.nickName,0)		
	else
		--不存在的话 直接进游戏  进游戏之后 再选性别、昵称、验证码
		--1、选择性别
		--2、昵称
		--3、班级 (已删掉)
		--4、登陆进入 输入验证码
    	
    	if s_CURRENT_USER.usertype == USER_TYPE_GUEST then
	    	self:register(self.phoneNumber,RegisterAccountView.PWD,"Guest",0)
	    else
			s_TIPS_LAYER:showSmallWithOneButton("该手机号未经注册，请检查您是否输入有误")
		end
		--[[
		self.curStep = RegisterAccountView.STEP_3  --选择性别
		self.direction = "left"
		self:goStep(self.curStep)
		]]
	end
end

--处理输入事件
--text 文本
--length 长度
function RegisterAccountView:ProcessPhoneInput(text,length,maxlength)
	if not tolua.isnull(self.btnPhoneNumberOK) then
		if maxlength == length then
			self.btnPhoneNumberOK:setVisible(true)
			self.btnPhoneNumberOK:setTouchEnabled(true)
		else
			self.btnPhoneNumberOK:setVisible(false)
			self.btnPhoneNumberOK:setTouchEnabled(false)
		end
	end
end
--------------------------------UI-------------------输入手机号码 结束-------------------------------------------------------------------------------------------------------
--------------------------------UI-------------------输入验证码 开始-------------------------------------------------------------------------------------------------------------
--显示输入验证码的界面 RegisterAccountView.STEP_9 RegisterAccountView.STEP_2
function RegisterAccountView:showInputSmsCode(args,type)
	local countDown = 50
	print("countDown:"..countDown)
	self.smsMode = type--verify 验证手机号码有效性 , smslogin SMSCode登陆
	local inputNode = InputNode.new("image/signup/shuru_bbchildren_gray.png","image/signup/shuru_bbchildren_white.png","请输入验证码",handler(self, self.processSMSInput),nil,nil,nil,6)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.8 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	
	local btnSMSCodeOK = ccui.Button:create("image/shop/button_back2.png")
	btnSMSCodeOK:setPosition(0.8 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.8 - 200)
	btnSMSCodeOK:addTouchEventListener(handler(self, self.onTouchSMSCodeOK))
	btnSMSCodeOK:setScaleX(-1)
	btnSMSCodeOK:setTitleFontSize(36)
	self.btnSMSCodeOK = btnSMSCodeOK
	self.btnSMSCodeOK:setVisible(false)
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

	if self.smsMode == "verify" then
		self.btnReturn:setTouchEnabled(true) --禁用返回按钮
		self.btnReturn:setVisible(true)
	end
	
	if countDown ~= 0 then
		--倒计时 请求验证码
		self:startSMSTick(countDown)
	end
	self.alertTip:setString("输入验证码")
end

function RegisterAccountView:processSMSInput(text,length,maxlength)
	if not tolua.isnull(self.btnSMSCodeOK) then
		if maxlength <= length then
			self.btnSMSCodeOK:setVisible(true)
			self.btnSMSCodeOK:setTouchEnabled(true)
		else
			self.btnSMSCodeOK:setVisible(false)
			self.btnSMSCodeOK:setTouchEnabled(false)
		end
	end
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
	if not self.countDown then
		-- self.scheduler:unscheduleScriptEntry(self.schedulerID)
		return
	end
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
		if self.smsMode == "verify" then --区分验证码的格式
			if self.phoneNumber == "" or not self.phoneNumber then
				self.phoneNumber = s_CURRENT_USER.mobilePhoneNumber
			end
			self:requestVerifySMSCode(self.phoneNumber)
		else
			self:requestLoginSMSCode(self.phoneNumber)
		end
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
		-- verify 验证手机号码有效性 , smslogin SMSCode登陆
		if not self.debug then
			if self.smsMode == "verify" then
				--请求验证 【验证手机号】 的验证码
				self:verifySMSCode(self.phoneNumber,self.SMSCode)
			else
				--请求手机+验证码 登陆
				self:loginWithSMS(self.phoneNumber,self.SMSCode)
			end
		else
			self.curStep = self.curStep + 1
			self.direction = "left"
			self:goStep(self.curStep)
		end
	else
		--验证码无效
		s_TIPS_LAYER:showSmallWithOneButton("请输入有效的验证码！")
	end
end

--显示选择性别的界面
function RegisterAccountView:showChooseSex()
	-- self.btnReturn:setTouchEnabled(false) --禁用返回按钮
	-- self.btnReturn:setVisible(false)

	self.alertTip:setString("你是男孩还是女孩？")
	self.title:setString("完善信息")

	local txtStep = cc.Label:createWithSystemFont("1/2","",26)
	txtStep:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 50)
	txtStep:setTextColor(cc.c3b(110,182,240))
	self:addChild(txtStep)
	self.views[#self.views+1] = txtStep

	local btnGirl = ccui.Button:create("image/login/button_boygirl_zhuce.png")
	btnGirl:setPosition(0.5 * s_DESIGN_WIDTH + 100,s_DESIGN_HEIGHT*0.6 - 50)
	btnGirl:addTouchEventListener(handler(self,self.onTouchSexOK))
	btnGirl:setName("btnGirl")
	btnGirl:setTitleText("♀ 女")
	btnGirl:setTitleFontSize(30)
	self:addChild(btnGirl)
	self.views[#self.views+1] = btnGirl

	local btnBoy = ccui.Button:create("image/login/button_boygirl_zhuce.png")
	btnBoy:setPosition(0.5 * s_DESIGN_WIDTH - 100,s_DESIGN_HEIGHT*0.6 - 50)
	btnBoy:addTouchEventListener(handler(self,self.onTouchSexOK))
	btnBoy:setName("btnBoy")
	btnBoy:setTitleText("♂ 男")
	btnBoy:setTitleFontSize(30)
	self.views[#self.views+1] = btnBoy
	self:addChild(btnBoy)
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
end

--选择性别确定
function RegisterAccountView:onTouchSexOK(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	self.btnReturn:setTouchEnabled(true) --启用返回按钮
	self.btnReturn:setVisible(true)
	--获取性别 女0  男1
	local btnName = sender:getName()
	if btnName == "btnGirl" then
		self.sex = 0
	else
		self.sex = 1
	end
	print("sex:"..self.sex)
	s_CURRENT_USER.sex = self.sex
	--第四步  输入昵称
	self.curStep = RegisterAccountView.STEP_4
	self.direction = "left"
	self:goStep(self.curStep)
end

--显示输入昵称
function RegisterAccountView:showInputNickName()
	local girlImg = "image/PersonalInfo/hj_personal_avatar.png"
	local boyImg = "image/PersonalInfo/boy_head.png"
	local headImg = nil
	local tipsex = ""
	if self.sex == 0 then
		tipsex = "girl"
		headImg = cc.Sprite:create(girlImg)	
	else
		tipsex = "boy"
		headImg = cc.Sprite:create(boyImg)
	end
	headImg:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self.headImg = headImg
	self.views[#self.views + 1] = headImg
	self:addChild(headImg)

	local txtStep = cc.Label:createWithSystemFont("2/2","",26)
	txtStep:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9 - 50)
	txtStep:setTextColor(cc.c3b(110,182,240))
	self:addChild(txtStep)
	self.views[#self.views+1] = txtStep

	local inputNode = InputNode.new("image/signup/shuru_bbchildren_white.png","image/signup/shuru_bbchildren_white.png","请输入昵称",handler(self, self.processInputName),nil,nil,nil,8,1)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.75 - 200)
	inputNode:setPlaceHolderColor()
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	--确定昵称按钮
	local btnNickName = ccui.Button:create("image/shop/button_back2.png")
	btnNickName:setPosition(0.8 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.75 - 200)
	btnNickName:addTouchEventListener(handler(self, self.onTouchNickNameOK))
	btnNickName:setScale(-1)
	self:addChild(btnNickName)
	btnNickName:setVisible(false)
	self.btnNickName = btnNickName
	self.views[#self.views + 1] = btnNickName

	local alertTip = cc.Label:createWithSystemFont("输入真实姓名，小伙伴更容易找到你","",26)
	alertTip:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.75 - 130)
	alertTip:setTextColor(cc.c3b(140, 139, 139))
	self:addChild(alertTip)
	self.views[#self.views + 1] = alertTip

	self.alertTip:setString("hi!"..tipsex.."! 这就是你在贝贝里的头像")
end

function RegisterAccountView:processInputName()
	if not tolua.isnull(self.btnNickName) then
		self.btnNickName:setVisible(true)
	end
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
	self.nickName = nickName
	--开始注册 注册完了 验证手机号码
	local pwd = 'bbdc123#'
	if self.smsMode == "verify" then
		self.smsMode = ""
	end
	self:register(self.phoneNumber,pwd,self.nickName,self.sex)
end
--显示输入密码的界面 RegisterAccountView.STEP_5
function RegisterAccountView:showInputPwd()
	local inputNode = InputNode.new("image/signup/shuru_bbchildren_gray.png","image/signup/shuru_bbchildren_white.png","请设置密码",nil,nil,nil,true,11)
	inputNode:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNode)
	self.inputNode = inputNode
	inputNode:openIME()
	self.views[#self.views+1] = inputNode
	
	local inputNodeV = InputNode.new("image/signup/shuru_bbchildren_gray.png","image/signup/shuru_bbchildren_white.png","请确认密码",nil,nil,nil,true,11)
	inputNodeV:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 330)
	self:addChild(inputNodeV)
	self.inputNodeV = inputNodeV
	self.views[#self.views+1] = inputNodeV
	
	local btnRegister = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnRegister:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 460)
	btnRegister:addTouchEventListener(handler(self, self.onTouchRegister))
	btnRegister:setTitleText("完成注册")
	btnRegister:setTitleFontSize(36)
	self:addChild(btnRegister)
	self.views[#self.views+1] = btnRegister

	self.alertTip:setString("输入密码")
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
		s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))--密码不合规范
	else
		--do nothing
	end
	--注册
	self:register(self.phoneNumber,pwd,self.nickName,self.sex)
end
--显示登陆界面
function RegisterAccountView:showLoginView(args)
	local phoneNumber = ""
	if args ~= nil and #args > 0 then
		phoneNumber = args[1]
	end
	--显示返回按钮
	self.btnReturn:setVisible(true)
	self.btnReturn:setTouchEnabled(true)
	self.title:setString("登 录")
	local inputNodeID = InputNode.new("image/signup/shuru_bbchildren_gray.png","image/signup/shuru_bbchildren_white.png","请输入手机号",nil,nil,nil,false,11)
	inputNodeID:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.8 - 200)
	self:addChild(inputNodeID)
	self.inputNodeID = inputNodeID
	self.views[#self.views+1] = inputNodeID
	--输入密码
	local inputNodePwd = InputNode.new("image/signup/shuru_bbchildren_gray.png","image/signup/shuru_bbchildren_white.png","请输入密码",handler(self,self.ProceInputPwd),nil,nil,true,11,6)
	inputNodePwd:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.8 - 300)
	self:addChild(inputNodePwd)
	self.inputNodePwd = inputNodePwd
	self.views[#self.views+1] = inputNodePwd
	--登陆按钮
	local btnLogin = ccui.Button:create("image/shop/button_back2.png")
	btnLogin:setPosition(0.8 * s_DESIGN_WIDTH, s_DESIGN_HEIGHT * 0.8  - 300)
	btnLogin:addTouchEventListener(handler(self, self.onLoginTouch))
	btnLogin:setScaleX(-1)
	btnLogin:setTitleFontSize(36)
	btnLogin:setVisible(false)
	self.btnLogin = btnLogin
	self:addChild(btnLogin)
	self.views[#self.views+1] = btnLogin
	
	if phoneNumber ~= "" then
		self.inputNodeID:setText(phoneNumber)
		self.inputNodeID:setEnabled(false)
		self.inputNodeID:setVisible(false)
		inputNodePwd:openIME()
		inputNodePwd:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.8 - 250)
		btnLogin:setPosition(0.8 * s_DESIGN_WIDTH, s_DESIGN_HEIGHT * 0.8  - 250)
	else
		inputNodeID:openIME()
	end
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
	if string.find(id,"^1[3|4|6|5|8][0-9]%d%d%d%d%d%d%d%d$") then
		--手机号码登陆
		s_O2OController.logInOnline(id, pwd, true)
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

--输入帐号密码
function RegisterAccountView:ProceInputPwd(text,length,maxlength)
	if maxlength <= length then
		self.btnLogin:setVisible(true)
		self.btnLogin:setTouchEnabled(true)
	else
		self.btnLogin:setVisible(false)
		self.btnLogin:setTouchEnabled(false)
	end
end

------显示选择登陆方式的界面sterAccountView.STEP_10----------------------------------------------------------------------------------------------------------------------
function RegisterAccountView:showIntroView()
	self.inited = false
	if not tolua.isnull(self.btnReturn) then
		self.btnReturn:setVisible(false)
 		self.btnReturn:setTouchEnabled(false)
 	end

 	self.introviews = {}
	--浅蓝色背景
	local bigWidth = s_DESIGN_WIDTH + 2 * s_DESIGN_OFFSET_WIDTH
    local bigHeight = 1.0 * s_DESIGN_HEIGHT
	local initColor = cc.LayerColor:create(cc.c4b(220,233,239,255), bigWidth, s_DESIGN_HEIGHT)
    initColor:setAnchorPoint(0.5,0.5)
    initColor:ignoreAnchorPointForPosition(false)  
    initColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    initColor:setTouchEnabled(false)
    self:addChild(initColor)
    self.introviews[#self.introviews + 1] = initColor

	--显示贝贝的LOGO  显示2个按钮
	local splogo = cc.Sprite:create("image/login/icon.png")
	splogo:setAnchorPoint(0.5,0.5)
	splogo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*0.75)
	self:addChild(splogo)
	self.introviews[#self.introviews + 1] = splogo

	local spslogan = cc.Sprite:create("image/login/slogan.png")
	spslogan:setAnchorPoint(0.5,0.5)
	spslogan:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*0.55)
	self:addChild(spslogan)
	self.introviews[#self.introviews + 1] = spslogan

	local btnRegister = ccui.Button:create("image/login/button_on.png","image/login/button_down.png")
	btnRegister:setAnchorPoint(0.5,0.5)
	btnRegister:setTitleFontSize(30)
	btnRegister:addTouchEventListener(handler(self, self.onIntroRegisterTouch))
	btnRegister:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*0.40)
	btnRegister:setTitleText("开始使用")
	self:addChild(btnRegister)
	self.introviews[#self.introviews + 1] = btnRegister

	local btnLogin = ccui.Button:create("image/login/button_on.png","image/login/button_down.png")
	btnLogin:setAnchorPoint(0.5,0.5)
	btnLogin:setTitleFontSize(30)
	btnLogin:addTouchEventListener(handler(self, self.onIntroLoginTouch))
	btnLogin:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*0.30)
	btnLogin:setTitleText("登陆")
	self:addChild(btnLogin)
	self.introviews[#self.introviews + 1] = btnLogin
end

function RegisterAccountView:onIntroLoginTouch( sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	
	for k,v in pairs(self.introviews) do
		v:removeFromParent()
	end
	print("进入登陆")
	self.curStep = RegisterAccountView.STEP_1
	self:goStep(self.curStep,"fromIntro")
end

function RegisterAccountView:onIntroRegisterTouch( sender,eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	for k,v in pairs(self.introviews) do
		v:removeFromParent()
	end
	print("进入注册  选性别")
	self.curStep = RegisterAccountView.STEP_3
	self:goStep(self.curStep,"fromIntro")
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
-- 验证手机
function RegisterAccountView:verifySMSCode(phoneNumber,smsCode)
	print("验证手机号码 验证码："..phoneNumber.." code:"..smsCode)
	showProgressHUD('', true)
	if not self.debug then
		cx.CXAvos:getInstance():verifyPhoneNumber(phoneNumber, smsCode,handler(self, self.onVerifySMSCodeCallBack))
	end
end
--验证手机验证码  返回回调
--error 	错误消息
--errorCode 错误号
function RegisterAccountView:onVerifySMSCodeCallBack(error,errorCode)
	hideProgressHUD(true)
	print("验证手机验证码回调："..tostring(error).." ,"..errorCode)
	if errorCode~= 0 then
		s_TIPS_LAYER:showSmallWithOneButton(error)
	else
		print("self.smsMode:"..self.smsMode)
		if self.smsMode == "verify" then
			cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
			s_CURRENT_USER.mobilePhoneVerified = true --通过验证

			--延迟1秒弹出
			s_SCENE:callFuncWithDelay(1,function()
			s_TIPS_LAYER:showSmallWithOneButton("手机号码验证成功！",function ()
				s_O2OController.resetPassword(handler(self,self.onResetPwdCallBack))--重置密码
				--去选择性别
				-- self.curStep = RegisterAccountView.STEP_3
				-- self:goStep(self.curStep)
				s_SCENE:removeAllPopups()
			end)
			end)

		elseif self.smsMode == "smslogin" then
			-- print("BBBBBBBBBBBBBBBBB")--do nothing
		end
	end
end

--请求 验证登陆 的验证码 
function RegisterAccountView:requestLoginSMSCode(phoneNumber)
	print("请求登陆的验证码")
	if not self.debug then
		cx.CXAvos:getInstance():requestLoginSMS(phoneNumber);
	end
end
--验证手机号码是否有效  HomeLayer调用到
function RegisterAccountView:requestVerifySMSCode(phoneNumber)
	print("请求验证手机的验证码")
	print("phoneNumber:"..phoneNumber)
	print("mobilePhoneNumber:"..s_CURRENT_USER.mobilePhoneNumber)
	print("self.phoneNumber"..self.phoneNumber)
	self.phoneNumber = phoneNumber
	if not self.debug then
		cx.CXAvos:getInstance():requestVerifyPhoneNumber(phoneNumber);
	end
end
--通过短信验证码登陆
function RegisterAccountView:loginWithSMS(phoneNumber,smsCode)
	print("短信验证码登陆:"..phoneNumber.." "..smsCode)
	s_O2OController.logInBySMSCode(phoneNumber,smsCode,handler(self, self.loginWithSMSCallBack))
end

function RegisterAccountView:loginWithSMSCallBack(error,errorCode)
	if error ~= nil then
		s_TIPS_LAYER:showSmallWithOneButton(error)
	else
		--请求重置密码
		s_O2OController.resetPassword(handler(self,self.onResetPwdCallBack))
	end
end

--重置密码回调
function RegisterAccountView:onResetPwdCallBack()
	--重置密码成功
	print("重置密码成功！")
	if not tolua.isnull(self) then
		self:endRegister()
	end
end
--开始注册
--phoneNumber 	就是手机号码
--pwd 			密码
--nickName 		昵称
function RegisterAccountView:register(phoneNumber,pwd,nickName,sex)
	print("电话号码:"..phoneNumber)
	print("密码:"..pwd)
	print("昵称:"..tostring(nickName))
	print("性别:"..tostring(sex))
	print("请求注册....")
	showProgressHUD('', true)
	--更新登陆信息
	s_UserBaseServer.updateLoginInfo(s_CURRENT_USER.username,pwd,phoneNumber,handler(self,self.onRegisterCallBack),nickName,sex)
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
	--触发完善信息任务
	s_MissionManager:updateMission(MissionConfig.MISSION_INFO,1,false)
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
	if self.smsMode ~= "verify" then
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
end

return RegisterAccountView

