

local TapNode = require("view.mat.TapNode")

local TapMat = class("TapMat", function()
    return cc.Layer:create()
end)

function TapMat.create(word, m ,n)
    local spriteName = "popcorn"

    local main = TapMat.new()
    main:setContentSize(640,640)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)

    -- block function
    main.success = function()
    end
    main.fail = function()
    end

    main.globalLock = false
    main.rightLock = false
    main.wrongLock = false

    -- system function
    math.randomseed(os.time())

    -- location function
    local onTouchBegan
    local onTouchMoved
    local fakeTouchMoved
    local onTouchEnded

    -- local variate
    local main_word = word
    local main_m = m
    local main_n = n

    local current_node_x
    local current_node_y
    local onNode
    local lastTouchLocation
    
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
            charaster_set_filtered[#charaster_set_filtered+1] = char
        end
    end

    local gap = 132
    local left = (s_DESIGN_WIDTH - (main_m-1)*gap) / 2
    local bottom = left

    local main_logic_mat = randomMat(main_m, main_n)
    local randomStartIndex = math.random(1, main_m*main_n-string.len(main_word)+1)

    local main_mat = {}
    local firstTapNode = nil
    for i = 1, main_m do
        main_mat[i] = {}
        for j = 1, main_n do
            local diff = main_logic_mat[i][j] - randomStartIndex
            local node
            if diff >= 0 and diff < string.len(main_word) then
                node = TapNode.create(spriteName, string.sub(main_word,diff+1,diff+1), i, j)
                node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                main:addChild(node)
            else
                local randomIndex = math.random(1, #charaster_set_filtered)
                node = TapNode.create(spriteName, charaster_set_filtered[randomIndex], i, j)
                node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                main:addChild(node)
            end
            main_mat[i][j] = node

            if diff == 0 then
                firstTapNode = node

                firstTapNode.firstStyle()

                local action1 = cc.ScaleTo:create(0.5,1.05)
                local action2 = cc.ScaleTo:create(0.5,0.95)
                local action3 = cc.Sequence:create(action1,action2)
                firstTapNode:runAction(cc.RepeatForever:create(action3))
            end
        end
    end
    
    local light = nil
    light = cc.Sprite:create("image/studyscene/long_light.png")
    light:setAnchorPoint(0.5,0.05)
    light:setVisible(false)
    light:setPosition(firstTapNode:getPosition())
    main:addChild(light)
    
    -- local function
    local checkTouchLocation = function(location)
        for i = 1, main_m do
            for j = 1, main_n do
                local node = main_mat[i][j]
                local node_position = cc.p(node:getPosition())
                local node_position_size = node:getContentSize()
                if cc.rectContainsPoint(node:getBoundingBox(), location) then
                    current_node_x = i
                    current_node_y = j
                    onNode = true
                    
--                    print("i="..i)
--                    print("j="..j)
--                    print("node_position.x="..node_position.x)
--                    print("node_position.y="..node_position.y)    
--                    print("location.x="..location.x)
--                    print("location.y="..location.y) 
--                    
--                    print("node_example_size.width="..node_position_size.width)
                    
                    return
                end
            end
        end
        onNode = false
    end
    
    local checkTouchLocation_opt = function(location)
        local i = 0
        local j = 0

        local node_example = main_mat[1][1]
        local node_example_size = node_example:getContentSize()

        if location.x < (left - node_example_size.width / 2) or location.x > (s_DESIGN_WIDTH - (left - node_example_size.width / 2)) or
            location.y < (bottom - node_example_size.height / 2) or location.y > (s_DESIGN_WIDTH - (bottom - node_example_size.height / 2)) then
            onNode = false
        elseif  ((gap - node_example_size.width )/2) < ((location.x - (left - node_example_size.width / 2)) % gap) and
            ((gap + node_example_size.width )/2) > ((location.x - (left - node_example_size.width / 2)) % gap) and
            ((gap - node_example_size.height )/2) < ((location.y - (bottom - node_example_size.height / 2)) % gap) and
            ((gap + node_example_size.height )/2) > ((location.y - (bottom - node_example_size.height / 2)) % gap) then

            i = math.ceil((location.x - (left - node_example_size.width / 2)) / gap)
            j = math.ceil((location.y - (bottom - node_example_size.height / 2)) / gap)

            current_node_x = i
            current_node_y = j

--            local node = main_mat[i][j]
--            local node_position = cc.p(node:getPosition())




--            print("i="..i)
--            print("j="..j)
--            print("node_position.x="..node_position.x)
--            print("node_position.y="..node_position.y)    
--            print("location.x="..location.x)
--            print("location.y="..location.y) 
--
--
--            print("node_example_size.width="..node_example_size.width)
--            print("left="..left)


            onNode = true
        else
            onNode = false
        end
    end
    
    
    local back_box = cc.Layer:create()
    local back_box_num = 0
    
    local updateSelectWord = function()
        for i = 1, back_box_num do
            main:removeChildByTag(i,true)
            main:removeChildByTag(100+i,true)
        end
        
        local gap = 28
        local left = s_DESIGN_WIDTH/2 - (#selectStack-1)*gap/2
        for i = 1, #selectStack do
            local term_back = cc.Sprite:create("image/studyscene/circle_back_green.png")
            term_back:setPosition(left+(i-1)*gap,640)
            term_back:setTag(i)
            main:addChild(term_back)
        end
        for i = 1, #selectStack do
            local term_char = cc.Label:createWithSystemFont(selectStack[i].main_character_content,"",28)
            term_char:setColor(cc.c4b(255,255,255,255))
            term_char:setPosition(left+(i-1)*gap,640)
            term_char:setTag(100+i)
            main:addChild(term_char)
        end
        back_box_num = #selectStack
    end

    -- handing touch events
    onTouchBegan = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint({x=0,y=0,width=main:getBoundingBox().width,height=main:getBoundingBox().height}, location) then
            return false
        end
    
        if main.globalLock then
            return true
        end
        
        
        
        light:setVisible(true)
        
        fakeTouchMoved(location)
        lastTouchLocation = location
        return true
    end

    onTouchMoved = function(touch, event)
        if main.globalLock then
            return
        end

        local length_gap = 3.0

        local location = main:convertToNodeSpace(touch:getLocation())

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
        
        light:setPosition(location)

    --    checkTouchLocation(location)
        checkTouchLocation_opt(location)

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
                    currentNode.addSelectStyle()
                    table.insert(selectStack, currentNode)
                    updateSelectWord()
                    playSound(slideCoco[#selectStack])

                else
                    local stackTop = selectStack[#selectStack]
                    if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                        currentNode.addSelectStyle()
                        table.insert(selectStack, currentNode)
                        updateSelectWord()
                        if #selectStack <= 7 then
                            playSound(slideCoco[#selectStack])
                        else
                            playSound(slideCoco[7])
                        end 
                    end
                end
            end
        else
            -- todo something
        end
    end

    onTouchEnded = function(touch, event)
        if main.globalLock then
            return
        end
        
        light:setVisible(false)

        if #selectStack < 1 then
            return
        end

        local location = main:convertToNodeSpace(touch:getLocation())

        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].main_character_content
        end

        if selectWord == main_word then
            if main.rightLock then
                main.globalLock = true
            end

            local moveTimeGap = 0.8/#selectStack

--            if s_CorePlayManager.chapterIndex == "chapter1" then
--                local actionArray1 = {}
--                for i = 2, #selectStack do
--                    local node = selectStack[i]
--                    local action = cc.MoveTo:create(moveTimeGap,cc.p(node:getPosition()))
--                    table.insert(actionArray1,action)
--                end
--            
--                local light_start = cc.Sprite:create("image/studyscene/long_light.png")
--                light_start:setAnchorPoint(0.5,0.05)
--                light_start:setPosition(selectStack[1]:getPosition())
--                main:addChild(light_start)
--                light_start:runAction(cc.Sequence:create(actionArray1))
--            
--                local actionArray2 = {}
--                for i = 1, #selectStack-1 do
--                    local node = selectStack[#selectStack-i]
--                    local action = cc.MoveTo:create(moveTimeGap,cc.p(node:getPosition()))
--                    table.insert(actionArray2,action)
--                end
--            
--                local light_end = cc.Sprite:create("image/studyscene/long_light.png")
--                light_end:setAnchorPoint(0.5,0.05)
--                light_end:setPosition(selectStack[#selectStack]:getPosition())
--                main:addChild(light_end)
--                light_end:runAction(cc.Sequence:create(actionArray2))
--            end
            
            
            for i = 1, #selectStack do
                local node = selectStack[i]
                node.win()
            end
            selectStack = {}

            main.success()
        else
            if main.wrongLock then
                main.globalLock = true
            end

            for i = 1, #selectStack do
                local node = selectStack[i]
                node.removeSelectStyle()
            end
            selectStack = {}

            firstTapNode.firstStyle()

            main.fail()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end


return TapMat







