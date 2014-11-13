local  PopupEnergyInfo = class("PopupEnergyInfo", function()
    return cc.Layer:create()
end)


function PopupEnergyInfo.create()
    local layer = PopupEnergyInfo.new()
    return layer
end

local number

function PopupEnergyInfo:ctor()

    self.energy_number = 3

    
    local json = ''
    local atlas = ''
    local min = 29
    local sec = 59
  --  print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
     self.ccbPopupEnergyInfo = {}
        
    self.ccbPopupEnergyInfo['onCloseButtonClicked'] = function()
         self:onCloseButtonClicked()
     end
     
    self.ccbPopupEnergyInfo['onBuyButtonClicked'] = function()
        self:onBuyButtonClicked()
     end

    self.ccb = {} 
    self.ccb['rightTopNode_Heart'] = self.ccbPopupEnergyInfo
    self.ccb['title'] = self.ccbPopupEnergyInfo_title
    self.ccb['subtitle'] = self.ccbPopupEnergyInfo_subtitle
    -- full or xx:xx
    self.ccb['energyNumber'] = self.ccbPopupEnergyInfo_energyNumber
    self.ccb['closeButton'] = self.ccbPopupEnergyInfo_closeButton
    self.ccb['buyButton'] = self.ccbPopupEnergyInfo_buyButton
    self.ccb['popupWindow'] = self.ccbPopupEnergyInfo_popupWindow

    self.ccb['energy_number'] = 3

    
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/righttopnode_heart.ccbi', proxy, self.ccbPopupEnergyInfo, self.ccb)
    self.ccbPopupEnergyInfo['title']:setString('贝贝的体力正在恢复！')
    self.ccbPopupEnergyInfo['subtitle']:setString('复习以前的关卡不耗费体力')
    self.ccbPopupEnergyInfo['energyNumber']:setString(string.format(min)..':'..string.format(sec))
    self.ccbPopupEnergyInfo['energyNumber']:setScale(2)
    node:setPosition(0,500)
    self:addChild(node)
    
    local label_buyEnergy = cc.Label:createWithSystemFont("体力商店购买","",36)
    label_buyEnergy:setPosition(0.5 * self.ccbPopupEnergyInfo['buyButton']:getContentSize().width + 20,0.5 * self.ccbPopupEnergyInfo['buyButton']:getContentSize().height)
    self.ccbPopupEnergyInfo['buyButton']:addChild(label_buyEnergy)
    
    
    if self.energy_number >= 4 then
    json = 'spine/energy/tilizhi_full.json'
    atlas = 'spine/energy/tilizhi_full.atlas'
    elseif  self.energy_number > 0 then
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
    heart:setPosition(0.5 * self.ccbPopupEnergyInfo['popupWindow']:getContentSize().width ,0.5 * self.ccbPopupEnergyInfo['popupWindow']:getContentSize().height  + 30)
    heart:setName("heart_animation")
    self.ccbPopupEnergyInfo['popupWindow']:addChild(heart) 
    
    if  self.energy_number > 0 and  self.energy_number < 4 then
    local label_energyNumber = cc.Label:createWithSystemFont( self.energy_number,"",36)
    label_energyNumber:setColor(cc.c4b(255,255,255 ,255))
    label_energyNumber:setPosition(0.5 * heart:getContentSize().width ,0.5 * heart:getContentSize().height )
        label_energyNumber:setName("energyNumber")
    heart:addChild(label_energyNumber,1)
--      print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    end
    
    
end



function PopupEnergyInfo:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupEnergyInfo:onBuyButtonClicked()
 --   s_logd('on buy button clicked')
    local IntroLayer = require("popup/PopupEnergyBuy")
    local introLayer = IntroLayer.create()  
    s_SCENE:popup(introLayer)
    
    local animation = introLayer.ccbPopupEnergyBuy['popupWindow']:getChildByName("heart_animation")
    local label = animation:getChildByName("energyNumber")
    label:setString(123)


    
end

return PopupEnergyInfo