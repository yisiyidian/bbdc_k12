require("cocos.init")
require("common.global")

local FlipNode = require("view.mat.FlipNode")

local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4

local FlipMat = class("FlipMat", function()
    return cc.Layer:create()
end)

function FlipMat.create(word, m ,n, isNewPlayerModel, spineName)
    if spineName == nil then
        spineName = "coconut_light"
    end
    
    local main_width    = 640
    local main_height   = 640
    
    local main = FlipMat.new()
    main:setContentSize(main_width, main_height)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)
    
    main.success    = function()end
    main.fail       = function()end
    main.globalLock = false
    main.rightLock  = false
    main.wrongLock  = false
    main.answerPath = {}
    for i = 1, string.len(word) do
        main.answerPath[i] = {x=0, y=0}
    end
    
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
    
    local startTouchLocation
    local lastTouchLocation
    
    local slideCoco = {}
    slideCoco[1] = s_sound_slideCoconut
    slideCoco[2] = s_sound_slideCoconut1
    slideCoco[3] = s_sound_slideCoconut2
    slideCoco[4] = s_sound_slideCoconut3
    slideCoco[5] = s_sound_slideCoconut4
    slideCoco[6] = s_sound_slideCoconut5
    slideCoco[7] = s_sound_slideCoconut6
    
--    local slideCoin = {}
--    slideCoin[1] = s_sound_slideCoin
--    slideCoin[2] = s_sound_slideCoin1
--    slideCoin[3] = s_sound_slideCoin2
--    slideCoin[4] = s_sound_slideCoin3
--    slideCoin[5] = s_sound_slideCoin4
--    slideCoin[6] = s_sound_slideCoin5
--    slideCoin[7] = s_sound_slideCoin6
        
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
    
    local main_logic_mat = randomMat(main_m, main_n)
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
                
                local tmp = {}
                tmp.x = i
                tmp.y = j
                main.answerPath[diff+1] = tmp
            else
                local randomIndex = math.random(1, #charaster_set_filtered)
                node = FlipNode.create(spineName, charaster_set_filtered[randomIndex], i, j)
                if isNewPlayerModel then
                    node:setPosition(320, -1136)
                    main:addChild(node)
                    
                    local tmp_sprite = cc.Sprite:create("image/coconut_font.png")
                    tmp_sprite:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                    tmp_sprite:setOpacity(120)
                    main:addChild(tmp_sprite)
                    
                    local tmp_label = cc.Label:createWithSystemFont(charaster_set_filtered[randomIndex],"",40)
                    tmp_label:setColor(cc.c3b(0,0,0))
                    tmp_label:setOpacity(120)
                    tmp_label:setPosition(tmp_sprite:getContentSize().width/2, tmp_sprite:getContentSize().height/2)
                    tmp_sprite:addChild(tmp_label)
                else
                    node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
                    main:addChild(node)
                end
            end
            main_mat[i][j] = node
            
            if diff == 0 then
                firstFlipNode = node
            
                firstFlipNode.firstStyle()
                
                local action1 = cc.ScaleTo:create(0.5,1.05)
                local action2 = cc.ScaleTo:create(0.5,0.95)
                local action3 = cc.Sequence:create(action1,action2)
                firstFlipNode:runAction(cc.RepeatForever:create(action3))
            end
        end
    end
    
    local finger = nil
    main.finger_action = function()
        if finger then
             finger:removeFromParent()
        end 
        
        finger = cc.Sprite:create("image/studyscene/global_finger.png")
        finger:setAnchorPoint(0,1)
        finger:setPosition(firstFlipNode:getPosition())
        main:addChild(finger)
         
        local actionList = {}
        local action1 = cc.DelayTime:create(0.5)
        table.insert(actionList, action1)
        for i = 1, #main.answerPath do
            local action2 = cc.MoveTo:create(0.5, cc.p(main_mat[main.answerPath[i].x][main.answerPath[i].y]:getPosition()))
            table.insert(actionList, action2)
        end
        local action3 = cc.FadeOut:create(0.5)
        local action4 = cc.Place:create(cc.p(firstFlipNode:getPosition()))
        local action5 = cc.FadeIn:create(0.5)
        table.insert(actionList, action3)
        table.insert(actionList, action4)
        table.insert(actionList, action5)
        local action6 = cc.Sequence:create(actionList)
        finger:runAction(cc.RepeatForever:create(action6))
    end
    --main.finger_action()
   ----houqi 
    local back_box = cc.Layer:create()
    local back_box_num = 0
    local updateSelectWord = function()
        for i = 1, back_box_num do
            main:removeChildByTag(i,true)
            main:removeChildByTag(100+i,true)
        end

        local gap = 28
        local left = s_DESIGN_WIDTH/2 - (#selectStack-1)*gap/2

        
        if NewStudyLayer_State == NewStudyLayer_State_Slide then
            for i = 1, #selectStack do
                local term_back = cc.Sprite:create("image/newstudy/wordbackground.png")
                term_back:setPosition(left+(i-1)*gap,830)
                term_back:setTag(i)
                main:addChild(term_back)
            end
            for i = 1, #selectStack do
                local term_char = cc.Label:createWithSystemFont(selectStack[i].main_character_content,"",28)
                term_char:setColor(BlackFont)
                term_char:setPosition(left+(i-1)*gap,830)
                term_char:setTag(100+i)
                main:addChild(term_char)
            end
            back_box_num = #selectStack

        else
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
        

    end
    
    
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
            
--            print("i="..i)
--            print("j="..j)
--            print("node_position.x="..node_position.x)
--            print("node_position.y="..node_position.y)    
--            print("location.x="..location.x)
--            print("location.y="..location.y) 
--            
--            
--            print("node_example_size.width="..node_example_size.width)
--            print("main_width="..main_width)
--            print("left="..left)
               
                  
            onNode = true
        else
            onNode = false
        end

    end
    
    onTouchBegan = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint({x=0,y=0,width=main:getBoundingBox().width,height=main:getBoundingBox().height}, location) then
            return false
        end
    
        if main.globalLock then
            return true
        end
        
        startTouchLocation = location
        lastTouchLocation = location

 --      checkTouchLocation(location)
        checkTouchLocation_opt(location)   
        
        if onNode then
            startNode = main_mat[current_node_x][current_node_y]
            table.insert(selectStack, startNode)
            updateSelectWord()
            startNode.addSelectStyle()
            startNode.bigSize()

            startAtNode = true
            playSound(s_sound_slideCoconut)
            
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
    
        local length_gap = 5.0

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
    
 --      checkTouchLocation(location)
        checkTouchLocation_opt(location)  

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

    onTouchEnded = function(touch, event)
        if main.globalLock then
            return
        end
        
        if #selectStack < 1 then
            return
        end
        
        local location = main:convertToNodeSpace(touch:getLocation())

        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].main_character_content
            -- slide coco "s_sound_slideCoconut"
--            if #selectStack <= 7 then
--                playSound(slideCoco[#selectStack])
--            else
--                playSound(slideCoco[7])
--            end
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
            
            -- slide true
            playSound(s_sound_learn_true)
        else
            if main.wrongLock then
                main.globalLock = true
            end
        
            for i = 1, #selectStack do
                local node = selectStack[i]
                node.removeSelectStyle()
            end
            selectStack = {}
            
            firstFlipNode.firstStyle()
            
            main.fail()
            
            --slide wrong
            playSound(s_sound_learn_false)
            
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
--    listener:setSwallowTouches(true)
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)
    
    return main
end


return FlipMat







