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
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	--创建任务背景图片
	local background = cc.Sprite:create("image/guide/taskBackground.png")
	background:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    background:setAnchorPoint(0.5,0.5)
    background:ignoreAnchorPointForPosition(false)
    self.background = background
    self:addChild(background)
    
    local bgWidth = background:getContentSize().width
	local bgHeight = background:getContentSize().height
	--添加文本（每日任务）
	local taskDay = cc.Label:createWithSystemFont("每日任务","",40)
	taskDay:setPosition(bgWidth/2,bgHeight-60)
	taskDay:setAnchorPoint(0.5,0.5)
	taskDay:setTextColor(cc.c3b(255,255,255))
	self.background:addChild(taskDay)
	self.taskDay = taskDay
	--添加boss
	local boss = cc.Sprite:create("image/guide/boss.png")
	boss:setPosition(bgWidth/2,bgHeight/2+60)
	boss:setAnchorPoint(0.5,0.5)
	boss:ignoreAnchorPointForPosition(false)
	self.background:addChild(boss)
	self.boss = boss
	--添加按钮（去完成任务）
	local taskGoButton = ccui.Button:create("image/guide/taskButton.png","image/guide/anniuxia.png","image/guide/taskButton.png")
	taskGoButton:setAnchorPoint(0.5,0.5)
	taskGoButton:setPosition(bgWidth/2,100)
	self.background:addChild(taskGoButton)
	taskGoButton:addTouchEventListener(handler(self,self.clickGoTaskButton))
	taskGoButton:setTitleText("去完成任务")
	taskGoButton:setTitleFontSize(40)
	taskGoButton:setVisible(true)
	self.taskGoButton = taskGoButton
	--添加按钮（领取奖励）
	local taskRewardButton = ccui.Button:create("image/guide/taskButton.png","image/guide/anniuxia.png","image/guide/taskButton.png")
	taskRewardButton:setAnchorPoint(0.5,0.5)
	taskRewardButton:setPosition(bgWidth/2,80)
	self.background:addChild(taskRewardButton)
	taskRewardButton:addTouchEventListener(handler(self,self.getRewardTaskButton))
	taskRewardButton:setTitleText("领取奖励")
	taskRewardButton:setTitleFontSize(40)
	taskRewardButton:setVisible(false)
	self.taskRewardButton = taskRewardButton

	--添加文字目标
	-- local target = cc.Label:createWithSystemFont("目标: ","",30)
	-- target:setPosition(80,bgHeight/4+80)
	-- target:setAnchorPoint(0.5,0.5)
	-- target:setTextColor(cc.c3b(0,0,0))
	-- self.background:addChild(target)
	-- self.target = target

	local taskTarget = cc.Label:createWithSystemFont("123","",30)
	taskTarget:setWidth(400)
	taskTarget:setLineBreakWithoutSpace(true)
	taskTarget:setPosition(bgWidth/2,bgHeight/4 + 80)
	taskTarget:setAnchorPoint(0.5,0.5)
	taskTarget:setTextColor(cc.c3b(0,0,0))
	--taskTarget:setVisible(false)
	self.background:addChild(taskTarget)
	self.taskTarget = taskTarget

	--添加奖励文字
	local taskReward = cc.Label:createWithSystemFont("奖励: ","",30)
	taskReward:setPosition(bgWidth/2-80,bgHeight/4+10)
	taskReward:setAnchorPoint(0.5,0.5)
	taskReward:setTextColor(cc.c3b(0,0,0))
	self.background:addChild(taskReward)
	self.taskReward = taskReward

	self:createBean()

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
	self.closeButton:setPosition(bgWidth-30,bgHeight-40)
	self.background:addChild(closeButton)

	--今日任务全部完成
	self:TodayTaskComplete()

	self:resetView()
	

	touchBackgroundClosePopup(self,self.background,function() 
			self:closeFunc() 
	end)

	onAndroidKeyPressed(self,function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup ~= 0 then
			self:closeFunc()
        end
    end, function ()end)

    local delayTime = cc.DelayTime:create(0.5)
    local func = cc.CallFunc:create(function ( ... )
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    self:runAction(cc.Sequence:create(delayTime,func))

    self.closeMark = false
end

function TaskView:closeFunc()
	if self.closeMark then
		return 
	end
	self.closeMark = true

	self.closeButton:setTouchEnabled(false)

	local action1 = cc.FadeOut:create(0.5)
	local action2 = cc.ScaleTo:create(0.5,0)
	local action3 = cc.MoveTo:create(0.5,cc.p(s_RIGHT_X - 500, -400))
	local action4 = cc.CallFunc:create(function ()
									    s_SCENE:removeAllPopups()
										end)
	local action5 = cc.Spawn:create(action1,action2,action3)
	local action6 = cc.CallFunc:create(function ()
		if self.callBox ~= nil then
			self.callBox()
		end
	end)
	local action7 = cc.DelayTime:create(0.1)
	self:runAction(cc.Sequence:create(action5,action6,action7,action4))     

	-- s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	-- local delayTime = cc.DelayTime:create(1)
 --    local func = cc.CallFunc:create(function ( ... )
 --        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
 --    end)
 --    self:runAction(cc.Sequence:create(delayTime,func))       
end

--今日任务全部完成
function TaskView:TodayTaskComplete()
	local label1 = cc.Label:createWithSystemFont("今天干的不错,","",30)
	label1:setPosition(self.background:getContentSize().width/2,self.background:getContentSize().height/2 + 60)
	label1:setAnchorPoint(0.5,0.5)
	label1:setTextColor(cc.c3b(0,0,0))
	label1:setVisible(false)
	self.background:addChild(label1)
	self.label1 = label1

	local label2 = cc.Label:createWithSystemFont("明天还有更多的任务等着你~","",30)
	label2:setPosition(self.background:getContentSize().width/2,self.background:getContentSize().height/2)
	label2:setAnchorPoint(0.5,0.5)
	label2:setTextColor(cc.c3b(0,0,0))
	label2:setVisible(false)
	self.background:addChild(label2)
	self.label2 = label2
end

function TaskView:resetView()
	--获取任务列表
	self.missionList = s_MissionManager:getMissionList()
	if self.missionList[1][1] == 0 then
		--全部任务已完成
		self.label1:setVisible(true)
		self.label2:setVisible(true)
		self.boss:setVisible(false)
		self.taskGoButton:setVisible(false)
		self.taskRewardButton:setVisible(false)
		self.taskTarget:setVisible(false)
		self.taskReward:setVisible(false)
		if not tolua.isnull(self.beanImg) then
			self.beanImg:setVisible(false)
		end
		if not tolua.isnull(self.beanNum) then
			self.beanNum:setVisible(false)
		end
		if not tolua.isnull(self.sign) then
			self.sign:setVisible(false)
		end
		-- self.beanNum:setVisible(false)
		-- self.sign:setVisible(false)
		return
	else
		dump(self.missionList,"任务列表")

		--绑定数据
		self:setData(self.missionList[1])
	end
end


function TaskView:setData(data)
	dump(data,"任务数据")
	self.taskID 	= data[1] --任务ID  为0的情况 就是随机任务的 明日再来
	self.status 	= data[2] --任务状态
	self.nowCount 	= data[3] --任务条件
	self.totalCount = data[4] --任务总条件
	self.index 		= data[5] --系列任务的游标
	self.bookKey 	= data[6] --书籍的key (可选)
	self.unitID     = data[7] --单元的ID  (可选)
	self.costTime   = data[8] --限定时间  (限定的时间)
 	--更新界面
	self:updateView()
end

function TaskView:createBean()
	self.missionList = s_MissionManager:getMissionList()
	if self.missionList[1][1] == 0 then
		return
	end
	--贝贝豆图标
	if not self.beanImg or tolua.isnull(self.beanImg) then
		self.beanImg = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
		self.beanImg:setAnchorPoint(0.5,0.5)
		self.beanImg:setPosition(self.background:getContentSize().width/2-10,self.background:getContentSize().height/4 + 10)
		self.background:addChild(self.beanImg)
	else
		self.beanImg:setVisible(true)
	end
	-- self.beanImg = beanImg
	--贝贝豆后面添加数量文字
	if not self.beanNum or tolua.isnull(self.beanNum) then
		self.beanNum = cc.Label:createWithSystemFont("X 10","",30)
		self.beanNum:setPosition(self.background:getContentSize().width/2+40,self.background:getContentSize().height/4 + 10)
		self.beanNum:setAnchorPoint(0.5,0.5)
		self.beanNum:setTextColor(cc.c3b(0,0,0))
		self.background:addChild(self.beanNum)
	else
		self.beanNum:setVisible(true)
	end
end


function TaskView:updateView()

	-- --判断任务是否全部完成
	-- if self.taskID == 0 then
	-- 	self.label1:setVisible(true)
	-- 	self.label2:setVisible(true)
	-- 	self.boss:setVisible(false)
	-- 	self.taskGoButton:setVisible(false)
	-- 	self.taskRewardButton:setVisible(false)
	-- 	self.taskTarget:setVisible(false)
	-- 	self.taskReward:setVisible(false)
	-- end

	--获取任务配置  根据指定的任务ID
	local config = s_MissionManager:getRandomMissionConfig(self.taskID)
	--判断是否是累计登陆
	--是累计登陆
	if self.taskID == MissionConfig.MISSION_LOGIN then
		--修改应该获得的贝贝豆数量
		local totalCount = "X "..self.totalCount
		self.beanNum:setString(totalCount)

		--累计登陆的天数
		local loginNum = "目标: ".."累计登陆"..self.totalCount.."天"
		self.taskTarget:setString(loginNum)
		--修改boss图片
		self.boss:setTexture("image/guide/loginReward.png")
	--不是累计登陆任务
	else
		local labelBeanNum = "X "..config.bean
		--self.beanNum:setString(config.bean)
		self.beanNum:setString(labelBeanNum)
		-- local unit = "Unit"
		-- local unitName = string.split(s_BookUnitName[s_CURRENT_USER.bookKey][''..(self.unitID)],'_')
		-- unit = unit..unitName[1]
		-- if #unitName == 2 then
		-- 	unit = unit.."("..unitName[2]..")"
		-- end
		if string.sub(self.taskID,1,1) == "4" then -- 4开头
			local unit = "Unit"
			self.unit = unit
			local unitName = string.split(s_BookUnitName[s_CURRENT_USER.bookKey][''..(self.unitID)],'_')
			self.unit = unitName[1]
			if #unitName == 2 then
				self.unit = self.unit.."("..unitName[2]..")"
			end
		end
		--根据TaskID判断是什么任务
		if self.taskID == "4-1" then 
			local temp = "目标: "..string.format(config.desc,self.costTime,self.unit)
			self.taskTarget:setString(temp)
			--self.taskTarget:setString(string.format(config.desc,self.costTime,unit))
		elseif self.taskID == "4-2" then 
			local temp = "目标: "..string.format(config.desc,self.unit)
			self.taskTarget:setString(temp)
			--self.taskTarget:setString(string.format(config.desc,unit))
		elseif self.taskID == "4-3" then
			local temp = "目标: "..string.format(config.desc,self.unit)
			self.taskTarget:setString(temp)
			--self.taskTarget:setString(string.format(config.desc,unit))
		else
			--修改应该获得的贝贝豆数量
			local temp = "目标: "..string.format(config.desc,self.totalCount,self.nowCount,self.totalCount)
			self.taskTarget:setString(temp)
			--self.taskTarget:setString(string.format(config.desc,self.totalCount,self.nowCount,self.totalCount))
		end
	end

	--修改图片
	for k,v in pairs(MissionConfig.randomMission) do
		if v.mission_id == self.taskID then
			self.boss:setTexture(v.picture)
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
		self.taskGoButton:setTouchEnabled(true)
		self.taskRewardButton:setVisible(false)
		self.taskRewardButton:setTouchEnabled(false)
		self.sign:setVisible(false)
	end
end

--关闭按钮点击
function TaskView:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	
	self:closeFunc()
end

function TaskView:runActionSign()
	local action0 = cc.DelayTime:create(1)
	local action1 = cc.ScaleTo:create(0.5,1)
	local action2 = cc.MoveBy:create(0.5,cc.p(0,0))
    local action3 = cc.FadeIn:create(0.5)
	local action4 = cc.EaseSineIn:create(action1)
	local action5 = cc.EaseSineIn:create(action2)
	self.sign:runAction(cc.Sequence:create(action0,cc.Spawn:create(action3,action4,action5)))
end

--去做任务按钮点击
function TaskView:clickGoTaskButton(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	self:closeFunc()
	--跳转到对应的界面
	local taskId = self.taskID
	if taskId == "2-1" then --完善个人信息
		s_CorePlayManager.enterSettingView()
	elseif taskId == "2-2" then --好友界面
		s_CorePlayManager.enterFriendView()
	elseif taskId == "2-3" then --下载音频
		s_CorePlayManager.enterHomeLayer()
	elseif string.sub(taskId,1,1) == "3" then --3开头 去解锁
		s_CorePlayManager.enterShopView()
	elseif string.sub(taskId,1,1) == "4" then --4开头 去打关卡
		local unitID = tonumber(self.unitID)
		if unitID == 1 then
			s_CorePlayManager.chapterLayer.listView:scrollToTop(1,false)
		else
			s_CorePlayManager.chapterLayer:scrollLevelLayer(unitID,1);
		end
	end
end

--TODO:领取奖励按钮点击
function TaskView:getRewardTaskButton(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	--任务是否完成
	--local re,bean = s_MissionManager:completeMission("MISSION_LOGIN",self.index,nil)
	local re,bean = s_MissionManager:completeMission(self.taskID,self.index,nil)
	if not re then
		print("完成任务失败")
		return
	end

	self:createBean()

	--执行贝贝豆飞上去动画(加上贝贝豆数量也飞上去)
	--图标
	local action1 = cc.MoveTo:create(0.3,cc.p(s_RIGHT_X-140 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    local action2 = cc.ScaleTo:create(0.1,0)
    local release = function(self)
    	self.beanImg:removeFromParent()
    	if self.beanCallBack ~= nil then 
    		self.beanCallBack()
    	end
    end
    --s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    local action3 = cc.CallFunc:create(handler(self,release))
    -- self.beanImg:setVisible(true)
    self.beanImg:runAction(cc.Sequence:create(action1,action2,action3)) 

    --贝贝豆数量
    local action4 = cc.MoveTo:create(0.3,cc.p(s_RIGHT_X-100 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    local releaseBean = function (self)
    	self.beanNum:removeFromParent()
    	self.beanNum = nil
    	self:createBean()
    	self:resetView()
    end
    local action5 = cc.CallFunc:create(handler(self,releaseBean))
    -- local beanCreate = function(self)
    	--self:resetView()
    -- end
    -- local action6 = cc.CallFunc:create(handler(self,beanCreate))
    -- local action7 = cc.CallFunc:create(handler(self,viewReset))
    -- self.beanNum:setVisible(false)
    local action22 = cc.ScaleTo:create(0.1,0)
    self.beanNum:runAction(cc.Sequence:create(action4,action22,action5))
end

return TaskView


