
-- 引导功能里的任务流程
-- by 侯琪
-- 2015年06月05日16:25:15
local GuideToTaskConfig = require("model/guide/GuideToTaskConfig.lua")
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

    local light1 = cc.Sprite:create("image/guide/light.png")
	light1:ignoreAnchorPointForPosition(false)
	light1:setAnchorPoint(0.5,0.5)
	light1:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
	light1:setVisible(false)
	self.light1 = light1
	self.backColor:addChild(self.light1)

	local light2 = cc.Sprite:create("image/guide/light.png")
	light2:ignoreAnchorPointForPosition(false)
	light2:setAnchorPoint(0.5,0.5)
	light2:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
	light2:setVisible(false)
	self.light2 = light2
	self.backColor:addChild(self.light2)

	self.light1:runAction(cc.RepeatForever:create(cc.RotateBy:create(2,360)))
	self.light2:runAction(cc.RepeatForever:create(cc.RotateBy:create(2,-360)))

    -- 箱子里的纸张
    local pape = cc.Sprite:create("image/guide/yindao_baoxiang_paper.png")
    pape:setScale(0)
    pape:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
    pape:ignoreAnchorPointForPosition(false)
    pape:setAnchorPoint(0.5,0.5)
    self.pape = pape
    self.backColor:addChild(self.pape)

    -- 箱子拟人的对话框
    local pop = cc.Sprite:create("image/guide/yindao_background_yellow3.png")
    pop:setScale(0)
    pop:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /(-2))
    pop:ignoreAnchorPointForPosition(false)
    pop:setAnchorPoint(0.5,0.5)
    self.pop = pop
    self.backColor:addChild(self.pop)

    -- 对话框里的内容
    local con = cc.Label:createWithSystemFont("","",34)
    con:setPosition(cc.p(self.pop:getContentSize().width / 2,self.pop:getContentSize().height *0.65))
    con:setColor(cc.c4b(0,0,0,255))
    con:ignoreAnchorPointForPosition(false)
    con:setAnchorPoint(0.5,0.5)
    self.con = con
    self.pop:addChild(self.con)
    self.con:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.con:setDimensions(self.pop:getContentSize().width *0.8,0)

	-- 临时图层，用于放置引导label
	local layer = cc.Layer:create()
	self.layer = layer
	self.backColor:addChild(self.layer)

	self.beans = cc.Sprite:create('image/chapter/chapter0/background_been_white.png')
    self.beans:setPosition(s_RIGHT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(self.beans) 
	self.beans:setVisible(false)
    self.beanCount = s_CURRENT_USER:getBeans()
    self.beanCountLabel = cc.Label:createWithSystemFont(self.beanCount,'',24)
    self.beanCountLabel:setColor(cc.c4b(0,0,0,255))
    self.beanCountLabel:ignoreAnchorPointForPosition(false)
    self.beanCountLabel:setPosition(self.beans:getContentSize().width * 0.65 , self.beans:getContentSize().height/2)
    self.beans:addChild(self.beanCountLabel)

	-- 箱子
   	local box = cc.Sprite:create("image/islandPopup/close.png")
   	box:setPosition(s_RIGHT_X-220,800)
   	box:ignoreAnchorPointForPosition(false)
    box:setAnchorPoint(0.5,0.5)
    box:setScale(0)
    self.box = box
    self.back:addChild(self.box)

    local con2 = cc.Label:createWithSystemFont("(点击宝箱领取任务)","",34)
    con2:setPosition(cc.p(self.pop:getContentSize().width / 2,self.pop:getContentSize().height *0.3))
    con2:setColor(cc.c4b(0,0,0,255))
    con2:ignoreAnchorPointForPosition(false)
    con2:setAnchorPoint(0.5,0.5)
    con2:setVisible(false)
    self.con2 = con2
    self.pop:addChild(self.con2)
    self.con2:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.con2:setDimensions(self.pop:getContentSize().width *0.8,0)

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
	self.con:setString("")
	if self.guideView ~= nil then
		self.guideView.label:setString("")
	end
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	self.layer:removeAllChildren()
	s_SCENE:removeAllPopups()
	local boxPos = cc.p(0,0)
	local isOpen = false
	local scaleTo = 1
	local showIndex = 0
	local light = false
	local labelTime = 1
	table.foreach(GuideToTaskConfig.data, 
		function(i, v)  
			if v.guideToTask_id == self.index then 
				print("当前任务引导是第"..i.."/"..#GuideToTaskConfig.data.."步") 
				isOpen = v.isOpen 
				boxPos = v.boxPos 
				scaleTo = v.scaleTo
				showIndex = v.guideId
				light = v.light
				labelTime = v.labelTime
			end 
		end)
	self.showIndex = showIndex
	self.scaleTo = scaleTo
	self.isOpen = isOpen
	self.boxPos = boxPos
	self.light = light
	self.labelTime = labelTime

	-- 根据数据改变ui
	self:resetLock()
	self:resetBox()
	self:resetPage()
	self:resetPopup()
	self:resetLight()
	self:resetGuideStep()
	self:resetLabel(self.labelTime)
	-- 结束引导
	if self.index == 6 then
		s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
		self:removeFromParent()
		s_CURRENT_USER.showTaskLayer = 1   
		s_CorePlayManager.enterLevelLayer()          
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
	local action1 = cc.DelayTime:create(4)
	local action2 = cc.CallFunc:create(function ()
		s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

function GuideToTaskView:resetLight()
	local action1 = cc.DelayTime:create(0.3)
	local action2 = cc.CallFunc:create(function ()
		if self.light == true then
			self.light1:setVisible(true)
			self.light2:setVisible(true)
		else
			self.light1:setVisible(false)
			self.light2:setVisible(false)	
		end
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

-- 重置对话框
function GuideToTaskView:resetPopup()
	local action1 = cc.DelayTime:create(0)
	local action2 = cc.CallFunc:create(function ()
		if self.index == 5 then
			local action1 = cc.MoveTo:create(0.1,cc.p(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT * 0.45))
			local action2 = cc.ScaleTo:create(0.1,1)
			local action = cc.Sequence:create(action1,action2)
			self.pop:runAction(action)
			self.con:setString("善良的勇者,感谢你从怪物的手中救了我,这是我给你的报酬")
		elseif self.index == 6 then
			self.con:setString("\n每天我都会发布一批神秘任务,如果你够勇敢，就能获得更多贝贝豆\n")
		end
	end)
	self:runAction(cc.Sequence:create(action1,action2))
end

-- 重置箱子纸张
function GuideToTaskView:resetPage()
	local actionList = {}
	local action1 = cc.DelayTime:create(0.6)
	table.insert(actionList,action1)

	if self.index == 2 then
		local action1 = cc.Place:create(cc.p(self.boxPos.x,self.boxPos.y + 100))
		local action2 = cc.ScaleTo:create(0.1,1)
		local action = cc.Sequence:create(action1,action2)
		table.insert(actionList,action)
	elseif self.index == 3 then
		local action1 = cc.ScaleTo:create(0.3,3)
		local action2 = cc.CallFunc:create(function ()
			self.pape:setVisible(false)
			local GuidePopup = require("view.guide.GuidePopup")
			local guidePopup = GuidePopup.create()
			s_SCENE:popup(guidePopup)
			s_SCENE.popupLayer.backColor:removeFromParent()
			guidePopup.ButtonClick = function ()
				guidePopup.showBean:runAction(cc.MoveTo:create(0.2,cc.p(s_RIGHT_X-100, s_DESIGN_HEIGHT-70)))
				if guidePopup.showBeanNumber and not tolua.isnull(guidePopup.showBeanNumber) then
					guidePopup.showBeanNumber:removeFromParent()
				end
				guidePopup.beanCountLabel:setString(guidePopup.beanCountLabel:getString()+10)
				local action1 = cc.DelayTime:create(0.3)
				local action2 = cc.CallFunc:create(function ()
					self:resetView()
					self.beans:setVisible(true)
					self.beanCountLabel:setString(self.beanCountLabel:getString()+10)
					s_CURRENT_USER:addBeans(10)
				end)
				self:runAction(cc.Sequence:create(action1,action2))
			end
		end)
		local action = cc.Sequence:create(action1,action2)
		table.insert(actionList,action)
	elseif self.index == 4 then
		local action = cc.CallFunc:create(function ()
			s_SCENE:removeAllPopups()
		end)
		table.insert(actionList,action)
	end

	self.pape:runAction(cc.Sequence:create(actionList))
end

-- 重置引导Label
function GuideToTaskView:resetLabel(time)
	if time == nil then
		return
	end
	if self.showIndex <= 13 then
		local action1 = cc.DelayTime:create(time)
		local action2 = cc.CallFunc:create(function ()
			s_CorePlayManager.enterGuideScene(self.showIndex,self.layer) 
		end)
		self:runAction(cc.Sequence:create(action1,action2))
	end
end

-- 重置箱子
function GuideToTaskView:resetBox()
	local actionList = {}
	local action1 = cc.ScaleTo:create(0.4,self.scaleTo)
	local action2 = cc.EaseBackOut:create(action1)
	local action3 = cc.MoveTo:create(0.4,self.boxPos)
	local action10 = cc.Spawn:create(action2,action3)
	table.insert(actionList,action10)

	if self.isOpen == true then
		local action1 = cc.MoveBy:create(0.1,cc.p(10,0))
        local action2 = action1:reverse()
        local action11 = cc.Sequence:create(action1,action2)
		table.insert(actionList,action11)
		table.insert(actionList,action11)
	end

	local action4 = cc.CallFunc:create(function () 
		if self.isOpen == true then
			self.box:setTexture('image/islandPopup/open.png')
		elseif self.isOpen == false then
			self.box:setTexture('image/islandPopup/close.png')
		else
			self.box:setTexture('image/islandPopup/baoxiang_close.png')
		end
	end)
	table.insert(actionList,action4)
	self.box:runAction(cc.Sequence:create(actionList))
end

return GuideToTaskView