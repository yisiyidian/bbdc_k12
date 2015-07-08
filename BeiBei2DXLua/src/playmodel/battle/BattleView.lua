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
	s_BattleManager:createPet({'2','3','4','5','6'})
	--绘制UI
	self:initUI()


end

function BattleView:initUI()

	--背景
	local background = cc.Sprite:create('image/playmodel/background.png')
	background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
	self:addChild(background)

	--local back = cc.Sprite:create()
	local boss = s_BattleManager.bossList
	for i = 1,#boss do
		if s_BattleManager.currentBossIndex == i then
			boss[i].ui:setPosition(s_DESIGN_WIDTH / 2 - 100,s_DESIGN_HEIGHT * 0.8)
			self:addChild(boss[i].ui)
		else
			boss[i].ui:setPosition(s_DESIGN_WIDTH / 2 - 100,s_DESIGN_HEIGHT * 0.8 + 400)
			self:addChild(boss[i].ui)
		end
	end

	local pet = s_BattleManager.petList
	for i = 1,#pet do
		pet[i].ui:setPosition(s_DESIGN_WIDTH * (5.5 - i) / 5,s_DESIGN_HEIGHT * 0.75)
		self:addChild(pet[i].ui)
	end

	local function update(delta)
		s_BattleManager:updateTime(delta)
	end
	self:scheduleUpdateWithPriorityLua(update,0)

    local MatView = require("playmodel.newmat.MatView").create()
	self:addChild(MatView)
	--暂停按钮
	s_SCENE.popupLayer.layerpaused = false 
    local pauseBtn = ccui.Button:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(1,1)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    self:addChild(pauseBtn,1)
    pauseBtn:setPosition(, s_DESIGN_HEIGHT)

    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
           s_BattleManager:createPausePopup()
        --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    onAndroidKeyPressed(pauseBtn, function ()
        s_BattleManager:createPausePopup()
    end, function ()

    end)


end

function BattleView:touchFunc()
	-- local function onTouchBegan(touch, event)
	-- 	print('onTouchBegan')
 --        return true
 --    end

 --    local function onTouchEnded(touch, event)
 --    	-- local list = {'3','4','2'}
 --    	-- s_BattleManager:sendNotification(ATTACK,{id = list})
 --    end

 --    local listener = cc.EventListenerTouchOneByOne:create()
 --    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
 --    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
 --    local eventDispatcher = self:getEventDispatcher()
 --    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return BattleView