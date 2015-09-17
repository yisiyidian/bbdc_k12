-- PKLayer功能
-- 直接从boss功能里改
local MeetOpponentLayer = require('view.summaryboss.MeetOpponentLayer')

local PKLayer = class("PKLayer", function ()
    return cc.Layer:create()
end)

function PKLayer.create(unit,playerName,schoolName)
    local layer = PKLayer.new(unit,playerName,schoolName)
    return layer
end

function PKLayer:ctor(unit,playerName,schoolName)
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    self.unit = unit
    self.playerName = playerName
    self.schoolName = schoolName
    self.showBoss = false
    self.showMat = false
    self:initStageInfo()
    self:initBackground()
    s_SCENE:callFuncWithDelay(1.5,function()
        playMusic(s_sound_Get_Outside,true)
        self:initBoss()
    end)
    s_SCENE:callFuncWithDelay(1.8,function ()
        self:creatMat()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)

    self:addPKModel()

    local function update(delta)
        self.useTime = self.useTime + delta
    end 
    self:scheduleUpdateWithPriorityLua(update, 0)
end

function PKLayer:initStageInfo()
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
    self.constWord = self:initWordList()
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

function PKLayer:addPKModel()
    self.opponentWord = #self.constWord
    self.myWord = #self.constWord
    -- 对手的血量
    math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
    local opponentEnd = 'win'
    local rand = math.random(1,2 * #self.wordList)
    if rand <= #self.wordList then
        opponentEnd = 'lose'
        print("对手失败 在第"..rand.."词")
    else
        print("对手成功")
    end
    self.failAt = rand
    self.opponentEnd = opponentEnd
    -- 对手输赢

    local speed = 1
    -- 对手的划词速度


    -- 左侧蓝底
    local blue = cc.Sprite:create("image/pk/blue.png")
    blue:ignoreAnchorPointForPosition(false)
    blue:setAnchorPoint(0,1)
    blue:setPosition(0,1136)
    self.blue = blue
    self:addChild(self.blue)

    -- 自己的名字
    local name = cc.Label:createWithSystemFont("",'',30)
    name:setColor(cc.c4b(255,255,255,255))
    name:setPosition(5,blue:getContentSize().height / 2)
    name:ignoreAnchorPointForPosition(false)
    name:setAnchorPoint(0,0.5)
    self.name = name
    self.blue:addChild(self.name)
    self.name:setString(MeetOpponentLayer:rename())

    -- 自己的成绩
    local myGrade = cc.Label:createWithSystemFont(0,'',40)
    myGrade:setColor(cc.c4b(255,255,255,255))
    myGrade:setPosition(blue:getContentSize().width - 30,blue:getContentSize().height / 2)
    myGrade:ignoreAnchorPointForPosition(false)
    myGrade:setAnchorPoint(1,0.5)
    self.myGrade = myGrade
    self.blue:addChild(self.myGrade) 

    -- 右侧红底
    local red = cc.Sprite:create("image/pk/red.png")
    red:ignoreAnchorPointForPosition(false)
    red:setAnchorPoint(1,1)
    red:setPosition(640,1136)
    self.red = red
    self:addChild(self.red)

    -- 对手名字
    local opName = cc.Label:createWithSystemFont("",'',30)
    opName:setColor(cc.c4b(255,255,255,255))
    opName:setPosition(red:getContentSize().width - 5,red:getContentSize().height / 2)
    opName:ignoreAnchorPointForPosition(false)
    opName:setAnchorPoint(1,0.5)
    self.opName = opName
    self.red:addChild(self.opName)
    self.opName:setString(self.playerName)

    -- 对手的成绩
    local opGrade = cc.Label:createWithSystemFont(0,'',40)
    opGrade:setColor(cc.c4b(255,255,255,255))
    opGrade:setPosition(30,red:getContentSize().height / 2)
    opGrade:ignoreAnchorPointForPosition(false)
    opGrade:setAnchorPoint(0,0.5)
    self.opGrade = opGrade
    self.red:addChild(self.opGrade)

    -- vs
    local vs = cc.Label:createWithSystemFont("VS",'',25)
    vs:setColor(cc.c4b(254,211,85 ,255))
    vs:setPosition((s_RIGHT_X - s_LEFT_X)/2, 1136)
    vs:ignoreAnchorPointForPosition(false)
    vs:setAnchorPoint(0.5,1)
    self.vs = vs
    self:addChild(self.vs)

    -- 总词数
    local num = cc.Label:createWithSystemFont(#self.constWord,'',25)
    num:setColor(cc.c4b(254,211,85,255))
    num:setPosition((s_RIGHT_X - s_LEFT_X)/2, 1136 - 25)
    num:ignoreAnchorPointForPosition(false)
    num:setAnchorPoint(0.5,1)
    self.num = num
    self:addChild(self.num)

    -- 计算划词数的总量
    local max = #self.constWord + 1
    if self.failAt <= max then
        max = self.failAt
    end

    -- 单词完成时间
    local timeList = {}
    for i=1,#self.constWord do
        timeList[#timeList + 1] = #self.constWord[i][1] * speed
    end    

    for i=2,#self.constWord do
        timeList[i] = timeList[i] + timeList[i-1]
    end

    
    -- 单词数量减少动作
    local actionList = {}
    for i=1,max - 1 do
        local func = cc.CallFunc:create(function ()
            callWithDelay(self,timeList[i],self.addOpGrade)
        end)
        actionList[#actionList + 1] = func
        print("对手在"..#self.constWord[i][1] * speed.."("..timeList[i]..")".."秒后，划对第"..i.."词")
    end
    local se = cc.Sequence:create(actionList)
    print("actionList"..#actionList)
    if #actionList > 0 then
        self:runAction(se)
    end

    self.endTime = 0
    if self.opponentEnd == 'lose' then
        self.endTime = timeList[self.failAt]
    else
        self.endTime = timeList[#timeList]
    end

    s_CURRENT_USER.pkPlayer = self.playerName
    saveUserToServer({['pkPlayer']=s_CURRENT_USER.pkPlayer})

    s_CURRENT_USER.schoolName = self.schoolName
    saveUserToServer({['schoolName']=s_CURRENT_USER.schoolName})

    s_CURRENT_USER.pkTime = os.time() + self.endTime    
    saveUserToServer({['pkTime']=s_CURRENT_USER.pkTime})

    s_CURRENT_USER.pkPlayerTime = self.endTime    
    saveUserToServer({['pkPlayerTime']=s_CURRENT_USER.pkPlayerTime})

    s_CURRENT_USER.pkUnitID = self.unit.unitID
    saveUserToServer({['pkUnitID']=s_CURRENT_USER.pkUnitID})
end

function PKLayer:addOpGrade()
    local num = self.opGrade:getString() + 1
    self.opGrade:setString(num)
end

function PKLayer:initWordList()
    -- 取词
    local unit = self.unit
    local wordList = {}
    if unit == nil then
        self.isReplay = false   
        self.unit = s_CorePlayManager.currentUnit
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

function PKLayer:initBackground()
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

function PKLayer:initBoss()
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

function PKLayer:creatMat()
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

function PKLayer:initMat()
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
        self.myGrade:setString(self.myGrade:getString() + 1)
        self.resetCount = self.resetCount + 1

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

        local time = 0
        for i = 1, #stack do
            local bullet = stack[i]:getChildByName("bullet")
            bullet:setVisible(true)
            local randP = cc.p(60 + math.random(0,80),60 + math.random(0,80))
            local bossPos = cc.p(self.boss:getPositionX() + randP.x,self.boss:getPositionY() + randP.y)
            local bulletPos = cc.p(stack[i]:getPosition())
            
            bossPos = cc.p(bossPos.x - bulletPos.x, bossPos.y - 150 - bulletPos.y)
            if time == 0 then
                time = math.sqrt(bossPos.x * bossPos.x + bossPos.y * bossPos.y) / (1200*(1 + i * 0.0))
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
        s_SCENE:callFuncWithDelay(0.2 *math.pow(#stack,0.8) + time,function ()
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

function PKLayer:initCrab()
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

    local touchBeginX = 0
    local touchBeginY = 0
    local touchEndX = 0
    local touchEndY = 0

    local onTouchBegan = function(touch, event)
        touchBeginX = self:convertToNodeSpace(touch:getLocation()).x
        touchBeginY = self:convertToNodeSpace(touch:getLocation()).y
        touchEndX = 0
        touchEndY = 0
        return true  
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        touchEndX = self:convertToNodeSpace(touch:getLocation()).x
        touchEndY = self:convertToNodeSpace(touch:getLocation()).y


        if cc.rectContainsPoint(cc.rect(190,50,440,150),location) and not tolua.isnull(self.crab) and math.abs(touchBeginX - touchEndX) < 20 and math.abs(touchBeginY - touchEndY) < 20 then
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


            s_SCENE:callFuncWithDelay(0.5,function ()
                if tolua.isnull(hintBoard) then
                    return
                end
                onAndroidKeyPressed(hintBoard, function ()
                local isPopup = s_SCENE.popupLayer:getChildren()
                if #isPopup ~= 0 then
                    hintBoard.hintOver()
                end
            end, function ()

            end)

            end)

            
            hintBoard.hintOver = function (  )
                hintBoard:removeFromParent()
                self.firstTimeToChange = false
                if #self.wordList > 1 then
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                    self:addWrongWordToEnd()
                    if not tolua.isnull(self.crab) then
                        self.crab:moveOut()
                    end
                    self:creatMat()
                    cc.Director:getInstance():getActionManager():resumeTarget(self.boss)
                    s_SCENE:callFuncWithDelay(0.2 ,function ()
                        self.gamePaused = false
                        end)
                end
            end

        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )  
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

--时间快到时屏幕闪烁
function PKLayer:screenBlink()
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

function PKLayer:gameOverFunc(win)
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    self.gameOver = true
    self.blink:stopAllActions()
    self:stopAllActions()

    if win then
        self.boss:fly()
        self.girl:setAnimation("win")
    else
        self.mat.forceFail()
    end
    --游戏结束界面
    print("op")
    print("time"..self.endTime)
    print("iswin"..self.opponentEnd)

    print("my")
    print("time"..math.ceil(self.useTime))
    if win then 
        print("win")
    else
        print("lose")
    end

    s_CURRENT_USER.pkMyTime = math.ceil(self.useTime)    
    saveUserToServer({['pkMyTime']=s_CURRENT_USER.pkMyTime})

    if win then
        s_CURRENT_USER.pkMyGrade = true
        saveUserToServer({['pkMyGrade']=s_CURRENT_USER.pkMyGrade})
    end

    if self.opponentEnd == "win" then
        s_CURRENT_USER.pkPlayerGrade = true
        saveUserToServer({['pkPlayerGrade']=s_CURRENT_USER.pkPlayerGrade})
    end

    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    s_SCENE:callFuncWithDelay(2,function ()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()        
        if os.time() >= s_CURRENT_USER.pkTime then
            local PKEndingLayer = require("view.summaryboss.PKEndingLayer")
            local pKEndingLayer = PKEndingLayer.create()
            s_SCENE:replaceGameLayer(pKEndingLayer) 
        else
            local WaitEndingLayer = require("view.summaryboss.WaitEndingLayer")
            local waitEndingLayer = WaitEndingLayer.create()
            s_SCENE:replaceGameLayer(waitEndingLayer) 
        end
    end)
end

function PKLayer:resetTime()
    self.totalTime = 4 * #self.wordList[1][1] + 10
    if self.unit ~= nil and self.unit.unitID ~= nil and self.unit.unitID >= 1 and self.unit.unitID <= 5 then
        self.totalTime = (4 * #self.wordList[1][1] + 10) * self.timeConfig[self.unit.unitID]
    end
    self.leftTime = self.totalTime
end

function PKLayer:addWrongWordToEnd()
    if self.wordList ~= nil then
        local word = self.wordList[1] 
        table.remove(self.wordList,1)
        self.wordList[#self.wordList + 1] = word 
    end
end

function PKLayer:getWordGroupArray(wordGroup)
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


return PKLayer