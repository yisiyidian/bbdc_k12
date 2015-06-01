-- 任务界面UI
local TaskViewRender = require("view.taskview.TaskViewRender")  --任务列表渲染单元
-- local MissionManager = require("controller.MissionManager")		--任务管理器

local TaskView = class("TaskView", function()
	local layer = cc.Layer:create()

	return layer
end)

-- 构造函数
-- callBox      关闭界面的回调
-- beanCallBack	贝贝豆的增加回调
function TaskView:ctor(callBox,beanCallBack)
	self.listView = nil
	self.callBox = callBox
	self.beanCallBack = beanCallBack
	self:initUI()
end

--初始化UI
function TaskView:initUI()
	local background = cc.Sprite:create("image/islandPopup/task_background.png")
    background:setAnchorPoint(0.0,0.0)
    self.background = background
    self:addChild(background)
    
    local bigWidth = background:getContentSize().width
	local bigHeight = background:getContentSize().height

	local sx = (s_DESIGN_WIDTH - bigWidth)/2
	local sy = (s_DESIGN_HEIGHT - bigHeight)/2
	self:setPosition(sx,sy)
	--添加顶部图片(每日任务)
	local topSprite = cc.Sprite:create("image/islandPopup/task_everyday.png")
	topSprite:setAnchorPoint(0.5,0.5)
	topSprite:ignoreAnchorPointForPosition(false)
	topSprite:setPosition(260,580)
	self.topSprite = topSprite
	self:addChild(topSprite)
	print("picture:"..topSprite:getContentSize().height)
	--滚动层
	local listView = ccui.ScrollView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setTouchEnabled(false)
    listView:setContentSize(bigWidth,bigHeight - 180)
    listView:removeAllChildren()
    listView:setPosition(0,80)
    self:addChild(listView)
    self.listView = listView

	--关闭按钮
	local closeButton = ccui.Button:create("image/islandPopup/task_closebutton.png")
	closeButton:addTouchEventListener(handler(self,self.CloseClick))
	self.closeButton = closeButton
	self.closeButton:setPosition(450,580)
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
	-- local splitheight = 265
	local renderheight = 160
	self.listView:removeAllChildren()
	--遍历listData初始化
	for k,v in pairs(self.missionList) do
		render = TaskViewRender.new(v[1])
	    render:setData(v,handler(self,self.getRewardCallBack))
		renders[#renders + 1] = render 
		self.listView:addChild(render)
		innerHeight = innerHeight + renderheight
	end

	--计算render坐标
	if innerHeight < renderheight*3 then
		innerHeight = renderheight * 3 - 10
	end
	local tlen = innerHeight - renderheight
	for _,rd in pairs(renders) do
		rd:setPosition(50,tlen)
		tlen = tlen - renderheight	
	end

	self.listView:setInnerContainerSize(cc.size(self.background:getContentSize().width,innerHeight))
end

--关闭按钮点击
function TaskView:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end


	local action1 = cc.FadeOut:create(0.5)
	local action2 = cc.ScaleTo:create(0.5,0)
	local action3 = cc.MoveTo:create(0.5,cc.p(s_RIGHT_X - 600, - 400))
	local action4 = cc.CallFunc:create(function ()
									    s_SCENE:removeAllPopups()
										end,{})
	local action5 = cc.Spawn:create(action1,action2,action3)
	-- --关闭宝箱
	local action6 = cc.CallFunc:create(function ()

	if self.callBox ~= nil then
		self.callBox()
	end

	end)
	self:runAction(cc.Sequence:create(action5,action4,action6))

end

function TaskView:getRewardCallBack(taskId,index,position)
	--获取任务列表   随机生成了一个新的任务
	--修改UI
	local re,bean = s_MissionManager:completeMission(taskId,index)
	if not re then
		print("完成任务失败")
		return
	end

	print("re:"..tostring(re))
	print("bean:"..bean)
	local pos = self:convertToNodeSpace(cc.p(position.x,position.y))
	local beanImg = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
	--beanImg:setPosition(260,380)
	beanImg:setPosition(pos.x-420,pos.y-52)
	self:addChild(beanImg)
	self.beanImg = beanImg
	print('position..',self:getPositionX(),self:getPositionY())

	local action0 = cc.DelayTime:create(1)
	--要减去起始点的坐标  s_RIGHT_X为界面最右边的坐标（ipad会比iphone长一点 所以s_DESIGN_WIDTH不是左右边坐标）
	--减去精灵坐标 是要算出算出精灵在大的界面上的相对坐标
    local action1 = cc.MoveTo:create(1,cc.p(s_RIGHT_X-140 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    local action2 = cc.ScaleTo:create(0.1,0)
    local release = function(self)
    	beanImg:removeFromParent()
    	s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    	if self.beanCallBack ~= nil then 
    		self.beanCallBack()
    	end
    end
    local action4 = cc.CallFunc:create(handler(self,release))
    beanImg:runAction(cc.Sequence:create(action0,action1,action2,action4)) 
    self:resetView()
end

return TaskView


