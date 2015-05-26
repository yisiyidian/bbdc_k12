-- 任务界面UI
local TaskViewRender = require("view.taskview.TaskViewRender")  --任务列表渲染单元
local MissionManager = require("controller.MissionManager")		--任务管理器

local TaskView = class("TaskView", function()
	local layer = cc.Layer:create()
	return layer
end)

function TaskView:ctor()
	self.listView = nil
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
	print("background:"..bigHeight)

	print("bigWidth:"..bigWidth)
	print("bigHeight:"..bigHeight)
	--添加顶部图片(每日任务)
	local topSprite = cc.Sprite:create("image/islandPopup/task_everyday.png")
	topSprite:setAnchorPoint(0.5,0.5)
	topSprite:ignoreAnchorPointForPosition(false)
	topSprite:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self.topSprite = topSprite
	self:addChild(topSprite)
	print("picture:"..topSprite:getContentSize().height)

	--滚动层
	local listView = ccui.ScrollView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setTouchEnabled(true)
    --listView:setContentSize(bigWidth,bigHeight - 43)
    listView:setContentSize(bigWidth,bigHeight - 100)
    listView:removeAllChildren()
    --self:addChild(listView)
    background:addChild(listView)
    self.listView = listView

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
	local splitheight = 265
	local renderheight = 160

	--遍历listData初始化
	for k,v in pairs(self.missionList) do
		render = TaskViewRender.new(v[1])
	    render:setData(v,handler(self,self.callback))
		renders[#renders + 1] = render 
		self.listView:addChild(render)
		innerHeight = innerHeight + splitheight
	end

	--计算render坐标
	local tlen = innerHeight - renderheight
	for _,rd in pairs(renders) do
		rd:setPosition(0,tlen)
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
	local action3 = cc.MoveTo:create(0.5,cc.p(s_RIGHT_X - 600, - 400))
	local action4 = cc.CallFunc:create(function ()
									    s_SCENE:removeAllPopups()
										end,{})
	local action5 = cc.Spawn:create(action1,action2,action3)
	self:runAction(cc.Sequence:create(action5,action4))

end

function TaskView:callback()
	--获取任务列表   随机生成了一个新的任务
	print("wwwwwwwwwwww")
	self.missionlist = s_MissionManager:getMissionList()
	dump(self.missionlist)

	--修改UI
	self:resetView()
	print("ssssssssssss")

	local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
	bean:setPosition(0,0)
	self:addChild(bean)
	self.bean = bean
	print('position..',self:getPositionX(),self:getPositionY())

	local action0 = cc.DelayTime:create(1)
	--要减去起始点的坐标  s_RIGHT_X为界面最右边的坐标（ipad会比iphone长一点 所以s_DESIGN_WIDTH不是左右边坐标）
	--减去精灵坐标 是要算出算出精灵再大的界面上的相对坐标
    local action1 = cc.MoveTo:create(1,cc.p(s_RIGHT_X-140 - self:getPositionX(), s_DESIGN_HEIGHT-70 - self:getPositionY()))
    local action2 = cc.ScaleTo:create(0.1,0)
    local release = function()
    	bean:removeFromParent()
    end
    local action4 = cc.CallFunc:create(release)
    bean:runAction(cc.Sequence:create(action0,action1,action2,action4)) 

    --右上角 增加贝贝豆
	
end

return TaskView


