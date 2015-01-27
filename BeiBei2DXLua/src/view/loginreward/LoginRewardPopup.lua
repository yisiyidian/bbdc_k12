local LoginRewardPopup = class ("LoginRewardPopup",function ()
    return cc.Layer:create()
end)

function LoginRewardPopup.create()
    local layer = LoginRewardPopup.new()
    return layer
end

function LoginRewardPopup:ctor()

	local backPopup = cc.Sprite:create("image/loginreward/backPopup.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backPopup)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
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
                local shadow_sprite = cc.Sprite:create("image/loginreward/back"..tag..".png")
                shadow_sprite:setPosition(addColor:getContentSize().width * 0.5,addColor:getContentSize().height * 0.25)
                addColor:addChild(shadow_sprite)
                for i = 1,tag do
                    local bean_sprite = cc.Sprite:create("image/loginreward/bean.png")
                    bean_sprite:setPosition(shadow_sprite:getContentSize().width * (0.5 - 0.08 * (tag - 1) + (i - 1) * 0.16),shadow_sprite:getContentSize().height + 10 )
                    shadow_sprite:addChild(bean_sprite)
                end  
            elseif tag == 6  then
                local shadow_sprite = cc.Sprite:create("image/loginreward/back"..tag..".png")
                shadow_sprite:setPosition(addColor:getContentSize().width * 0.5,addColor:getContentSize().height * 0.15)
                addColor:addChild(shadow_sprite)
                local bean_sprite = cc.Sprite:create("image/loginreward/many.png")
                bean_sprite:setPosition(shadow_sprite:getContentSize().width * 0.5,shadow_sprite:getContentSize().height + 20 )
                shadow_sprite:addChild(bean_sprite)  
            elseif tag == 7  then
                local shadow_sprite = cc.Sprite:create("image/loginreward/back"..tag..".png")
                shadow_sprite:setPosition(addColor:getContentSize().width * 0.50,addColor:getContentSize().height * 0.1)
                addColor:addChild(shadow_sprite)
                local bean_sprite = cc.Sprite:create("image/loginreward/more.png")
                bean_sprite:setPosition(shadow_sprite:getContentSize().width * 0.5,shadow_sprite:getContentSize().height + 25 )
                shadow_sprite:addChild(bean_sprite)
            elseif tag == 8  then
                local up_sprite = cc.Sprite:create("image/loginreward/up.png")
                up_sprite:setPosition(addColor:getContentSize().width * 0.5 ,addColor:getContentSize().height * 0.5 )
                addColor:addChild(up_sprite)   
            end
        end
    end
    
    for x = 0,2 do
        for y = 0,2 do
           local addColor = cc.LayerColor:create(cc.c4b(0,0,0,125),158,135)
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
    
    local addColor6 = cc.Sprite:create("image/loginreward/tagsix.png")
    addColor6:setPosition(67 ,98 ) 
    addColor6:setAnchorPoint(0,0)
    addColor6:ignoreAnchorPointForPosition(true)
    backPopup:addChild(addColor6)
    addColor6:setName("reward6")
    addColor6:setVisible(false)
    
    for i = 1,7 do
       local sprite = backPopup:getChildByName("reward"..i)
       sprite:setVisible(true)
       local mark = cc.Sprite:create("image/loginreward/mark.png")
       mark:setPosition(sprite:getContentSize().width * 0.7,sprite:getContentSize().height * 0.3)
       mark:setScale(0.8)
       sprite:addChild(mark)
       if i % 2 == 0 then
          mark:setTexture("image/loginreward/miss.png")
       end
    end
    
    
    
    
end

return LoginRewardPopup