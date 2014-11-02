
local PopupSummarySuccess = class('PopupSummarySuccess', function()
    return cc.Layer:create()
end)

function PopupSummarySuccess:create()
    local layer = PopupSummarySuccess.new()
    return layer
end

function PopupSummarySuccess:ctor()
    self.ccbPopupSummarySuccess = {}
    self.ccbPopupSummarySuccess['onCloseButtonClicked'] = self.onCloseButtonClicked
    self.ccbPopupSummarySuccess['onGoButtonClicked'] = self.onGoButtonClicked
    
    self.ccb = {}
    self.ccb['popup_summary_success'] = self.ccbPopupSummarySuccess
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/popup_summary_success.ccbi',proxy,self.ccbPopupSummarySuccess, self.ccb)
    
    -- set title
    self.ccbPopupSummarySuccess['summary_boss_text']:setString(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_NORMAL_START_PLAY_SUMMARY_BOSS))
    -- run action
    node:setPosition(0, 200)
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)

    self:addChild(node)
end

function PopupSummarySuccess:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupSummarySuccess:onGoButtonClicked()
    s_logd('on go button clicked')
end

return PopupSummarySuccess