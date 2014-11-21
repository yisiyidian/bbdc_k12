local  PopupEnergyBuy = class("PopupEnergyBuy", function()
    return cc.Layer:create()
end)


function PopupEnergyBuy.create()
    local layer = PopupEnergyBuy.new()
    return layer
end



function PopupEnergyBuy:ctor()
 --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    
    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.25) 
    
    self.energy_number =  s_CURRENT_USER.energyCount 
    
    local json = ''
    local atlas = ''
    self.ccbPopupEnergyBuy = {}

    self.ccbPopupEnergyBuy['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPopupEnergyBuy['onBuyButtonClicked'] = function()
        self:onBuyButtonClicked()
    end

    self.ccb = {} 
    self.ccb['rightTopNode_Buy'] = self.ccbPopupEnergyBuy
    self.ccb['title'] = self.ccbPopupEnergyBuy_title
    self.ccb['subtitle'] = self.ccbPopupEnergyBuy_subtitle
    self.ccb['subsubtitle'] = self.ccbPopupEnergyBuy_subsubtitle
    self.ccb['energyNumber'] = self.ccbPopupEnergyBuy_energyNumber
    self.ccb['closeButton'] = self.ccbPopupEnergyBuy_closeButton
    self.ccb['buyButton'] = self.ccbPopupEnergyBuy_buyButton
    self.ccb['popupWindow'] = self.ccbPopupEnergyBuy_popupWindow
    self.ccb['energy_number'] =  s_CURRENT_USER.energyCount 





    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/righttopnode_buy.ccbi', proxy, self.ccbPopupEnergyBuy, self.ccb)
      self.ccbPopupEnergyBuy['title']:setString('购买贝贝体力！')
      self.ccbPopupEnergyBuy['subtitle']:setString('体力会用在挑战新关卡处')
    self.ccbPopupEnergyBuy['subsubtitle']:setString('每30分钟回复一点')
    self.ccbPopupEnergyBuy['energyNumber']:setString('+30')
    self.ccbPopupEnergyBuy['energyNumber']:setScale(2)
    node:setPosition(0,600)
    self:addChild(node)

    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    local label_buyEnergy = cc.Label:createWithSystemFont("￥6.00","",36)
    label_buyEnergy:setPosition(0.5 * self.ccbPopupEnergyBuy['buyButton']:getContentSize().width ,0.5 * self.ccbPopupEnergyBuy['buyButton']:getContentSize().height)
    self.ccbPopupEnergyBuy['buyButton']:addChild(label_buyEnergy)
    
    if self.energy_number >= s_energyMaxCount then
        json = 'spine/energy/tilizhi_full.json'
        atlas = 'spine/energy/tilizhi_full.atlas'
    elseif self.energy_number > 0 then
        json = 'spine/energy/tilizhi_recovery.json' 
        atlas = 'spine/energy/tilizhi_recovery.atlas'
    else
        json = 'spine/energy/tilizhi_no.json'
        atlas = 'spine/energy/tilizhi_no.atlas'
    end

    local heart = sp.SkeletonAnimation:create(json,atlas, 1)
    heart:setAnimation(0,'animation',true)
    heart:ignoreAnchorPointForPosition(false)
    heart:setAnchorPoint(0.5,0.5)
    heart:setName("heart_animation")
    heart:setPosition(0.5 * self.ccbPopupEnergyBuy['popupWindow']:getContentSize().width ,0.5 * self.ccbPopupEnergyBuy['popupWindow']:getContentSize().height  + 30)
    self.ccbPopupEnergyBuy['popupWindow']:addChild(heart) 
    

    local   label_energyNumber = cc.Label:createWithSystemFont(s_CURRENT_USER.energyCount,"",36)
    label_energyNumber:setColor(cc.c4b(255,255,255 ,255))
    label_energyNumber:setPosition(0.5 * heart:getContentSize().width ,0.5 * heart:getContentSize().height )
    label_energyNumber:setName("energyNumber")
    heart:addChild(label_energyNumber,1)



    local function update(delta)
    -- update timer
        local time_betweenServerAndEnergy = s_CURRENT_USER.energyLastCoolDownTime + s_energyCoolDownSecs - s_CURRENT_USER.serverTime
        local min = math.floor(time_betweenServerAndEnergy / 60)
        local sec = math.floor(time_betweenServerAndEnergy % 60)        
           
        if s_CURRENT_USER.energyCount >= s_energyMaxCount then 
            if json == 'spine/energy/tilizhi_recovery.json'  or json == 'spine/energy/tilizhi_no.json' then
                local change = self.ccbPopupEnergyBuy['popupWindow']:removeChildByName("heart_animation")   
                json = 'spine/energy/tilizhi_full.json'
                atlas = 'spine/energy/tilizhi_full.atlas'
                local replace = sp.SkeletonAnimation:create(json,atlas, 1)
                replace:setAnimation(0,'animation',true)
                replace:ignoreAnchorPointForPosition(false)
                replace:setAnchorPoint(0.5,0.5)
                replace:setPosition(0.5 * self.ccbPopupEnergyBuy['popupWindow']:getContentSize().width ,0.5 * self.ccbPopupEnergyBuy['popupWindow']:getContentSize().height  + 30)
                replace:setName("heart_animation")
                self.ccbPopupEnergyBuy['popupWindow']:addChild(replace)  
            end
            local animation = self.ccbPopupEnergyBuy['popupWindow']:getChildByName("heart_animation")
            local label = animation:getChildByName("energyNumber")
            if label ~= nil then
                label:setString("")
            end   

            
       elseif s_CURRENT_USER.energyCount > 0 then       
            --heartnumber
            label_energyNumber:setString(s_CURRENT_USER.energyCount ) 
                 
            if json == 'spine/energy/tilizhi_no.json' then
                local change = self.ccbPopupEnergyBuy['popupWindow']:removeChildByName("heart_animation")   
                json = 'spine/energy/tilizhi_recovery.json'
                atlas = 'spine/energy/tilizhi_recovery.atlas'
                local replace = sp.SkeletonAnimation:create(json,atlas, 1)
                replace:setAnimation(0,'animation',true)
                replace:ignoreAnchorPointForPosition(false)
                replace:setAnchorPoint(0.5,0.5)
                replace:setPosition(0.5 * self.ccbPopupEnergyBuy['popupWindow']:getContentSize().width ,0.5 * self.ccbPopupEnergyBuy['popupWindow']:getContentSize().height  + 30)
                replace:setName("heart_animation")
                self.ccbPopupEnergyBuy['popupWindow']:addChild(replace)  
            end
        else
            local animation = self.ccbPopupEnergyBuy['popupWindow']:getChildByName("heart_animation")
            local label = animation:getChildByName("energyNumber")
            if label ~= nil then
                label:setString("")
            end   
        
        end
     end           


    self:scheduleUpdateWithPriorityLua(update, 0) 

end



function PopupEnergyBuy:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
    
    -- button sound
    playSound(s_sound_buttonEffect)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
end

function PopupEnergyBuy:onBuyButtonClicked()
    s_logd('on buy button clicked')
    s_SCENE:removeAllPopups()
    
    -- button sound
    local energyCountBought = 10
    playSound(s_sound_buttonEffect)
    local function onBuyResult( code, msg, info )
        print('store onBuyResult: ' .. tostring(code) .. ', ' .. msg)
        if code == 0 then
            s_CURRENT_USER.energyCount = s_CURRENT_USER.energyCount + energyCountBought
            s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)
            s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER,
                function(api,result)
                    s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)
                    local str = string.format(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_BOUGHT_ENERGY), energyCountBought)
                    s_TIPS_LAYER:showSmall(str)
                    s_LOADING_CIRCLE_LAYER:hide()
                end,
                function(api, code, message, description)
                    s_TIPS_LAYER:showSmall(message)
                    s_LOADING_CIRCLE_LAYER:hide()
                end) 
        else
            s_TIPS_LAYER:showSmall(tostring(code) .. ', ' .. msg)
            s_LOADING_CIRCLE_LAYER:hide()
        end
    end
    
    s_LOADING_CIRCLE_LAYER:show()
    s_STORE.buy(onBuyResult)
end

return PopupEnergyBuy
