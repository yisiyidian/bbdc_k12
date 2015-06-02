--任务列表渲染Render
local MissionConfig = require("model.mission.MissionConfig")
local TaskViewRender = class("TaskViewRender", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(506,160))
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
	--创建左侧的图片
	local imgbig = cc.Sprite:create(imgbigeveryday)
	imgbig:setPosition(s_DESIGN_WIDTH/2 - 520/2 - 20, 80)
	imgbig:setAnchorPoint(0.5,0.5)
	imgbig:ignoreAnchorPointForPosition(false)
	self:addChild(imgbig)
	self.imgbig = imgbig
    --中间的小图片
	local imgsmall = cc.Sprite:create(imgpurse)
	imgsmall:setPosition(s_DESIGN_WIDTH/2 - 520/2 - 20, 80)
	imgsmall:setAnchorPoint(0.5,0.5)
	imgsmall:ignoreAnchorPointForPosition(false)
	self:addChild(imgsmall)
	self.imgsmall = imgsmall
	--中间的label 天数(登录)
	local labelTask = cc.Label:createWithSystemFont("0","",20)
	labelTask:setPosition(s_DESIGN_WIDTH/2 - 102,100)
	labelTask:setAnchorPoint(0.5,0.5)
	self.labelTask = labelTask
	labelTask:setTextColor(cc.c3b(0, 0, 0))
	self:addChild(labelTask)
	--贝贝豆数量
	local bbdNum = cc.Label:createWithSystemFont("0","",20)
	bbdNum:setPosition(s_DESIGN_WIDTH/2 - 102,60)
	bbdNum:setAnchorPoint(0.5,0.5)
	self.bbdNum = bbdNum
	bbdNum:setTextColor(cc.c3b(0, 0, 0))
	self:addChild(bbdNum)
	--领取按钮 
	local button_task = ccui.Button:create("image/islandPopup/task_button1.png","image/islandPopup/task_button2.png","image/islandPopup/task_button2.png")
	button_task:setPosition(s_DESIGN_WIDTH/2 + 60,80)
	button_task:setTouchEnabled(true)
	button_task:addTouchEventListener(handler(self,self.onButtonTouch))
	button_task:setTitleText("领取")
	button_task:setTitleFontSize(20)
	self:addChild(button_task)
	self.button_task = button_task

	--累计登陆任务完成显示文字  先隐藏
	local labelTaskLoginComplete = cc.Label:createWithSystemFont("恭喜你获得称号:签到达人","",30)
	labelTaskLoginComplete:setPosition(s_DESIGN_WIDTH/2 - 520/2 + 215,80)
	labelTaskLoginComplete:setAnchorPoint(0.5,0.5)
	labelTaskLoginComplete:setTextColor(cc.c3b(0,0,0))
	self:addChild(labelTaskLoginComplete)
	labelTaskLoginComplete:setVisible(false)
	self.labelTaskLoginComplete = labelTaskLoginComplete

	--随机任务完成显示文字  先隐藏
	local labelTaskRandomComplete = cc.Label:createWithSystemFont("今日任务已毕:请明日再来","",30)
	labelTaskRandomComplete:setPosition(s_DESIGN_WIDTH/2 - 520/2 + 215,80)
	labelTaskRandomComplete:setAnchorPoint(0.5,0.5)
	labelTaskRandomComplete:setTextColor(cc.c3b(0,0,0))
	self:addChild(labelTaskRandomComplete)
	labelTaskRandomComplete:setVisible(false)
	self.labelTaskRandomComplete = labelTaskRandomComplete


	--左侧的图片更新的时候是不会变的，所以根据不同类型 写死
	--累计登录任务类型
	if type == MissionConfig.MISSION_LOGIN then
		--改变图片 隐藏小图标
		self.imgbig:setTexture(imglogin)
		self.imgsmall:setVisible(false)
		--添加按钮名字 添加label 累计登陆上的天数
	    local labelday = cc.Label:createWithSystemFont("10","",26)
		labelday:setPosition(s_DESIGN_WIDTH/2 - 520/2 - 10, 40)
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

function TaskViewRender:setData(data,getRewardCallBack)
	dump(data)
	self.taskID 	= data[1] --任务ID  为0的情况 就是随机任务的 明日再来
	self.status 	= data[2] --任务状态
	self.nowCount 	= data[3] --任务条件
	self.totalCount = data[4] --任务总条件
	self.index 		= data[5] --系列任务的游标

	self.getRewardCallBack = getRewardCallBack
	--更新界面
	self:updataView()
end

--更新数据 更新按钮状态
function TaskViewRender:updataView()
	--累积登录
	if self.taskID == MissionConfig.MISSION_LOGIN then

		--是否完成全部任务
		if self.index == 0 then
			--隐藏label 与按钮 贝贝豆数量
			self.labelTask:setVisible(false)
			self.button_task:setVisible(false)
			self.bbdNum:setVisible(false)
			self.labelTaskLoginComplete:setVisible(true)
			self.labelday:setString(self.nowCount)

		else
			--获取用户连续多少天登录 贝贝豆数量
			local LoginTaskBBD = "奖励："..self.totalCount.."贝贝豆"
			self.bbdNum:setString(LoginTaskBBD)

			local LoginDayLabel = nil
			if self.nowCount > self.totalCount then 
				LoginDayLabel = "登录"..self.totalCount.."/"..self.totalCount.."天"
			else
				LoginDayLabel = "登录"..self.nowCount.."/"..self.totalCount.."天"
			end
			self.labelTask:setString(LoginDayLabel)

			--修改label
			self.labelday:setString(self.nowCount)
		end
	else
		if self.taskID == 0 then
			--隐藏label 与按钮 贝贝豆数量
			self.labelTask:setVisible(false)
			self.button_task:setVisible(false)
			self.bbdNum:setVisible(false)
			self.labelTaskRandomComplete:setVisible(true)
		else

			--随机任务 贝贝豆数量
			local config = s_MissionManager:getRandomMissionConfig(self.taskID) ---Render多的话,这么写的效率很低
			local RandomTaskBBD = "奖励："..config.bean.."贝贝豆"
			self.bbdNum:setString(RandomTaskBBD)
			--任务名称

			self.labelTask:setString(string.format(config.desc,self.totalCount,self.nowCount,self.totalCount))
		end

	end

	--设置按钮的状态
	--任务完成 可以领取 按钮为可点击  蓝色
	if self.status == "1" then
		self.button_task:setTouchEnabled(true)
		self.button_task:setBright(true)
	else
		self.button_task:setTouchEnabled(false)
		self.button_task:setBright(false)
	end
end

--按钮事件处理
function TaskViewRender:onButtonTouch(sender,eventType)
	
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	local pos = self:convertToWorldSpace(cc.p(sender:getPosition()))
  
  if self.getRewardCallBack ~= nil then
		self.getRewardCallBack(self.taskID,self.index,pos)
	end
end
 
return TaskViewRender