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
	self.coco = {}

	-- 初始化ui
	self:initUI()
	-- 注册观察者
	MatController:register()
end

function MatView:initUI()
	-- 砖块矩阵5*5
	-- 坐标（1，1）到坐标（5，5）

	local back = cc.Sprite:create()
	back:setPosition(cc.p(0,0))
	back:ignoreAnchorPointForPosition(false)
	back:setAncherPoint(0.5,0.5)
	self.back = back 
	self:addChild(self.back)

	for i=1,5 do
		for j=1,5 do
			local cocoView = CocoView.create()
			self.coco[i][j] = cocoView 
			self.back:addChild(self.coco[i][j])
		end
	end
end

function MatView:touchFunc()
	local function onTouchBegan(touch, event)
        local location = self.back:convertToNodeSpace(touch:getLocation())
        for i = 1,5 then
        	for j=1,5 do
        		if cc.rectContainsPoint(self.coco[i][j]:getBoundingBox(),location) then
        			MatController.updateArr(cc.p[i][j])
        		end
        	end
        end
        return true
    end

    local function onTouchMoved(touch, event)
        local location = self.back:convertToNodeSpace(touch:getLocation())
        for i = 1,5 then
        	for j=1,5 do
        		if cc.rectContainsPoint(self.coco[i][j]:getBoundingBox(),location) then
        			MatController.updateArr(cc.p[i][j])
        		end
        	end
        end
        return true
    end

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