require("cocos.init")
require("common.global")

local NewSummaryBossLayer = class("NewSummaryBossLayer", function ()
    return cc.Layer:create()
end)

function NewSummaryBossLayer.create(unit)
	local layer = NewSummaryBossLayer.new(unit)
	return layer
end

function NewSummaryBossLayer:ctor(unit)
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	--设置关卡信息
	self:initStageInfo(unit)
	--添加小女孩
	self:initBackground()
	--ready go 之后添加boss
	s_SCENE:callFuncWithDelay(1.5,function()
		self:initBoss()
	end)
    --boss下落后增加椰子
    s_SCENE:callFuncWithDelay(1.8,function ()
        self:initMat()
    end)

    local function update(delta)
        if self.gameStart and not self.gameOver then 
            self.useTime = self.useTime + delta
        end
    end 
    self:scheduleUpdateWithPriorityLua(update, 0)

end

function NewSummaryBossLayer:initStageInfo(unit)
    --游戏开始的标志
    self.gameStart = false
    --游戏结束的标志
    self.gameOver = false
    --是否加过道具
    self.useItem = false
    --单元
    self.unit = unit
    --是否是重玩
    self.isReplay = true
	--单词
	self.wordList = self:initWordList()
	--总词数
	self.maxCount = #self.wordList
	--boss血量
    self.totalBlood = 0
    for i = 1,#self.wordList do
        self.totalBlood = self.totalBlood + string.len(self.wordList[i]) * 2
    end
    --boss剩余血量
    self.currentBlood = self.totalBlood
    --总时间
    self.totalTime = 20--math.ceil(self.totalBlood / 14) * 15
    --剩余时间
    self.leftTime = self.totalTime
    --花费时间
    self.useTime = 0
    --椰子的行列数
    self.mat_length = 4
    --生词数
    self.wrongWord = 0
    --熟词
    self.rightWordList = ''
    --换词次数
    self.resetCount = 0
end

function NewSummaryBossLayer:initWordList()
	-- 取词
	local unit = self.unit
    local wordList
    if unit == nil then
        self.isReplay = false
        wordList = s_CorePlayManager.currentWrongWordList
        self.unit = s_CorePlayManager.currentUnit
    else
        wordList = unit.wrongWordList
    end
    --print("~~~~~~~~~~~~~~~~~~~~~~~~~")
    --print_lua_table(unit)
    -- 打乱取词
    for i = 1, #wordList do
        local randomIndex = math.random(1,#wordList)
        local tmp = wordList[i]
        wordList[i] = wordList[randomIndex]
        wordList[randomIndex] = tmp     
    end
    return wordList
end

function NewSummaryBossLayer:initBackground()
	--添加背景
	local blueBack = cc.LayerColor:create(cc.c4b(52, 177, 240, 255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blueBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blueBack)
    --背景动画
    local back = sp.SkeletonAnimation:create("res/spine/summaryboss/zongjieboss_diyiguan_background.json", "res/spine/summaryboss/zongjieboss_diyiguan_background.atlas", 1)
    back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    self:addChild(back)
    back:addAnimation(0, 'animation', true)
    --add hole
    local hole = {}    
    local gap = 132
    local left = (s_DESIGN_WIDTH - (self.mat_length - 1)*gap)/2
    local bottom = left + 150
    for i = 1, self.mat_length do
        hole[i] = {}
        for j = 1, self.mat_length do
            hole[i][j] = cc.Sprite:create(string.format("image/summarybossscene/hole_1.png"))
            hole[i][j]:setPosition(left + gap * (i - 1), bottom + gap * (j - 1))
            self:addChild(hole[i][j],0)
        end
    end
    self.hole = hole
    --添加暂停按钮
    s_SCENE.popupLayer.layerpaused = false 
    local pauseBtn = ccui.Button:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    self:addChild(pauseBtn,100)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)
    local function createPausePopup()
        if self.currentBlood <= 0 or self.gameOver or s_SCENE.popupLayer.layerpaused then
            return
        end
        local pauseLayer = require("view.Pause").create()
        pauseLayer:setPosition(s_LEFT_X, 0)
        s_SCENE.popupLayer:addBackground()
        s_SCENE.popupLayer:addChild(pauseLayer)
        s_SCENE.popupLayer.listener:setSwallowTouches(true)
    end

    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
           createPausePopup()
        --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    onAndroidKeyPressed(pauseBtn, function ()
        createPausePopup()
    end, function ()

    end)
	--添加girl
	local girl = require("view.summaryboss.Girl").create()
	girl:setPosition(s_DESIGN_WIDTH * 0.05, s_DESIGN_HEIGHT * 0.76)
	self:addChild(girl,1)
	girl:setAnimation("normal")
	--小女孩的动作有：win,lose,right,wrong,normal,afraid
	self.girl = girl
	--readyGo动画
	local readyGoFile = "spine/summaryboss/readygo_diyiguan"
    local readyGo = sp.SkeletonAnimation:create(string.format("%s.json",readyGoFile),string.format("%s.atlas",readyGoFile),1)
    readyGo:setPosition(s_DESIGN_WIDTH * 0.5, s_DESIGN_HEIGHT * 0.5)
    readyGo:addAnimation(0,'animation',false)
    self:addChild(readyGo,100)
    -- ready go sound
    playSound(s_sound_ReadyGo)

    --添加闪烁的动画
    local blinkBack = cc.LayerColor:create(cc.c4b(0,0,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blinkBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blinkBack,0)
    self.blink = blinkBack
end

function NewSummaryBossLayer:initBoss()
	local boss = require("view.summaryboss.Boss").create()
	boss:setPosition(s_DESIGN_WIDTH * 0.65, s_DESIGN_HEIGHT * 1.15)
	self:addChild(boss)
	self.boss = boss
    boss:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.75 + 20))))
	--过关失败
	boss.bossWin = function ()
		if self.currentBlood > 0 then
            -- self.isLose = true
            self:gameOverFunc(false)   
        end
	end
    --boss靠近
    boss.bossClose = function (  )
        --self.girl:setAnimation("afraid")
        self:screenBlink()
    end
    --boss远离
    boss.bossBack = function (  )
        self.girl:setAfraid(false)
        self.girl:setAnimation("normal")
        self.blink:stopAllActions()
    end
end

function NewSummaryBossLayer:initMat()
	local mat = require("view.summaryboss.Mat").create(self,false,"coconut_dark")
    mat:setPosition(s_DESIGN_WIDTH/2, 150)
    self:addChild(mat,1)
    self.mat = mat
    --提示的螃蟹
    s_SCENE:callFuncWithDelay(0.7,function (  )
        self:initCrab()
    end)
    --划错单词后
    mat.fail = function (  )
        self.girl:setAnimation("wrong")
        self.crab:shake()
    end
    --划对单词后
    mat.success = function(stack)
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        self.girl:setAnimation("right")
        if self.resetCount < self.maxCount then
            if self.rightWordList == '' then
                self.rightWordList = self.wordList[1]
            else
                self.rightWordList = self.rightWordList..'|'..self.wordList[1]
            end
        end
        print(self.rightWordList)
        --子弹打boss
        local delaytime = 0
        for i = 1, #stack do
            local bullet = stack[i]:getChildByName("bullet")
            bullet:setVisible(true)
            local randP = cc.p(60 + math.random(0,80),60 + math.random(0,80))
            local bossPos = cc.p(self.boss:getPositionX() + randP.x,self.boss:getPositionY() + randP.y)
            local bulletPos = cc.p(stack[i]:getPosition())
            
            bossPos = cc.p(bossPos.x - bulletPos.x, bossPos.y - 150 - bulletPos.y)
            local time = math.sqrt(bossPos.x * bossPos.x + bossPos.y * bossPos.y) / (1200*(1 + i * 0.1))
            if time > 0.5 then
                time = 0.5
            end
            if delaytime < time then
                delaytime = time
            end
            local delay = cc.DelayTime:create(0.2 *math.pow(i,0.8))
            local hit = cc.MoveBy:create(time,bossPos)
            local hide = cc.Hide:create()
            local attacked = cc.CallFunc:create(function() 
                self.boss.boss:setAnimation(0,'a3',false)
                playSound(s_sound_FightBoss)  
                local damage_label = cc.Label:createWithSystemFont('2','',36)
                damage_label:enableOutline(cc.c4b(255,0,0,255),2)
                damage_label:setColor(cc.c4b(255,0,0,255))
                damage_label:setPosition(randP)
                self.currentBlood = self.currentBlood - 2
                self.boss:setBlood(self.currentBlood,self.totalBlood)
                --damage_label:setOpacity(0)
                local action1 = cc.Spawn:create(cc.MoveBy:create(0.2,cc.p(0,30)),cc.FadeOut:create(0.2))
                local action2 = cc.CallFunc:create(function (  )
                    damage_label:removeFromParent()
                end,{})
                damage_label:runAction(cc.Sequence:create(action1,action2))
                self.boss:addChild(damage_label)
            end,{})
            bullet:runAction(cc.Sequence:create(delay,hit,attacked,hide))
        end
        --更换mat
        s_SCENE:callFuncWithDelay(0.2 *math.pow(#stack,0.8),function ()
            self.boss:goBack(self.totalTime)
            self:resetMat()
        end)
	end
end
--重置mat
function NewSummaryBossLayer:resetMat()
    self.resetCount = self.resetCount + 1
    self.crab:moveOut()
    local remove = cc.CallFunc:create(function() 
        self.mat:removeFromParent() 
        table.remove(self.wordList,1)
        if self.currentBlood > 0 then
            self:initMat()
        else
            self:gameOverFunc(true)
        end
    end,{})
    self.mat:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT*0.7)),remove))
end

function NewSummaryBossLayer:initCrab()
    local crab = require("view.summaryboss.Crab").create(self.wordList[1])
    self:addChild(crab)
    self.crab = crab
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    if self.gameStart then return end
    self.gameStart = true
    self.boss:goForward(self.totalTime)
    self:addChangeBtn()
end

function NewSummaryBossLayer:addChangeBtn()
    --换词按钮
    local changeBtn = ccui.Button:create('image/summarybossscene/button_change_h5_boss.png','image/summarybossscene/button_pressed_change_h5_boss.png')
    changeBtn:setPosition(s_DESIGN_WIDTH * 0.84,100)
    self:addChild(changeBtn)
    changeBtn:setScale(0)
    changeBtn:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.5,1)))
    local function changeWord(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.resetCount < self.maxCount then
                self.wrongWord = self.wrongWord + 1
                --print('self.wrongWord',self.wrongWord)
            end
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local curtain = cc.LayerColor:create(cc.c4b(0,0,0,150),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
            self:addChild(curtain,99)
            curtain:setPosition(s_LEFT_X,0)
            --出现中英对照
            local wordBoard = cc.Sprite:create('image/summarybossscene/bckground_words_h5_boss.png')
            wordBoard:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 3 / 2)
            self:addChild(wordBoard,100)

            local word_en = cc.Label:createWithTTF(self.wordList[1],'font/CenturyGothic.ttf',40)
            word_en:setPosition(wordBoard:getContentSize().width / 2,wordBoard:getContentSize().height * 3 / 4)
            wordBoard:addChild(word_en)
            word_en:setColor(cc.c3b(0,0,0))

            local word_cn = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getWordInfoFromWordName(self.wordList[1]).wordMeaningSmall,'',40)
            word_cn:setPosition(wordBoard:getContentSize().width / 2,wordBoard:getContentSize().height * 1 / 4)
            wordBoard:addChild(word_cn)
            word_cn:setColor(cc.c3b(0,0,0))

            
            s_SCENE:callFuncWithDelay(2.6,function (  )
                --s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                curtain:removeFromParent()
                table.insert(self.wordList,self.wordList[1])
                self:resetMat()
            end)
            wordBoard:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT))),cc.DelayTime:create(2),cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(0,s_DESIGN_HEIGHT)))))
            
        end
    end
    changeBtn:addTouchEventListener(changeWord)
end

--时间快到时屏幕闪烁
function NewSummaryBossLayer:screenBlink()
    --小女孩害怕
    local afraid = cc.CallFunc:create(function() 
        if self.currentBlood > 0 then
            self.girl:setAnimation("afraid")
            -- deadline "Mechanical Clock Ring "
            playSound(s_sound_Mechanical_Clock_Ring)
            playMusic(s_sound_Get_Outside_Speedup,true)
        end
    end,{})
    --闪烁动画
    local blinkIn = cc.FadeTo:create(0.5,50)
    local blinkOut = cc.FadeTo:create(0.5,0.0)
    local blink = cc.Sequence:create(blinkIn,blinkOut)
    local repeatBlink = cc.Repeat:create(blink,math.ceil(self.totalTime * 0.2))
    self.blink:runAction(cc.Sequence:create(afraid,repeatBlink))
end

function NewSummaryBossLayer:gameOverFunc(win)
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    self.gameOver = true
    self.blink:stopAllActions()
	if win then
        if self.unit.unitState == 0 then
            s_LocalDatabaseManager.addStudyWordsNum(self.maxCount)
            s_LocalDatabaseManager.addRightWord(self.rightWordList,self.unit.unitID)
            s_LocalDatabaseManager.addGraspWordsNum(self.maxCount - self.wrongWord)
        elseif self.unit.unitState == 4 then
            s_LocalDatabaseManager.addGraspWordsNum(self.maxCount - #split(self.rightWordList,'|'))
            s_LocalDatabaseManager.addRightWord(self.unit.wrongWordList,self.unit.unitID)
        end
        self.boss:fly()
		self.girl:setAnimation("win")
	else
		self.girl:setAnimation("lose")
	end
	--游戏结束界面
	s_SCENE:callFuncWithDelay(2,function ()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        local alter = require("view.summaryboss.SummaryBossAlter").create(self,win,true)
        alter:setPosition(0,0)
        self:addChild(alter,1000)
    end)
end


return NewSummaryBossLayer