local TaskViewRender = class("TaskViewRender", function()
	local layer = cc.Layer:create()
	return layer
end)

--累计任务类型
TaskViewRender.LOG = "TaskViewRender.LOG"

--随机任务类型
TaskViewRender.TASKRANDOM = "TaskViewRender.TASKRANDOM"

function TaskViewRender:ctor(type)
	self.type = type
	self:init(type)
end

function TaskViewRender:init(type)
	-- --白色底
	-- local bg  = cc.Sprite:create("image/login/login_white_background.png")
	-- local bgSize = bg:getContentSize()
	-- bg:setPosition(bgSize.width/2, bgSize.height/2)
	-- self:addChild(bg)
	-- self.bg = bg
	--IMG
	local img = cc.Sprite:create("image/islandPopup/task_add_newwords.png")
	img:setPosition(150, s_DESIGN_HEIGHT / 2 -160)
	img:setAnchorPoint(0.5,0.5)
	img:ignoreAnchorPointForPosition(false)
	self:addChild(img)
	self.img = img

	--累积生词上的钱袋
	local purse = cc.Sprite:create("image/islandPopup/task_newword.png")
	purse:setPosition(150,s_DESIGN_HEIGHT / 2 -170)
	purse:setAnchorPoint(0.5,0.5)
	purse:ignoreAnchorPointForPosition(false)
	self:addChild(purse)
	self.purse = purse
	-- --按钮
	-- local checkBox = ccui.CheckBox:create()
	-- checkBox:setTouchEnabled(true) --可点击
	-- checkBox:loadTextures(
	-- 	"image/islandPopup/task_button2.png",--normal
	-- 	"image/islandPopup/task_button2.png",--normal press
	-- 	"image/islandPopup/task_button1.png",--normal active
	-- 	"image/islandPopup/task_button2.png",-- normal disable
	-- 	"image/islandPopup/task_button2.png"--active disable
	-- 	)
	-- 	checkBox:addEventListener(handler(self, self.onCheckBoxTouch))
	-- 	checkBox:setPosition(bgSize.width*0.8, bgSize.height/2)
	-- 	checkBox:setSelected(true)	--默认选中
	-- 	self.checkBox = checkBox
	-- 	self:addChild(checkBox)

	-- --奖励贝贝豆数量
	-- local bbdnum = cc.Label:createWithSystemFont("","",15)
	-- bbdnum:setPosition(bgSize.width*0.5,bgSize.height*0.4)
	-- bbdnum:setAnchorPoint(0.0,0.0)
	-- self.bbdnum = bbdnum
	-- self.bbdnum:setTextColor(cc.c3b(0,0,0))
	-- self:addChild(self.bbdnum)

	-- --累计任务类型
	-- if type == TaskViewRender.LOG then
	-- 	local CumulativeTask = cc.Label:createWithSystemFont("","",20)
	-- 	CumulativeTask:setPosition(bgSize.width*0.3,bgSize.height*0.6)
	-- 	CumulativeTask:setAnchorPoint(0.0,0.0)
	-- 	self.CumulativeTask = CumulativeTask
	-- 	self.CumulativeTask:setTextColor(cc.c3b(0, 0, 0))
	-- 	self:addChild(self.CumulativeTask)
	-- end

	-- --随机任务类型
	-- if type == TaskViewRender.TASKRANDOM then
	-- 	local RandomTask = cc.Label:createWithSystemFont("1235466","",50)
	-- 	RandomTask:setPosition(bgSize.width*0.3,bgSize.height*0.6)
	-- 	RandomTask:setAnchorPoint(cc.p(0.0,0.0))
	-- 	self.RandomTask = RandomTask
	-- 	self.RandomTask:setTextColor(cc.c3b(0, 0, 0))
	-- 	self:addChild(self.RandomTask)
	-- 	print("2222222222222")

	-- end
end

function TaskViewRender:setData(data)
	self.key = data.key
	self.type = data.data
	self.taskname = data.taskname
	self.callback = callback
	self.bbdnum = data.bbdnum
	self.addday = data.addday

	--更新界面
	--self:updataView()
end

--更新数据
function TaskViewRender:updataView()
	if self.type == TaskViewRender.LOG then 
		--贝贝豆数量
		self.bbdnum:setString(self.bbdnum)
		
	elseif self.type == TaskViewRender.TASKRANDOM then
		--贝贝豆数量
		local RandomTaskBBD = "奖励："..self.bbdnum.."贝贝豆"
		self.bbdnum:setString(RandomTaskBBD)

		--任务类型
		self.bbdnum:setString(self.type)
	end
end

--复选框事件处理
function TaskViewRender:onCheckBoxTouch(sender,eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		--按钮变灰 不可点击

		--判断下一个任务是否完成（不一定在这里判断）

		--改变贝贝豆与任务进度
		
	elseif eventType == ccui.CheckBoxEventType.unselected then
		
	end

end



return TaskViewRender