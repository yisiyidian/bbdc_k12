local  PauseHelpSummary = class("PauseHelpNormal", function()
    return cc.Layer:create()
end)


function PauseHelpSummary.create()
    local layer = PauseHelpSummary.new()
    return layer
end



function PauseHelpSummary:ctor()
    --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")


    self.ccbPauseHelpSummary = {}

    self.ccbPauseHelpSummary['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPauseHelpSummary['onBlueButtonClicked'] = function()
        self:onBlueButtonClicked()
    end

    self.ccb = {} 
    self.ccb['pause_Nornal'] = self.ccbPauseHelpSummary
    self.ccb['closeButton'] = self.ccbPauseHelpSummary_closeButton
    self.ccb['blueButton'] = self.ccbPauseHelpSummary_blueButton
    self.ccb['popupWindow'] = self.ccbPauseHelpSummary_popupWindow





    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('ccb/pause_help_summary.ccbi', proxy, self.ccbPauseHelpSummary, self.ccb)
    node:setPosition(0,0)
    self:addChild(node)


    --    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    --    local action2 = cc.EaseBackOut:create(action1)
    --    node:runAction(action2)

    local label_ok  = cc.Label:createWithSystemFont("OK","",36)
    label_ok:setPosition(0.5 * self.ccbPauseHelpSummary['blueButton']:getContentSize().width ,0.5 * self.ccbPauseHelpSummary['blueButton']:getContentSize().height)
    self.ccbPauseHelpSummary['blueButton']:addChild(label_ok)
end



function PauseHelpSummary:onCloseButtonClicked()
    s_logd('on close button clicked')
    --    s_SCENE:removeAllPopups()
end

function PauseHelpSummary:onBlueButtonClicked()
    s_logd('on collect button clicked')
    local action1 = cc.MoveTo:create(0.3, cc.p(0,600))      
    self:runAction(action1) 
    s_SCENE:callFuncWithDelay(0.3,function()
        --        s_SCENE:removeAllPopups()
        end)

end

return PauseHelpSummary