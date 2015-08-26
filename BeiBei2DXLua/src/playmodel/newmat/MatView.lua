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
	self.locationX = 56 - 55
	self.locationY = 200 - 55
	self.size = cc.p(0,0)
	-- 每个砖块大小
	self.coco = {}
	-- 砖块容器

	-- 这个地方开始调用每个小岛的单词
	self.word = s_BattleManager.wordList
	-- 当前关卡的词汇
	self.path = {}
	self.path2 = {}
	self.mat = {{5,5,5,5,5,5,5,5,5,5},{5,5,5,5,5,5,5,5,5,5},{5,5,5,5,5,5,5,5,5,5},{5,5,5,5,5,5,5,5,5,5},{5,5,5,5,5,5,5,5,5,5},}

	-- 注册观察者
	MatController:register()
	MatController:reset()
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
	local wordsprite = ccui.Scale9Sprite:create("image/mat/circle.png",cc.rect(0,0,79,74),cc.rect(27.49,0,27.51,74))
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

    local chinesesprite = ccui.Scale9Sprite:create("image/playmodel/chinesedisplay.png",cc.rect(0,0,235,60),cc.rect(105.49,0,105.51,60))
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

    local changeButton = longButtonInStudy.create("image/playmodel/changeWordButton_downside.png","image/playmodel/changeWordButton_upside.png",5,"换词")
	changeButton:setPosition(cc.p(s_DESIGN_WIDTH *0.9,700))
    changeButton:ignoreAnchorPointForPosition(false)
    changeButton:setAnchorPoint(0.5,0.5)
    changeButton.color = cc.c4b(0,0,0,255)
    changeButton:resetUI()
	self.changeButton = changeButton
	self:addChild(self.changeButton)


	self.changeButton.func = function ()
		MatController:changeFunc()
	end

	local tipButton = longButtonInStudy.create("image/playmodel/changeWordButton_downside.png","image/playmodel/changeWordButton_upside.png",5,"提示")
	tipButton:setPosition(cc.p(s_DESIGN_WIDTH *0.1,700))
    tipButton:ignoreAnchorPointForPosition(false)
    tipButton:setAnchorPoint(0.5,0.5)
    tipButton.color = cc.c4b(0,0,0,255)
    tipButton:resetUI()
	self.tipButton = tipButton
	self:addChild(self.tipButton)

	self.tipButton.func = function ()
		self:letterTip()
	end

	local changeLabel = ""
	if s_CURRENT_USER.isSoundAm == 0 then
		changeLabel = "英"
	else
		changeLabel = "美"
	end

	local amButton = longButtonInStudy.create("image/playmodel/changeWordButton_downside.png","image/playmodel/changeWordButton_upside.png",5,changeLabel)
	amButton:setPosition(cc.p(s_DESIGN_WIDTH *0.1,1075))
    amButton:ignoreAnchorPointForPosition(false)
    amButton:setAnchorPoint(0.5,0.5)
    amButton.color = cc.c4b(0,0,0,255)
    amButton:resetUI()
	self.amButton = amButton
	self:addChild(self.amButton)

	self.amButton.func = function ()
		s_CURRENT_USER.isSoundAm = 1 - s_CURRENT_USER.isSoundAm	
		saveUserToServer({['isSoundAm']=s_CURRENT_USER.isSoundAm})
		if s_CURRENT_USER.isSoundAm == 0 then
			changeLabel = "英"
		else
			changeLabel = "美"
		end
		self.amButton.text = changeLabel
		self.amButton:resetUI()
	end

	-- ui填充
	self:resetUI()
	self:resetWordLabel("")
	-- 触摸事件
	self:touchFunc()
end

-- 重置英文划词
function MatView:resetWordLabel(string)
	local length = countLength(string)
	local len = string.len(string)
	if len == 0 or string == "" then
		self.wordsprite:setVisible(false)
	else
		self.wordsprite:setVisible(true)
		self.wordsprite:setContentSize(length * 7 + 60 ,74)
	end

	self.wordlabel:setString(string)
	self.wordlabel:setPosition(self.wordsprite:getContentSize().width/2,self.wordsprite:getContentSize().height/2)
end

-- 重置汉语意思
function MatView:resetChineseLabel(string)
	local length = countLength(string)
	local len = string.len(string)
	if len == 0 or string == "" then
		self.chinesesprite:setVisible(false)
	else
		self.chinesesprite:setVisible(true)
		self.chinesesprite:setContentSize(length * 7 + 60 ,60)
	end

	self.chineselabel:setString(string)
	self.chineselabel:setPosition(self.chinesesprite:getContentSize().width/2,self.chinesesprite:getContentSize().height/2)
end

function MatView:resetUI()
	-- self.changeButton.label:setString(MatController.index)
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
			self.coco[i][j]:setPosition(cc.p(self.locationX + i * 110 ,self.locationY + j * 110))	 
			self.coco[i][j].letter = string.char(math.random(100,120))
			if self.mat[i][j] == 5 then
				self.coco[i][j].color = 0
			else
				self.coco[i][j].color = self.mat[i][j]
			end
			self.coco[i][j]:resetView()
			if j > 5 then
				self.coco[i][j]:setVisible(false)
			end
			-- 加入砖块
		end
	end

	-- 获取参数
	local length = string.len(MatController.word[MatController.index][1])
	math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 

	-- 是否反向
	local random = math.random(1,2)
	print(MatController.word[MatController.index][1])
	print(random)
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
		self.coco[self.path[k].x][self.path[k].y].letter = string.sub(MatController.word[MatController.index][1],k,k) 
		if k == 1 then
			self.coco[self.path[k].x][self.path[k].y].isFisrt = true
		end
		self.coco[self.path[k].x][self.path[k].y]:resetView()
		print(string.sub(MatController.word[MatController.index][1],k,k)..self.path[k].x..self.path[k].y)
	end
	-- print(MatController.word[1])

	-- 获取第二条路径
	self.path2 = AlternatePathController:getPath(self.path)

	-- 重新绘制砖块
	for k,v in pairs(self.path2) do
		self.coco[self.path2[k].x][self.path2[k].y].letter = string.sub(MatController.word[MatController.index][1],k,k) 
		if k == 1 then
			self.coco[self.path2[k].x][self.path2[k].y].isFisrt = true
		end
		self.coco[self.path2[k].x][self.path2[k].y]:resetView()
		print(string.sub(MatController.word[MatController.index][1],k,k)..self.path2[k].x..self.path2[k].y)
	end
	local word = MatController.word[MatController.index][3]
	self:resetChineseLabel(s_LocalDatabaseManager.getWordInfoFromWordName(word).wordMeaningSmall)

	self:letterTip()
	self:runAct()

end

function MatView:runAct()
	-- for i=1,5 do
	-- 	for j=1,5 do
	-- 		local t1 = cc.DelayTime:create(0.2*i/5)
	-- 		local r1 = cc.RotateBy:create(0.2*j/5,30)
	-- 		local r2 = cc.RotateBy:create(0.2*j/5,-60)
	-- 		local r3 = cc.RotateBy:create(0.2*j/5,30)
	-- 		self.coco[i][j]:runAction(cc.Sequence:create(r1,r2,r3))
	-- 	end
	-- end
end

function MatView:letterTip()
	-- -- 首字母提示
	-- for i=1,5 do
	-- 	for j=1,5 do
	-- 		if self.coco[i][j].letter == string.sub(MatController.word[MatController.index][1],1,1) then
	-- 			self.coco[i][j].touchState = 2
	-- 		end
	-- 		self.coco[i][j]:resetView()
	-- 	end
	-- end

	-- s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	-- local delayAction =  cc.DelayTime:create(1)
	-- local runAction = cc.CallFunc:create(function ( ... )
	-- 	s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
	-- 	for i=1,5 do
	-- 		for j=1,5 do
	-- 			self.coco[i][j].touchState = 1
	-- 			self.coco[i][j]:resetView()
	-- 		end
	-- 	end
	-- end)
	-- self:runAction(cc.Sequence:create(delayAction,runAction))
end

function MatView:dropFunc(callback)
	-- 掉落事件
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	for i=1,5 do
		for j=1,10 do
			if self.coco[i][j].touchState ~= 1 then
				local chilli = cc.Sprite:create("image/playmodel/chilliNormal.png")
				chilli:setPosition(self.locationX + i * 110 ,self.locationY + j * 110)
				self.back:addChild(chilli)

				local px,py
				px,py = s_BattleManager.petList[1].ui:getPosition()
				chilli:runAction(cc.MoveTo:create(0.4,cc.p(px,py)))
			end
		end
	end

	for i=1,5 do
		for j=1,10 do
			if self.coco[i][j]:getPositionY() - 120 * self.coco[i][j].drop <= self.coco[i][5]:getPositionY() then
				self.coco[i][j]:setVisible(true)
			end
			self.coco[i][j]:runAction(cc.MoveBy:create(0.4,cc.p(0,-120 * self.coco[i][j].drop)))
		end
	end

	local delay = cc.DelayTime:create(0.4)
	self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function ()
		if callback ~= nil then callback() end
	end)))

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