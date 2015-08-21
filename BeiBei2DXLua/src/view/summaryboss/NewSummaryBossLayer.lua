local NewSummaryBossLayer = class("NewSummaryBossLayer", function ()
    return cc.Layer:create()
end)

function NewSummaryBossLayer.create(unit)
    local layer = NewSummaryBossLayer.new(unit)
    return layer
end

function NewSummaryBossLayer:ctor(unit)
    --s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    if unit == 0 then
        AnalyticsSummaryStep(s_summary_enterTryGame)
    end
    self.unit = unit

    self:initStageInfo()
    self:initBackground()
    s_SCENE:callFuncWithDelay(1.5,function()
        playMusic(s_sound_Get_Outside,true)
        self:initBoss()
    end)
    s_SCENE:callFuncWithDelay(1.8,function ()
        self:creatMat()
    end)

    local function update(delta)
        if self.gameStart and not self.gameOver and not self.gamePaused then 
            self.useTime = self.useTime + delta

            if (self.tutorialStep == 0 and self.finishTrying == true) or self.tutorialStep == 1 then
                self.changeBtnTime = self.changeBtnTime + delta
                --第二次划词引导
                if self.changeBtnTime > self.totalTime / 2 then
                    self:secondWordTutorial()
                end
            elseif self.tutorialStep >= 2 then
                self.changeBtnTime = self.changeBtnTime + delta
                --两次划词引导结束后，判断是否需要换词引导
                if self.changeBtnTime > self.totalTime / 2 and self.firstTimeToChange then
                    self.mat.forceFail()
                    self.changeBtnTime = - 10000
                    self:changeWordTutorial()
                end
            end
        end
    end 
    if not self.isTrying then
        self:scheduleUpdateWithPriorityLua(update, 0)
    end
end

function NewSummaryBossLayer:initStageInfo()
    self.finishTrying = s_CURRENT_USER.finishTrying
    --游戏开始的标志
    self.gameStart = false
    --游戏结束的标志
    self.gameOver = false
    --游戏暂停的标志
    self.gamePaused = false
    --是否加过道具
    self.useItem = false
    --单元
    self.oldUnit = self.unit
    --是否是试玩
    self.isTrying = false
    if self.unit == 0 then
        self.isTrying = true
        self.oldUnit = nil
        self.unit = nil
        s_CURRENT_USER:setGuideStep(s_guide_step_tryBoss)
    end
    --是否是重玩
    self.isReplay = true
    --总时间
    self.totalTime = 20
    --剩余时间
    self.leftTime = self.totalTime
    local timeConfig = {2,1.8,1.6,1.4,1.2}
    self.timeConfig = timeConfig
    --花费时间
    self.useTime = 0
    --单词
    self.wordList = self:initWordList()
    --总词数
    self.maxCount = #self.wordList
    --boss血量
    self.totalBlood = 0
    for i = 1,#self.wordList do
        self.totalBlood = self.totalBlood + string.len(self.wordList[i][1]) * 2
    end
    --boss剩余血量
    self.currentBlood = self.totalBlood
    --提示换词功能
    self.changeBtnTime = 0
    self.hintChangeBtn = nil
    --是否首次换词
    self.firstTimeToChange = (s_CURRENT_USER.needBossChangeWordTutorial == 0)
    --椰子的行列数
    self.mat_length = 4
    --生词数
    self.wrongWord = 0
    --熟词
    self.rightWordList = ''
    --换词次数
    self.resetCount = 0
    self.isFirstBossGuide = 0
    --划词引导阶段，0为需要首次划词提示，1为需要二次划词提示，2为不需要引导
    self.tutorialStep = 0
    if s_CURRENT_USER.needBossSlideTutorial == 1 then
        self.tutorialStep = 2
    else
        self.newguid = true
    end
end

function NewSummaryBossLayer:initWordList()
    -- 取词
    local unit = self.unit
    local wordList = {}
    if unit == nil then
        self.isReplay = false   
        self.unit = s_CorePlayManager.currentUnit
    end
    -- 试玩特殊处理
    if self.isTrying then
        wordList = {{'apple','','apple','apple'},{'pear','','pear','pear'}}
        return wordList
    end
    print_lua_table(self.unit.wrongWordList)
    for i = 1,#self.unit.wrongWordList do
        wordList[i] = {}
        --wordList[i][1]表示这个词组的第一个单词，如果不是词组则取单词本身，【2】表示词组剩余部分,[3]表示词组以空格分隔，【4】表示词组以 分隔
        if isWord(self.unit.wrongWordList[i]) == true then
            wordList[i] = {self.unit.wrongWordList[i],"","",self.unit.wrongWordList[i]}
        else
            wordList[i] = self:getWordGroupArray(self.unit.wrongWordList[i])
        end
    end

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
    self:addChild(pauseBtn,1)
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

    s_SCENE:callFuncWithDelay(5,function ()
        onAndroidKeyPressed(pauseBtn, function ()
            local isPopup = s_SCENE.popupLayer:getChildren()
            if #isPopup == 0 then
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                if not self.gamePaused then 
                    createPausePopup()
                end
            end
        end, function ()

        end)
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
    hideProgressHUD(true) 
end

function NewSummaryBossLayer:initBoss()
    local boss = require("view.summaryboss.Boss").create()
    boss:setPosition(s_DESIGN_WIDTH * 0.65, s_DESIGN_HEIGHT * 1.15)
    self:addChild(boss,1)
    self.boss = boss
    boss:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.75 + 20))))
    --过关失败
    if not self.isTrying then
        boss.bossWin = function ()
            if self.currentBlood > 0 then
                self:gameOverFunc(false)   
                if s_CURRENT_USER.summaryStep < s_summary_failFirstLevel then
                    s_CURRENT_USER:setSummaryStep(s_summary_failFirstLevel)
                    AnalyticsSummaryStep(s_summary_failFirstLevel)
                end
            end
        end
    end
    --boss靠近
    boss.bossClose = function (  )
        self:screenBlink()
    end
    --boss远离
    boss.bossBack = function (  )
        self.girl:setAfraid(false)
        self.girl:setAnimation("normal")
        self.blink:stopAllActions()
        self.blink:setOpacity(0)
    end
end

function NewSummaryBossLayer:creatMat()
    local delay = cc.DelayTime:create(1)
    local func = cc.CallFunc:create(function ( ... )
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        self.gamePaused = false
    end)
    self:runAction(cc.Sequence:create(delay,func))
    
    if self.mat == nil then
        self:initMat()
        return
    end

    local removeMat = cc.CallFunc:create(function() 
        if self.mat ~= nil then
            self.mat:removeFromParent()
        end
        self.mat = nil
        self:initMat()
    end,{})
    self.mat:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT*0.7)),removeMat))
end

function NewSummaryBossLayer:initMat()
    local isNewPlayer =  (self.isTrying and self.wordList[1][1] == 'apple') or (self.tutorialStep < 1 and self.finishTrying == false)
    local mat = require("view.summaryboss.Mat").create(self,isNewPlayer,"coconut_dark")
    if isNewPlayer then
        mat:changeToGuideMode('normal')
    end
    mat:setPosition(s_DESIGN_WIDTH/2, 150)
    self:addChild(mat,1)

    self:resetTime()

    self.mat = mat
    s_SCENE:callFuncWithDelay(0.7,function (  )
        self:initCrab()
    end)
    --划错单词后
    mat.fail = function (  )
        self.girl:setAnimation("wrong")
        if self.crab ~= nil and self.crab.shake ~= nil then
            self.crab:shake()
        end
    end
    --划对单词后
    mat.success = function(stack)
        self.resetCount = self.resetCount + 1

        if self.tutorialStep < 2 then
            self.tutorialStep = self.tutorialStep + 1
            self.gamePaused = false
        end

        self.changeBtnTime = 0
        if s_CURRENT_USER.summaryStep < s_summary_doFirstWord and self.isTrying ~= true then
            s_CURRENT_USER:setSummaryStep(s_summary_doFirstWord)
            AnalyticsSummaryStep(s_summary_doFirstWord)
        end
        if self.gameOver then return end
        playWordSound(self.wordList[1][4])
        self.boss:stopAllActions()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        self.girl:setAnimation("right")
        if self.resetCount < self.maxCount then
            if self.rightWordList == '' then
                self.rightWordList = self.wordList[1][4]
            else
                self.rightWordList = self.rightWordList..'||'..self.wordList[1][4]
            end
        end

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
        if s_CURRENT_USER.summaryStep < s_summary_successFirstLevel and self.isTrying ~= true then
            s_CURRENT_USER:setSummaryStep(s_summary_successFirstLevel)
            AnalyticsSummaryStep(s_summary_successFirstLevel)
        end
        s_SCENE:callFuncWithDelay(0.2 *math.pow(#stack,0.8) + 0.5,function ()
            if self.currentBlood > 0 then
                if self.girl.isAfraid then
                    playMusic(s_sound_Get_Outside)
                end
                table.remove(self.wordList,1)
                self:resetTime()
                self.boss:goBack(self.totalTime)
                self.crab:moveOut()
                self:creatMat()
            else
                self:gameOverFunc(true)
            end
        end)
    end
end

function NewSummaryBossLayer:initCrab()
    local id = 0
    if self.unit ~= nil then
        id = self.unit.unitID
    end
    -- print_lua_table(self.wordList)
    local crab = require("view.summaryboss.Crab").create(self.wordList[1][4],self.isTrying,id)
    self:addChild(crab,1)
    self.crab = crab
    -- s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    if self.gameStart then return end
    self.gameStart = true
    self.boss:goForward(self.totalTime)
    if not self.isTrying then
        self:addChangeBtn()
    end
end

function NewSummaryBossLayer:addChangeBtn()
    --换词按钮
    local changeBtn = ccui.Button:create('image/summarybossscene/hint_change_btn.png','image/summarybossscene/hint_change_btn_click.png')
    changeBtn:setPosition(s_DESIGN_WIDTH * 0.84,100)
    self:addChild(changeBtn,0)
    self.changeBtn = changeBtn
    changeBtn:setScale(0)
    changeBtn:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.5,1)))
    local function changeWord(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            playWordSound(self.wordList[1][4])
            self.ishited = true
            if self.hintChangeBtn ~= nil and self.hintChangeBtn.hintOver ~= nil then
                self.hintChangeBtn.hintOver()
                self.hintChangeBtn = nil
                --return
            end
            if self.resetCount < self.maxCount then
                self.wrongWord = self.wrongWord + 1
                --print('self.wrongWord',self.wrongWord)
            end
            
            self.gamePaused = true
            local hintBoard = require("view.summaryboss.HintWord").create(self.wordList[1][4],self.boss,self.firstTimeToChange,self.unit.unitID)
            s_SCENE.popupLayer:addChild(hintBoard)

            onAndroidKeyPressed(hintBoard, function ()
                local isPopup = s_SCENE.popupLayer:getChildren()
                if #isPopup ~= 0 then
                    hintBoard.hintOver()
                end
            end, function ()

            end)
            
            hintBoard.hintOver = function (  )
                hintBoard:removeFromParent()
                self.firstTimeToChange = false
                if #self.wordList > 1 then
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                    self:addWrongWordToEnd()
                    self.crab:moveOut()
                    self:creatMat()
                end
            end
            
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
    if self.isTrying then
        local StoryLayer = require('view.level.StoryLayer')
        local storyLayer = StoryLayer.create(7)
        s_SCENE:replaceGameLayer(storyLayer)
        return
    end
    if win then
        if self.tutorialStep >= 2 then
            if s_CURRENT_USER.guideStep < s_guide_step_second then
                s_CURRENT_USER:setGuideStep(s_guide_step_second)
            end
            s_CURRENT_USER.needBossSlideTutorial = 1
            saveUserToServer({['needBossSlideTutorial']=s_CURRENT_USER.needBossSlideTutorial})
            if self.firstTimeToChange == false then
                s_CURRENT_USER.needBossChangeWordTutorial = 1
                saveUserToServer({['needBossChangeWordTutorial']=s_CURRENT_USER.needBossChangeWordTutorial})
            end
        end
        if self.unit.unitState == 0 then
            s_LocalDatabaseManager.addStudyWordsNum(self.maxCount)
            s_LocalDatabaseManager.addRightWord(self.rightWordList,self.unit.unitID)
            s_LocalDatabaseManager.addGraspWordsNum(self.maxCount - self.wrongWord)
         --   print(self.maxCount - self.wrongWord)
        elseif self.unit.unitState == 4 then
            local list = self.unit.wrongWordList[1]
             for i = 2,#self.unit.wrongWordList do
                 list = list..'||'..self.unit.wrongWordList[i]
             end
            s_LocalDatabaseManager.addGraspWordsNum(self.maxCount - #split(self.rightWordList,'||'))
            s_LocalDatabaseManager.addRightWord(list,self.unit.unitID)
        end
        self.boss:fly()
        self.girl:setAnimation("win")
    else
        self.mat.forceFail()
        local timeout = cc.Sprite:create('image/summarybossscene/lose/timeover_h5_zongjieboss.png')
        timeout:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 3 / 2)
        self:addChild(timeout,100)
        timeout:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)))
                                            ,cc.DelayTime:create(1.0)
                                            ,cc.EaseBackIn:create(cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 3 / 2)))
                                            ,cc.CallFunc:create(function (  )
                                                timeout:removeFromParent()
                                            end)))
        self.girl:setAnimation("lose")
    end
    --游戏结束界面
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    s_SCENE:callFuncWithDelay(2,function ()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        local alter = require("view.summaryboss.SummaryBossAlter").create(self,win,true)
        alter:setPosition(0,0)
        self:addChild(alter,1000)
    end)
end

function NewSummaryBossLayer:resetTime()
    self.totalTime = 4 * #self.wordList[1][1] + 10
    if self.unit ~= nil and self.unit.unitID ~= nil and self.unit.unitID >= 1 and self.unit.unitID <= 5 then
        self.totalTime = (4 * #self.wordList[1][1] + 10) * self.timeConfig[self.unit.unitID]
    end
    self.leftTime = self.totalTime
end

--第二次划词引导
function NewSummaryBossLayer:secondWordTutorial()
    --s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    self.mat.forceFail()
    self.gamePaused = true
    self.changeBtnTime = 0
    --s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    local curtain = require('view.summaryboss.Curtain').create()
    self:addChild(curtain,2)
    self.boss:setLocalZOrder(3)
    local hint = cc.Sprite:create('image/guide/yindao_background_boss.png')
    hint:setPosition(curtain:getContentSize().width / 2 - 50 , 870)
    curtain:addChild(hint)
    local label = cc.Label:createWithSystemFont('怪兽抓到贝贝就完蛋了！','',36)
    label:setColor(cc.c3b(0,0,0))
    label:setPosition(hint:getContentSize().width/2,hint:getContentSize().height * 0.25)
    hint:addChild(label)
    --self.girl:setLocalZOrder(3)
    cc.Director:getInstance():getActionManager():pauseTarget(self.boss)
    curtain.remove = function()
        --s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        --self.gamePaused = false
        self.mat:changeToGuideMode("special")
        self.boss:setLocalZOrder(0)
        --self.girl:setLocalZOrder(0)
        curtain:removeFromParent()
    end
end
--换词引导
function NewSummaryBossLayer:changeWordTutorial()
    self.gamePaused = true
    self.changeBtn:setLocalZOrder(2)
    local hintBoard = require("view.summaryboss.HintWord").create(self.wordList[1][4],self.boss,self.firstTimeToChange,self.unit.unitID)
    s_SCENE.popupLayer:addChild(hintBoard)
    -- self.hintChangeBtn = hintBoard
    
    hintBoard.hintOver = function (  )
        s_CURRENT_USER.needBossChangeWordTutorial = 1
        saveUserToServer({['needBossChangeWordTutorial']=s_CURRENT_USER.needBossChangeWordTutorial})
        self.firstTimeToChange = false
        hintBoard:removeFromParent()
        -- self.changeBtn:setLocalZOrder(0)
        self:addWrongWordToEnd()
        if #self.wordList > 1 then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        end
        self.crab:moveOut()
        self:creatMat()
    end

    onAndroidKeyPressed(hintBoard, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup ~= 0 then
            hintBoard.hintOver()
        end
    end, function ()

    end)
end

function NewSummaryBossLayer:addWrongWordToEnd()
    if self.wordList ~= nil then
        local word = self.wordList[1] 
        table.remove(self.wordList,1)
        self.wordList[#self.wordList + 1] = word 
    end
end

function NewSummaryBossLayer:getWordGroupArray(wordGroup)
    local len = 0
    local wordTable = {}
    local array = {}
    for k=1,#wordGroup do
        table.insert(wordTable,string.sub(wordGroup,k,k))
    end
    for k=1,#wordGroup do
        local num = string.byte(wordTable[k])
        if num < 65 or (num > 90 and num < 97 ) or num > 122 then
            len = k
        end
        if len > 0 then
            array[1] = string.sub(wordGroup,1,len-1)
            array[2] = string.sub(wordGroup,len,#wordGroup)
            array[3] = array[1] .. "" .. array[2]
            array[4] = wordGroup
            return array
        end
    end
end


return NewSummaryBossLayer