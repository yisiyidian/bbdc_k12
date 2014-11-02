
local PopupSummaryFail = class('PopupSummaryFail', function()
    return cc.Layer:create()
end)

function PopupSummaryFail.create(starInfo)
    local layer = PopupSummaryFail.new(starInfo)
    return layer
end

function PopupSummaryFail:ctor(starInfo)
    self.ccbPopupSummaryFail = {}
    self.ccbPopupSummaryFail['onCloseButtonClicked'] = self.onCloseButtonClicked
    self.ccbPopupSummaryFail['onContinueButtonClicked'] = self.onContinueButtonClicked
    
    self.ccb = {}
    self.ccb['popup_summary_fail'] = self.ccbPopupSummaryFail
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/popup_summary_fail.ccbi',proxy,self.ccbPopupSummaryFail,self.ccb)
    
    -- set title
    self.ccbPopupSummaryFail['summary_boss_text']:setString(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_NEED_XXX_STARS_TO_UNLOCK_LV))
    -- add sad girl
    local girl = sp.SkeletonAnimation:create('spine/bb_yumen_public.json', 'spine/bb_yumen_public.atlas',1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(self:getContentSize().width/3, self:getContentSize().height/4)
    self:addChild(girl, 10)
    -- set stars
    s_logd(starInfo[1]..',',starInfo[2])
    self.ccbPopupSummaryFail['current_star_count']:setString(starInfo[1])
    self.ccbPopupSummaryFail['total_star_count']:setString(starInfo[2]) 
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