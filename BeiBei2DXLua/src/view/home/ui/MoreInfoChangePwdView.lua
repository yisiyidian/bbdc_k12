-- 修改密码界面
-- Author: whe
-- Date: 2015-05-07 15:16:23
local InputNode = require("view.login.InputNode")

local MoreInfoChangePwdView = class("MoreInfoChangePwdView", function ()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	layerHoldTouch(layer)
	return layer
end)

function MoreInfoChangePwdView:ctor()
	self:initUI()
end

--closeCallBack 关闭回调
function MoreInfoChangePwdView:setData(closeCallBack)
	self.closeCallBack = closeCallBack
end

--初始化UI
function MoreInfoChangePwdView:initUI()
	--标题
	local title = cc.Label:createWithSystemFont("修改密码","",60)
	title:setTextColor(cc.c3b(106,182,240))
	title:setPosition(s_DESIGN_WIDTH*0.5,s_DESIGN_HEIGHT*0.9)
	self:addChild(title)
	self.title = title
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back2.png")
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	self.btnReturn:setPosition(s_DESIGN_WIDTH*0.1,s_DESIGN_HEIGHT*0.9)
	self:addChild(self.btnReturn)
	
	--输入框 旧密码
	local inputOldPwd = InputNode.new("image/signup/shuru_bbchildren_white.png","填写旧密码",nil,nil,nil,nil,11)
	inputOldPwd:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputOldPwd)
	self.inputOldPwd = inputOldPwd
	--输入框 月份
	local inputNewPwd = InputNode.new("image/signup/shuru_bbchildren_white.png","填写新密码",nil,nil,nil,nil,11)
	inputNewPwd:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 300)
	self:addChild(inputNewPwd)
	self.inputNewPwd = inputNewPwd
	--日期
	local inputNewPwdConfirm = InputNode.new("image/signup/shuru_bbchildren_white.png","确认新密码",nil,nil,nil,nil,11)
	inputNewPwdConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 400)
	self:addChild(inputNewPwdConfirm)
	self.inputNewPwdConfirm = inputNewPwdConfirm

	local btnConfirm = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 500)
	btnConfirm:addTouchEventListener(handler(self, self.onConfirmTouch))
	btnConfirm:setTitleText("确 定")
	btnConfirm:setTitleFontSize(36)
	self:addChild(btnConfirm)
end

-- key,MoreInformationRender.OTHER,data,title,handler(self, self.onEditClose)

--设置回调
--key s_CURRENT_USER 里的键值
--type 类型
--data 文本
--title 标题 
--closeCallBack 关闭的回调  会触发移动 会触发render里的修改内容
function MoreInfoChangePwdView:setData(key,type,data,title,closeCallBack)
	self.key = key
	self.type = type
	-- self.data = data --is nil
	-- self.title = title  -- is nil
	self.closeCallBack = closeCallBack
end

function MoreInfoChangePwdView:onReturnClick(sender, eventType)
	if self.closeCallBack ~= nil then
		self.closeCallBack()
	end
end
--确定按钮点击
function MoreInfoChangePwdView:onConfirmTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	local oldPwd = self.inputOldPwd:getText()
	local newPwd = self.inputNewPwd:getText()
	local newPwdCon = self.inputNewPwdConfirm:getText()
	--判空
	if oldPwd == "" or newPwd == "" or newPwdCon == "" then
		s_TIPS_LAYER:showSmallWithOneButton("输入的密码不能为空！")
		return
	end
	--两次密码一致
	if newPwd ~= newPwdCon then
		s_TIPS_LAYER:showSmallWithOneButton("两次输入的新密码不一致！")
		return
	end
	--密码符合规范
	if not validatePassword(newPwd) then
		s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))
	end

	--请求更新密码
	showProgressHUD('', true)
	s_UserBaseServer.updateUsernameAndPassword(s_CURRENT_USER.username,newPwd,handler(self, self.onChangPwdCallBack),oldPwd)
end

--修改密码回调
--username	用户名
--password  密码
--errordescription 错误描述
--errorcode	 错误码
function MoreInfoChangePwdView:onChangPwdCallBack(username, password, errordescription, errorcode)
	if errordescription then                  
	    s_TIPS_LAYER:showSmallWithOneButton(errordescription)
	else        
	    print("修改密码成功了")
	end     
	hideProgressHUD(true)
end

return MoreInfoChangePwdView