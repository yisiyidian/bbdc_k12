

local RightTopNode = class("RightTopNode", function()
    return cc.Layer:create()
end)

function RightTopNode.create()
    local layer = RightTopNode.new()

    return layer
end

local introLayer_star
local introLayer_heart
local heartNumber 
local starNumber
local time_betweenServerAndEnergy

function RightTopNode:ctor()
    heartNumber = s_CURRENT_USER.energyCount 

    starNumber = s_CURRENT_USER:getUserCurrentChapterObtainedStarCount()
    --test
    

    local heartShow = ""
 --   starNumber = 1


       
    -- heart info     
--    local IntroLayer = require("popup/PopupEnergyInfo")
--    local introLayer = IntroLayer.create()  


    local click_star = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local IntroLayer = require("popup/PopupStarInfo")
            introLayer_star = IntroLayer.create()  
            s_SCENE:popup(introLayer_star)
            

        end
    end

    local click_heart = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- click
            
            local IntroLayer = require("popup/PopupEnergyInfo")
            introLayer_heart = IntroLayer.create()  
            s_SCENE:popup(introLayer_heart)
            

        end 
    end

    local click_word = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then    

        end
    end


    local star = ccui.Button:create("image/chapter_level/starEnergyLong.png", "image/chapter_level/starEnergyLong.png", "")
    star:addTouchEventListener(click_star)
    star:ignoreAnchorPointForPosition(false)
    star:setAnchorPoint(1,0.5)
    star:setPosition(s_RIGHT_X - 10 , s_DESIGN_HEIGHT - 150 )
    star:setLocalZOrder(1)
    self:addChild(star)

    local star_back = cc.Sprite:create("image/chapter_level/starBack.png")
    star_back:setPosition(132,42)
    star_back:setLocalZOrder(-1)
    star:addChild(star_back)

    local heart = ccui.Button:create("image/chapter_level/energyHeartLong.png", "image/chapter_level/energyHeartLong.png", "")
    heart:addTouchEventListener(click_heart)
    heart:ignoreAnchorPointForPosition(false)
    heart:setAnchorPoint(1,0.5)
    heart:setPosition(s_RIGHT_X   , s_DESIGN_HEIGHT - 70 )
    heart:setLocalZOrder(1)
    self:addChild(heart)

    local heartExist = cc.Label:createWithSystemFont(heartNumber,"",36)
    heartExist:setPosition(75,38)
    heart:addChild(heartExist)

    local  heart_back = cc.Sprite:create("image/chapter_level/heartBack.png")
    heart_back:setPosition(145,36)
    heart_back:setLocalZOrder(-1)
    heart:addChild(heart_back)

    local wordAday = ccui.Button:create("image/chapter_level/wsy_meiriyici.png", "image/chapter_level/wsy_meiriyici.png", "") 
    wordAday:addTouchEventListener(click_word)
    wordAday:ignoreAnchorPointForPosition(false)
    wordAday:setAnchorPoint(1,0.5)
    wordAday:setPosition(s_RIGHT_X - 15 , s_DESIGN_HEIGHT - 230 )
    wordAday:setLocalZOrder(1)
    wordAday:setScale(0.5);
    self:addChild(wordAday)

    local wordAday_back = cc.Sprite:create("image/chapter_level/checkInGlow.png")
    wordAday_back:setPosition(0.5 * wordAday:getContentSize().width,0.5 * wordAday:getContentSize().height)
    --    wordAday_back:ignoreAnchorPointForPosition(false)
    --    wordAday_back:setAnchorPoint(1,0.5)
    wordAday_back:setScale(0.5);
    wordAday:addChild(wordAday_back,-1)


    local fade_in = cc.FadeIn:create(0.5) 
    local fade_out = cc.FadeOut:create(0.5)
    local action = cc.Sequence:create(fade_in,fade_out)
    wordAday_back:runAction(cc.RepeatForever:create(action))




    local label_heart = cc.Label:createWithSystemFont(heartShow,"",36)
    label_heart:ignoreAnchorPointForPosition(false)
    label_heart:setAnchorPoint(0.5,0.5)
    label_heart:setColor(cc.c4b(255 , 255, 255 ,255))
    label_heart:setPosition(100 , 30 )
    label_heart:setLocalZOrder(1)
    heart_back:addChild(label_heart)


    local label_star = cc.Label:createWithSystemFont(starNumber,"",36)
    label_star:ignoreAnchorPointForPosition(false)
    label_star:setAnchorPoint(0.5,0.5)
    label_star:setColor(cc.c4b(255 , 255, 255 ,255))
    label_star:setPosition(95,30)
    label_star:setLocalZOrder(1)
    star_back:addChild(label_star)
  
--    s_CURRENT_USER.addEnergys(10)



    
    local function update(delta)
    
        local time_betweenServerAndEnergy = s_CURRENT_USER.energyLastCoolDownTime + s_energyCoolDownSecs - s_CURRENT_USER.serverTime
        local min = math.floor(time_betweenServerAndEnergy / 60)
        local sec = math.floor(time_betweenServerAndEnergy % 60)
        
        if s_CURRENT_USER.energyCount >= s_energyMaxCount then
           heartShow = "full"
        else     
            heartShow = string.format("%d",min) ..":"..string.format("%d",sec)   

        end           
        heartExist:setString(s_CURRENT_USER.energyCount)  
        label_heart:setString(heartShow)
        label_star:setString(starNumber)
       -- update data  

--       --show full or time
--        if introLayer_heart ~= nil then
--            if introLayer_heart.ccbPopupEnergyInfo ~= nil then
--            introLayer_heart.ccbPopupEnergyInfo['energyNumber']:setString(heartShow)
--            local animation = introLayer_heart.ccbPopupEnergyInfo['popupWindow']:getChildByName("heart_animation")
--            local label = animation:getChildByName("energyNumber")
--            if label ~= nil then
--            label:setString(heartNumber)
--            end
--            end     
--        end
        

         
--       --show number
--          introLayer.ccbPopupEnergyInfo['energy_number'] = heartNumber
--          local animation = introLayer.ccbPopupEnergyInfo['popupWindow']:getChildByName("heart_animation")
--         local label = animation:getChildByName("energyNumber")
--         label:setString(heartShow)
            
           


    end


    self:scheduleUpdateWithPriorityLua(update, 0)  
    
    
    --    -- popupwindow
    --    layer.ccb = {}
    --    ccbPopupWindow['close'] = layer.close
    --    ccbPopupWindow['count'] = layer.count
    --    ccbPopupWindow['total'] = layer.total
    --    ccbPopupWindow['collect'] = layer.collect
    --    ccbPopupWindow['onClose'] = layer.onClose
    ----  ccbPause['Layer'] = self
    --
    --    
    --    layer.ccb['star'] = ccbPopupWindow
    --    
    --    local proxy = cc.CCBProxy:create()    
    --    local node  = CCBReaderLoad("ccb/righttopnode.ccbi", proxy, ccbPopupWindow, layer.ccb)
    --    layer:addChild(node)
    --  
end

return RightTopNode