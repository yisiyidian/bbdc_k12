require("playmodel.battle.Notification")

local BattleView = class('BattleView',function (  )
	return cc.Layer:create()
end)

function BattleView:ctor()
	--初始化
	s_BattleManager:battleBegan()
	-- --创建boss
	-- s_BattleManager:createBoss({'1','1','1'})
	-- --创建pet
	-- s_BattleManager:createPet({'2','3','4','5','6'})
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
	--显示关卡信息
	self:showStageInfo()
	--暂停按钮
	s_SCENE.popupLayer.layerpaused = false 
    local pauseBtn = ccui.Button:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(1,1)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    self:addChild(pauseBtn,1)
    pauseBtn:setPosition(s_RIGHT_X, s_DESIGN_HEIGHT)

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

    -- 播放背景音乐	
    playMusic(s_sound_Get_Outside,true)
end

function BattleView:showStageInfo()
	local back = cc.LayerColor:create(cc.c4b(255,255,255,150),200,110)
	back:setPosition(0,950)
	self:addChild(back)
	local label_boss = cc.Label:createWithSystemFont('boss:'..(s_BattleManager.currentBossIndex - 1)..'/'..#s_BattleManager.bossList,'',28)
	label_boss:setColor(cc.c3b(0,0,0))
	label_boss:setPosition(back:getContentSize().width / 2,100)
	back:addChild(label_boss)

	local label_collect = cc.Label:createWithSystemFont('collection:','',28)
	label_collect:setColor(cc.c3b(0,0,0))
	label_collect:setPosition(back:getContentSize().width / 2,70)
	back:addChild(label_collect)

	local label_time = cc.Label:createWithSystemFont('','',28)
	label_time:setColor(cc.c3b(0,0,0))
	label_time:setPosition(back:getContentSize().width / 2,40)
	back:addChild(label_time)

	local label_wordCount = cc.Label:createWithSystemFont('','',28)
	label_wordCount:setColor(cc.c3b(0,0,0))
	label_wordCount:setPosition(back:getContentSize().width / 2,10)
	back:addChild(label_wordCount)
	local function update(delta)
		label_boss:setString('boss:'..(s_BattleManager.currentBossIndex - 1)..'/'..#s_BattleManager.bossList)
		label_wordCount:setString('wordCount:'..s_BattleManager.currentWordCount..'/'..s_BattleManager.totalWordCount)
		label_collect:setString('collection:'..s_BattleManager.currentCollect[1]..s_BattleManager.currentCollect[2]..s_BattleManager.currentCollect[3]..s_BattleManager.currentCollect[4]..s_BattleManager.currentCollect[5])
		if s_BattleManager.stageType == 'time' then
			local time = s_BattleManager.totalTime - s_BattleManager.currentTime
			label_time:setString('time left:'..math.floor(time / 60)..':'..math.floor(time % 60))
		else
			label_time:setString('step:'..s_BattleManager.currentStep..'/'..s_BattleManager.totalStep)
		end
	end

	back:scheduleUpdateWithPriorityLua(update,0)
end

return BattleView