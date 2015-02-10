local LoginRewardPopup = class ("LoginRewardPopup",function ()
    return cc.Layer:create()
end)

function LoginRewardPopup.create()
    local layer = LoginRewardPopup.new()
    return layer
end

local function numberToSprite(number)
    if number >= 1 and number <= 5 then
        local shadow_sprite = cc.Sprite:create("image/loginreward/back"..number..".png")
        for i = 1,number do
            local bean_sprite = cc.Sprite:create("image/loginreward/bean.png")
            bean_sprite:setPosition(shadow_sprite:getContentSize().width * (0.5 - 0.08 * (number - 1) + (i - 1) * 0.16),shadow_sprite:getContentSize().height + 10 )
            shadow_sprite:addChild(bean_sprite)
        end 
        return shadow_sprite
	elseif number == 6 then
        local shadow_sprite = cc.Sprite:create("image/loginreward/back"..number..".png")
        shadow_sprite:setScale(0.8)
        local bean_sprite = cc.Sprite:create("image/loginreward/many.png")
        bean_sprite:setPosition(shadow_sprite:getContentSize().width * 0.5,shadow_sprite:getContentSize().height + 20)
        shadow_sprite:addChild(bean_sprite)  
        return shadow_sprite
    elseif number == 7 then
        local shadow_sprite = cc.Sprite:create("image/loginreward/back"..number..".png")
        shadow_sprite:setScale(0.8)
        local bean_sprite = cc.Sprite:create("image/loginreward/more.png")
        bean_sprite:setPosition(shadow_sprite:getContentSize().width * 0.5,shadow_sprite:getContentSize().height + 25)
        shadow_sprite:addChild(bean_sprite)
        return shadow_sprite
	end
end

function LoginRewardPopup:ctor()

    local rewardList = s_DataManager.bean

	local backPopup = cc.Sprite:create("image/loginreward/backPopup.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backPopup)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end

    local button_close = ccui.Button:create("image/friend/close.png","","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(backPopup:getContentSize().width - 20 , backPopup:getContentSize().height - 20 )
    button_close:addTouchEventListener(button_close_clicked)
    backPopup:addChild(button_close)
    
    local title_sprite = cc.Sprite:create("image/loginreward/reward.png")
    title_sprite:setPosition(backPopup:getContentSize().width / 2 , backPopup:getContentSize().height * 0.92 )
    backPopup:addChild(title_sprite)
    
    local label_sprite = cc.Sprite:create("image/loginreward/label.png")
    label_sprite:setPosition(backPopup:getContentSize().width / 2 , backPopup:getContentSize().height * 0.75 )
    backPopup:addChild(label_sprite)
    
    for x = 0,2 do
        for y = 0,2 do
            local addColor = cc.LayerColor:create(cc.c4b(0,0,0,0),158,135)
            addColor:setPosition(66 + x * 164,101 + y * 142)          
            addColor:setAnchorPoint(0,0)
            addColor:ignoreAnchorPointForPosition(true)
            backPopup:addChild(addColor)
            local  tag = 6 +  x - 3 * y
            if  tag == 0 then
                local beibei_sprite = cc.Sprite:create("image/loginreward/beibei.png")
                beibei_sprite:setPosition(addColor:getContentSize().width * 0.5,addColor:getContentSize().height * 0.5)
                addColor:addChild(beibei_sprite)
            elseif tag >= 1 and tag <= 5 then
                local shadow_sprite = numberToSprite(tonumber(rewardList[tag].reward))
                shadow_sprite:setPosition(addColor:getContentSize().width * 0.5,addColor:getContentSize().height * 0.25)
                addColor:addChild(shadow_sprite)
            elseif tag == 6  then
                local shadow_sprite = numberToSprite(tonumber(rewardList[tag].reward))
                shadow_sprite:setPosition(addColor:getContentSize().width * 0.5,addColor:getContentSize().height * 0.3)
                addColor:addChild(shadow_sprite) 
            elseif tag == 7  then
                local shadow_sprite = numberToSprite(tonumber(rewardList[tag].reward))
                shadow_sprite:setPosition(addColor:getContentSize().width * 0.5,addColor:getContentSize().height * 0.3)
                addColor:addChild(shadow_sprite) 
--                local reward_label = cc.Label:createWithSystemFont("+30","",25)
--                reward_label:setColor(cc.c4b(212,129,86,255))
--                reward_label:setPosition(addColor:getContentSize().width * 0.8,addColor:getContentSize().height * 0.12)
--                reward_label:setRotation(10)
--                addColor:addChild(reward_label)
            elseif tag == 8  then
                local up_sprite = cc.Sprite:create("image/loginreward/up.png")
                up_sprite:setPosition(addColor:getContentSize().width * 0.5 ,addColor:getContentSize().height * 0.5 )
                addColor:addChild(up_sprite)   
            end
        end
    end
    
    for x = 0,2 do
        for y = 0,2 do
           local addColor = cc.LayerColor:create(cc.c4b(0,0,0,80),158,135)
           addColor:setPosition(66 + x * 165,101 + y * 142)          
           addColor:setAnchorPoint(0,0)
           addColor:ignoreAnchorPointForPosition(true)
           backPopup:addChild(addColor)
           local tag = 6 +  x - 3 * y
           if tag >= 1 and tag <=7 and tag ~= 6 then
              addColor:setName("reward"..tag)
           end
           addColor:setVisible(false)
        end
    end
    
    local tag = 6
    local addColor6 = cc.Sprite:create("image/loginreward/tagsix.png")
    addColor6:setPosition(67 ,98 ) 
    addColor6:setAnchorPoint(0,0)
    addColor6:ignoreAnchorPointForPosition(true)
    backPopup:addChild(addColor6)
    addColor6:setName("reward"..tag)
    addColor6:setVisible(false)
    
     local loginData = s_CURRENT_USER.logInDatas
     local loginData_array = {}
     for i = 1,#loginData do
         loginData_array[i] = loginData[i]:getDays()
     end
     local dayInWeekBegin = 0
     for i = 1,7 do
         if loginData_array[1][i] > 0 then
             day = i
             break
         end
     end
     local currentData = {}
     local currentTime = os.time()
     local today = math.floor((currentTime - s_CURRENT_USER.localTime) / ( 24 * 60 * 60 ) ) % 7
     local dayInWeekEnd = dayInWeekBegin + today

     local currentWeek = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]

     currentWeek:getReward(os.time())
     if dayInWeekEnd <= 7 then
        for i = dayInWeekBegin,dayInWeekEnd do
            table.insert(currentData,currentWeek:isGotReward(os.time() - (dayInWeekEnd - dayInWeekBegin + i - dayInWeekBegin) * dayTime))
        end
     else
        local lastWeek = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas - 1]
        for i = 8,dayInWeekEnd do
            if lastWeek == nil then
               table.insert(currentData,false)
            else
               table.insert(currentData,lastWeek:isGotReward(os.time() - (dayInWeekEnd - dayInWeekBegin + i - 8) * dayTime))
            end     
        end
        for i = 1,dayInWeekBegin do
            table.insert(currentData,currentWeek:isGotReward(os.time() - (i - dayInWeekBegin) * dayTime))
        end
     end
     
    local dayTime = 24 * 60 * 60


    local lastTime = s_CURRENT_USER.getDailyRewardTime
    local todayMark = 0
    if math.floor((currentTime - s_CURRENT_USER.getDailyRewardTime) / ( 24 * 60 * 60 )) >= 1 then
       todayMark = 0
    else
       todayMark = 1
    end
    for i = 1,#currentData do
        local sprite = backPopup:getChildByName("reward"..i)
        local mark = cc.Sprite:create("image/loginreward/mark.png")
        mark:setPosition(sprite:getContentSize().width * 0.7,sprite:getContentSize().height * 0.3)
        mark:setScale(0.8)
        sprite:addChild(mark)
        if i < #currentData then
            if currentData[i] == false  then
                mark:setTexture("image/loginreward/miss.png")
            end  
            sprite:setVisible(true)
        else
            if todayMark > 0  then
                sprite:setVisible(true)
            end  
        end
    end
    
    local onTouchBegan = function(touch, event)
        return true  
    end 

    local sprite = backPopup:getChildByName("reward"..(today + 1))
    local onTouchEnded = function(touch, event)
        if todayMark == 0 and sprite ~= nil then
            local location = backPopup:convertToNodeSpace(touch:getLocation())
            if cc.rectContainsPoint(sprite:getBoundingBox(), location)  then
                s_CURRENT_USER:addBeans(rewardList[#currentData].reward)  
                saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                sprite:setVisible(true) 
                s_CURRENT_USER.getDailyRewardTime = currentTime 
                saveUserToServer({['getDailyRewardTime'] = s_CURRENT_USER.getDailyRewardTime})

                todayMark = 1   
            end
        end
    end
    

    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = backPopup:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backPopup)  
    
end

return LoginRewardPopup