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
			boss[i].ui:setPosition(s_DESIGN_WIDTH / 2 ,s_DESIGN_HEIGHT * 0.8 + 20)
			self:addChild(boss[i].ui)
		else
			boss[i].ui:setPosition(s_DESIGN_WIDTH / 2 ,s_DESIGN_HEIGHT * 0.8 + 420)
			self:addChild(boss[i].ui)
		end
	end



	local function update(delta)
		s_BattleManager:updateTime(delta)
	end
	self:scheduleUpdateWithPriorityLua(update,0)

    local MatView = require("playmodel.newmat.MatView").create()
	self:addChild(MatView)

	local pet = s_BattleManager.petList
	pet[1].ui:setPosition(336,110)
	self:addChild(pet[1].ui)
	
	--显示关卡信息
	self:showStageInfo()
	--暂停按钮
	s_SCENE.popupLayer.layerpaused = false 
    local pauseBtn = ccui.Button:create("image/playmodel/pauseNormal.png","image/playmodel/pausePress.png","")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0.5,0.5)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    self:addChild(pauseBtn,1)
    pauseBtn:setPosition(595,1091)

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
	local back = cc.LayerColor:create(cc.c4b(255,255,255,0),s_DESIGN_WIDTH,300)
	back:setPosition(0,s_DESIGN_HEIGHT)
	back:ignoreAnchorPointForPosition(false)
	back:setAnchorPoint(0,1)
	self:addChild(back)

	local bossStatistics = cc.Sprite:create("image/playmodel/bossNum.png")
	bossStatistics:setPosition(20,255)
	back:addChild(bossStatistics)

	local itemStatistics = cc.Sprite:create("image/playmodel/chilliNum.png")
	itemStatistics:setPosition(20,190)
	back:addChild(itemStatistics)

	local wordStatistics = cc.Sprite:create("image/playmodel/wordNum.png")
	wordStatistics:setPosition(20,125)
	back:addChild(wordStatistics)

	local label_boss = cc.Label:createWithSystemFont((#s_BattleManager.bossList - s_BattleManager.currentBossIndex + 1),'',30)
	label_boss:setColor(cc.c4b(255,255,255,255))
	label_boss:setPosition(137,bossStatistics:getContentSize().height *0.4)
	label_boss:enableOutline(cc.c4b(0,0,0,255),1)
	bossStatistics:addChild(label_boss)

	local bossComplete = cc.Sprite:create("image/playmodel/complete.png") 
	bossComplete:setPosition(137,bossStatistics:getContentSize().height *0.4)
	bossStatistics:addChild(bossComplete)
	bossComplete:setVisible(false)

	---------------------------------------------------------

	local label_collect = cc.Label:createWithSystemFont("",'',30)
	label_collect:setColor(cc.c4b(255,255,255,255))
	label_collect:setPosition(137,itemStatistics:getContentSize().height *0.4)
	label_collect:enableOutline(cc.c4b(0,0,0,255),1)
	itemStatistics:addChild(label_collect)

	local itemComplete = cc.Sprite:create("image/playmodel/complete.png") 
	itemComplete:setPosition(137,itemStatistics:getContentSize().height *0.4)
	itemStatistics:addChild(itemComplete)
	itemComplete:setVisible(false)

	---------------------------------------------------------	
	local label_wordCount = cc.Label:createWithSystemFont("",'',30)
	label_wordCount:setColor(cc.c4b(255,255,255,255))
	label_wordCount:setPosition(137,wordStatistics:getContentSize().height *0.4)
	label_wordCount:enableOutline(cc.c4b(0,0,0,255),1)
	wordStatistics:addChild(label_wordCount)

	local wordComplete = cc.Sprite:create("image/playmodel/complete.png") 
	wordComplete:setPosition(137,wordStatistics:getContentSize().height *0.4)
	wordStatistics:addChild(wordComplete)
	wordComplete:setVisible(false)

	---------------------------------------------------------

	local limitSprite = cc.Sprite:create("image/playmodel/limit.png")
	limitSprite:ignoreAnchorPointForPosition(false)
	limitSprite:setAnchorPoint(0.5,1)
	limitSprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height)
	back:addChild(limitSprite)

	local label_time = cc.Label:createWithSystemFont('','',25)
	label_time:setColor(cc.c3b(0,0,0))
	label_time:setPosition(limitSprite:getContentSize().width / 2,limitSprite:getContentSize().height / 2)
	label_time:enableOutline(cc.c4b(255,255,255,255),1)
	limitSprite:addChild(label_time)

	local function update(delta)
		label_boss:setString(#s_BattleManager.bossList - s_BattleManager.currentBossIndex + 1)
		if (#s_BattleManager.bossList - s_BattleManager.currentBossIndex + 1) <= 1 and s_BattleManager.bossList[s_BattleManager.currentBossIndex].blood <= 0 then
			label_boss:setVisible(false)
			bossComplete:setVisible(true)
		end

		label_wordCount:setString(s_BattleManager.totalWordCount - s_BattleManager.currentWordCount)
		if (s_BattleManager.totalWordCount - s_BattleManager.currentWordCount) <= 0 then
			label_wordCount:setVisible(false)
			wordComplete:setVisible(true)
		end

		label_collect:setString(s_BattleManager.totalCollect[1] - s_BattleManager.currentCollect[1])
		if (s_BattleManager.totalCollect[1] - s_BattleManager.currentCollect[1]) <= 0 then
			label_collect:setVisible(false)
			itemComplete:setVisible(true)
		end

		if s_BattleManager.stageType == 'time' then
			local time = s_BattleManager.totalTime - s_BattleManager.currentTime
			label_time:setString('限时:'..math.floor(time / 60)..':'..math.floor(time % 60))
		else
			label_time:setString('限步:'..(s_BattleManager.totalStep - s_BattleManager.currentStep))
		end
	end

	back:scheduleUpdateWithPriorityLua(update,0)
end

return BattleView