require("playmodel.battle.Notification")

local BattleView = class('BattleView',function (  )
	return cc.Layer:create()
end)

function BattleView:ctor()
	--初始化
	s_BattleManager:battleBegan()
	--创建boss
	s_BattleManager:createBoss({'1','1','1'})
	--创建pet
	s_BattleManager:createPet({'2','3','4'})
	--绘制UI
	self:initUI()


end

function BattleView:initUI()

	--local back = cc.Sprite:create()
	local boss = s_BattleManager.bossList
	for i = 1,#boss do
		if s_BattleManager.currentBossIndex == i then
			boss[i].ui:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.9)
			self:addChild(boss[i].ui)
		else
			boss[i].ui:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.9 + 400)
			self:addChild(boss[i].ui)
		end
	end

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
		print('onTouchBegan')
        return true
    end

    local function onTouchEnded(touch, event)
    	s_BattleManager:sendNotification(ATTACK,{})
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return BattleView