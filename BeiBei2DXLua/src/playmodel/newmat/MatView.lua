-- 矩阵
local CocoView = require("playmodel.newmat.CocoView")
local PathController = require("playmodel.newmat.PathController")
local AlternatePathController = require("playmodel.newmat.AlternatePathController")
local MatController = require("playmodel.newmat.MatController")
local longButtonInStudy = require("view.button.longButtonInStudy")
local MatView = class("MatView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function MatView.create()
	return MatView.new()
end

function MatView:ctor()
	self.size = cc.p(0,0)
	-- 每个砖块大小
	self.coco = {}
	-- 砖块容器

	-- 这个地方开始调用每个小岛的单词
	self.word = {"apple",}
	-- 当前关卡的词汇
	self.path = {}
	self.path2 = {}

	-- 注册观察者
	MatController:register()
	-- 控制器和视图建立联系
	MatController.MatView = self
	MatController.word = MatController:createWordGroup(self.word)

	-- 初始化ui
	self:initUI()
end

function MatView:initUI()
	-- 砖块矩阵5*5
	-- 坐标（1，1）到坐标（5，5）

	local back = cc.Sprite:create()
	back:setPosition(cc.p(0,0))
	back:ignoreAnchorPointForPosition(false)
	back:setAnchorPoint(0.5,0.5)
	self.back = back 
	self:addChild(self.back)
	-- 布景

	-- 划词显示
	local wordsprite = ccui.Scale9Sprite:create("image/playmodel/changeWordButton_upside.png")
	wordsprite:setPosition(cc.p(s_DESIGN_WIDTH /2,770))
	wordsprite:setAnchorPoint(0.5,0.5)
	self.wordsprite = wordsprite
	self:addChild(self.wordsprite)

	local wordlabel = cc.Label:createWithSystemFont("","",25)
    wordlabel:ignoreAnchorPointForPosition(false)
    wordlabel:setAnchorPoint(0.5,0.5)
    wordlabel:setColor(cc.c4b(0,0,0,255))
    self.wordlabel = wordlabel
    self.wordsprite:addChild(self.wordlabel)

    local chinesesprite = ccui.Scale9Sprite:create("image/playmodel/changeWordButton_downside.png")
	chinesesprite:setPosition(cc.p(s_DESIGN_WIDTH /2,700))
	chinesesprite:setAnchorPoint(0.5,0.5)
	self.chinesesprite = chinesesprite
	self:addChild(self.chinesesprite)

	local chineselabel = cc.Label:createWithSystemFont("","",25)
    chineselabel:ignoreAnchorPointForPosition(false)
    chineselabel:setAnchorPoint(0.5,0.5)
    chineselabel:setColor(cc.c4b(0,0,0,255))
    self.chineselabel = chineselabel
    self.chinesesprite:addChild(self.chineselabel)

    local changeButton = longButtonInStudy.create("image/playmodel/changeWordButton_downside.png","image/playmodel/changeWordButton_upside.png",5,"")
	changeButton:setPosition(cc.p(s_DESIGN_WIDTH *0.8,700))
    changeButton:ignoreAnchorPointForPosition(false)
    changeButton:setAnchorPoint(0.5,0.5)
	self.changeButton = changeButton
	self:addChild(self.changeButton)

	self.changeButton.func = function ()
		MatController:changeFunc()
	end

	-- ui填充
	self:resetUI()
	self:resetWordLabel("")
	-- 触摸事件
	self:touchFunc()
end

-- 重置英文划词
function MatView:resetWordLabel(string)
	local len = string.len(string)
	if len == 0 or string == "" then
		self.wordsprite:setVisible(false)
	else
		self.wordsprite:setVisible(true)
		self.wordsprite:setContentSize((len+1) * 18 + 60 ,63)
	end

	self.wordlabel:setString(string)
	self.wordlabel:setPosition(self.wordsprite:getContentSize().width/2,self.wordsprite:getContentSize().height/2)
end

-- 重置汉语意思
function MatView:resetChineseLabel(string)
	local len = string.len(string)
	if len == 0 or string == "" then
		self.chinesesprite:setVisible(false)
	else
		self.chinesesprite:setVisible(true)
		self.chinesesprite:setContentSize((len+1) * 18 + 60 ,63)
	end

	self.chineselabel:setString(string)
	self.chineselabel:setPosition(self.chinesesprite:getContentSize().width/2,self.chinesesprite:getContentSize().height/2)
end

function MatView:resetUI()
	self.changeButton.label:setString(MatController.index.."/"..MatController.index)
	-- 重置
	if self.coco ~= nil then
		self.back:removeAllChildren()
		self.coco = {}
	end
	math.randomseed(os.time())

	-- 砖块初始化
	for i=1,5 do
		local temp = {}
		self.coco[#self.coco +1] = temp 
		for j=1,10 do
			local cocoView = CocoView.create()
			self.coco[i][j] = cocoView 
			self.back:addChild(self.coco[i][j])
			self.coco[i][j]:setPosition(cc.p(i * 120 -40,j * 120))	 
			self.coco[i][j].letter = string.char(math.random(100,120))
			self.coco[i][j].color = math.random(1,1000)%5
			self.coco[i][j]:resetView()
			if j > 5 then
				self.coco[i][j]:setVisible(false)
			end
			-- 加入砖块
		end
	end

	-- 获取参数
	local length = string.len(MatController.word[MatController.index])
	math.randomseed(os.time())

	-- 是否反向
	local random = math.random(1,2)
	-- 获取第一条路径
	self.path = PathController:getPath(length)
	local temp = {}
	if random == 2 then
		for k,v in pairs(self.path) do
		 	local tempP = cc.p(0,0)
		 	tempP.x = self.path[#self.path - k + 1].x
		 	tempP.y = self.path[#self.path - k + 1].y
		 	temp[#temp +1] = tempP
		 end 
		self.path = temp
	end

	-- 重新绘制砖块
	for k,v in pairs(self.path) do
		self.coco[self.path[k].x][self.path[k].y].letter = string.sub(MatController.word[MatController.index],k,k) 
		self.coco[self.path[k].x][self.path[k].y]:resetView()
		-- print(string.sub(MatController.word[1],k,k)..self.path[k].x..self.path[k].y)
	end
	-- print(MatController.word[1])

	-- 获取第二条路径
	self.path2 = AlternatePathController:getPath(self.path)

	-- 重新绘制砖块
	for k,v in pairs(self.path2) do
		self.coco[self.path2[k].x][self.path2[k].y].letter = string.sub(MatController.word[MatController.index],k,k) 
		self.coco[self.path2[k].x][self.path2[k].y]:resetView()
		-- print(string.sub(MatController.word[1],k,k)..self.path2[k].x..self.path2[k].y)
	end
end

function MatView:dropFunc()
	-- 掉落事件
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	for i=1,5 do
		for j=1,10 do
			if self.coco[i][j]:getPositionY() - 120 * self.coco[i][j].drop <= self.coco[i][5]:getPositionY() then
				self.coco[i][j]:setVisible(true)
			end
			self.coco[i][j]:runAction(cc.MoveBy:create(0.4,cc.p(0,-120 * self.coco[i][j].drop)))
		end
	end

	-- 重置ui
	local delay = cc.DelayTime:create(0.5)
	self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(self.resetUI)))

	-- 解锁
	local delay = cc.DelayTime:create(0.6)
	self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)))

end


function MatView:touchFunc()
	-- 触摸砖块，更新控制器的字母序列
	local function onTouchBegan(touch, event)
        local location = self.back:convertToNodeSpace(touch:getLocation())
        for i = 1,5 do
        	for j=1,5 do
        		if cc.rectContainsPoint(self.coco[i][j]:getBoundingBox(),location) then
        			MatController:updateArr(cc.p(i,j),self.coco[i][j])
        		end
        	end
        end
        return true
    end

    local function onTouchMoved(touch, event)
        local location = self.back:convertToNodeSpace(touch:getLocation())
        for i = 1,5 do
        	for j=1,5 do
        		if cc.rectContainsPoint(self.coco[i][j]:getBoundingBox(),location) then
        			MatController:updateArr(cc.p(i,j),self.coco[i][j])
        		end
        	end
        end
    end

    -- 触摸结束，进行判断
    local function onTouchEnded(touch, event)
    	MatController.judgeFunc()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self.back:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.back)
end

return MatView