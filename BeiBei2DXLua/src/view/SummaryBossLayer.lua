require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local FlipNode = require("view.FlipNode")

local SummaryBossLayer = class("SummaryBosslayer", function ()
    return cc.Layer:create()
end)

local scale = 0.92
local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4

function SummaryBossLayer.create()   
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    local layer = SummaryBossLayer.new()
    local globalLock = false
    math.randomseed(os.time())
    --add back
    local back = sp.SkeletonAnimation:create("res/spine/summaryboss/zongjieboss_diyiguan_background.json", "res/spine/summaryboss/zongjieboss_diyiguan_background.atlas", 1)
    back:setPosition(s_SCREEN_WIDTH / 2, s_SCREEN_HEIGHT / 2)
    layer:addChild(back)
    --add coconut
    local gap = 120
    local left = (s_SCREEN_WIDTH - (5 - 1)*gap)/2
    local bottom = 220
    local hole = {}
    local coconut = {}
    local wordPool = {}
    local startIndexPool = {}
    local currentIndex = 1
    
    local current_node_x
    local current_node_y
    local current_dir
    local onNode
    local startAtNode

    local startTouchLocation
    local lastTouchLocation

    local startNode
    local selectStack = {}

    local killedCrabCount = 0
    local crabOnView = {}

    -- location function
    local onTouchBegan
    local onTouchMoved
    local fakeTouchMoved
    local onTouchEnded
    
    for i = 1, 5 do
        hole[i] = {}
        for j = 1, 5 do
            hole[i][j] = cc.Sprite:create("image/summarybossscene/summaryboss_chapter1_hole.png")
            hole[i][j]:setScale(0.92)
            hole[i][j]:setPosition(left + gap * (i - 1), bottom + gap * (j - 1))
            layer:addChild(hole[i][j],0)
        end
    end
    
    local initWordList = function()
        local wordList = {"apple","pear","water","day"}
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
                       wordPool[#wordPool + 1] = tmp
                       break
                   end
               end 
           end
           if index > #wordList then
               break
           end
           wordPool[#wordPool + 1] = tmp          
        end
    end
    
    initWordList()
    
    local initStartIndex = function()
        startIndexPool = {}
        if #wordPool[currentIndex] == 1 then
            local localgap = 25 - string.len(wordPool[currentIndex][1])
            local randomStart = math.random(0,localgap)
            startIndexPool[#startIndexPool + 1] = randomStart + 1
        elseif #wordPool[currentIndex] == 2 then
            local localgap = 25 - string.len(wordPool[currentIndex][1]) - string.len(wordPool[currentIndex][2])
            local randomStart1 = math.random(0,localgap)
            localgap = localgap - randomStart1
            local randomStart2 = math.random(0,localgap)
            startIndexPool[#startIndexPool + 1] = randomStart1 + 1
            startIndexPool[#startIndexPool + 1] = randomStart1 + string.len(wordPool[currentIndex][1]) + randomStart2 + 1
        elseif #wordPool[currentIndex] == 3 then
            local localgap = 25 - string.len(wordPool[currentIndex][1]) - string.len(wordPool[currentIndex][2]) - string.len(wordPool[currentIndex][3])
            local randomStart1 = math.random(0,localgap)
            localgap = localgap - randomStart1
            local randomStart2 = math.random(0,localgap)
            localgap = localgap - randomStart2
            local randomStart3 = math.random(0,localgap)
            startIndexPool[#startIndexPool + 1] = randomStart1 + 1
            startIndexPool[#startIndexPool + 1] = randomStart1 + string.len(wordPool[currentIndex][1]) + randomStart2 + 1
            startIndexPool[#startIndexPool + 1] = randomStart1 + string.len(wordPool[currentIndex][1]) + randomStart2 + string.len(wordPool[currentIndex][2]) + randomStart3 + 1        
        end
    end
    
    local initMap = function()
        initStartIndex()
        for i = 1, #wordPool[currentIndex] do
            crabOnView[i] = true
        end
        local charaster_set_filtered = {}
        for i = 1, 26 do
            local char = string.char(96+i)
            charaster_set_filtered[#charaster_set_filtered+1] = char
        end
        
        local main_logic_mat = randomMat(5, 5)
        for i = 1, 5 do
            coconut[i] = {}
            for j = 1, 5 do
                local randomIndex = math.random(1, #charaster_set_filtered)
                
                if #wordPool[currentIndex] == 1 then
                    local diff = main_logic_mat[i][j] - startIndexPool[1]
                    if diff >= 0 and diff < string.len(wordPool[currentIndex][1]) then
                        coconut[i][j] = FlipNode.create("coconut_light", string.sub(wordPool[currentIndex][1],diff+1,diff+1), i, j)
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        coconut[i][j] = FlipNode.create("coconut_light", charaster_set_filtered[randomIndex], i, j)
                    end
                elseif #wordPool[currentIndex] == 2 then
                    local diff1 = main_logic_mat[i][j] - startIndexPool[1]
                    local diff2 = main_logic_mat[i][j] - startIndexPool[2]
                    if diff1 >= 0 and diff1 < string.len(wordPool[currentIndex][1]) then
                        coconut[i][j] = FlipNode.create("coconut_light", string.sub(wordPool[currentIndex][1],diff1+1,diff1+1), i, j)
                    elseif diff2 >= 0 and diff2 < string.len(wordPool[currentIndex][2]) then
                        coconut[i][j] = FlipNode.create("coconut_light", string.sub(wordPool[currentIndex][2],diff2+1,diff2+1), i, j)
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        coconut[i][j] = FlipNode.create("coconut_light", charaster_set_filtered[randomIndex], i, j)
                    end
                elseif #wordPool[currentIndex] == 3 then
                    local diff1 = main_logic_mat[i][j] - startIndexPool[1]
                    local diff2 = main_logic_mat[i][j] - startIndexPool[2]
                    local diff3 = main_logic_mat[i][j] - startIndexPool[3]
                    if diff1 >= 0 and diff1 < string.len(wordPool[currentIndex][1]) then
                        coconut[i][j] = FlipNode.create("coconut_light", string.sub(wordPool[currentIndex][1],diff1+1,diff1+1), i, j)
                    elseif diff2 >= 0 and diff2 < string.len(wordPool[currentIndex][2]) then
                        coconut[i][j] = FlipNode.create("coconut_light", string.sub(wordPool[currentIndex][2],diff2+1,diff2+1), i, j)
                    elseif diff3 >= 0 and diff3 < string.len(wordPool[currentIndex][3]) then
                        coconut[i][j] = FlipNode.create("coconut_light", string.sub(wordPool[currentIndex][3],diff3+1,diff3+1), i, j)
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        coconut[i][j] = FlipNode.create("coconut_light", charaster_set_filtered[randomIndex], i, j)
                    end
                    
                end
                coconut[i][j]:setScale(scale)
                coconut[i][j]:setPosition(hole[i][j]:getPosition())
                layer:addChild(coconut[i][j],1)
                
            end
        end  
        
    end
    
    initMap()
    
    
    -- local function
    local checkTouchLocation = function(location)
        for i = 1, 5 do
            for j = 1, 5 do
                local node = coconut[i][j]
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
                    
                    onNode = true
                    return
                end
            end
        end
        
        onNode = false
    end
    
    -- handing touch events
    onTouchBegan = function(touch, event)
        if layer.globalLock then
            return true
        end
        
        local location = layer:convertToNodeSpace(touch:getLocation())
        
        startTouchLocation = location
        lastTouchLocation = location
        
        checkTouchLocation(location)
        
        if onNode then
            startNode = coconut[current_node_x][current_node_y]
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
        if globalLock then
            return
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
        if globalLock then
            return
        end
    
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
                local currentNode = coconut[current_node_x][current_node_y]
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
                        selectStack[#selectStack+1] = currentNode
                    else
                        local stackTop = selectStack[#selectStack]
                        if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                            selectStack[#selectStack+1] = currentNode
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

    onTouchEnded = function(touch, event)
        if globalLock then
            return
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
        for i = 1, #wordPool[currentIndex] do
            if crabOnView[i] then
                if selectWord == wordPool[currentIndex][i] then
                    killedCrabCount = killedCrabCount + 1
                    match = true
                    crabOnView[i] = false
                    for j = 1, #selectStack do
                        local node = selectStack[j]
                        node.win()
                        local recover = cc.CallFunc:create(
                            function()
                                node.normal()
                            end,{}
                        )
                        node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),recover))
                    end
                    selectStack = {}
                    if killedCrabCount == #wordPool[currentIndex] then
                        --next group
                        currentIndex = currentIndex + 1
                        killedCrabCount = 0
                        for m = 1, 5 do
                            for n = 1, 5 do
                                local remove = cc.CallFunc:create(function() 
                                    coconut[m][n]:removeFromParentAndCleanup(true)    
                                end,{})
                                coconut[m][n]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_SCREEN_HEIGHT*0.7)),remove))
                            end
                        end
                        layer:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function() 
                            coconut = {}
                            initMap()
                        end,{})))
                    end
                    break
                end
            end
        end
        
        if not match then
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
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer  
end

return SummaryBossLayer