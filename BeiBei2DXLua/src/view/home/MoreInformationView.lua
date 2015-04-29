--查看更多个人信息界面
--从左侧菜单栏进入

--小格子
local MoreInformationRender = require("view.home.ui.MoreInformationRender")

local MoreInfomationView = class("MoreInfomationView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)

function MoreInfomationView:ctor()
	self:init()
end

function MoreInfomationView:init()

	local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    -- listView:addEventListener(listViewEvent)
    -- listView:addScrollViewEventListener(scrollViewEvent)
    listView:removeAllChildren()
    self:addChild(listView)
    self.listView = listView

	local title = cc.Label:createWithSystemFont("个人信息","",60)
	title:setTextColor(cc.c3b(121,200,247))
	title:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9)
	self.title = title
	self:addChild(title)

	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:setPosition(0.1*s_DESIGN_WIDTH,0.9*s_DESIGN_HEIGHT)
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self:addChild(btnReturn)



	--先init数据
	self:initData()
	--再initUI
	sefl:initUI()
end

--初始化数据
function MoreInfomationView:initData()
	local nickName  	= s_CURRENT_USER.nickName
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

	local listData = {}
	listData[1] = {["key"] = "headImg",			["type"] = MoreInformationRender.TEXT,["title"] = "头像",["content"] = "",			["callback"]=nil,["data"] = headImg} --头像
	listData[2] = {["key"] = "nickName",		["type"] = MoreInformationRender.TEXT,["title"] = "昵称",["content"] = nickName,		["callback"]=nil,["data"] = nil} --昵称
	listData[3] = {["key"] = "sex",				["type"] = MoreInformationRender.SEX,["title"] = "性别",["content"] = sex,			["callback"]=nil,["data"] = nil}--性别
	listData[4] = {["key"] = "email",			["type"] = MoreInformationRender.TEXT,["title"] = "邮箱",["content"] = email,		["callback"]=nil,["data"] = nil}--邮箱
	listData[5] = {["key"] = "birthday",		["type"] = MoreInformationRender.DATE,["title"] = "生日",["content"] = birthday,		["callback"]=nil,["data"] = nil}--生日
	listData[6] = {["key"] = "job",				["type"] = MoreInformationRender.TEXT,["title"] = "职业",["content"] = job,			["callback"]=nil,["data"] = nil}--职业
	listData[7] = {["key"] = "school",			["type"] = MoreInformationRender.TEXT,["title"] = "学校",["content"] = school,		["callback"]=nil,["data"] = nil}--学校
	listData[8] = {["key"] = "position",		["type"] = MoreInformationRender.TEXT,["title"] = "位置",["content"] = position,		["callback"]=nil,["data"] = nil}--位置
	listData[9] = {["key"] = "examination",		["type"] = MoreInformationRender.TEXT,["title"] = "在准备的考试",["content"] = examination,		["callback"]=nil,["data"] = 1}--在准备的考试

	listData[10] = {["key"] = "relateContacts",	["type"] = MoreInformationRender.SWITCH,["title"] = "关联通讯录",	["content"] = "",				["callback"]=nil,["data"] = 1}--关联通讯录
	listData[11] = {["key"] = "bindAccount"   ,	["type"] = MoreInformationRender.ICON,  ["title"] = "帐号绑定",	["content"] = "",				["callback"]=nil,["data"] = 1}--帐号绑定
	listData[12] = {["key"] = "showPosition",	["type"] = MoreInformationRender.SWITCH,["title"] = "关联通讯录",["content"] = "",				["callback"]=nil,["data"] = 1}--位置可见

	listData[13] = {["key"] = "changPwd",		["type"] = MoreInformationRender.OTHER,["title"] = "修改密码",	["content"] = "",			["callback"]=nil,["data"] = 1}--修改密码

	--列表数据
	self.listData = listData
end

--初始化UI
function MoreInfomationView:initUI()
	local render = nil 
	for k,v in pairs(self.listData) do
		render = MoreInformationRender.new(v.type,v.title,v.content,v.callback,v.data)
		render:setData(v.key)
		-- TODO计算坐标位置
		-- render:setPosition(position)
		self.listView:addChild(render)
	end


end

--返回按钮点击
function MoreInfomationView:onReturnClick(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	s_SCENE:removeAllPopups()
end

--maybe not use
function MoreInfomationView:onEditTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

end

return MoreInfomationView