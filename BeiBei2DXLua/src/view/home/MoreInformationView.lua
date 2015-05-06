--查看更多个人信息界面
--从左侧菜单栏进入
--
---listView由MoreInformationRender渲染单元组成，MoreInformationRender由listData驱动显示,
---触摸Render会触发回调，根据Render表示的数据类型显示指定的EditView（见require的table）,
---EditView修改完成之后会触发回调MoreInfomationView:onEditClose,然后更新数据到s_CURRENT_USER,调用Render的回调renderEditCall修改Render显示的内容

local MoreInformationRender = require("view.home.ui.MoreInformationRender")--小格子
local MoreInfoEditSexView = require("view.home.ui.MoreInfoEditSexView")	--修改性别的view
local MoreInfoEditDateView = require("view.home.ui.MoreInfoEditDateView") --修改日期的view
local MoreInfoEditTextView = require("view.home.ui.MoreInfoEditTextView") --修改文本的view

local MoreInfomationView = class("MoreInfomationView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)

function MoreInfomationView:ctor()
	self.editView = nil
	self.listView = nil
	self:init()
end

function MoreInfomationView:init()
	local listView = ccui.ScrollView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setTouchEnabled(true)
    listView:setContentSize(s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    listView:removeAllChildren()
    self:addChild(listView)
    self.listView = listView
    --标题
	local title = cc.Label:createWithSystemFont("个人信息","",60)
	title:setTextColor(cc.c3b(121,200,247))
	self.title = title
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	
	self:initData() --先init数据
	self:initUI() 	--再initUI
end

--初始化数据
function MoreInfomationView:initData()
	local nickName  	= s_CURRENT_USER.username
	local sex 			= s_CURRENT_USER.sex == 0 and "女" or "男"
	local headImg 		= s_CURRENT_USER.headImg
	local email 		= s_CURRENT_USER.email    --邮箱
	local birthday 		= s_CURRENT_USER.birthday --生日
	local job 			= s_CURRENT_USER.job 	  --职业
	local school		= s_CURRENT_USER.school   --学校
	local position  	= s_CURRENT_USER.position --位置
	local examination 	= s_CURRENT_USER.examination --正准备的考试

	local relateContacts = s_CURRENT_USER.relateContacts --关联通讯录
	local bindAccount    = s_CURRENT_USER.bindAccount    --帐号绑定
	local showPosition   = s_CURRENT_USER.showPosition   --位置可见
	--特殊处理一下名字
	if s_CURRENT_USER.nickName ~= "" then
		nickName = s_CURRENT_USER.nickName
	end
	--验证昵称是否合法
	local function checkName(text)
		if validateUsername(text) then
			return true,""
		else
			-- s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR))
			print(s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR))
			return false,s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR)
		end
	end
	--验证邮箱
	local function checkEmail(text)
		if validateEmail(text) then
			return true,""
		else
			return false,"邮箱格式不正确！"
		end
	end
	--非空验证
	local function checkNotNil(text)
		if text ~= "" then
			return true,""
		end
		return false,"内容不能为空！"
	end

	local listData = {}
	listData[1] = {["key"] = "headImg",			["type"] = MoreInformationRender.TEXT,["title"] = "头像",			["content"] = "",			["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = headImg} --头像	
	listData[2] = {["key"] = "nickName",		["type"] = MoreInformationRender.TEXT,["title"] = "昵称",			["content"] = nickName,		["callback"]=handler(self,self.onRenderTouch),["check"]=checkName,	["data"] = nil} --昵称
	listData[3] = {["key"] = "sex",				["type"] = MoreInformationRender.SEX,["title"] = "性别",				["content"] = sex,			["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = nil}--性别
	listData[4] = {["key"] = "email",			["type"] = MoreInformationRender.TEXT,["title"] = "邮箱",			["content"] = email,		["callback"]=handler(self,self.onRenderTouch),["check"]=checkEmail,	["data"] = nil}--邮箱
	listData[5] = {["key"] = "birthday",		["type"] = MoreInformationRender.DATE,["title"] = "生日",			["content"] = birthday,		["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = nil}--生日
	listData[6] = {["key"] = "job",				["type"] = MoreInformationRender.TEXT,["title"] = "职业",			["content"] = job,			["callback"]=handler(self,self.onRenderTouch),["check"]=checkNotNil,["data"] = nil}--职业
	listData[7] = {["key"] = "school",			["type"] = MoreInformationRender.TEXT,["title"] = "学校",			["content"] = school,		["callback"]=handler(self,self.onRenderTouch),["check"]=checkNotNil,["data"] = nil}--学校
	listData[8] = {["key"] = "position",		["type"] = MoreInformationRender.TEXT,["title"] = "位置",			["content"] = position,		["callback"]=handler(self,self.onRenderTouch),["check"]=checkNotNil,["data"] = nil}--位置
	listData[9] = {["key"] = "examination",		["type"] = MoreInformationRender.TEXT,["title"] = "在准备的考试",		["content"] = examination,	["callback"]=handler(self,self.onRenderTouch),["check"]=checkNotNil,["data"] = 1}--在准备的考试

	listData[10] = {["key"] = "relateContacts",	["type"] = MoreInformationRender.SWITCH,["title"] = "关联通讯录",		["content"] = "",			["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = false}--关联通讯录
	listData[11] = {["key"] = "bindAccount"   ,	["type"] = MoreInformationRender.ICON,  ["title"] = "帐号绑定",		["content"] = "",			["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = {}}--帐号绑定
	listData[12] = {["key"] = "showPosition",	["type"] = MoreInformationRender.SWITCH,["title"] = "关联通讯录",		["content"] = "",			["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = false}--位置可见

	listData[13] = {["key"] = "changPwd",		["type"] = MoreInformationRender.OTHER,["title"] = "修改密码",		["content"] = "",			["callback"]=handler(self,self.onRenderTouch),["check"]=nil,		["data"] = 1}--修改密码
	--列表数据
	self.listData = listData
end

--初始化UI
function MoreInfomationView:initUI()
	local render = nil 
	local sumY = 0
	local innerHeight = 0
	local renders = {} --临时容器
	for k,v in pairs(self.listData) do
		render = MoreInformationRender.new(v.type)
		-- render:setData(v.key,v.title,v.content,v.callback,v.data,v.check)
		render:setData(v)
		renders[#renders+1] = render
		sumY = sumY + 120
		self.listView:addChild(render)
		innerHeight = innerHeight + 120
	end
	--计算render坐标
	local tlen = innerHeight - 120
	for _,rd in pairs(renders) do
		rd:setPosition(0,tlen)
		tlen = tlen - 120
	end
	--设置标题 返回按钮的坐标
	innerHeight = innerHeight + 130
	self.title:setPosition(s_DESIGN_WIDTH*0.5,innerHeight - 80)
	self.listView:addChild(self.title)
	self.btnReturn:setPosition(s_DESIGN_WIDTH*0.1,innerHeight - 80)
	self.listView:addChild(self.btnReturn)

	self.listView:setInnerContainerSize(cc.size(s_DESIGN_WIDTH,innerHeight))
end

--返回按钮点击
function MoreInfomationView:onReturnClick(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	s_SCENE:removeAllPopups()
end

---Render 触摸回调
--type 显示类型
--key  键值
--data 数据	
--callback 回调 		在修改界面完成输入之后,回调给Render去更新显示内容
function MoreInfomationView:onRenderTouch(renderType,key,data,title,callback,checkCall)
	--文本 格子点击事件	
	--性别格子点击
	--日期格子点击
	local view = nil
	self.renderEditCall = nil
	print("renderType:"..renderType)
	if renderType == MoreInformationRender.TEXT then
		view = MoreInfoEditTextView.new()
		view:setData(key,data,title,handler(self, self.onEditClose),checkCall)
		self.renderEditCall = callback --绑定回调
	elseif renderType == MoreInformationRender.DATE then

	elseif renderType == MoreInformationRender.SEX then

	elseif renderType == MoreInformationRender.SWITCH then

	elseif renderType == MoreInformationRender.ICON then

	elseif renderType == MoreInformationRender.OTHER then

	end
	--显示编辑界面
	if view then
		self:showEditView(view)
	end
end
--关闭EditView
--同时触发Render的回调以修改Render的显示内容
--同时修改玩家的资料
function MoreInfomationView:onEditClose(key,type,data)
	self:hideEditView()
	if key == nil then
		return
	end
	--修改玩家的数据
	--s_CURRENT_USER
	if type == MoreInformationRender.TEXT then
		s_CURRENT_USER[key] == data
	elseif type == MoreInformationRender.DATE then

	elseif type == MoreInformationRender.SEX then

	end

	--回调给Render
	if self.renderEditCall ~= nil then
		self.renderEditCall(key,data)
	end
end
--显示修改界面
function MoreInfomationView:showEditView(view)
	self.listView:setTouchEnabled(false)
	self.editView = view
	self.editView:setPosition(s_DESIGN_WIDTH,0)--移到屏幕左侧
	self:addChild(self.editView)
	
	local actionMove = cc.MoveTo:create(0.3,cc.p(0,0))--移动的Action
	self.editView:runAction(actionMove)
end
--隐藏修改界面
function MoreInfomationView:hideEditView()
	if self.editView then
		local actionMove 		= cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH,0))
		local actionComplete 	= cc.CallFunc:create(handler(self, self.moveComplete))
		self.editView:runAction(cc.Sequence:create(actionMove,actionComplete))
	end
end
--移动完成回调
function MoreInfomationView:moveComplete()
	self.listView:setTouchEnabled(true)

	self.editView:removeFromParent()
	self.editView = nil
end

return MoreInfomationView