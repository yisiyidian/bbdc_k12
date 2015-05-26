--任务列表渲染Render
local MissionConfig = require("model.mission.MissionConfig")
local TaskViewRender = class("TaskViewRender", function()
	local layer = cc.Layer:create()
	return layer
end)

function TaskViewRender:ctor(type)
	self.type = type
	self:init(type)
end
--初始化UI
function TaskViewRender:init(type)
	local imgbigeveryday = "image/islandPopup/task_add_newwords.png"
	local imgpurse = "image/islandPopup/task_newword.png"
	local imglogin = "image/islandPopup/task_login.png"
	local imgrandom = "image/islandPopup/task_random.png"
	local imgturntable = "image/islandPopup/task_turntable.png"

	--创建一个白色的底
	local bg = cc.Sprite:create("image/islandPopup/background_renwu_white.png")
	local size = bg:getContentSize()
	bg:setPosition(size.width/2,size.height/2)
	self:addChild(bg)
	self.bg = bg
	--一个小黑条
	local balck_gray = cc.Sprite:create("image/islandPopup/background_renwu_gray.png")
	balck_gray:setPosition(size.width/2,0)
	self:addChild(balck_gray)
	self.balck_gray = balck_gray
	--创建左侧的图片
	local imgbig = cc.Sprite:create(imgbigeveryday)
	imgbig:setPosition(size.width * 0.15, size.height * 0.62)
	imgbig:setAnchorPoint(0.5,0.5)
	imgbig:ignoreAnchorPointForPosition(false)
	self:addChild(imgbig)
	self.imgbig = imgbig
    --中间的小图片
	local imgsmall = cc.Sprite:create(imgpurse)
	imgsmall:setPosition(size.width * 0.15, size.height * 0.65)
	imgsmall:setAnchorPoint(0.5,0.5)
	imgsmall:ignoreAnchorPointForPosition(false)
	self:addChild(imgsmall)
	self.imgsmall = imgsmall
	--中间的label 天数(登录)
	local labelTask = cc.Label:createWithSystemFont("BBB","",20)
	labelTask:setPosition(size.width * 0.5,size.height * 0.60)
	labelTask:setAnchorPoint(0.5,0.5)
	self.labelTask = labelTask
	labelTask:setTextColor(cc.c3b(0, 0, 0))
	self:addChild(labelTask)
	--贝贝豆数量
	local bbdNum = cc.Label:createWithSystemFont("AAA","",20)
	bbdNum:setPosition(size.width * 0.5,size.height * 0.40)
	bbdNum:setAnchorPoint(0.5,0.5)
	self.bbdNum = bbdNum
	bbdNum:setTextColor(cc.c3b(0, 0, 0))
	self:addChild(bbdNum)
	--领取按钮 
	local button_task = ccui.Button:create("image/islandPopup/task_button1.png","image/islandPopup/task_button2.png","image/islandPopup/task_button2.png")
	button_task:setPosition(size.width * 0.85,size.height * 0.5)
	button_task:setTouchEnabled(true)
	button_task:addTouchEventListener(handler(self,self.onButtonTouch))
	button_task:setTitleText("领取")
	button_task:setTitleFontSize(20)
	--button_name:setHighlighted(true)
	self:addChild(button_task)
	self.button_task = button_task


	--左侧的图片更新的时候是不会变的，所以根据不同类型 写死
	--累计登录任务类型
	if type == MissionConfig.MISSION_LOGIN then
		--改变图片 隐藏小图标
		self.imgbig:setTexture(imglogin)
		self.imgsmall:setVisible(false)
		--添加按钮名字 添加label 累计登陆上的天数
	    local labelday = cc.Label:createWithSystemFont("23","",20)
		labelday:setPosition(s_DESIGN_WIDTH/2 - 520/2 - 10, 50)
		labelday:setAnchorPoint(0.5,0.5)
		self.labelday = labelday
		self.labelday:setTextColor(cc.c3b(0, 0, 0))
		imgbig:addChild(self.labelday)
	else
		--随机任务类型
		self.imgbig:setTexture(imgrandom)
		self.imgsmall:setTexture(imgturntable)
	 end
end

function TaskViewRender:setData(data,callback)
	self.taskID 	= data[1] --任务ID
	self.status 	= data[2] --任务状态
	self.nowCount 	= data[3] --任务条件
	self.totalCount = data[4] --任务总条件
	self.index 		= data[5] --系列任务的游标

	self.callback = callback
	--更新界面
	self:updataView()
end

--更新数据 更新按钮状态
function TaskViewRender:updataView()
	--累积登录
	if self.taskID == MissionConfig.MISSION_LOGIN then 
		--获取用户连续多少天登录 贝贝豆数量
		local LoginTaskBBD = "奖励："..self.totalCount.."贝贝豆"
		self.bbdNum:setString(LoginTaskBBD)

		local LoginDayLabel = "登录"..self.nowCount.."/"..self.totalCount.."天"
		self.labelTask:setString(LoginDayLabel)
		self.labelday:setString(self.totalCount)
	else
		--随机任务 贝贝豆数量
		local config = s_MissionManager:getRandomMissionConfig(self.taskID) ---Render多的话,这么写的效率很低
		local RandomTaskBBD = "奖励："..config.bean.."贝贝豆"
		self.bbdNum:setString(RandomTaskBBD)
		--任务名称
		self.labelTask:setString(config.desc)
	end

	--设置按钮的状态
	--任务完成 可以领取 按钮为可点击  蓝色
	if self.status == 1 then
		self.button_task:setTouchEnabled(true)
	else
		self.button_task:setTouchEnabled(false)
	end
end

--按钮事件处理
function TaskViewRender:onButtonTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	--领取任务奖励  （任务状态改变了 任务ID改变为新的）
	self.button_task:setHighlighted(false)
	local flag,beannum = s_MissionManager:completeMission(self.taskID)


	if self.callback ~= nil then
		self.callback(self.taskID)
	end

    --右上角加上贝贝豆数量
end
 
return TaskViewRender