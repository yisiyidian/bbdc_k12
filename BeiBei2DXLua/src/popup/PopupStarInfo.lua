local  PopupStarInfo = class("PopupStarInfo", function()
    return cc.Layer:create()
end)


function PopupStarInfo.create(starNumber)
    local layer = PopupStarInfo.new(starNumber)
    return layer
end



function PopupStarInfo:ctor(starNumber)
    --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

    local  totalNumber = 255
    
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
    self.ccb['starNumber'] = self.ccbPopupStarInfo_starNumber
    self.ccb['totalNumber'] = self.ccbPopupStarInfo_totalNumber
    self.ccb['closeButton'] = self.ccbPopupStarInfo_closeButton
    self.ccb['collectButton'] = self.ccbPopupStarInfo_collectButton
    self.ccb['popupWindow'] = self.ccbPopupStarInfo_popupWindow
    




    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/righttopnode_star.ccbi', proxy, self.ccbPopupStarInfo, self.ccb)
    self.ccbPopupStarInfo['title']:setString('贝贝收集的星星')
    self.ccbPopupStarInfo['starNumber']:setString(starNumber)
    self.ccbPopupStarInfo['totalNumber']:setString(totalNumber)
    node:setPosition(0,600)
    self:addChild(node)

    local label_collect  = cc.Label:createWithSystemFont("继续收集","",36)
    label_collect:setPosition(0.5 * self.ccbPopupStarInfo['collectButton']:getContentSize().width ,0.5 * self.ccbPopupStarInfo['collectButton']:getContentSize().height)
    self.ccbPopupStarInfo['collectButton']:addChild(label_collect)
end



function PopupStarInfo:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupStarInfo:onContinueButtonClicked()
    s_logd('on collect button clicked')
    local action1 = cc.MoveTo:create(0.3, cc.p(0,600))      
    self:runAction(action1) 
    s_SCENE:callFuncWithDelay(0.3,function()
    s_SCENE:removeAllPopups()
    end)

end

return PopupStarInfo