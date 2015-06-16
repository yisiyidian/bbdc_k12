-- 任务界面UI
require("cocos.init")
require("common.global")

local MissionConfig = require("model.mission.MissionConfig")

local TaskView = class("TaskView", function()
	local layer = cc.Layer:create()

	return layer
end)

-- 构造函数
-- callBox      关闭界面的回调
-- beanCallBack	贝贝豆的增加回调
function TaskView:ctor(callBox,beanCallBack)
	--宝箱回调绑定
	self.callBox = callBox
	--贝贝豆回调绑定
	self.beanCallBack = beanCallBack
	self:initUI()
end

--初始化UI
function TaskView:initUI()
	--创建任务背景图片
	local background = cc.Sprite:create("image/guide/popup.png")
	background:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    background:setAnchorPoint(0.5,0.5)
    background:ignoreAnchorPointForPosition(false)
    self.background = background
    self:addChild(background)
    
    local bgWidth = background:getContentSize().width
	local bgHeight = background:getContentSize().height
	print(bgWidth,"背景高度")
	print(bgHeight,"背景宽度")

	-- local sx = (s_DESIGN_WIDTH - bgWidth)/2
	-- local sy = (s_DESIGN_HEIGHT - bgHeight)/2
	-- self:setPosition(sx,sy)

	--添加按钮（去完成任务）
	local taskGoButton = ccui.Button:create("image/islandPopup/task_button1.png")
	taskGoButton:setAnchorPoint(0.5,0.5)
	taskGoButton:setPosition(bgWidth/2,80)
	self.background:addChild(taskGoButton)
	taskGoButton:addTouchEventListener(handler(self,self.clickGoTaskButton))
	taskGoButton:setTitleText("去做任务")
	taskGoButton:setTitleFontSize(20)
	taskGoButton:setVisible(true)
	self.taskGoButton = taskGoButton

	--添加按钮（领取奖励）
	local taskRewardButton = ccui.Button:create("image/islandPopup/task_button1.png")
	taskRewardButton:setAnchorPoint(0.5,0.5)
	taskRewardButton:setPosition(bgWidth/2,80)
	self.background:addChild(taskRewardButton)
	taskRewardButton:addTouchEventListener(handler(self,self.getRewardTaskButton))
	taskRewardButton:setTitleText("领取奖励")
	taskRewardButton:setTitleFontSize(20)
	taskRewardButton:setVisible(false)
	self.taskRewardButton = taskRewardButton

	--添加任务目标文字
	local taskTarget = cc.Label:createWithSystemFont("123","",30)
	taskTarget:setPosition(bgWidth/2-40,bgHeight/4 + 80)
	taskTarget:setAnchorPoint(0.5,0.5)
	taskTarget:setTextColor(cc.c3b(0,0,0))
	--taskTarget:setVisible(false)
	self.background:addChild(taskTarget)
	self.taskTarget = taskTarget

	--贝贝豆图标
	local beanImg = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
	beanImg:setAnchorPoint(0.5,0.5)
	beanImg:setPosition(bgWidth/2-10,bgHeight/4 + 10)
	self.background:addChild(beanImg)
	self.beanImg = beanImg

	--贝贝豆后面添加数量文字
	local beanNum = cc.Label:createWithSystemFont("X 10","",30)
	beanNum:setPosition(bgWidth/2+40,bgHeight/4 + 10)
	beanNum:setAnchorPoint(0.5,0.5)
	beanNum:setTextColor(cc.c3b(0,0,0))
	self.background:addChild(beanNum)
	self.beanNum = beanNum

	--任务已完成图片
	local sign = cc.Sprite:create("image/guide/sign.png")
	sign:setPosition(self.background:getContentSize().width * 0.71,310)
	sign:setVisible(false)
	sign:setAnchorPoint(0.5,0.5)
	sign:setScale(5)
    sign:setOpacity(0)
	self.background:addChild(sign)
	self.sign = sign

	--关闭按钮
	local closeButton = ccui.Button:create("image/islandPopup/task_closebutton.png")
	closeButton:addTouchEventListener(handler(self,self.CloseClick))
	self.closeButton = closeButton
	self.closeButton:setPosition(bgWidth-40,bgHeight-40)
	self.background:addChild(closeButton)
	--渲染列表
	self:resetView()
end

function TaskView:resetView()
	--获取任务列表
	self.missionList = s_MissionManager:getMissionList()
	dump(self.missionList,"任务列表")
	--绑定数据
	self:setData(self.missionList[1])

	--修改界面文字（任务名称，）
	-- -- dump(self.missionList,"任务列表数据")
	-- --创建中间的任务部分
	-- local render = nil
	-- local renders = {} --临时容器 计算坐标用
	-- local innerHeight = 0
	-- -- local splitheight = 265
	-- local renderheight = 160
	--self.listView:removeAllChildren()
	--遍历listData初始化
	-- for k,v in pairs(self.missionList) do
	-- 	render = TaskViewRender.new(v[1])
	--     render:setData(v,handler(self,self.getRewardCallBack))
	-- 	renders[#renders + 1] = render 
	-- 	--self.listView:addChild(render)
	-- 	innerHeight = innerHeight + renderheight
	-- end

	-- --计算render坐标
	-- if innerHeight < renderheight*3 then
	-- 	innerHeight = renderheight * 3 - 10
	-- end
	-- local tlen = innerHeight - renderheight
	-- for _,rd in pairs(renders) do
	-- 	rd:setPosition(50,tlen)
	-- 	tlen = tlen - renderheight	
	-- end

	--self.listView:setInnerContainerSize(cc.size(self.background:getContentSize().width,innerHeight))

	-- for k,v in pairs(self.missionList) do
	-- 	render = TaskViewRender.new(v[1])
	--     render:setData(v,handler(self,self.getRewardCallBack))
	-- 	renders[#renders + 1] = render 
		--self.listView:addChild(render)
		-- innerHeight = innerHeight + renderheight
	-- end
end


function TaskView:setData(data)
	dump(data,"任务数据")
	self.taskID 	= data[1] --任务ID  为0的情况 就是随机任务的 明日再来
	self.status 	= data[2] --任务状态
	self.nowCount 	= data[3] --任务条件
	self.totalCount = data[4] --任务总条件
	self.index 		= data[5] --系列任务的游标

	--更新界面
	self:updateView()
end



function TaskView:updateView()

	--获取任务配置  根据指定的任务ID
	local config = s_MissionManager:getRandomMissionConfig(self.taskID)
	--判断是否是累计登陆
	--是累计登陆
	if self.taskID == MissionConfig.MISSION_LOGIN then
		--修改应该获得的贝贝豆数量
		local totalCount = "X "..self.totalCount
		self.beanNum:setString(totalCount)

		--累计登陆的天数
		local loginNum = "累计登陆"..self.totalCount.."天"
		self.taskTarget:setString(loginNum)
	--不是累计登陆任务
	else
		local unit = s_LocalDatabaseManager.getAllUnitInfo()[1].unitID
		self.beanNum:setString(config.bean)
		--根据TaskID判断是什么任务
		if self.taskID == "4-1" then 
			self.taskTarget:setString(string.format(config.desc,10,unit))
		elseif self.taskID == "4-2" then 
			self.taskTarget:setString(string.format(config.desc,unit))
		elseif self.taskID == "4-3" then
			self.taskTarget:setString(string.format(config.desc,unit))
		else
			--修改应该获得的贝贝豆数量
			--self.beanNum:setString(config.bean)
			self.taskTarget:setString(string.format(config.desc,self.totalCount,self.nowCount,self.totalCount))
		end
	end

	--判断任务是否完成 1为任务完成
	if self.status == "1" then
		--更改按钮
		self.taskGoButton:setVisible(false)
		self.taskGoButton:setTouchEnabled(false)
		self.taskRewardButton:setVisible(true)
		self.taskRewardButton:setTouchEnabled(true)
		self.sign:setVisible(true)
		--播放一段动画
		self:runActionSign()
	else
		self.taskGoButton:setVisible(true)
		self.taskGoButton:setVisible(true)
		self.taskRewardButton:setVisible(false)
		self.taskRewardButton:setTouchEnabled(false)
		self.sign:setVisible(false)
	end

	--判断任务是否全部完成
	if self.index == 0 then
	end

end

--关闭按钮点击
function TaskView:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	
	self.closeButton:setTouchEnabled(false)

	local action1 = cc.FadeOut:create(0.5)
	local action2 = cc.ScaleTo:create(0.5,0)
	local action3 = cc.MoveTo:create(0.5,cc.p(s_RIGHT_X - 500, -400))
	local action4 = cc.CallFunc:create(function ()
									    s_SCENE:removeAllPopups()
									    -- s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
										end,{})
	local action5 = cc.Spawn:create(action1,action2,action3)
	-- --关闭宝箱
	local action6 = cc.CallFunc:create(function ()
		if self.callBox ~= nil then
			self.callBox()
		end
	end)
	self:runAction(cc.Sequence:create(action5,action4,action6))
	-- --开启触摸
	-- s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
end

function TaskView:runActionSign()
	local action0 = cc.DelayTime:create(1)
	local action1 = cc.ScaleTo:create(0.5,1)
	local action2 = cc.MoveBy:create(0.5,cc.p(0,40))
    local action3 = cc.FadeIn:create(0.5)
	local action4 = cc.EaseSineIn:create(action1)
	local action5 = cc.EaseSineIn:create(action2)
	self.sign:runAction(cc.Sequence:create(action0,cc.Spawn:create(action3,action4,action5)))
end

--TODO:去做任务按钮点击
function TaskView:clickGoTaskButton(sender,eventType)
	print("qweqweqweqwe")
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	--跳转到对应的界面

end

--TODO:领取奖励按钮点击
function TaskView:getRewardTaskButton(sender,eventType)
	print("asdasdasdasd")
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	print(self.taskID,"按钮回调任务ID")
	print(self.index,"按钮回调任务索引")
	--任务是否完成
	--local re,bean = s_MissionManager:completeMission("MISSION_LOGIN",self.index,nil)
	local re,bean = s_MissionManager:completeMission(self.taskID,self.index,nil)
	if not re then
		print("完成任务失败")
		return
	end
	--执行贝贝豆飞上去动画(加上贝贝豆数量也飞上去)
	--图标
	local action1 = cc.MoveTo:create(0.3,cc.p(s_RIGHT_X-140 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    local action2 = cc.ScaleTo:create(0.1,0)
    local release = function(self)
    	self.beanImg:removeFromParent()
    	--s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    	if self.beanCallBack ~= nil then 
    		self.beanCallBack()
    	end
    end
    --s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    local action3 = cc.CallFunc:create(handler(self,release))
    self.beanImg:runAction(cc.Sequence:create(action1,action2,action3)) 

    --贝贝豆数量
    local action4 = cc.MoveTo:create(0.3,cc.p(s_RIGHT_X-100 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    local releaseBean = function (self)
    	self.beanNum:removeFromParent()
    end
    local action5 = cc.CallFunc:create(handler(self,releaseBean))
    self.beanNum:runAction(cc.Sequence:create(action4,action2,action5))

	--刷新任务
	self:resetView()
end

return TaskView


