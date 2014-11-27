require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local SummaryBossAlter = require("view.summaryboss.SummaryBossAlter")
local Pause = require("view.Pause")

local TapNode = require("view.mat.TapNode")

local SummaryBossLayerII = class("SummaryBossLayerII", function ()
    return cc.Layer:create()
end)

local scale = 0.92
local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4

function SummaryBossLayerII.create(levelConfig)   
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    local layer = SummaryBossLayerII.new()
    math.randomseed(os.time())
    --add coconut
    --layer.levelConfig = levelConfig
    layer.coconut = {}
    layer.isFirst = {}
    layer.wordPool = {}
    layer.startIndexPool = {}
    layer.currentIndex = 1
    layer.crab = {}
    layer.ccbcrab = {}
    layer.hintTime = 0
    layer.isPaused = false
    layer.isHinting = false
    layer.wordStack = {}
    local fingerLight = cc.Sprite:create('image/studyscene/long_light.png')
    fingerLight:setVisible(false)
    fingerLight:setAnchorPoint(0.5,0.05)
    layer:addChild(fingerLight,10)
    -- slide coco
    local slideCoco = {}
    slideCoco[1] = s_sound_slideCoconut
    slideCoco[2] = s_sound_slideCoconut1
    slideCoco[3] = s_sound_slideCoconut2
    slideCoco[4] = s_sound_slideCoconut3
    slideCoco[5] = s_sound_slideCoconut4
    slideCoco[6] = s_sound_slideCoconut5
    slideCoco[7] = s_sound_slideCoconut6

    local startAtNode

    local startTouchLocation
    local lastTouchLocation

    local startNode
    local selectStack = {}

    local killedCrabCount = 0
    layer.crabOnView = {}

    -- location function
    local onTouchBegan
    local onTouchMoved
    local fakeTouchMoved
    local onTouchEnded

    layer:initWordList(levelConfig)
    layer:initBossLayer(levelConfig)
    layer:initMap()

    --update
    local function update(delta)

        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or layer.layerPaused then
            return
        end

        --s_logd(layer.hintTime)
        if layer.hintTime < 10 or layer.isPaused then
            if layer.hintTime >= 8 and layer.isPaused then
                layer.hintTime = 8
            else
                layer.hintTime = layer.hintTime + delta
            end
        elseif not layer.isPaused and not layer.isHinting then

            layer:hint()
        end
    end
    layer:scheduleUpdateWithPriorityLua(update, 0)

    -- handing touch events
    onTouchBegan = function(touch, event)
        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or layer.layerPaused then
            return true
        end

        local location = layer:convertToNodeSpace(touch:getLocation())
        fingerLight:setPosition(location)
        fingerLight:setVisible(true)
        startTouchLocation = location
        lastTouchLocation = location

        layer:checkTouchLocation(location)

        if layer.onNode then
            layer.isPaused = true
            for i = 1, 5 do
                for j = 1,5 do
                    layer.coconut[i][j]:stopAllActions()
                    layer.coconut[i][j]:setScale(scale)
                end
            end
            startNode = layer.coconut[layer.current_node_x][layer.current_node_y]
            selectStack[#selectStack+1] = startNode
            layer:updateWord(selectStack)
            startNode.addSelectStyle()
            --startNode.bigSize()
            if startNode.isFirst > 0 and layer.crabOnView[startNode.isFirst] then
                s_logd(startNode.isFirst)
                layer.ccbcrab[startNode.isFirst]['boardBig']:setVisible(true)
                layer.ccbcrab[startNode.isFirst]['boardSmall']:setVisible(false)
--                layer.ccbcrab[startNode.isFirst]['legBig']:setVisible(true)
--                layer.ccbcrab[startNode.isFirst]['legSmall']:setVisible(false)
            end
            startAtNode = true
        else
            startAtNode = false
        end

        for i = 1,#layer.wordPool[layer.currentIndex] do
            if cc.rectContainsPoint(layer.crab[i]:getBoundingBox(), location) then
                layer.isPaused = true
                layer.ccbcrab[i]['boardBig']:setVisible(true)
                layer.ccbcrab[i]['boardSmall']:setVisible(false)
--                layer.ccbcrab[i]['legBig']:setVisible(true)
--                layer.ccbcrab[i]['legSmall']:setVisible(false)
                layer.onCrab = i
                for m = 1, 5 do
                    for n = 1,5 do
                        if layer.coconut[m][n].isFirst == i then
                            layer.coconut[m][n]:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.2 * scale),cc.ScaleTo:create(0.5,1.0 * scale)),2))
                            break
                        end
                    end
                end
            end
        end
        if layer.isPaused then
            layer.isHinting = false
        end
        -- CCTOUCHBEGAN event must return true
        return true
    end

    onTouchMoved = function(touch, event)
        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or layer.layerPaused then
            return true
        end

        local length_gap = 3.0

        local location = layer:convertToNodeSpace(touch:getLocation())
        fingerLight:setPosition(location)
        local length = math.sqrt((location.x - lastTouchLocation.x)^2+(location.y - lastTouchLocation.y)^2)
        if length <= length_gap then
            fakeTouchMoved(location)
        else
            local deltaX = (location.x - lastTouchLocation.x) * length_gap/length
            local deltaY = (location.y - lastTouchLocation.y) * length_gap/length

            for i = 1, length/length_gap do
                fakeTouchMoved({x=lastTouchLocation.x+(i-1)*deltaX,y=lastTouchLocation.y+(i-1)*deltaY})
            end
            fakeTouchMoved(location)
        end

        lastTouchLocation = location
    end

    fakeTouchMoved = function(location)
        if layer.globalLock then
            return
        end

        layer:checkTouchLocation(location)

        if startAtNode then
            local x = location.x - startTouchLocation.x
            local y = location.y - startTouchLocation.y

            if math.abs(x) > 5 or math.abs(y) > 5 then
                
                startAtNode = false
            end
        else
            if layer.onNode then
                local currentNode = layer.coconut[layer.current_node_x][layer.current_node_y]
                if currentNode.hasSelected then
                    if #selectStack >= 2 then
                        local stackTop = selectStack[#selectStack]
                        local secondStackTop = selectStack[#selectStack-1]
                        if currentNode.logicX == secondStackTop.logicX and currentNode.logicY == secondStackTop.logicY then
                            stackTop.removeSelectStyle()
                            table.remove(selectStack)    
                            -- slide coco "s_sound_slideCoconut"
                            if #selectStack <= 7 then
                                playSound(slideCoco[#selectStack])
                            else
                                playSound(slideCoco[7])
                            end
                        end

                    end
                else
                    if #selectStack == 0 then
                        
                        currentNode.hasSelected = true
                        selectStack[#selectStack+1] = currentNode
                        --layer:updateWord(selectStack)
                        --slide coco
                        playSound(s_sound_slideCoconut)
                    else
                        local stackTop = selectStack[#selectStack]
                        if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                            selectStack[#selectStack+1] = currentNode
                            --layer:updateWord(selectStack)
                            -- slide coco "s_sound_slideCoconut"
                            if #selectStack <= 7 then
                                playSound(slideCoco[#selectStack])
                            else
                                playSound(slideCoco[7])
                            end

                            currentNode.addSelectStyle()
                            
                        end
                    end
                end
            else

            end
        end
        layer:updateWord(selectStack)
    end

    onTouchEnded = function(touch, event)

        layer.isPaused = false
        if layer.globalLock then
            return
        end
        fingerLight:setVisible(false)
        --s_logd(layer.onCrab)
        if layer.onCrab > 0 then

            layer.ccbcrab[layer.onCrab]['boardBig']:setVisible(false)
            layer.ccbcrab[layer.onCrab]['boardSmall']:setVisible(true)
--            layer.ccbcrab[layer.onCrab]['legBig']:setVisible(false)
--            layer.ccbcrab[layer.onCrab]['legSmall']:setVisible(true)
            layer.onCrab = 0
        end

        if #selectStack < 1 then
            return
        end


        local location = layer:convertToNodeSpace(touch:getLocation())

        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].main_character_content
        end
        --check answer
        local match = false
        for i = 1, #layer.wordPool[layer.currentIndex] do
            if layer.crabOnView[i] then
                if selectWord == layer.wordPool[layer.currentIndex][i] then
                    killedCrabCount = killedCrabCount + 1
                    layer.rightWord = layer.rightWord + 1
                    layer.hintTime = 0
                    match = true
                    layer.globalLock = true
                    layer.crabOnView[i] = false
                    layer.currentBlood = layer.currentBlood - #selectStack
                    layer.boss.blood:setPercentage(100 * layer.currentBlood / layer.totalBlood)
                    --layer.boss:setAnimation(0,'a3',false)
                    layer.boss:addAnimation(0,'a2',false)
                    layer.ccbcrab[i]['boardBig']:setVisible(false)
                    layer.ccbcrab[i]['boardSmall']:setVisible(true)
--                    layer.ccbcrab[i]['legBig']:setVisible(false)
--                    layer.ccbcrab[i]['legSmall']:setVisible(true)
                    layer.crab[i]:runAction(cc.EaseBackIn:create(cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT * 0.2))))

                    -- slide true
                    playSound(s_sound_learn_true)
                    -- beat boss sound
                    s_SCENE:callFuncWithDelay(0.3,function()
                        playSound(s_sound_FightBoss)       
                    end)


                    local delaytime = 0
                    for j = 1, #selectStack do
                        local node = selectStack[j]
                        node.win()
                        local bullet = node.bullet
                        bullet:setVisible(true)
                        local bossPos = cc.p(layer.bossNode:getPosition())
                        s_logd("boss %f %f",bossPos.x,bossPos.y)
                        local bulletPos = cc.p(bullet:getPosition())
                        s_logd("bullet %f %f",bulletPos.x,bulletPos.y)
                        bossPos = cc.p(bossPos.x + 50 - bulletPos.x, bossPos.y + 50 - bulletPos.y)
                        s_logd("moveby %f %f",bossPos.x,bossPos.y)
                        local time = math.sqrt(bossPos.x * bossPos.x + bossPos.y * bossPos.y) / 1200
                        if time > 0.5 then
                            time = 0.5
                        end
                        if delaytime < time then
                            delaytime = time
                        end
                        local hit = cc.MoveBy:create(time,bossPos)
                        local hide = cc.Hide:create()
                        local attacked = cc.CallFunc:create(function() 
                            layer.boss:setAnimation(0,'a3',false)
                        end,{})
                        local resume = cc.MoveTo:create(0.0,cc.p(bullet:getPosition()))
                        bullet:runAction(cc.Sequence:create(hit,attacked,hide,resume))
                        local recover = cc.CallFunc:create(
                            function()
                                layer.globalLock = false
                                node.removeSelectStyle()
                                if node.isFirst > 0 and layer.crabOnView[node.isFirst] then
                                    node.firstStyle()
                                end
                            end,{}
                        )
                        node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),recover))
                    end
                    if layer.currentBlood <= 0 then
                        layer.globalLock = true
                        layer.blink:stopAllActions()
                        --layer.boss:stopAllActions()
                        local move = cc.MoveTo:create(0.5,cc.p(0.9 * s_DESIGN_WIDTH,1.1 * s_DESIGN_HEIGHT))
                        local mini = cc.ScaleTo:create(0.5,0.5)
                        local rotate = cc.RotateBy:create(0.5,360)
                        local fly = cc.Spawn:create(move,rotate)
                        local win = cc.CallFunc:create(function()

                                --layer.boss:removeFromParent()
                                layer:win()
                        end,{})
                        layer.boss:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),fly,win))

                    else
                        selectStack = {}
                        if layer.girlAfraid then
                            s = 'girl-afraid' 
                        else 
                            s = 'girl-stand'
                        end


                        layer.girl:setAnimation(0,'girl_happy',false)
                        layer.girl:addAnimation(0,'girl_happy',false)
                        layer.girl:addAnimation(0,s,true)
                        if killedCrabCount == #layer.wordPool[layer.currentIndex] then
                            --next group
                            layer.globalLock = true
                            layer.currentIndex = layer.currentIndex + 1
                            killedCrabCount = 0
                            for m = 1, 5 do
                                for n = 1, 5 do
                                    local remove = cc.CallFunc:create(function() 
                                        layer.coconut[m][n]:removeFromParent(true)    
                                    end,{})
                                    layer.coconut[m][n]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT*0.7)),remove))
                                end
                            end
                            layer:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function() 
                                layer.coconut = {}
                                layer:initMap()
                            end,{})))
                        end
                        break
                    end
                end
            end
        end

        if not match then
            local s
            if layer.girlAfraid then
                s = 'girl-afraid'
            else 
                s = 'girl-stand'
            end
            layer.girl:setAnimation(0,'girl-no',false)
            layer.girl:addAnimation(0,s,true)
            for i = 1, #selectStack do
                local node = selectStack[i]
                node.removeSelectStyle()
                if node.isFirst > 0 and layer.crabOnView[node.isFirst] then
                    node.firstStyle()
                    local shakeOnce = cc.Sequence:create(cc.RotateBy:create(0.05,9),cc.RotateBy:create(0.05,-18),cc.RotateBy:create(0.05,9))
                    local shake = cc.Repeat:create(shakeOnce,2)
                    local small = cc.CallFunc:create(function() 
                        layer.ccbcrab[node.isFirst]['boardBig']:setVisible(false)
                        layer.ccbcrab[node.isFirst]['boardSmall']:setVisible(true)
--                        layer.ccbcrab[node.isFirst]['legBig']:setVisible(false)
--                        layer.ccbcrab[node.isFirst]['legSmall']:setVisible(true)   
                    end,{})
                    layer.crab[node.isFirst]:runAction(cc.Sequence:create(shake,small))
                end
            end
            selectStack = {}

            --slide wrong
            playSound(s_sound_learn_false)
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    -- boss "s_sound_Get_Outside"
    playMusic(s_sound_Get_Outside,true)

    return layer  
end

function SummaryBossLayerII:updateWord(selectStack)
    for i = 1, #self.wordStack do
        self.wordStack[i]:stopAllActions()
        self.wordStack[i]:removeFromParent()
    end
    self.wordStack = {}

    local count = #selectStack
    local gap = 32
    local left = (s_DESIGN_WIDTH - (count-1)*gap)/2

    for i = 1, #selectStack do
        local wordBack = cc.Sprite:create("image/summarybossscene/global_zongjiebossdancixianshi_dierguan.png")
        --wordBack:setScaleX(count * gap/wordBack:getContentSize().width + 1.0/5)
        wordBack:setPosition(left + gap*(i - 1), 0.72*s_DESIGN_HEIGHT)
        wordBack:setScale(0.7)
        self:addChild(wordBack)
        self.wordStack[i] = wordBack
        local letter = cc.Label:createWithSystemFont(selectStack[i].main_character_content,"",30)
        letter:setScale(10 / 7)
        --letter:setColor(cc.c3b(0,0,0))
        letter:setPosition(0.5 * wordBack:getContentSize().width, 0.5 * wordBack:getContentSize().height)
        wordBack:addChild(letter)
    end
end

function SummaryBossLayerII:initBossLayer(levelConfig)
    self.globalLock = true
    --    local unlock = cc.CallFunc:create(function() 
    --        
    --        self:initMap()
    --    end,{})
    --    self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),unlock))


    --stage info
    self.girlAfraid = false
    self.totalBlood = levelConfig.summary_boss_hp
    self.currentBlood = self.totalBlood
    self.rightWord = 0
    self.totalTime = levelConfig.summary_boss_time
    self.onCrab = 0
    self.isLose = false
    self.layerPaused = false 

    --add back
    local blueBack = cc.LayerColor:create(cc.c4b(52, 177, 240, 255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blueBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blueBack)

    local back = cc.Sprite:create("image/summarybossscene/summaryboss_dierguan_back.png")    
    back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    self:addChild(back)
    
    local backEffect = sp.SkeletonAnimation:create('spine/summaryboss/second-level-summary-light.json','spine/summaryboss/second-level-summary-light.atlas',1)
    backEffect:setPosition(-30 - s_LEFT_X,0.675 * back:getContentSize().height)
    backEffect:setAnimation(0,'animation',true)
    back:addChild(backEffect)

    local blinkBack = cc.LayerColor:create(cc.c4b(0,0,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blinkBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blinkBack,0)
    local wait = cc.DelayTime:create(2.3 + self.totalTime * 0.9)
    local afraid = cc.CallFunc:create(function() 
        if self.currentBlood > 0 then
            self.girlAfraid = true
            self.girl:setAnimation(0,'girl-afraid',true)
            -- deadline "Mechanical Clock Ring "
            playSound(s_sound_Mechanical_Clock_Ring)
        end
    end,{})
    local blinkIn = cc.FadeTo:create(0.5,50)
    local blinkOut = cc.FadeTo:create(0.5,0.0)
    local blink = cc.Sequence:create(blinkIn,blinkOut)
    local repeatBlink = cc.Repeat:create(blink,math.ceil(self.totalTime * 0.1))
    blinkBack:runAction(cc.Sequence:create(wait,afraid,repeatBlink))
    self.blink = blinkBack
    --add pauseButton
    local menu = cc.Menu:create()
    self:addChild(menu)
    local pauseBtn = cc.MenuItemImage:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    menu:setPosition(0, s_DESIGN_HEIGHT)
    menu:addChild(pauseBtn)

    local function pauseScene(sender)
        if self.currentBlood <= 0 or self.isLose or self.globalLock or self.layerPaused then
            return
        end
        local pauseLayer = Pause.create()
        pauseLayer:setPosition(s_LEFT_X, 0)
        self:addChild(pauseLayer,1000)
        self.layerPaused = true
        --director:getActionManager():resumeTargets(pausedTargets)

        --button sound
        playSound(s_sound_buttonEffect)

    end
    pauseBtn:registerScriptTapHandler(pauseScene)

    --add girl
    local girl = sp.SkeletonAnimation:create("spine/summaryboss/girl-stand.json","spine/summaryboss/girl-stand.atlas",1)
    girl:setPosition(s_DESIGN_WIDTH * 0.07, s_DESIGN_HEIGHT * 0.79)
    self:addChild(girl)
    girl:setAnimation(0,'girl-stand',true)
    self.girl = girl
    
    local light_girl = cc.Sprite:create('image/summarybossscene/global_zongjiebosshuangshubeibei_dierguan.png')
    light_girl:setAnchorPoint(0.08,0.1)
    light_girl:setPosition(0,0)
    girl:addChild(light_girl,-1)

    --add readyGo
    local readyGo = sp.SkeletonAnimation:create("spine/summaryboss/readygo_dierguan.json","spine/summaryboss/readygo_dierguan.atlas",1)
    readyGo:setPosition(s_DESIGN_WIDTH * 0.5, s_DESIGN_HEIGHT * 0.5)
    readyGo:addAnimation(0,'animation',false)
    self:addChild(readyGo,100)

    -- ready go "ReadyGo"
    playSound(s_sound_ReadyGo)

    --add boss
    local bossNode = cc.Node:create()
    bossNode:setPosition(s_DESIGN_WIDTH * 0.65, s_DESIGN_HEIGHT * 1.15)
    self:addChild(bossNode)
    local boss = sp.SkeletonAnimation:create("spine/summaryboss/klswangqianzou.json","spine/summaryboss/klswangqianzou.atlas",1)
    boss:setPosition(0,0)
    bossNode:addChild(boss,1)
    boss:setAnimation(0,'a2',true)
    
    --boss light
    local light_boss = cc.Sprite:create('image/summarybossscene/global_zongjiebosshuangshuboss_dierguan.png')
    light_boss:setAnchorPoint(0,0)
    light_boss:setPosition(0,0)
    bossNode:addChild(light_boss)
    light_boss:setVisible(false)
    light_boss:runAction(cc.Sequence:create(cc.DelayTime:create(2.6),cc.Show:create()))
    
    local bossAction = {}
    bossAction[1] = cc.DelayTime:create(2.3)
    bossAction[2] = cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.76)))
    for i = 1, 10 do
        local stop = cc.DelayTime:create(self.totalTime / 10 * 0.8)
        local stopAnimation = cc.CallFunc:create(function() 
            boss:setAnimation(0,'a2',true)
        end,{})
        local move = cc.MoveBy:create(self.totalTime / 10 * 0.2,cc.p(- 0.45 * s_DESIGN_WIDTH / 10, 0))
        local moveAnimation = cc.CallFunc:create(function() 
            boss:setAnimation(0,'animation',false)
        end,{})
        bossAction[#bossAction + 1] = cc.Spawn:create(stop,stopAnimation)
        bossAction[#bossAction + 1] = cc.Spawn:create(move,moveAnimation)
    end
    bossAction[#bossAction + 1] = cc.CallFunc:create(function() 
        if self.currentBlood > 0 then
            self.isLose = true
            self:lose()
        end
    end,{})
    bossNode:runAction(cc.Sequence:create(bossAction))
    local bloodBack = cc.Sprite:create("image/summarybossscene/global_zongjieboss_bossdexietiaobeijing_dierguan.png")
    bloodBack:setPosition(100,215)
    boss:addChild(bloodBack)
    boss.blood = cc.ProgressTimer:create(cc.Sprite:create("image/summarybossscene/global_zongjieboss_bossdexietiao_dierguan.png"))
    boss.blood:setPosition(100,215)
    boss.blood:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    boss.blood:setMidpoint(cc.p(0,0))
    boss.blood:setBarChangeRate(cc.p(1,0))
    boss.blood:setPercentage(100)
    boss:addChild(boss.blood) 
    self.boss = boss
    self.bossNode = bossNode
    --add hole
    local hole = {}    
    local gap = 120
    local left = (s_DESIGN_WIDTH - (5 - 1)*gap)/2
    local bottom = 220
    for i = 1, 5 do
        hole[i] = {}
        for j = 1, 5 do
            hole[i][j] = cc.Sprite:create("image/summarybossscene/hole_II.png")
            hole[i][j]:setScale(0.92)
            hole[i][j]:setPosition(left + gap * (i - 1), bottom + gap * (j - 1))
            self:addChild(hole[i][j],0)
        end
    end
    self.hole = hole
end

function SummaryBossLayerII:initWordList(levelConfig)
    local wordList = split(levelConfig.word_content,'|')
    local index = 1

    for i = 1, #wordList do
        local randomIndex = math.random(1,#wordList)
        local tmp = wordList[i]
        wordList[i] = wordList[randomIndex]
        wordList[randomIndex] = tmp
        --for j = 1, #wordList do
        s_logd(randomIndex)
        --end
    end


    while true do
        local totalLength = 0
        local tmp = {}
        for i = 1, 3 do
            local w = wordList[index]
            s_logd(#wordList)
            if(totalLength + string.len(w) <= 25) then
                tmp[#tmp + 1] = w
                totalLength = totalLength + string.len(w)
                index = index + 1
                if index > #wordList then
                    self.wordPool[#self.wordPool + 1] = tmp
                    break
                end
            end 
        end
        if index > #wordList then
            break
        end
        self.wordPool[#self.wordPool + 1] = tmp          
    end
end

function SummaryBossLayerII:initStartIndex()
    self.startIndexPool = {}
    if #self.wordPool[self.currentIndex] == 1 then
        local localgap = 25 - string.len(self.wordPool[self.currentIndex][1])
        local randomStart = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart + 1
    elseif #self.wordPool[self.currentIndex] == 2 then
        local localgap = 25 - string.len(self.wordPool[self.currentIndex][1]) - string.len(self.wordPool[self.currentIndex][2])
        local randomStart1 = math.random(0,localgap)
        localgap = localgap - randomStart1
        local randomStart2 = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[self.currentIndex][1]) + randomStart2 + 1
    elseif #self.wordPool[self.currentIndex] == 3 then
        local localgap = 25 - string.len(self.wordPool[self.currentIndex][1]) - string.len(self.wordPool[self.currentIndex][2]) - string.len(self.wordPool[self.currentIndex][3])
        local randomStart1 = math.random(0,localgap)
        localgap = localgap - randomStart1
        local randomStart2 = math.random(0,localgap)
        localgap = localgap - randomStart2
        local randomStart3 = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[self.currentIndex][1]) + randomStart2 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[self.currentIndex][1]) + randomStart2 + string.len(self.wordPool[self.currentIndex][2]) + randomStart3 + 1        
    end
end

function SummaryBossLayerII:initCrab()
    local proxy = cc.CCBProxy:create()
    self.ccb = {}
    if #self.wordPool[self.currentIndex] ==1 then
        self.ccbcrab[1] = {} 
        self.ccb[1] = {}
        self.ccb[1]['CCB_crab'] = self.ccbcrab[1]
        self.crab[1] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[1],self.ccb[1])
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.5, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[1])
    elseif #self.wordPool[self.currentIndex] ==2 then
        self.ccbcrab[1] = {} 
        self.ccb[1] = {}
        self.ccb[1]['CCB_crab'] = self.ccbcrab[1]
        self.crab[1] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[1],self.ccb[1])
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.3, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[1])

        self.ccbcrab[2] = {} 
        self.ccb[2] = {}
        self.ccb[2]['CCB_crab'] = self.ccbcrab[2]
        self.crab[2] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[2],self.ccb[2])
        self.crab[2]:setPosition(s_DESIGN_WIDTH * 0.7, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[2])
    elseif #self.wordPool[self.currentIndex] ==3 then
        self.ccbcrab[1] = {} 
        self.ccb[1] = {}
        self.ccb[1]['CCB_crab'] = self.ccbcrab[1]
        self.crab[1] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[1],self.ccb[1])
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.2, -s_DESIGN_HEIGHT * 0.1)
        self.crab[1]:setRotation(5)
        self:addChild(self.crab[1])
        self.ccbcrab[2] = {} 
        self.ccb[2] = {}
        self.ccb[2]['CCB_crab'] = self.ccbcrab[2]
        self.crab[2] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[2],self.ccb[2])
        self.crab[2]:setPosition(s_DESIGN_WIDTH * 0.5, -s_DESIGN_HEIGHT * 0.1 - 10)
        self:addChild(self.crab[2])
        self.ccbcrab[3] = {} 
        self.ccb[3] = {}
        self.ccb[3]['CCB_crab'] = self.ccbcrab[3]
        self.crab[3] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[3],self.ccb[3])
        self.crab[3]:setPosition(s_DESIGN_WIDTH * 0.8, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[3])
    end
    for i = 1,#self.crab do
        local appear = cc.EaseBackOut:create(cc.MoveBy:create(0.5,cc.p(0,s_DESIGN_HEIGHT * 0.2)))
        local delaytime = 0
        if self.currentIndex == 1 then
            delaytime = 1.5
        end
        self.crab[i]:runAction(cc.Sequence:create(cc.DelayTime:create(1.1 + delaytime),appear))
        self.ccbcrab[i]['meaningSmall']:setString(s_WordPool[self.wordPool[self.currentIndex][i]].wordMeaningSmall)
        self.ccbcrab[i]['meaningBig']:setString(s_WordPool[self.wordPool[self.currentIndex][i]].wordMeaningSmall)
    end
end

function SummaryBossLayerII:initMap()
    self:initStartIndex()
    self.coconut = {}
    self.isFirst = {}
    self.isCrab = {}
    for i = 1, #self.crab do
        self.crab[i]:removeFromParent()
    end
    self.crab = {}
    for i = 1, #self.wordPool[self.currentIndex] do
        self.crabOnView[i] = true
    end
    local charaster_set_filtered = {}
    for i = 1, 26 do
        local char = string.char(96+i)
        charaster_set_filtered[#charaster_set_filtered+1] = char
    end

    local main_logic_mat = randomMat(5, 5)
    for i = 1, 5 do
        self.coconut[i] = {}
        self.isFirst[i] = {}
        self.isCrab[i] = {}
        for j = 1, 5 do
            local randomIndex = math.random(1, #charaster_set_filtered)
            self.isFirst[i][j] = 0
            self.isCrab[i][j] = 0
            if #self.wordPool[self.currentIndex] == 1 then
                local diff = main_logic_mat[i][j] - self.startIndexPool[1]
                if diff >= 0 and diff < string.len(self.wordPool[self.currentIndex][1]) then
                    self.coconut[i][j] = TapNode.create("popcorn", string.sub(self.wordPool[self.currentIndex][1],diff+1,diff+1), i, j)
                    self.isCrab[i][j] = 1
                    if diff == 0 then
                        self.coconut[i][j].firstStyle()
                        self.isFirst[i][j] = 1
                    end
                else
                    local randomIndex = math.random(1, #charaster_set_filtered)
                    self.coconut[i][j] = TapNode.create("popcorn", charaster_set_filtered[randomIndex], i, j)
                end
            elseif #self.wordPool[self.currentIndex] == 2 then
                local diff1 = main_logic_mat[i][j] - self.startIndexPool[1]
                local diff2 = main_logic_mat[i][j] - self.startIndexPool[2]
                if diff1 >= 0 and diff1 < string.len(self.wordPool[self.currentIndex][1]) then
                    self.coconut[i][j] = TapNode.create("popcorn", string.sub(self.wordPool[self.currentIndex][1],diff1+1,diff1+1), i, j)
                    self.isCrab[i][j] = 1
                elseif diff2 >= 0 and diff2 < string.len(self.wordPool[self.currentIndex][2]) then
                    self.coconut[i][j] = TapNode.create("popcorn", string.sub(self.wordPool[self.currentIndex][2],diff2+1,diff2+1), i, j)
                    self.isCrab[i][j] = 2
                else
                    local randomIndex = math.random(1, #charaster_set_filtered)
                    self.coconut[i][j] = TapNode.create("popcorn", charaster_set_filtered[randomIndex], i, j)
                end
                if diff1 * diff2 == 0 then
                    self.coconut[i][j].firstStyle()
                    if diff1 == 0 then
                        self.isFirst[i][j] = 1
                    else
                        self.isFirst[i][j] = 2
                    end
                end
            elseif #self.wordPool[self.currentIndex] == 3 then
                local diff1 = main_logic_mat[i][j] - self.startIndexPool[1]
                local diff2 = main_logic_mat[i][j] - self.startIndexPool[2]
                local diff3 = main_logic_mat[i][j] - self.startIndexPool[3]
                if diff1 >= 0 and diff1 < string.len(self.wordPool[self.currentIndex][1]) then
                    self.coconut[i][j] = TapNode.create("popcorn", string.sub(self.wordPool[self.currentIndex][1],diff1+1,diff1+1), i, j)
                    self.isCrab[i][j] = 1
                elseif diff2 >= 0 and diff2 < string.len(self.wordPool[self.currentIndex][2]) then
                    self.coconut[i][j] = TapNode.create("popcorn", string.sub(self.wordPool[self.currentIndex][2],diff2+1,diff2+1), i, j)
                    self.isCrab[i][j] = 2
                elseif diff3 >= 0 and diff3 < string.len(self.wordPool[self.currentIndex][3]) then
                    self.coconut[i][j] = TapNode.create("popcorn", string.sub(self.wordPool[self.currentIndex][3],diff3+1,diff3+1), i, j)
                    self.isCrab[i][j] = 3
                else
                    local randomIndex = math.random(1, #charaster_set_filtered)
                    self.coconut[i][j] = TapNode.create("popcorn", charaster_set_filtered[randomIndex], i, j)
                end

                if diff1 * diff2 * diff3 == 0 then
                    self.coconut[i][j].firstStyle()
                    if diff1 == 0 then
                        self.isFirst[i][j] = 1
                    elseif diff2 == 0 then
                        self.isFirst[i][j] = 2
                    else
                        self.isFirst[i][j] = 3
                    end
                end

            end
            self.coconut[i][j].bullet = cc.Sprite:create('image/summarybossscene/bullet_popcorn.png')
            self.coconut[i][j].bullet:setPosition(self.hole[i][j]:getPosition())
            self.coconut[i][j].bullet:setVisible(false)
            --self.coconut[i][j].bullet:setAnimation(0,'animation',true)
            self:addChild(self.coconut[i][j].bullet,2)
            self.coconut[i][j]:setScale(0)
            self.coconut[i][j]:setPosition(self.hole[i][j]:getPosition())
            self:addChild(self.coconut[i][j],1)
            local delaytime = 0
            if self.currentIndex == 1 then
                delaytime = 1.5
            end
            if i == 5 and j == 1 then
                local unlock = cc.CallFunc:create(function() 
                    self.globalLock = false
                end,{})
                self.coconut[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (3 + i - j) + delaytime),cc.ScaleTo:create(0.1, scale),unlock))
            else
                self.coconut[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (3 + i - j) + delaytime),cc.ScaleTo:create(0.1, scale)))
            end
            self.coconut[i][j].isFirst = self.isFirst[i][j]
        end
    end
    self:initCrab()
end

function SummaryBossLayerII:checkTouchLocation(location)
    for i = 1, 5 do
        for j = 1, 5 do
            local node = self.coconut[i][j]
            local node_position = cc.p(node:getPosition())
            local node_size = node:getContentSize()

            if cc.rectContainsPoint(node:getBoundingBox(), location) then
                self.current_node_x = i
                self.current_node_y = j

                local x = location.x - node_position.x
                local y = location.y - node_position.y
                if y > x and y > -x then
                    self.current_dir = dir_up
                elseif y < x and y < -x then
                    self.current_dir = dir_down
                elseif y > x and y < -x then
                    self.current_dir = dir_left
                else
                    self.current_dir = dir_right
                end

                self.onNode = true
                return
            end
        end
    end

    self.onNode = false
end

function SummaryBossLayerII:win()
    self.globalLock = true
    self.girl:setAnimation(0,'girl_win',true)
    local alter = SummaryBossAlter.create(true,self.rightWord,self.currentBlood,2)
    alter:setPosition(0,0)
    self:addChild(alter,1000)

--    -- win sound
--    playSound(s_sound_win)
end

function SummaryBossLayerII:lose()
    self.globalLock = true
    self.girl:setAnimation(0,'girl-fail',true)
    local alter = SummaryBossAlter.create(false,self.rightWord,self.currentBlood,2)
    alter:setPosition(0,0)
    self:addChild(alter,1000)
--
--    -- lose sound
--    playSound(s_sound_fail)    
end

function SummaryBossLayerII:hint()
    self.isHinting = true
    local num = math.random(1,#self.wordPool[self.currentIndex])
    local index = 1
    for i = 1, #self.wordPool[self.currentIndex] do
        if self.crabOnView[i] then
            index = i
            break
        end
    end
    s_logd('x = %d',index)
    for i = 1, 5 do
        for j = 1, 5 do
            if self.isCrab[i][j] == index then
                self.coconut[i][j]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
            end
        end
    end

end

return SummaryBossLayerII