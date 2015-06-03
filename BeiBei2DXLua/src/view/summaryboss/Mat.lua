require("cocos.init")
require("common.global")

local FlipNode            = require("view.mat.FlipNode")
local NodeBulletAnimation = require("view.mat.NodeBulletAnimation")
local GuideLine           = require("view.mat.GuideLine")

local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4

local Mat = class("Mat", function()
    return cc.Layer:create()
end)

function Mat.create(bosslayer, isNewPlayerModel, spineName)

    local word = bosslayer.wordList[1][1]
    local m = bosslayer.mat_length
    local n = m
    if spineName == nil then
        spineName = "coconut_light"
    end

    local main_width    = 640
    local main_height   = 640

    local main = Mat.new()
    main:setContentSize(main_width, main_height)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)
    -- main:setPosition(blackColor:getContentSize().width/2,160)
    -- blackColor:addChild(main)

    main.success    = function(stack)end
    main.fail       = function()end
    main.globalLock = false
    main.rightLock  = false
    main.wrongLock  = false
    main.answerPath = {}
    for i = 1, string.len(word) do
        main.answerPath[i] = {x=0, y=0}
    end
    main.endPosition = 0


    math.randomseed(os.time())

    local onTouchBegan
    local onTouchMoved
    local fakeTouchMoved
    local onTouchEnded

    local main_word = word
    local main_m    = m
    local main_n    = n

    local current_node_x
    local current_node_y
    local current_dir
    local onNode
    local startAtNode
    local startNode

    local bullet

    local startTouchLocation
    local lastTouchLocation

    local judgementFunction
    local failFunction
    local successFunction
    local buildTimer
    local removeTimer
    local time

    local slideCoco = {}
    slideCoco[1] = s_sound_slideCoconut
    slideCoco[2] = s_sound_slideCoconut1
    slideCoco[3] = s_sound_slideCoconut2
    slideCoco[4] = s_sound_slideCoconut3
    slideCoco[5] = s_sound_slideCoconut4
    slideCoco[6] = s_sound_slideCoconut5
    slideCoco[7] = s_sound_slideCoconut6

    local selectStack = {}

    local charaster_set_filtered = {}
    for i = 1, 26 do
        local char = string.char(96+i)
        if string.find(main_word, char) == nil then
            table.insert(charaster_set_filtered, char)
        end
    end

    local gap       = 132
    local left      = (main_width - (main_m-1)*gap) / 2
    local bottom    = left
    local time1=  os.clock()
    local main_logic_mat = randomMat(main_m, main_n)
    --local main_logic_mat = {{1,2,3,4},{8,7,6,5},{9,10,11,12},{16,15,14,13}}
    -- print_lua_table(main_logic_mat)
    -- print('map time = ',os.clock() - time1)
    local randomStartIndex = math.random(1, main_m*main_n-string.len(main_word)+1)

    local main_mat = {}
    local firstFlipNode = nil
    for i = 1, main_m do
        main_mat[i] = {}
        for j = 1, main_n do
            local diff = main_logic_mat[i][j] - randomStartIndex
            local node
            if diff >= 0 and diff < string.len(main_word) then
                node = FlipNode.create(spineName, string.sub(main_word,diff+1,diff+1), i, j)
                node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                main:addChild(node) 

                --add bullet 
                bullet = NodeBulletAnimation.create()
                bullet:setPosition(node:getContentSize().width / 2,node:getContentSize().height / 2)
                bullet:setName("bullet")
                bullet:setVisible(false)
                node:addChild(bullet)

                local tmp = {}
                tmp.x = i
                tmp.y = j
                main.answerPath[diff+1] = tmp
            else
                local randomIndex = math.random(1, #charaster_set_filtered)
                node = FlipNode.create(spineName, charaster_set_filtered[randomIndex], i, j)

                if isNewPlayerModel == true then
                    node:setPosition(320, -1136)
                    main:addChild(node)

                    local tmp_sprite = cc.Sprite:create("image/coconut_font.png")
                    tmp_sprite:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                    --tmp_sprite:setOpacity(120)
                    main:addChild(tmp_sprite)
                    tmp_sprite:setScale(0)
                    tmp_sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (3 + i - j)),cc.ScaleTo:create(0.1, 1)))

                    local tmp_label = cc.Label:createWithTTF(charaster_set_filtered[randomIndex],'font/CenturyGothic.ttf',60)
                    tmp_label:setColor(cc.c3b(20,20,20))
                    --tmp_label:setOpacity(120)
                    tmp_label:setPosition(tmp_sprite:getContentSize().width/2 + 3, tmp_sprite:getContentSize().height/2 + 3)
                    tmp_sprite:addChild(tmp_label)
                    
                else
                    node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                    main:addChild(node)
                end
            end
            main_mat[i][j] = node
            node:setScale(0)
            node:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (3 + i - j)),cc.ScaleTo:create(0.1, 1)))

            if diff == 0 then
                firstFlipNode = node
                firstFlipNode.firstStyle()
                if not isNewPlayerModel then
                    main:runAction(cc.Sequence:create(cc.DelayTime:create(1.2),cc.CallFunc:create(function (  )
                        local action1 = cc.ScaleTo:create(0.5,1.05)
                        local action2 = cc.ScaleTo:create(0.5,0.95)
                        local action3 = cc.Sequence:create(action1,action2)
                        firstFlipNode:runAction(cc.RepeatForever:create(action3))
                    end,{})))
                end
            end
        end
    end

    local function guidePath()
        local actionList = {}
        for i = 1, #main.answerPath do
            local action1 = cc.MoveTo:create(0.3, cc.p(main_mat[main.answerPath[i].x][main.answerPath[i].y]:getPosition()))
            table.insert(actionList, action1)
        end

        local action = cc.Sequence:create(actionList)
        return action
    end


    local finger
    main.finger_action = function()
        finger = cc.Sprite:create('image/newstudy/qian.png')
        finger:setPosition(firstFlipNode:getPositionX(),firstFlipNode:getPositionY())
        finger:ignoreAnchorPointForPosition(false)
        finger:setAnchorPoint(0.2,0.8)
        finger:setScale(1.5)
        main:addChild(finger) 

        local action0 = cc.DelayTime:create(0.5)
        local action2 = cc.DelayTime:create(1 + 0.3 * string.len(main_word))
        local action3 = cc.DelayTime:create(0.2)

        main:runAction(cc.RepeatForever:create(cc.Sequence:create(
            cc.CallFunc:create(function ()
                finger:runAction(cc.FadeIn:create(0.5))
                finger:setTexture("image/newstudy/qian.png")
                finger:runAction(cc.ScaleTo:create(0.5,1))
            end),
            action0,
            cc.CallFunc:create(
            function ()
                finger:setTexture("image/newstudy/hou.png")
                finger:runAction(guidePath())
            end)
            ,action2,
            cc.CallFunc:create(function ()
                finger:runAction(cc.FadeOut:create(0.2))
                finger:setTexture("image/newstudy/qian.png")
                finger:runAction(cc.ScaleTo:create(0.2,1.5))
            end)
            ,action3,
            cc.CallFunc:create(function ()
                finger:runAction(cc.Place:create(cc.p(firstFlipNode:getPosition())))
            end)
        )))
        
    end

    local pointList = {}
    main.guidePoint = function ()
        for i = 1,15 do
            local point = cc.LayerColor:create(cc.c4b(255,255,0 + i * 1,255 - i * 20), 16 - i , 16 - i)
            point:setPosition(firstFlipNode:getPosition())
            point:ignoreAnchorPointForPosition(false)
            point:setAnchorPoint(0.5,0.5)
            point:setVisible(false)
            main:addChild(point)

            table.insert(pointList,point)

            local action0 = cc.DelayTime:create(0.5 + i/20)
            local action2 = cc.DelayTime:create(1 + 0.3 * string.len(main_word) - i/20)
            local action3 = cc.DelayTime:create(0.2)

            main:runAction(cc.RepeatForever:create(cc.Sequence:create(action0,
                cc.CallFunc:create(function ()
                point:setVisible(true)
                point:runAction(guidePath())
                end)
                ,action2,
                cc.CallFunc:create(function ()
                point:setVisible(false)
                end)
                ,action3,
                cc.CallFunc:create(function ()
                point:runAction(cc.Place:create(cc.p(firstFlipNode:getPosition())))
                end)
            )))
        end
    end

    main.cocoAnimation = function()
        local newList = {"up"}
            for i=1, #main.answerPath - 1 do
                if main.answerPath[i].x == main.answerPath[i+1].x and main.answerPath[i].y > main.answerPath[i+1].y then
                    table.insert(newList,"down")
                elseif main.answerPath[i].x == main.answerPath[i+1].x and main.answerPath[i].y < main.answerPath[i+1].y then
                    table.insert(newList,"up")
                elseif main.answerPath[i].x > main.answerPath[i+1].x and main.answerPath[i].y == main.answerPath[i+1].y then
                    table.insert(newList,"left")
                elseif main.answerPath[i].x < main.answerPath[i+1].x and main.answerPath[i].y == main.answerPath[i+1].y then
                    table.insert(newList,"right")
                end
            end
        for i = 1, #main.answerPath do
            local node = main_mat[main.answerPath[i].x][main.answerPath[i].y]
            local action0 = cc.DelayTime:create(0.5 + 0.3 * i)
            local action2 = cc.DelayTime:create(1.2 + 0.3 * string.len(main_word) - 0.3 * i)

            main:runAction(cc.RepeatForever:create(cc.Sequence:create(action0,
                cc.CallFunc:create(function ()
                    if newList[i] == "down" then
                    node.down()
                    elseif newList[i] == "up" then
                    node.up()
                    elseif newList[i] == "left" then
                    node.left()
                    elseif newList[i] == "right" then
                    node.right()
                    end
                end)
                ,action2,
                cc.CallFunc:create(function ()
                node.removeSelectStyle()
                end)
            )))
        end
    end
    
    if isNewPlayerModel == true then
        s_SCENE:callFuncWithDelay(1.2,function (  )
            local hintBoard = cc.Sprite:create('image/summarybossscene/hint_slide.png')
            hintBoard:setPosition(0.5 * s_DESIGN_WIDTH,0.72 * s_DESIGN_HEIGHT - 180)
            main:addChild(hintBoard)
            hintBoard:setName('board')
            main.guidePoint()
            main.cocoAnimation()   
            main.finger_action()
            firstFlipNode:stopAllActions()
        end)
        
    end



    
    local back_box = cc.Layer:create()
    local back_box_num = 0
    local updateSelectWord = function()
 
        bosslayer:removeChildByTag(1,true)
        if #selectStack == 0 and bosslayer.wordList[1][2] == '' then
            return
        end

        local sprite =  ccui.Scale9Sprite:create("image/mat/circle.png",cc.rect(0,0,79,74),cc.rect(28.499,0,28.501,74))
        sprite:setPosition(s_DESIGN_WIDTH/2,790)
        if bosslayer.wordList[1][2] == '' then
            sprite:setContentSize((#selectStack) * 18 + 60 ,74)
        else
            sprite:setContentSize((#selectStack+string.len(bosslayer.wordList[1][2])+1) * 18 + 60 ,74)
        end
        sprite:setTag(1)
        bosslayer:addChild(sprite)

        local circle_succeed = ccui.Scale9Sprite:create("image/mat/circle_succeed.png",cc.rect(0,0,232,94),cc.rect(47,0,138,94))
        circle_succeed:setPosition(sprite:getContentSize().width/2 ,sprite:getContentSize().height/2)
        if bosslayer.wordList[1][2] == '' then
            circle_succeed:setContentSize((#selectStack) * 18 + 94 ,94)
        else
            circle_succeed:setContentSize((#selectStack+string.len(bosslayer.wordList[1][2])+1) * 18 + 94 ,94)
        end
        sprite:addChild(circle_succeed)
        circle_succeed:setOpacity(0)
        main.circle_succeed = circle_succeed

        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord..selectStack[i].main_character_content
        end
        selectWord = selectWord..bosslayer.wordList[1][2]

        local label1 = cc.Label:createWithTTF(selectWord,'font/CenturyGothic.ttf',36)
        label1:setColor(cc.c4b(255,255,255,255))
        label1:setPosition(circle_succeed:getContentSize().width/2 ,circle_succeed:getContentSize().height/2)
        label1:ignoreAnchorPointForPosition(false)
        label1:setAnchorPoint(0.5,0.5)
        label1:setScale(1)
        circle_succeed:addChild(label1)

        if bosslayer.wordList[1][2] ~= '' then
            local line = cc.LayerColor:create(cc.c4b(255,255,255,255),18 * #selectStack + 18,1)
            line:setPosition(47 + #selectStack / 2,20)
            circle_succeed:addChild(line)
        end
    end
    updateSelectWord()

    -- local function
    local checkTouchLocation = function(location)
        for i = 1, main_m do
            for j = 1, main_n do
                local node = main_mat[i][j]
                local node_position = cc.p(node:getPosition())
                local node_size = node:getContentSize()

                if cc.rectContainsPoint(node:getBoundingBox(), location) then
                    current_node_x = i
                    current_node_y = j

                    local x = location.x - node_position.x
                    local y = location.y - node_position.y
                    if y > x and y > -x then
                        current_dir = dir_up
                    elseif y < x and y < -x then
                        current_dir = dir_down
                    elseif y > x and y < -x then
                        current_dir = dir_left
                    else
                        current_dir = dir_right
                    end


                    --                    print("i="..i)
                    --                    print("j="..j)
                    --                    print("node_position.x="..node_position.x)
                    --                    print("node_position.y="..node_position.y)    
                    --                    print("location.x="..location.x)
                    --                    print("location.y="..location.y) 

                    onNode = true
                    return
                end
            end
        end
        onNode = false
    end
    --    local gap       = 132
    --    local left      = (main_width - (main_m-1)*gap) / 2
    --    local bottom    = left


    local checkTouchLocation_opt = function(location)
        local i = 0
        local j = 0

        local node_example = main_mat[1][1]
        local node_example_size = node_example:getContentSize()

        if location.x < (left - node_example_size.width / 2) or location.x > (main_width - (left - node_example_size.width / 2)) or
            location.y < (bottom - node_example_size.height / 2) or location.y > (main_height - (bottom - node_example_size.height / 2)) then
            onNode = false
        elseif  ((gap - node_example_size.width )/2) < ((location.x - (left - node_example_size.width / 2)) % gap) and
            ((gap + node_example_size.width )/2) > ((location.x - (left - node_example_size.width / 2)) % gap) and
            ((gap - node_example_size.height )/2) < ((location.y - (bottom - node_example_size.height / 2)) % gap) and
            ((gap + node_example_size.height )/2) > ((location.y - (bottom - node_example_size.height / 2)) % gap) then

            i = math.ceil((location.x - (left - node_example_size.width / 2)) / gap)
            j = math.ceil((location.y - (bottom - node_example_size.height / 2)) / gap)

            current_node_x = i
            current_node_y = j

            local node_choose = main_mat[i][j]
            local node_position = cc.p(node_choose:getPosition())

            local x = location.x - node_position.x
            local y = location.y - node_position.y

            if y > x and y > -x then
                current_dir = dir_up
            elseif y < x and y < -x then
                current_dir = dir_down
            elseif y > x and y < -x then
                current_dir = dir_left
            else
                current_dir = dir_right
            end

            onNode = true
        else
            onNode = false
        end

    end

    local isGuide = true

    local stopAllGuide = function ()
        main:removeChildByName('board')
        main:stopAllActions()
        for i=1,#main.answerPath do
            local node = main_mat[main.answerPath[i].x][main.answerPath[i].y]
            node.removeSelectStyle()
        end
        if finger ~= nil then
        finger:runAction(cc.FadeOut:create(0.5))
        end
        if #pointList ~= 0 then
           for i=1,#pointList do
               pointList[i]:runAction(cc.FadeOut:create(0.5))
           end
        end
        isGuide = false
    end

    onTouchBegan = function(touch, event)

        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint({x=0,y=0,width=main:getBoundingBox().width,height=main:getBoundingBox().height}, location) then
            return false
        end

        if main.globalLock then
            return true
        end

        if #selectStack < 1 then
            startTouchLocation = location
            lastTouchLocation = location
        else    
            lastTouchLocation = location
        end 

        checkTouchLocation(location)

        if onNode then
            if isGuide and isNewPlayerModel then
               stopAllGuide()
            end

            startNode = main_mat[current_node_x][current_node_y]
            table.insert(selectStack, startNode)
            updateSelectWord()
            startNode.addSelectStyle()
            startNode.bigSize()
            
            startAtNode = true
            playSound(slideCoco[1])

            local x = location.x - startTouchLocation.x
            local y = location.y - startTouchLocation.y

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
        else
            startAtNode = false
        end
        return true
    end

    onTouchMoved = function(touch, event)

        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint({x=0,y=0,width=main:getBoundingBox().width,height=main:getBoundingBox().height}, location) then
            return
        end

        if main.globalLock then
            return
        end

        local length_gap = 50.0

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
        if main.globalLock then
            return
        end

        checkTouchLocation(location)
        --        checkTouchLocation_opt(location)  

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
            if onNode then
                local currentNode = main_mat[current_node_x][current_node_y]
                if currentNode.hasSelected then
                    if #selectStack >= 2 then
                        local stackTop = selectStack[#selectStack]
                        local secondStackTop = selectStack[#selectStack-1]
                        if currentNode.logicX == secondStackTop.logicX and currentNode.logicY == secondStackTop.logicY then
                            stackTop.removeSelectStyle()
                            table.remove(selectStack)
                            updateSelectWord()
                            if #selectStack <= 7 then
                                playSound(slideCoco[#selectStack])
                            else
                                playSound(slideCoco[7])
                            end  
                        end
                    end
                else
                    if #selectStack == 0 then
                        if current_dir == dir_up then
                            currentNode.down()
                        elseif current_dir == dir_down then
                            currentNode.up()
                        elseif current_dir == dir_left then
                            currentNode.right()
                        else
                            currentNode.left()
                        end
                        currentNode.hasSelected = true
                        table.insert(selectStack, currentNode)
                        updateSelectWord()
                    else
                        local stackTop = selectStack[#selectStack]
                        if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                            table.insert(selectStack, currentNode)
                            updateSelectWord()
                            -- slide coco "s_sound_slideCoconut"
                            if #selectStack <= 7 then
                                playSound(slideCoco[#selectStack])
                            else
                                playSound(slideCoco[7])
                            end
                            currentNode.addSelectStyle()
                            currentNode.bigSize()
                            if current_dir == dir_up then
                                currentNode.down()
                            elseif current_dir == dir_down then
                                currentNode.up()
                            elseif current_dir == dir_left then
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
    end

    judgementFunction = function ()
        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].main_character_content
        end

        if selectWord == main_word then
            successFunction()
        else
            failFunction()
        end
    end

    successFunction = function ()
        if main.rightLock then
            main.globalLock = true
        end

        for i = 1, #selectStack do
            local node = selectStack[i]
            node.win()
        end   

        --firstFlipNode:setVisible(false)

        main.success(selectStack)

        selectStack = {}
        main.circle_succeed:runAction(cc.Sequence:create(cc.FadeIn:create(0.2),cc.ScaleTo:create(0.2,1.2),cc.ScaleTo:create(0.2,1.0)))
        -- updateSelectWord()
        -- slide true
        playSound(s_sound_learn_true)
    end

    failFunction = function ()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        if main.wrongLock then
            main.globalLock = true
        end
        for i = 1, #selectStack do
            local node = selectStack[i]
            node.removeSelectStyle()
        end
        selectStack = {}
        firstFlipNode.firstStyle()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        main.fail()
        playSound(s_sound_learn_false)
    end

    main.forceFail = function ()
        failFunction()
        updateSelectWord()
    end

    onTouchEnded = function(touch, event)
        if main.globalLock then
            return
        end

        if #selectStack < 1 then
            return
        end        

        judgementFunction()
    end


    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end

return Mat