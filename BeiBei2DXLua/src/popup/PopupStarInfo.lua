local  PopupStarInfo = class("PopupStarInfo", function()
    return cc.Layer:create()
end)


function PopupStarInfo.create()
    local layer = PopupStarInfo.new()
    return layer
end



function PopupStarInfo:ctor()
    --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    self.ccbPopupStarInfo = {}

    self.ccbPopupStarInfo['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPopupStarInfo['onContinueButtonClicked'] = function()
        self:onContinueButtonClicked()
    end

    self.ccb = {} 
    self.ccb['rightTopNode_Star'] = self.ccbPopupStarInfo
    self.ccb['title'] = self.ccbPopupStarInfo_title
    self.ccb['countNumber'] = self.ccbPopupStarInfo_countNumber
    self.ccb['totalNumber'] = self.ccbPopupStarInfo_totalNumber
    self.ccb['closeButton'] = self.ccbPopupStarInfo_closeButton
    self.ccb['collectButton'] = self.ccbPopupStarInfo_collectButton





    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/righttopnode_star.ccbi', proxy, self.ccbPopupStarInfo, self.ccb)
--    self.ccbPopupEnergyBuy['title']:setString('购买贝贝体力！')
--    self.ccbPopupEnergyBuy['subtitle']:setString('体力会用在挑战新关卡处')
--    self.ccbPopupEnergyBuy['subsubtitle']:setString('每30分钟回复一点')
--    self.ccbPopupEnergyBuy['energyNumber']:setString('+30')
    node:setPosition(0,200)
    self:addChild(node)

--    local label_buyEnergy = cc.Label:createWithSystemFont("￥6.00","",36)
--    label_buyEnergy:setPosition(0.5 * self.ccbPopupEnergyBuy['buyButton']:getContentSize().width ,0.5 * self.ccbPopupEnergyBuy['buyButton']:getContentSize().height)
--    self.ccbPopupEnergyBuy['buyButton']:addChild(label_buyEnergy)
end



function PopupStarInfo:onCloseButtonClicked()
    s_logd('on close button clicked')
        s_SCENE:removeAllPopups()
end

function PopupStarInfo:onContinueButtonClicked()
    s_logd('on collect button clicked')
end

return PopupStarInfo