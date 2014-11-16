local  PauseHelpNormal = class("PauseHelpNormal", function()
    return cc.Layer:create()
end)


function PauseHelpNormal.create()
    local layer = PauseHelpNormal.new()
    return layer
end



function PauseHelpNormal:ctor()
    --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")


    self.ccbPauseHelpNormal = {}

    self.ccbPauseHelpNormal['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPauseHelpNormal['onBlueButtonClicked'] = function()
        self:onBlueButtonClicked()
    end

    self.ccb = {} 
    self.ccb['pause_Nornal'] = self.ccbPauseHelpNormal
    self.ccb['closeButton'] = self.ccbPauseHelpNormal_closeButton
    self.ccb['blueButton'] = self.ccbPauseHelpNormal_blueButton
    self.ccb['popupWindow'] = self.ccbPauseHelpNormal_popupWindow





    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('ccb/pause_help_normal.ccbi', proxy, self.ccbPauseHelpNormal, self.ccb)
    node:setPosition(0,600)
    self:addChild(node)


    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)

    local label_ok  = cc.Label:createWithSystemFont("OK","",36)
    label_ok:setPosition(0.5 * self.ccbPauseHelpNormal['blueButton']:getContentSize().width ,0.5 * self.ccbPauseHelpNormal['blueButton']:getContentSize().height)
    self.ccbPauseHelpNormal['blueButton']:addChild(label_ok)
end



function PauseHelpNormal:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PauseHelpNormal:onBlueButtonClicked()
    s_logd('on collect button clicked')
    local action1 = cc.MoveTo:create(0.3, cc.p(0,600))      
    self:runAction(action1) 


    s_SCENE:callFuncWithDelay(0.3,function()
    s_SCENE:removeAllPopups()
    end)



end

return PauseHelpNormal