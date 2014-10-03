require "model.randomMat"
local flipNode = require("model.flipNode")

local flipMat = class("flipMat", function()
return cc.Layer:create()
end)

function flipMat.create(word, m ,n)
    -- system variate
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local main = flipMat.new()
    
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
    local current_dir
    local onNode
    local startAtNode
    
    local startTouchLocation
    local lastTouchLocation
    
    local startNode
    
    local selectStack = {}

    local charaster_set_filtered = {}
    for i = 1, 26 do
        local char = string.char(96+i)
        if string.find(main_word, char) == nil then
            charaster_set_filtered[#charaster_set_filtered+1] = char
        end
    end

    local gap = 132
    local left = (size.width - (main_m-1)*gap) / 2
    local bottom = left
    
    local main_logic_mat = randomMat(main_m, main_n)
    local randomStartIndex = math.random(1, main_m*main_n)
    
    local main_mat = {}
    for i = 1, main_m do
        main_mat[i] = {}
        for j = 1, main_n do
            local diff = main_logic_mat[i][j] - randomStartIndex
            local node
            if diff >= 0 and diff < string.len(main_word) then
                node = flipNode.create("coconut_light", string.sub(main_word,diff+1,diff+1), i, j)
            else
                local randomIndex = math.random(1, #charaster_set_filtered)
                node = flipNode.create("coconut_light", charaster_set_filtered[randomIndex], i, j)
            end
            node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
            main:addChild(node)
            main_mat[i][j] = node
        end
    end
    
    -- local function
    local checkTouchLocation = function(location)
        for i = 1, main_m do
            for j = 1, main_n do
                local node = main_mat[i][j]
                local node_position = cc.p(node:getPosition())
                local node_size = node:getContentSize()
                
                if location.x >= node_position.x - node_size.width/2 and location.x <= node_position.x + node_size.width/2 
                and location.y >= node_position.y - node_size.height/2 and location.y <= node_position.y + node_size.height/2 then
                    current_node_x = i
                    current_node_y = j
                    
                    local x = location.x - node_position.x
                    local y = location.y - node_position.y
                    if y > x and y > -x then
                        current_dir = 1
                    elseif y < x and y < -x then
                        current_dir = 2
                    elseif y > x and y < -x then
                        current_dir = 3
                    else
                        current_dir = 4
                    end
                    
                    onNode = true
                    
                    print(string.format("(%d,%d)->%d",current_node_x,current_node_y,current_dir))
                    
                    return
                end
            end
        end
        
        onNode = false
    end
    
    -- handing touch events
    onTouchBegan = function(touch, event)
        print("touch began")
        local location = touch:getLocation()
        
        startTouchLocation = location
        lastTouchLocation = location
        
        checkTouchLocation(location)
        
        if onNode then
            startNode = main_mat[current_node_x][current_node_y]
            selectStack[#selectStack+1] = startNode
            startNode.addSelectStyle()
            startNode.bigSize()

            startAtNode = true
        else
            startAtNode = false
        end
        
        -- CCTOUCHBEGAN event must return true
        return true
    end

    onTouchMoved = function(touch, event)
        local length_gap = 3.0

        local location = touch:getLocation()

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
        checkTouchLocation(location)

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
                        end
                    end
                else
                    if #selectStack == 0 then
                        if current_dir == 1 then
                            currentNode.down()
                        elseif current_dir == 2 then
                            currentNode.up()
                        elseif current_dir == 3 then
                            currentNode.right()
                        else
                            currentNode.left()
                        end
                        currentNode.hasSelected = true
                        selectStack[#selectStack+1] = currentNode
                    else
                        local stackTop = selectStack[#selectStack]
                        if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                            selectStack[#selectStack+1] = currentNode
                            currentNode.addSelectStyle()
                            currentNode.bigSize()
                            if current_dir == 1 then
                                currentNode.down()
                            elseif current_dir == 2 then
                                currentNode.up()
                            elseif current_dir == 3 then
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

    onTouchEnded = function(touch, event)
        print("touch ended")
        local location = touch:getLocation()


        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].main_character_content
        end
        print(selectWord)

        if selectWord == main_word then
            for i = 1, #selectStack do
                local node = selectStack[i]
                node.win()
            end
            selectStack = {}
        else
            for i = 1, #selectStack do
                local node = selectStack[i]
                node.removeSelectStyle()
            end
            selectStack = {}
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


return flipMat







