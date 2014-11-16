local  PopupEnergyBuy = class("PopupEnergyBuy", function()
    return cc.Layer:create()
end)


function PopupEnergyBuy.create()
    local layer = PopupEnergyBuy.new()
    return layer
end

local label_energyNumber

function PopupEnergyBuy:ctor()
 --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
 
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
    
    if self.energy_number >= 4 then
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
    



    local function update(delta)
    
    local time_betweenServerAndEnergy = s_CURRENT_USER.serverTime - s_CURRENT_USER.energyLastCoolDownTime
    local min = time_betweenServerAndEnergy / 60
    local sec = time_betweenServerAndEnergy % 60          
           
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
            self.ccbPopupEnergyBuy['energyNumber']:setString("full") 
            
       elseif s_CURRENT_USER.energyCount > 0 then       
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
            
        end
     end           


    self:scheduleUpdateWithPriorityLua(update, 0) 

    if s_CURRENT_USER.energyCount > 0 and s_CURRENT_USER.energyCount < 4 then
        label_energyNumber = cc.Label:createWithSystemFont(s_CURRENT_USER.energyCount,"",36)
        label_energyNumber:setColor(cc.c4b(255,255,255 ,255))
        label_energyNumber:setPosition(0.5 * heart:getContentSize().width ,0.5 * heart:getContentSize().height )
        label_energyNumber:setName("energyNumber")
        heart:addChild(label_energyNumber,1)
        --      print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    end
end



function PopupEnergyBuy:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupEnergyBuy:onBuyButtonClicked()
    s_logd('on buy button clicked')
end

return PopupEnergyBuy