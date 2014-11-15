
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
    self:addChild(node)
    
    -- set title
    self.ccbPopupReviewBoss['review_boss_text']:setString(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_YOUR_NEED_REVIEW))
    -- add review boss
    local reviewBoss = sp.SkeletonAnimation:create('spine/3zlstanchujianxiao.json', 'spine/3zlstanchujianxiao.atlas',1)
    reviewBoss:addAnimation(0,'animation',true)
    reviewBoss:setPosition(node:getContentSize().width/3-30, node:getContentSize().height/3+50)
    node:addChild(reviewBoss)
    
    -- run action
    node:setPosition(0, 200)
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
end

function PopupReviewBoss:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupReviewBoss:onGoButtonClicked()
    s_logd('on go button clicked')
    
    self:onCloseButtonClicked()
    s_CorePlayManager.enterReviewBossLayer()
end

return PopupReviewBoss