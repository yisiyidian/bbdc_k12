

local TapNode = require("view.TapNode")

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
    
    local light = cc.Sprite:create("image/studyscene/long_light.png")
    light:setAnchorPoint(0.5,0.05)
    light:setVisible(false)
    light:setPosition(firstTapNode:getPosition())
    main:addChild(light)
    

    -- local function
    local checkTouchLocation = function(location)
        for i = 1, main_m do
            for j = 1, main_n do
                local node = main_mat[i][j]
                if cc.rectContainsPoint(node:getBoundingBox(), location) then
                    current_node_x = i
                    current_node_y = j
                    onNode = true
                    return
                end
            end
        end
        onNode = false
    end

    -- handing touch events
    onTouchBegan = function(touch, event)
        if main.globalLock then
            return true
        end
        
        light:setVisible(true)

        local location = main:convertToNodeSpace(touch:getLocation())
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

        checkTouchLocation(location)

        if onNode then
            local currentNode = main_mat[current_node_x][current_node_y]
            if currentNode.hasSelected then
                if #selectStack >= 2 then
                    local stackTop = selectStack[#selectStack]
                    local secondStackTop = selectStack[#selectStack-1]
                    if currentNode.logicX == secondStackTop.logicX and currentNode.logicY == secondStackTop.logicY then
                        stackTop.removeSelectStyle()
                        table.remove(selectStack)
                    end
                end
            else
                if #selectStack == 0 then
                    currentNode.addSelectStyle()
                    table.insert(selectStack, currentNode)
                else
                    local stackTop = selectStack[#selectStack]
                    if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                        currentNode.addSelectStyle()
                        table.insert(selectStack, currentNode)
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







