-- 任务界面UI
local TaskViewRender = require("view.taskview.TaskViewRender")  --任务列表渲染单元
local MissionManager = require("controller.MissionManager")		--任务管理器

local TaskView = class("TaskView", function()
	local layer = cc.Layer:create()
	return layer
end)

function TaskView:ctor()
	self:initUI()
end

--初始化UI
function TaskView:initUI()
	local background = cc.Sprite:create("image/islandPopup/task_background.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(background)
    self.background = background
    background:setAnchorPoint(0.5,0.5)

    local bigWidth = background:getContentSize().width
	local bigHeight = background:getContentSize().height

	print("bigWidth:"..bigWidth)
	print("bigHeight:"..bigHeight)
	--添加顶部图片(每日任务)
	local topSprite = cc.Sprite:create("image/islandPopup/task_everyday.png")
	topSprite:setAnchorPoint(0.5,0.5)
	topSprite:ignoreAnchorPointForPosition(false)
	topSprite:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self.topSprite = topSprite
	self:addChild(topSprite)

	--关闭按钮
	local closeButton = ccui.Button:create("image/islandPopup/task_closebutton.png")
	closeButton:addTouchEventListener(handler(self,self.CloseClick))
	self.closeButton = closeButton
	self.closeButton:setPosition(bigWidth,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self:addChild(closeButton)
	--渲染列表
	self:resetView()
end

--初始化UI
function TaskView:resetView()
	self.missionList = s_MissionManager:getMissionList()
	-- dump(self.missionList,"任务列表数据")
	--创建中间的任务部分
	local render = nil
	local renders = {} --临时容器 计算坐标用
	local innerHeight = 0
	local splitheight = 420
	local renderheight = 160

	--遍历listData初始化
	for k,v in pairs(self.missionList) do
		render = TaskViewRender.new(v[1])
	    render:setData(v)
		renders[#renders + 1] = render 
		self:addChild(render)
		innerHeight = innerHeight + splitheight
	end

	--计算render坐标
	local tlen = innerHeight - renderheight
	for _,rd in pairs(renders) do
		rd:setPosition(110,tlen)
		tlen = tlen - renderheight	
	end
end

--关闭按钮点击
function TaskView:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	local action1 = cc.FadeOut:create(0.5)
	local action2 = cc.ScaleTo:create(0.5,0)
	print("XXXXXXXXXX",self:getPositionX())
	print("YYYYYYYYYY",self:getPositionY())
	print("ZZZZZZZZZZ"..s_RIGHT_X)
	-- local action3 = cc.MoveTo:create(0.5,cc.p(s_RIGHT_X - self:getPositionX() - 600, -self:getPositionY()
	-- 	 - 400))
	local action3 = cc.MoveTo:create(0.5,cc.p(s_RIGHT_X - 600, - 400))
	local action4 = cc.CallFunc:create(function ()
									    s_SCENE:removeAllPopups()
										end,{})
	local action5 = cc.Spawn:create(action1,action2,action3)
	self:runAction(cc.Sequence:create(action5,action4))

end

return TaskView


