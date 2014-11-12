local  PopupEnergyInfo = class("PopupEnergyInfo", function()
    return cc.Layer:create()
end)


function PopupEnergyInfo.create()
    local layer = PopupEnergyInfo.new()
    return layer
end



function PopupEnergyInfo:ctor()
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
--    self.ccb['title'] = self.title
--    self.ccb['tilizhi'] = self.tilizhi
--    self.ccb['close'] = self.close
--    self.ccb['buy'] = self.buy
--    self.ccb['onClose'] = self.onClose
--    self.ccb['maitili'] = self.maitili

    

    
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/righttopnode_heart.ccbi', proxy, self.ccbPopupEnergyInfo, self.ccb)
 --   self.ccbPopupEnergyInfo['title']:setString('hfh')
    node:setPosition(0,200)
    self:addChild(node)
end



function PopupEnergyInfo:onCloseButtonClicked()
    s_logd('on close button clicked')
--    s_SCENE:removeAllPopups()
end

function PopupEnergyInfo:onBuyButtonClicked()
    s_logd('on buy button clicked')
end

return PopupEnergyInfo