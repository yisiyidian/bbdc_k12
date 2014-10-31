
local PopupReviewBoss = class('PopupReviewBoss', function()
    return cc.Layer:create()
end)

function PopupReviewBoss:create()
    local layer = PopupReviewBoss.new()
    return layer
end

function PopupReviewBoss:ctor()
    self.ccbPopupReviewBoss = {}
    self.ccbPopupReviewBoss['onCloseButtonClicked'] = self.onCloseButtonClicked 
    self.ccbPopupReviewBoss['onGoButtonClicked'] = self.onGoButtonClicked
    
    self.ccb = {}
    self.ccb['popup_review_boss'] = self.ccbPopupReviewBoss
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('ccb/popup_review_boss.ccbi',proxy,self.ccbPopupReviewBoss,self.ccb)
    -- run action
    node:setPosition(0, 200)
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    self:addChild(node)
end

function PopupReviewBoss:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupReviewBoss:onGoButtonClicked()
    s_logd('on go button clicked')
end

return PopupReviewBoss