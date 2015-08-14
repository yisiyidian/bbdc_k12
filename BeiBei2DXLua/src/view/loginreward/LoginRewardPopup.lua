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

    AnalyticsLoginReward()

    local rewardList = s_DataManager.bean

	local backPopup = cc.Sprite:create("image/loginreward/backPopup.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 * 3)
    self:addChild(backPopup)

    backPopup:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 0.5))))

    local function closeAnimation()
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
        local remove = cc.CallFunc:create(function() 
             s_SCENE:removeAllPopups()
        end)
        backPopup:runAction(cc.Sequence:create(move,remove))
    end

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            closeAnimation()
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
     local dayInWeekBegin = 0
     local firstWeek = s_CURRENT_USER.logInDatas[1] 
     
     if firstWeek.Monday > 0 then
        dayInWeekBegin = 1
     elseif firstWeek.Tuesday > 0 then
        dayInWeekBegin = 2
     elseif firstWeek.Wednesday > 0 then
        dayInWeekBegin = 3
     elseif firstWeek.Thursday > 0 then
        dayInWeekBegin = 4
     elseif firstWeek.Friday > 0 then
        dayInWeekBegin = 5
     elseif firstWeek.Saturday > 0 then
        dayInWeekBegin = 6
     elseif firstWeek.Sunday > 0 then
        dayInWeekBegin = 7
     end

     local currentData = {}
     if #currentData > 0 then
        currentData = {}
     end
     local currentTime = os.time()
     local today = math.floor((currentTime - s_CURRENT_USER.localTime) / ( 24 * 60 * 60 ) ) % 7
     local dayInWeekEnd = dayInWeekBegin + today
     
     local currentWeek = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
     -- print("~~~~~~~~~~~")
     -- print_lua_table(currentWeek)
     -- print("~~~~~~~~~~~")
     local dayTime = 24 * 60 * 60
     if dayInWeekEnd <= 7 then
        for i = dayInWeekBegin,dayInWeekEnd do
            table.insert(currentData,currentWeek:isGotReward(os.time() + (dayInWeekBegin - dayInWeekEnd + i - dayInWeekBegin) * dayTime))
        end
     else
        local last = (#s_CURRENT_USER.logInDatas) - 1
        local lastWeek = s_CURRENT_USER.logInDatas[last]
        for i = dayInWeekBegin,7 do
            if lastWeek == nil then
                table.insert(currentData,false)
            else
                table.insert(currentData,lastWeek:isGotReward(os.time() + (dayInWeekBegin - dayInWeekEnd + i - dayInWeekBegin) * dayTime))
            end     
        end
        for i = 1,dayInWeekEnd - 7 do
            table.insert(currentData,currentWeek:isGotReward(os.time() - (dayInWeekEnd - 7 - i) * dayTime)) 
        end
     end

     -- print("~~~~~~~~~~~")
     -- print_lua_table(currentData)
     -- print("~~~~~~~~~~~")


    local todayMark = 0

    if currentData[#currentData] == false then
       todayMark = 0
    else
       todayMark = 1
    end

    for i = 1,#currentData do
        local sprite = backPopup:getChildByName("reward"..i)
        local mark = cc.Sprite:create("image/loginreward/mark.png")
        mark:setPosition(sprite:getContentSize().width * 0.7,sprite:getContentSize().height * 0.3)
        mark:setScale(0.8)
        if i < #currentData then
            if currentData[i] == false  then
                mark:setTexture("image/loginreward/miss.png")
            end  
            sprite:setVisible(true)
            sprite:addChild(mark)
        else
            if todayMark > 0  then
                sprite:setVisible(true)
                sprite:addChild(mark)
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
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                s_CURRENT_USER:addBeans(rewardList[#currentData].reward)  
                saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                sprite:setVisible(true) 
                
                local spine = sp.SkeletonAnimation:create('spine/duigou.json', 'spine/duigou.atlas',1)
                local action = cc.DelayTime:create(0.3)
                spine:runAction(cc.Sequence:create(action,cc.CallFunc:create(function()spine:addAnimation(0, 'animation', false)
                    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                    end)))
                spine:setPosition(50,0)
                sprite:addChild(spine)
                spine:setScale(0.8)
                currentWeek:getReward(os.time())
                getRewardEverydayInfo()
                todayMark = 1   
            end
        end
        
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(backPopup:getBoundingBox(),location) then
              closeAnimation()
        end
    end
    

    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)  

    onAndroidKeyPressed(self, function ()
        closeAnimation()
    end, function ()

    end)

    -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
    --     print("WWWWWXXXXXX")
    --     cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.html?time=0&wordlist=apple', '我完成这些单词只用了秒，你能做到吗？', '贝贝单词－根本停不下来')
    --     print("WWWWWXXXXXX")
    -- end
    
end

return LoginRewardPopup