require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")


--ccbLogInSignUpLayer = ccbLogInSignUpLayer or {}
--ccb['signup_login'] = ccbLogInSignUpLayer

ccbCheckInNode = ccbCheckInNode or {}

local currentWord

local CheckInNode = class("CheckInNode", function ()
    return cc.Node:create()
end)

function CheckInNode.create(pNode)
    local node = CheckInNode.new()
    node.pNode = pNode
    return node
end


local letterArray = {}

function CheckInNode:ctor()
    self.globalLock = false
    --control volune
    if s_DATABASE_MGR.isMusicOn() then
       cc.SimpleAudioEngine:getInstance():setMusicVolume(0.25)
    end

--    -- sound
--    local slideCoco = {}
--    slideCoco[1] = s_sound_slideCoconut
--    slideCoco[2] = s_sound_slideCoconut1
--    slideCoco[3] = s_sound_slideCoconut2
--    slideCoco[4] = s_sound_slideCoconut3
--    slideCoco[5] = s_sound_slideCoconut4
--    slideCoco[6] = s_sound_slideCoconut5
--    slideCoco[7] = s_sound_slideCoconut6

    self.ccb = {}

    self.ccb['CCB_checkInNode'] = ccbCheckInNode
    
    ccbCheckInNode['onClose'] = self.onClose
    ccbCheckInNode['onSucceedClose'] = self.onSucceedClose
    ccbCheckInNode['Layer'] = self
    
    --meaning
    ccbCheckInNode['_wordMeaing'] = self._wordMeaing
    
    --win window
    ccbCheckInNode['_meaning'] = self._meaning
    ccbCheckInNode['_pronounce'] = self._pronounce
    ccbCheckInNode['_sentence'] = self._sentence
    
    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("ccb/checkIn.ccbi", proxy, ccbCheckInNode, self.ccb)
    node:setPosition(0,0)
    self:addChild(node)

    ccbCheckInNode['_checkInBack']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(0.5 * s_DESIGN_WIDTH,0.56 * s_DESIGN_HEIGHT))))
    
    -- checkin day lasttime
    
    
    local checkInDay = s_CURRENT_USER.dailyCheckInData.dailyCheckInAwards
    
    if  checkInDay == nil then
      checkInDay = 0
    elseif checkInDay == 7 then
      checkInDay = 0
    end
    
    checkInDay = checkInDay + 1
    
--    checkInDay = s_CURRENT_USER.dailyCheckInData.
    

    
    
    
    --checkinword @ chaochao
    
    -- whether currentWord == nil
    if currentWord == nil then
    currentWord = s_DATABASE_MGR.getRandomWord()
--test
--    print("random")
    else
    --test
--    print("current")
    end
    
    
    -- example n.apple
    
    local checkInWord = currentWord
    local exampleWordMeaning = s_WordPool[checkInWord].wordMeaningSmall
    ccbCheckInNode['_wordMeaing']:setString(exampleWordMeaning)
    
    local checkInWordInAnotherWindow = checkInWord
    ccbCheckInNode['_meaning']:setString(exampleWordMeaning)
    
    --example / ’bla/
    local wordPronounce = s_WordPool[checkInWord].wordSoundMarkEn
    ccbCheckInNode['_pronounce']:setString(wordPronounce)
    
    --example an apple keep blablablalal
    local sentenceExample = s_WordPool[checkInWord].sentenceEn
    ccbCheckInNode['_sentence']:setString(sentenceExample)
    
    
    -- if s_CURRENT_USER is a new one
    -- checkinword = apple or many or tea
    -- 
    -- if s_CURRENT_USER havs any mistake
    -- checkinword = mistake
    --
    -- if s_CURRENT_USER has no mistake
    -- checkinword = all
    
    
    --checkinword @ chaochao
    
    local main_logic_mat = randomMat(4, 4)
    local randomStartIndex = math.random(1, 4*4-string.len(checkInWord)+1)
    local charaster_set_filtered = {}
    for i = 1, 26 do
        local char = string.char(96+i)
        if string.find(checkInWord, char) == nil then
            charaster_set_filtered[#charaster_set_filtered+1] = char
        end
    end
    
    
    local GridNum = 4
    local gap = 120
    local bottom = 94
    local left = (ccbCheckInNode['_checkInBack']:getContentSize().width - (GridNum-1)*gap)/2
    for i = 1, 4 do
        letterArray[i] = {}
        for j = 1, 4 do
        
            letterArray[i][j] = cc.Sprite:create("ccb/ccbResources/checkIn/checkin_letter_back.png")
            letterArray[i][j]:setAnchorPoint(0.5,0.5)
            letterArray[i][j]:ignoreAnchorPointForPosition(false)
            letterArray[i][j]:setPosition(left+gap*(i - 1) , bottom+gap*(j - 1))
            ccbCheckInNode['_checkInBack']:addChild(letterArray[i][j])
            letterArray[i][j].logicX = i
            letterArray[i][j].logicY = j
            letterArray[i][j].hasSelected = false
            
            local diff = main_logic_mat[i][j] - randomStartIndex
            if diff >= 0 and diff < string.len(checkInWord) then
                letterArray[i][j].character = string.sub(checkInWord,diff+1,diff+1)
            else
                local randomIndex = math.random(1, #charaster_set_filtered)
                letterArray[i][j].character = charaster_set_filtered[randomIndex]
            end
            
            local letter = cc.Label:createWithSystemFont(letterArray[i][j].character,"",50)
            letter:setColor(cc.c3b(0,0,0))
            letter:setPosition(letterArray[i][j]:getContentSize().width / 2,letterArray[i][j]:getContentSize().height / 2)
            letterArray[i][j]:addChild(letter,0,"character")
            
            if diff == 0 then
                local action1 = cc.ScaleTo:create(0.5,1.1)
                local action2 = cc.ScaleTo:create(0.5,1.0)
                local action3 = cc.RepeatForever:create(cc.Sequence:create(action1,action2))
                letterArray[i][j]:runAction(action3)
            end
        end
    end
    
    -- location function
    local onTouchBegan
    local onTouchMoved
    local fakeTouchMoved
    local onTouchEnded

    -- local variate
    
    local current_node_x
    local current_node_y
    local current_dir
    local onNode
    local startAtNode

    local startTouchLocation
    local lastTouchLocation

    local startNode

    local selectStack = {}
    local wordStack = {}

    local charaster_set_filtered = {}
    
    local checkTouchLocation = function(location)
        for i = 1, 4 do
            for j = 1, 4 do
                local node = letterArray[i][j]
                local node_position = cc.p(node:getPosition())
                local node_size = node:getContentSize()

                if cc.rectContainsPoint(node:getBoundingBox(), location) then
                    current_node_x = i
                    current_node_y = j
                    onNode = true
                    return
                end
            end
        end
        s_logd('notOnNode')
        onNode = false
    end
    
    local updateWord = function()
        
        for i = 1, #wordStack do
            wordStack[i]:stopAllActions()
            wordStack[i]:removeFromParent()
        end
        wordStack = {}
        
        local count = #selectStack
        local gap = 20
        local left = (ccbCheckInNode['_checkInBack']:getContentSize().width - (count-1)*gap)/2
        
        local wordBack = cc.Sprite:create("ccb/ccbResources/checkIn/checkin_wordback.png")
        wordBack:setScaleX(count * gap/wordBack:getContentSize().width + 1.0/5)
        wordBack:setPosition(ccbCheckInNode['_checkInBack']:getContentSize().width / 2,ccbCheckInNode['_checkInBack']:getContentSize().height * 0.74)
        ccbCheckInNode['_checkInBack']:addChild(wordBack)
        wordStack[1] = wordBack
        
        for i = 1, #selectStack do
            local letter = cc.Label:createWithSystemFont(selectStack[i].character,"",30)
            letter:setColor(cc.c3b(0,0,0))
            letter:setPosition(left + gap*(i - 1), 0.74*ccbCheckInNode['_checkInBack']:getContentSize().height)
            ccbCheckInNode['_checkInBack']:addChild(letter)
            wordStack[i + 1] = letter
        end
    end
    
    -- handing touch events
    onTouchBegan = function(touch, event)
        s_logd('touchBegin')
        
        if self.globalLock then
            return true
        end
        
        local location = ccbCheckInNode['_checkInBack']:convertToNodeSpace(touch:getLocation())

        startTouchLocation = location
        lastTouchLocation = location

        checkTouchLocation(location)

        if onNode then
            startNode = letterArray[current_node_x][current_node_y]
            selectStack[#selectStack+1] = startNode
            startNode:setTexture("ccb/ccbResources/checkIn/checkin_letter_deepback.png")
            local character = startNode:getChildByName("character")
            character:setPosition(startNode:getContentSize().width / 2,startNode:getContentSize().height / 2)
            startNode.hasSelected = true
            startAtNode = true
            updateWord()
            
--            -- slide coco
--            playSound(s_sound_slideCoconut)
        else
            startAtNode = false
        end
        
        return true
    end

    onTouchMoved = function(touch, event)
        s_logd('touchMove')
        
        if self.globalLock then
            return true
        end
        
        local length_gap = 3.0

        local location = ccbCheckInNode['_checkInBack']:convertToNodeSpace(touch:getLocation())

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
        
        return true
    end
    
   fakeTouchMoved = function(location)
   
        if self.globalLock then
            return
        end
        
        checkTouchLocation(location)

        if startAtNode then
            local x = location.x - startTouchLocation.x
            local y = location.y - startTouchLocation.y

            if math.abs(x) > 5 or math.abs(y) > 5 then
                startAtNode = false
            end
        else
            if onNode then
                local currentNode = letterArray[current_node_x][current_node_y]
                if currentNode.hasSelected then
                    s_logd(#selectStack)
                    if #selectStack >= 2 then
                        local stackTop = selectStack[#selectStack]
                        local secondStackTop = selectStack[#selectStack-1]
                        if currentNode.logicX == secondStackTop.logicX and currentNode.logicY == secondStackTop.logicY then
                            stackTop:setTexture("ccb/ccbResources/checkIn/checkin_letter_back.png")
                            local character = stackTop:getChildByName("character")
                            character:setPosition(stackTop:getContentSize().width / 2,stackTop:getContentSize().height / 2)
                            stackTop.hasSelected = false
                            table.remove(selectStack)
                            updateWord()
                        end
                    end
                    
--                    -- slide coco "s_sound_slideCoconut"
--                    if #selectStack <= 7 then
--                        playSound(slideCoco[#selectStack])
--                    else
--                        playSound(slideCoco[7])
--                    end
                    
                else
                    if #selectStack == 0 then
                        currentNode.hasSelected = true
                        selectStack[#selectStack+1] = currentNode
                        updateWord()
                    else
                        local stackTop = selectStack[#selectStack]
                        if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                            currentNode.hasSelected = true
                            selectStack[#selectStack+1] = currentNode
                            currentNode:setTexture("ccb/ccbResources/checkIn/checkin_letter_deepback.png")
                            local character = currentNode:getChildByName("character")
                            character:setPosition(currentNode:getContentSize().width / 2,currentNode:getContentSize().height / 2)
                            updateWord()
                        end
                    end
                end
            else

            end
        end
    end

    onTouchEnded = function(touch, event)
        s_logd('touchEnd')
        
        if self.globalLock then
            return true
        end
        
        if #selectStack < 1 then
            return
        end

        local location = ccbCheckInNode['_checkInBack']:convertToNodeSpace(touch:getLocation())

        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].character
        end


        -- checkinword @chaochao
        if selectWord == checkInWord then
        -- checkinword @chaochao
        
        --learn true
            playSound(s_sound_learn_true)
        
            self.pNode.checkIn:setVisible(false)
            
            -- add heart
            s_CURRENT_USER:addEnergys(1)
            self.globalLock = true
--            for i = 1, #selectStack do
--                local node = selectStack[i]
--                node.hasSelected = false
--            end
--            selectStack = {}
            for i = 1, 4 do
                for j = 1, 4 do
                    letterArray[i][j]:stopAllActions()
                    letterArray[i][j]:setScale(1)
                    local action1 = cc.ScaleTo:create(0.3,1.1)
                    local action2 = cc.ScaleTo:create(0.3,1.0)
                    local action3 = cc.RotateTo:create(0.0,math.random(-90,90))
                    local action4 = cc.EaseBackOut:create(cc.MoveBy:create(1.5,cc.p(0,-0.7 * s_DESIGN_HEIGHT)))
                    local action5 = cc.CallFunc:create(
                        function()
                            letterArray[i][j]:removeFromParent()    	
                        end,{}
                    )
                    letterArray[i][j]:runAction(cc.Sequence:create(action1,action2,action3,action4,action5))
                    
                end
            end
            
            local heart = cc.Sprite:create("ccb/ccbResources/checkIn/checkin_heart.png")
            heart:setPosition(ccbCheckInNode['_squareBack']:getPosition())
            heart:setVisible(false)
            ccbCheckInNode['_checkInBack']:addChild(heart,10)
            
            local ac1 = cc.ScaleTo:create(1.5,0)
            local ac2 = cc.Show:create()
            local ac3 = cc.ScaleTo:create(0.5,2)
            local ac4 = cc.JumpBy:create(0.6,cc.p((0.1 + 2.0 * (checkInDay - 1) / 15 - 0.5)*ccbCheckInNode['_totalBack']:getContentSize().width,(- 0.14 - 0.345) * ccbCheckInNode['_checkInBack']:getContentSize().height - 0.18 * ccbCheckInNode['_totalBack']:getContentSize().height),0.2,1)
            local ac5 = cc.ScaleTo:create(0.5,0.9)
            local ac6 = cc.EaseBackOut:create(cc.ScaleTo:create(0.3,1.2))
            local ac7 = cc.ScaleTo:create(0.4,0.9)
            local ac8 = cc.CallFunc:create(
                function()
                    ccbCheckInNode['_checkInBack']:runAction(cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(0,s_DESIGN_HEIGHT))))
                    ccbCheckInNode['_succeedBack']:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseBackOut:create(cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT)))))
                end,{}
            )
            heart:runAction(cc.Sequence:create(ac1,ac2,ac3,cc.Spawn:create(ac4,ac5),ac6,ac7,ac8))
        else
           --learn false
            playSound(s_sound_learn_false)

            for i = 1, #selectStack do
                local node = selectStack[i]
                node.hasSelected = false
                node:setTexture("ccb/ccbResources/checkIn/checkin_letter_back.png")
                local character = node:getChildByName("character")
                character:setPosition(node:getContentSize().width / 2,node:getContentSize().height / 2)
            end
            selectStack = {}
            for i = 1, #wordStack do
                wordStack[i]:runAction(cc.Repeat:create(cc.Sequence:create(cc.MoveBy:create(0.01,cc.p(10,0)),cc.MoveBy:create(0.02,cc.p(-20,0)),cc.MoveBy:create(0.01,cc.p(10,0))),14))
            end

        end
        return true
    end
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    
end

function CheckInNode:onClose()
    if self.globalLock then
        for i = 1,4 do
            for j = 1,4 do
                letterArray[i][j]:removeFromParent()
            end
        end
    end
    local moveOut = cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(0,s_DESIGN_HEIGHT))) 
    local remove = cc.CallFunc:create(function()
        s_SCENE:removeAllPopups()
    end
    ,{})
    ccbCheckInNode['_checkInBack']:runAction(cc.Sequence:create(moveOut,remove))
    
    -- button sound
    playSound(s_sound_buttonEffect)
    
    --control volune
    if s_DATABASE_MGR.isMusicOn() then
      cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5)
    end
end

function CheckInNode:onSucceedClose()
    local moveOut = cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(0,s_DESIGN_HEIGHT))) 
    local remove = cc.CallFunc:create(function()
        s_SCENE:removeAllPopups()
    end
    ,{})
    ccbCheckInNode['_succeedBack']:runAction(cc.Sequence:create(moveOut,remove))
    
    -- button sound
    playSound(s_sound_buttonEffect)
    
    --control volune
    if s_DATABASE_MGR.isMusicOn() then
       cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5)
    end

    -- after success write down time right now
    --   local lastCheckInAward = s_CURRENT_USER.serverTime
    local lastCheckInAward = 1
    s_UserBaseServer.saveDailyCheckInOfCurrentUser(lastCheckInAward, true, false) 
--    lastCheckInAward = s_CURRENT_USER.dailyCheckInData.dailyCheckInAwards
--    is2TimeInSameDay(secondsA, secondsB) 

    currentWord = nil
end

return CheckInNode
