-- 矩阵
local CocoView = require("playmodel.newmat.CocoView")
local MatController = require("playmodel.newmat.MatController")
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
	self.word = {}
	-- 当前关卡的词汇

	-- 初始化ui
	self:initUI()
	-- 注册观察者
	MatController:register()
	MatController.MatView = self
	for k,v in pairs(self.word) do
		table.insert(MatController.word,v)
	end
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


	self:resetUI()
	self:touchFunc()
end

function MatView:resetUI()
	if self.coco ~= nil then
		self.back:removeAllChildren()
		self.coco = {}
	end
	math.randomseed(os.time())
	for i=1,5 do
		local temp = {}
		self.coco[#self.coco +1] = temp 
		for j=1,10 do
			local cocoView = CocoView.create()
			self.coco[i][j] = cocoView 
			self.back:addChild(self.coco[i][j])
			self.coco[i][j]:setPosition(cc.p(i * 120 -40,j * 120))	 
			self.coco[i][j].letter = string.char(math.random(100,120))
			self.coco[i][j]:resetView()
			if j > 5 then
				self.coco[i][j]:setVisible(false)
			end
			-- 加入砖块
		end
	end
end

function MatView:dropFunc()
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	for i=1,5 do
		for j=1,10 do
			if self.coco[i][j]:getPositionY() - 120 * self.coco[i][j].drop <= self.coco[i][5]:getPositionY() then
				self.coco[i][j]:setVisible(true)
			end
			self.coco[i][j]:runAction(cc.MoveBy:create(0.4,cc.p(0,-120 * self.coco[i][j].drop)))
		end
	end

	local delay = cc.DelayTime:create(0.5)
	self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(self.resetUI)))

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