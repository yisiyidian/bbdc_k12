
local TaskViewRender = require("view.taskview.TaskViewRender")

local TaskView = class("TaskView", function()
	local layer = cc.Layer:create()
	return layer
end)

function TaskView:ctor()
	self:init()
end

function TaskView:init()


	local background = cc.Sprite:create("image/islandPopup/task_background.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(background)
    self.background = background
    background:setAnchorPoint(0.5,0.5)

    local bigWidth = background:getContentSize().width
	local bigHeight = background:getContentSize().height

	--添加顶部图片(每日任务)
	local topSprite = cc.Sprite:create("image/islandPopup/task_everyday.png")
	topSprite:setAnchorPoint(0.5,0.5)
	topSprite:ignoreAnchorPointForPosition(false)
	topSprite:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self.topSprite = topSprite
	self:addChild(topSprite)

	-- --标题
	-- local title = cc.Label:createWithSystemFont("每日任务", "", 36)
	-- title:setTextColor(cc.c3b(0,0,0))
	-- self.title = title
	-- title:setPosition(bigWidth * 0.5,bigHeight - 20)
	-- self:addChild(title)

	--关闭按钮
	local closeButton = ccui.Button:create("image/islandPopup/task_closebutton.png")
	closeButton:addTouchEventListener(handler(self,self.CloseClick))
	self.closeButton = closeButton
	self.closeButton:setPosition(bigWidth,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self:addChild(closeButton)

	--初始化数据
	self:initData()
	--初始化UI
	self:initUI()
	
end

--初始化数据
function TaskView:initData()

	--应该有一些变量去初始化（任务类型）（贝贝豆数量）（登录天数）

	--初始化数据 key(任务类型图标) type(任务类型)  taskname(任务名称) callback(回掉函数，现在用不到)  bbdnum(简历的贝贝豆数量)  addday(累计天数)  taskfalg
	local listData = {}
	listData[1] = {["key"] = "leftImg",	["type"] = TaskViewRender.LOG,        ["taskname"] = nil, ["callback"] = nil, ["bbdnum"] = nil, ["addday"] = "", ["taskflag"] = "false"}
	listData[2] = {["key"] = "leftImg", ["type"] = TaskViewRender.TASKRANDOM, ["taskname"] = nil, ["callback"] = nil, ["bbdnum"] = 100, ["addday"] = "", ["taskflag"] = "false"}

	self.listData = listData
end

--初始化UI
function TaskView:initUI()

	--创建中间的任务部分
	local render = nil
	local renders = {} --临时容器 计算坐标用
	local innerHeight = 0
	local splitheight = 350
	local renderheight = 50

	--遍历listData初始化
	for k,v in pairs(self.listData) do
		render = TaskViewRender.new(v.type)
	    render:setData(v)
		renders[#renders+1] = render 
		self:addChild(render)
		innerHeight = innerHeight + splitheight
	end

	--计算render坐标
	local tlen = innerHeight - renderheight
	for _,rd in pairs(renders) do
		rd:setPosition(0,tlen)
		tlen = tlen - splitheight	
	end


	--设置坐标
	-- innerHeight = innerHeight + 130
	-- self.topSprite:setPosition(s_DESIGN_WIDTH*0.5,innerHeight - 80)
	-- self.listView:addChild(self.title)
    -- self.closeButton:setPosition(s_DESIGN_WIDTH*0.1,innerHeight - 80)
	-- self:addChild(self.btnReturn)
	-- self.title:setPosition(s_DESIGN_WIDTH*0.1,innerHeight - 80)
	-- self.listView:addChild(self.btnReturn)

end

--关闭按钮点击
function TaskView:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	s_SCENE:removeAllPopups()
end

return TaskView


