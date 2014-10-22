
ccbPopupSummaryFail = ccbPopupSummaryFail or {}
ccb['popup_summary_fail'] = ccbPopupSummaryFail

local PopupSummaryFail = class('PopupSummaryFail', function()
    return cc.Layer:create()
end)

function PopupSummaryFail:create()
    local layer = PopupSummaryFail.new()
    return layer
end

function PopupSummaryFail:ctor()
    ccbPopupSummaryFail['onCloseButtonClicked'] = self.onCloseButtonClicked
    ccbPopupSummaryFail['onContinueButtonClicked'] = self.onContinueButtonClicked
    
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/popup_summary_fail.ccbi',proxy,ccbPopupSummaryFail)
    
    -- run action
    node:setPosition(0, 200)
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    self:addChild(node)
end

function PopupSummaryFail:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupSummaryFail:onContinueButtonClicked()
    s_logd('on continue button clicked')
end

return PopupSummaryFail