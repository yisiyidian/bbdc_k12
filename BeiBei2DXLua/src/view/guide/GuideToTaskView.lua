
-- 引导功能里的任务流程
-- by 侯琪
-- 2015年06月05日16:25:15
local GuideToTaskConfig = require("model/guide/GuideToTaskConfig.lua")
local GuideToTaskRender = require("view/guide/GuideToTaskRender.lua")
local GuideToTaskView = class("GuideToTaskView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function GuideToTaskView.create()
    local layer = GuideToTaskView.new()
    return layer
end

function GuideToTaskView:ctor()
	self.index = 1
	self:initUI()
	-- 初始化UI
end

function GuideToTaskView:initUI()
	local backColor = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
	backColor:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setAnchorPoint(0.5,0.5)
    self.backColor = backColor
    self:addChild(self.backColor)

	local back = ccui.Layout:create()
	back:setContentSize(s_DESIGN_WIDTH ,s_DESIGN_HEIGHT)
	back:setColor(cc.c4b(0,0,0,100))
    back:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self.backColor:addChild(self.back)
    -- 暗色背景

    -- 箱子里的纸张
    local pape = cc.Sprite:create("image/guide/yindao_baoxiang_paper.png")
    pape:setScale(0)
    pape:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
    pape:ignoreAnchorPointForPosition(false)
    pape:setAnchorPoint(0.5,0.5)
    self.pape = pape
    self.backColor:addChild(self.pape)

    -- 箱子拟人的对话框
    local pop = cc.Sprite:create("image/alter/tanchu_board_small_white.png")
    pop:setScale(0)
    pop:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
    pop:ignoreAnchorPointForPosition(false)
    pop:setAnchorPoint(0.5,0.5)
    self.pop = pop
    self.backColor:addChild(self.pop)

    -- 对话框里的内容
    local con = cc.Label:createWithSystemFont("","",30)
    con:setPosition(cc.p(self.pop:getContentSize().width / 2,self.pop:getContentSize().height /2))
    con:setColor(cc.c4b(0,0,0,255))
    con:ignoreAnchorPointForPosition(false)
    con:setAnchorPoint(0.5,0.5)
    self.con = con
    self.pop:addChild(self.con)

	-- 临时图层，用于放置引导label
	local layer = cc.Layer:create()
	self.layer = layer
	self.backColor:addChild(self.layer)

	-- 箱子
   	local box = cc.Sprite:create("image/islandPopup/close.png")
   	box:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT *1.5)
   	box:ignoreAnchorPointForPosition(false)
    box:setAnchorPoint(0.5,0.5)
    self.box = box
    self.back:addChild(self.box)

	self.back:setTouchEnabled(true)
	-- 背景的触摸事件
	self.back:addTouchEventListener(handler(self,self.touchFunc))   
	--渲染
	self:resetView()
end

function GuideToTaskView:touchFunc(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    self:resetView()
end

function GuideToTaskView:resetView()
	-- 初始化数据
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	self.layer:removeAllChildren()
	local boxPos = cc.p(0,0)
	local isOpen = false
	local scaleTo = 1
	local showIndex = 0
	table.foreach(GuideToTaskConfig.data, 
		function(i, v)  
			if v.guideToTask_id == self.index then 
				print("当前任务引导是第"..i.."/"..#GuideToTaskConfig.data.."步") 
				isOpen = v.isOpen 
				boxPos = v.boxPos 
				scaleTo = v.scaleTo
				showIndex = v.guideId
			end 
		end)
	self.showIndex = showIndex
	self.scaleTo = scaleTo
	self.isOpen = isOpen
	self.boxPos = boxPos

	-- 根据数据改变ui
	self:resetLock()
	self:resetLabel()
	self:resetBox()
	self:resetPage()
	self:resetPopup()
	self:resetGuideStep()

	-- 结束引导
	if self.index == 7 then
		s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
		self:removeFromParent()
		return
	end
	self.index = self.index + 1
end

-- 更新引导步
function GuideToTaskView:resetGuideStep()
	local currentStep = s_CURRENT_USER.guideStep
	s_CURRENT_USER:setGuideStep(currentStep + 1)
end

-- 加入锁屏
function GuideToTaskView:resetLock()
	local action1 = cc.DelayTime:create(0.3)
	local action2 = cc.CallFunc:create(function ()
		s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

-- 重置对话框
function GuideToTaskView:resetPopup()
	local action1 = cc.DelayTime:create(0.3)
	local action2 = cc.CallFunc:create(function ()
		if self.index == 5 then
			local action1 = cc.Place:create(cc.p(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT * 0.35))
			local action2 = cc.ScaleTo:create(0.1,1)
			local action = cc.Sequence:create(action1,action2)
			self.pop:runAction(action)
			self.con:setString("善良的勇者，感谢你从怪物的手中救了我\n这是我给你的报酬，请收下吧")
		elseif self.index == 6 then
			self.con:setString("千万不要小看这些豆子\n在这个世界里\n你用这些豆子可以买到任何东西\n想要获得更多豆子\n就快点帮我做事吧")
		elseif self.index == 7 then
			self.con:setString("来，交给你一个伟大的任务\n（点击我查看任务）")
		end
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

-- 重置箱子纸张
function GuideToTaskView:resetPage()
	local action1 = cc.DelayTime:create(0.3)
	local action2 = cc.CallFunc:create(function ()
		if self.index == 3 then
			local action1 = cc.Place:create(cc.p(self.boxPos.x,self.boxPos.y + 100))
			local action2 = cc.ScaleTo:create(0.1,1)
			local action = cc.Sequence:create(action1,action2)
			self.pape:runAction(action)
		elseif self.index == 4 then
			local action1 = cc.ScaleTo:create(0.1,1)
			local action2 = cc.MoveBy:create(0.1,cc.p(0, -40))
			local action3 = cc.CallFunc:create(function ()
				self.page:setTexture()
			end)
			local action = cc.Sequence:create(action1,action2,action3)
			self.pape:runAction(action)
		elseif self.index == 5 then
			local action1 = cc.ScaleTo:create(0.1,0)
			local action2 = cc.MoveTo:create(0.1,cc.p(self.boxPos))
			local action = cc.Spawn:create(action1,action2)
			self.pape:runAction(action)
		end
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

-- 重置引导Label
function GuideToTaskView:resetLabel()
	local action1 = cc.DelayTime:create(0.3)
	local action2 = cc.CallFunc:create(function ()
		s_CorePlayManager.enterGuideScene(self.showIndex,self.layer) 
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

-- 重置箱子
function GuideToTaskView:resetBox()
	local action1 = cc.ScaleTo:create(0.3,self.scaleTo)
	local action2 = cc.MoveTo:create(0.3,self.boxPos)
	local action = cc.Spawn:create(action1,action2)
	local action3 = cc.CallFunc:create(function ()
		if self.isOpen == true then
			self.box:setTexture('image/islandPopup/open.png')
		elseif self.isOpen == false then
			self.box:setTexture('image/islandPopup/close.png')
		end
	end)
	self.box:runAction(cc.Sequence:create(action,action3))
end

return GuideToTaskView