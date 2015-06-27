local BattleView = class('BattleView',function (  )
	return cc.Layer:create()
end)

function BattleView:ctor()
	s_BattleManager:register()
	--初始化
	s_BattleManager:initBattle()
	--创建boss boss编号
	s_BattleManager:createBoss({'1','1','1'})

	--创建pet pet编号
	s_BattleManager:createPet({'2','3','4'})
	--绘制UI
	self:initUI()


end

function BattleView:initUI()

	--local back = cc.Sprite:create()
	local currentBoss = self.currentBoss.ui
	currentBoss:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.9)
	self:addChild(currentBoss)

	local pet = s_BattleManager.petList
	for i = 1,#pet do
		pet[i].ui:setPosition(s_DESIGN_WIDTH * (5.5 - i) / 5,s_DESIGN_HEIGHT * 0.7)
		self:addChild(pet[i].ui)
	end
	--点击事件
    self:touchFunc()

end

function BattleView:touchFunc()
	local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchEnded(touch, event)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return BattleView