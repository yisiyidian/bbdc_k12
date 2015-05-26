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
	labelTask:setPosition(s_DESIGN_WIDTH/2 - 102,80)
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
	local button_task = ccui.Button:create("image/islandPopup/task_button1.png","","image/islandPopup/task_button2.png")
	button_task:setPosition(s_DESIGN_WIDTH/2 + 60,90)
	button_task:setTouchEnabled(true)
	button_task:addTouchEventListener(handler(self,self.onButtonTouch))
	button_task:setTitleText("领取")
	button_task:setTitleFontSize(20)
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
		labelday:setPosition(s_DESIGN_WIDTH/2 - 520/2 - 10, 30)
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
	self.taskID 	= data[1] --任务ID
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
		--获取用户连续多少天登录 贝贝豆数量
		local LoginTaskBBD = "奖励："..self.totalCount.."贝贝豆"
		self.bbdNum:setString(LoginTaskBBD)

		local LoginDayLabel = "登录"..self.nowCount.."/"..self.totalCount.."天"
		self.labelTask:setString(LoginDayLabel)
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
		self.button_task:setBright(true)
	else
		--按钮和精灵相反
		self.button_task:setTouchEnabled(false)
		self.button_task:setBright(false)
	end
end

--按钮事件处理
function TaskViewRender:onButtonTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	
	-- print("fuck")
	--按钮变灰 不可点击
	-- self.button_task:setTouchEnabled(false)  --不可点击
	-- self.button_task:setVisible(false)
	-- self.spriteBtn:setVisible(true)
	--改变贝贝豆数量(右上角) 做一个动画  TODO: 贝贝豆的位置需要调整
	--创建豆的精灵
	if self.getRewardCallBack ~= nil then
		self.getRewardCallBack(self.taskID,self.index)
	end

	--[[
	local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
	bean:setPosition(0,0)
	self:addChild(bean)
	self.bean = bean
	print('position..',self:getPositionX(),self:getPositionY())

	local action0 = cc.DelayTime:create(1)
	--要减去起始点的坐标  s_RIGHT_X为界面最右边的坐标（ipad会比iphone长一点 所以s_DESIGN_WIDTH不是左右边坐标）
	--减去精灵坐标 是要算出算出精灵再大的界面上的相对坐标
    local action1 = cc.MoveTo:create(1,cc.p(s_RIGHT_X-140 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    --local action1 = cc.MoveTo:create(1,cc.p(s_RIGHT_X - 100,s_DESIGN_HEIGHT - 100))
    local action2 = cc.ScaleTo:create(0.1,0)
    local release = function()
    	bean:removeFromParent()
    end
    local action4 = cc.CallFunc:create(release)
    bean:runAction(cc.Sequence:create(action0,action1,action2,action4)) 
    ]]
end
 
return TaskViewRender