require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local SummaryBossAlter = require("view.summaryboss.SummaryBossAlter")
local Pause = require("view.Pause")

local FlipNode = require("view.mat.FlipNode")

local SummaryBossLayer = class("SummaryBosslayer", function ()
    return cc.Layer:create()
end)

local scale = 0.92
local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4

function SummaryBossLayer.create(levelConfig)   
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    local layer = SummaryBossLayer.new()
    
    
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
    layer:initBossLayer_back(levelConfig)
    
    local loadingTime = 0
    local loadingState = 0
    --update
    local function update(delta)
        if loadingTime > delta and loadingState < 2 then
            loadingState = 2
        elseif loadingTime > 1.5 and loadingState < 4 then
            loadingState = 4
        elseif loadingTime > 2.0 and loadingState < 6 then
            loadingState = 6    
        end       
        if loadingState == 0 then
            loadingState = 1
            layer:initBossLayer_girl(levelConfig)
        elseif loadingState == 2 then
            loadingState = 3
            
            layer:initMapInfo()
        elseif loadingState == 4 then
            loadingState = 5
            layer:initBossLayer_boss(levelConfig)
        elseif loadingState == 6 then
            loadingState = 7
            
            layer:initMap()
        end
        if loadingTime < 5 then
            loadingTime = loadingTime + delta
        end
        
        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or s_SCENE.popupLayer.layerpaused then
            return
        end
        
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
        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or s_SCENE.popupLayer.layerpaused then
            return true
        end
        
        local location = layer:convertToNodeSpace(touch:getLocation())
        
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
            startNode.bigSize()
            if startNode.isFirst > 0 and layer.crabOnView[startNode.isFirst] then
                layer.ccbcrab[startNode.isFirst]['boardBig']:setVisible(true)
                layer.ccbcrab[startNode.isFirst]['boardSmall']:setVisible(false)
                layer.ccbcrab[startNode.isFirst]['legBig']:setVisible(true)
                layer.ccbcrab[startNode.isFirst]['legSmall']:setVisible(false)
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
                layer.ccbcrab[i]['legBig']:setVisible(true)
                layer.ccbcrab[i]['legSmall']:setVisible(false)
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
        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or s_SCENE.popupLayer.layerpaused then
            return true
        end
    
        local length_gap = 3.0

        local location = layer:convertToNodeSpace(touch:getLocation())

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
                if y > x and y > -x then
                    startNode:up()
                elseif y < x and y < -x then
                    startNode:down()
                elseif y > x and y < -x then
                    startNode:left()
                else
                    startNode:right()
                end
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
                        if layer.current_dir == dir_up then
                            currentNode.down()
                        elseif layer.current_dir == dir_down then
                            currentNode.up()
                        elseif layer.current_dir == dir_left then
                            currentNode.right()
                        else
                            currentNode.left()
                        end
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
                            currentNode.bigSize()
                            if layer.current_dir == dir_up then
                                currentNode.down()
                            elseif layer.current_dir == dir_down then
                                currentNode.up()
                            elseif layer.current_dir == dir_left then
                                currentNode.right()
                            else
                                currentNode.left()
                            end
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
        if layer.onCrab > 0 then

            layer.ccbcrab[layer.onCrab]['boardBig']:setVisible(false)
            layer.ccbcrab[layer.onCrab]['boardSmall']:setVisible(true)
            layer.ccbcrab[layer.onCrab]['legBig']:setVisible(false)
            layer.ccbcrab[layer.onCrab]['legSmall']:setVisible(true)
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
                    layer.ccbcrab[i]['legBig']:setVisible(false)
                    layer.ccbcrab[i]['legSmall']:setVisible(true)
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
                        local bulletPos = cc.p(bullet:getPosition())
                        bossPos = cc.p(bossPos.x + 50 - bulletPos.x, bossPos.y + 50 - bulletPos.y)
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
                                if killedCrabCount > 0 and layer.globalLock then
                                    layer.globalLock = false
                                end
                                node.normal()
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
--                                        layer.coconut[m][n]:removeFromParent(true)    
                                    end,{})
                                    layer.coconut[m][n]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT*0.7)),remove))
                                end
                            end
                            layer:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function() 
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
                        layer.ccbcrab[node.isFirst]['legBig']:setVisible(false)
                        layer.ccbcrab[node.isFirst]['legSmall']:setVisible(true)   
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

function SummaryBossLayer:updateWord(selectStack)
    for i = 1, #self.wordStack do
            self.wordStack[i]:stopAllActions()
            self.wordStack[i]:removeFromParent()
    end
    self.wordStack = {}
        
    local count = #selectStack
    local gap = 32
    local left = (s_DESIGN_WIDTH - (count-1)*gap)/2
        
    for i = 1, #selectStack do
        local wordBack = cc.Sprite:create("image/button/USButton1.png")
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

function SummaryBossLayer:initBossLayer_back(levelConfig)
    self.globalLock = true
    --stage info
    self.girlAfraid = false
    self.hasMap = false
    self.totalBlood = levelConfig.summary_boss_hp
    self.currentBlood = self.totalBlood
    self.rightWord = 0
    self.totalTime = levelConfig.summary_boss_time
    self.onCrab = 0
    self.isLose = false
    s_SCENE.popupLayer.layerpaused = false 

    --add back
    local blueBack = cc.LayerColor:create(cc.c4b(52, 177, 240, 255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blueBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blueBack)

    local back = sp.SkeletonAnimation:create("res/spine/summaryboss/zongjieboss_diyiguan_background.json", "res/spine/summaryboss/zongjieboss_diyiguan_background.atlas", 1)
    back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    self:addChild(back)
    back:addAnimation(0, 'animation', true)
    
    
    --add hole
    local hole = {}    
    local gap = 120
    local left = (s_DESIGN_WIDTH - (5 - 1)*gap)/2
    local bottom = 220
    for i = 1, 5 do
        hole[i] = {}
        for j = 1, 5 do
            hole[i][j] = cc.Sprite:create("image/summarybossscene/summaryboss_chapter1_hole.png")
            hole[i][j]:setScale(0.92)
            hole[i][j]:setPosition(left + gap * (i - 1), bottom + gap * (j - 1))
            self:addChild(hole[i][j],0)
        end
    end
    self.hole = hole
end

function SummaryBossLayer:initBossLayer_girl(levelConfig)
    --add pauseButton
    local pauseBtn = ccui.Button:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    self:addChild(pauseBtn,100)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)

    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.currentBlood <= 0 or self.isLose or self.globalLock or s_SCENE.popupLayer.layerpaused then
                return
            end
            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer:addChild(pauseLayer)
            s_SCENE.popupLayer.listener:setSwallowTouches(true)
        
        --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)
    --add girl
    local girl = sp.SkeletonAnimation:create("spine/summaryboss/girl-stand.json","spine/summaryboss/girl-stand.atlas",1)
    girl:setPosition(s_DESIGN_WIDTH * 0.05, s_DESIGN_HEIGHT * 0.76)
    self:addChild(girl)
    girl:setAnimation(0,'girl-stand',true)
    self.girl = girl
    
    --add readyGo
    local readyGo = sp.SkeletonAnimation:create("spine/summaryboss/readygo_diyiguan.json","spine/summaryboss/readygo_diyiguan.atlas",1)
    readyGo:setPosition(s_DESIGN_WIDTH * 0.5, s_DESIGN_HEIGHT * 0.5)
    readyGo:addAnimation(0,'animation',false)
    self:addChild(readyGo,100)
    
    -- ready go "ReadyGo"
    playSound(s_sound_ReadyGo)
    
end

function SummaryBossLayer:initBossLayer_boss(levelConfig)
    
    local blinkBack = cc.LayerColor:create(cc.c4b(0,0,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blinkBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blinkBack,0)
    local wait = cc.DelayTime:create(0.0 + self.totalTime * 0.9)
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

    
    --add boss
    local bossNode = cc.Node:create()
    bossNode:setPosition(s_DESIGN_WIDTH * 0.65, s_DESIGN_HEIGHT * 1.15)
    self:addChild(bossNode)
    local boss = sp.SkeletonAnimation:create("spine/summaryboss/klswangqianzou.json","spine/summaryboss/klswangqianzou.atlas",1)
    boss:setPosition(0,0)
    bossNode:addChild(boss)
    boss:setAnimation(0,'a2',true)
    local bossAction = {}
    bossAction[1] = cc.DelayTime:create(0.0)
    bossAction[2] = cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.75)))
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
    local bloodBack = cc.Sprite:create("image/summarybossscene/summaryboss_blood_back.png")
    bloodBack:setPosition(100,215)
    boss:addChild(bloodBack)
    boss.blood = cc.ProgressTimer:create(cc.Sprite:create("image/summarybossscene/summaryboss_blood_front.png"))
    boss.blood:setPosition(100,215)
    boss.blood:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    boss.blood:setMidpoint(cc.p(0,0))
    boss.blood:setBarChangeRate(cc.p(1,0))
    boss.blood:setPercentage(100)
    boss:addChild(boss.blood) 
    self.boss = boss
    self.bossNode = bossNode
end

function SummaryBossLayer:initWordList(levelConfig)
    local wordList = split(levelConfig.word_content,'|')
    local index = 1
    
    for i = 1, #wordList do
        local randomIndex = math.random(1,#wordList)
        local tmp = wordList[i]
        wordList[i] = wordList[randomIndex]
        wordList[randomIndex] = tmp
    end
    
    self.maxCount = #wordList


    while true do
        local totalLength = 0
        local tmp = {}
        for i = 1, 3 do
            local w = wordList[index]
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

function SummaryBossLayer:initStartIndex(index)
    self.startIndexPool = {}
    if #self.wordPool[index] == 1 then
        local localgap = 25 - string.len(self.wordPool[index][1])
        local randomStart = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart + 1
    elseif #self.wordPool[index] == 2 then
        local localgap = 25 - string.len(self.wordPool[index][1]) - string.len(self.wordPool[index][2])
        local randomStart1 = math.random(0,localgap)
        localgap = localgap - randomStart1
        local randomStart2 = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[index][1]) + randomStart2 + 1
    elseif #self.wordPool[index] == 3 then
        local localgap = 25 - string.len(self.wordPool[index][1]) - string.len(self.wordPool[index][2]) - string.len(self.wordPool[index][3])
        local randomStart1 = math.random(0,localgap)
        localgap = localgap - randomStart1
        local randomStart2 = math.random(0,localgap)
        localgap = localgap - randomStart2
        local randomStart3 = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[index][1]) + randomStart2 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[index][1]) + randomStart2 + string.len(self.wordPool[index][2]) + randomStart3 + 1        
    end
end

function SummaryBossLayer:initCrab()
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
            --delaytime = 1.5
        end
        self.crab[i]:runAction(cc.Sequence:create(cc.DelayTime:create(1.1 + delaytime),appear))
        self.ccbcrab[i]['meaningSmall']:setString(s_WordPool[self.wordPool[self.currentIndex][i]].wordMeaningSmall)
        self.ccbcrab[i]['meaningBig']:setString(s_WordPool[self.wordPool[self.currentIndex][i]].wordMeaningSmall)
    end
end

function SummaryBossLayer:initMapInfo()
    self.isFirst = {}
    self.isCrab = {}
    self.character = {}
    for k = 1,#self.wordPool do
        self:initStartIndex(k)
        self.character[k] = {}
        self.isFirst[k] = {}
        self.isCrab[k] = {}
        local charaster_set_filtered = {}
        for i = 1, 26 do
            local char = string.char(96+i)
            charaster_set_filtered[#charaster_set_filtered+1] = char
        end

        local main_logic_mat = randomMat(5, 5)
        for i = 1, 5 do
            self.character[k][i] = {}
            self.isFirst[k][i] = {}
            self.isCrab[k][i] = {}
            for j = 1, 5 do
                local randomIndex = math.random(1, #charaster_set_filtered)
                self.isFirst[k][i][j] = 0
                self.isCrab[k][i][j] = 0
                if #self.wordPool[k] == 1 then
                    local diff = main_logic_mat[i][j] - self.startIndexPool[1]
                    if diff >= 0 and diff < string.len(self.wordPool[k][1]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][1],diff+1,diff+1)
                        self.isCrab[k][i][j] = 1
                        if diff == 0 then
                            self.isFirst[k][i][j] = 1
                        end
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        self.character[k][i][j] = charaster_set_filtered[randomIndex]

                    end
                elseif #self.wordPool[k] == 2 then
                    local diff1 = main_logic_mat[i][j] - self.startIndexPool[1]
                    local diff2 = main_logic_mat[i][j] - self.startIndexPool[2]
                    if diff1 >= 0 and diff1 < string.len(self.wordPool[k][1]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][1],diff1+1,diff1+1)
                        self.isCrab[k][i][j] = 1
                    elseif diff2 >= 0 and diff2 < string.len(self.wordPool[k][2]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][2],diff2+1,diff2+1)
                        self.isCrab[k][i][j] = 2
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        self.character[k][i][j] = charaster_set_filtered[randomIndex]
                    end
                    if diff1 * diff2 == 0 then
                        if diff1 == 0 then
                            self.isFirst[k][i][j] = 1
                        else
                            self.isFirst[k][i][j] = 2
                        end
                    end
                elseif #self.wordPool[k] == 3 then
                    local diff1 = main_logic_mat[i][j] - self.startIndexPool[1]
                    local diff2 = main_logic_mat[i][j] - self.startIndexPool[2]
                    local diff3 = main_logic_mat[i][j] - self.startIndexPool[3]
                    if diff1 >= 0 and diff1 < string.len(self.wordPool[k][1]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][1],diff1+1,diff1+1)
                        self.isCrab[k][i][j] = 1
                    elseif diff2 >= 0 and diff2 < string.len(self.wordPool[k][2]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][2],diff2+1,diff2+1)
                        self.isCrab[k][i][j] = 2
                    elseif diff3 >= 0 and diff3 < string.len(self.wordPool[k][3]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][3],diff3+1,diff3+1)
                        self.isCrab[k][i][j] = 3
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        self.character[k][i][j] = charaster_set_filtered[randomIndex]
                    end

                    if diff1 * diff2 * diff3 == 0 then
                        if diff1 == 0 then
                            self.isFirst[k][i][j] = 1
                        elseif diff2 == 0 then
                            self.isFirst[k][i][j] = 2
                        else
                            self.isFirst[k][i][j] = 3
                        end
                    end

                end
            end
        end
    end
end

function SummaryBossLayer:initMap()

    for i = 1, #self.crab do
        self.crab[i]:removeFromParent()
    end
    self.crab = {}
    for i = 1, #self.wordPool[self.currentIndex] do
        self.crabOnView[i] = true
    end
    
    for i = 1, 5 do
        if self.currentIndex == 1 then
            self.coconut[i] = {}
        end
        for j = 1, 5 do
            
             if self.currentIndex > 1 then
                self.coconut[i][j].main_character_content = self.character[self.currentIndex][i][j]
                self.coconut[i][j].main_character_label:setString(self.character[self.currentIndex][i][j])
             else
                self.coconut[i][j] = FlipNode.create("coconut_dark", self.character[self.currentIndex][i][j], i, j)
             end
             if self.isFirst[self.currentIndex][i][j] == 1 or self.isFirst[self.currentIndex][i][j] == 2 or self.isFirst[self.currentIndex][i][j] == 3 then
                self.coconut[i][j].firstStyle()
             end
           
            if self.currentIndex == 1 then
                self.coconut[i][j].bullet = sp.SkeletonAnimation:create("spine/summaryboss/zongjieboss_2_douzi_zhuan.json","spine/summaryboss/zongjieboss_2_douzi_zhuan.atlas",1)
                self:addChild(self.coconut[i][j],1)
                self.coconut[i][j].bullet:setAnimation(0,'animation',true)
                self:addChild(self.coconut[i][j].bullet,2)
            else
                self.coconut[i][j].bullet:stopAllActions()  
            end
            self.coconut[i][j].bullet:setPosition(self.hole[i][j]:getPosition())
            self.coconut[i][j].bullet:setVisible(false)
            self.coconut[i][j]:setScale(0)
            self.coconut[i][j]:setPosition(self.hole[i][j]:getPosition())
            
            local delaytime = 0
            if self.currentIndex == 1 then
                --delaytime = 1.5
            end
            if i == 5 and j == 1 then
                local unlock = cc.CallFunc:create(function() 
                    self.globalLock = false
                end,{})
                self.coconut[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (3 + i - j) + delaytime),cc.ScaleTo:create(0.1, scale),unlock))
            else
                self.coconut[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (3 + i - j) + delaytime),cc.ScaleTo:create(0.1, scale)))
            end
            self.coconut[i][j].isFirst = self.isFirst[self.currentIndex][i][j]
        end
    end
    self:initCrab()
end

function SummaryBossLayer:checkTouchLocation(location)
    local main_width    = 640
    
    local gap       = 120
    local left      = (main_width - (5-1)*gap) / 2
    local main_height   = 220 * 2 + 4 * gap
    local bottom    = 220
    local i = 0
    local j = 0

    local node_example = self.coconut[1][1]
    local node_example_size = node_example:getContentSize()

    if location.x < (left - node_example_size.width / 2) or location.x > (main_width - (left - node_example_size.width / 2)) or
        location.y < (bottom - node_example_size.height / 2) or location.y > (main_height - (bottom - node_example_size.height / 2)) then
        self.onNode = false
    elseif  ((gap - node_example_size.width )/2) < ((location.x - (left - node_example_size.width / 2)) % gap) and
        ((gap + node_example_size.width )/2) > ((location.x - (left - node_example_size.width / 2)) % gap) and
        ((gap - node_example_size.height )/2) < ((location.y - (bottom - node_example_size.height / 2)) % gap) and
        ((gap + node_example_size.height )/2) > ((location.y - (bottom - node_example_size.height / 2)) % gap) then

        i = math.ceil((location.x - (left - node_example_size.width / 2)) / gap)
        j = math.ceil((location.y - (bottom - node_example_size.height / 2)) / gap)

        self.current_node_x = i
        self.current_node_y = j

        local node = self.coconut[i][j]
        local node_position = cc.p(node:getPosition())

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
    else
        self.onNode = false
    end
end

function SummaryBossLayer:win()
    self.globalLock = true
    self.girl:setAnimation(0,'girl_win',true)
    local alter = SummaryBossAlter.create(true,self.rightWord,self.currentBlood,1)
    alter:setPosition(0,0)
    self:addChild(alter,1000)
    
--    -- win sound
--    playSound(s_sound_win)
end

function SummaryBossLayer:lose()
    self.globalLock = true
    self.girl:setAnimation(0,'girl-fail',true)
    local alter = SummaryBossAlter.create(false,self.rightWord,self.currentBlood,1)
    alter:setPosition(0,0)
    self:addChild(alter,1000)
    
--    -- lose sound
--    playSound(s_sound_fail)    
end

function SummaryBossLayer:hint()
    self.isHinting = true
    local num = math.random(1,#self.wordPool[self.currentIndex])
    local index = 1
    for i = 1, #self.wordPool[self.currentIndex] do
        if self.crabOnView[i] then
            index = i
            break
        end
    end
    for i = 1, 5 do
        for j = 1, 5 do
            if self.isCrab[self.currentIndex][i][j] == index then
                self.coconut[i][j]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
            end
        end
    end
    
end

return SummaryBossLayer