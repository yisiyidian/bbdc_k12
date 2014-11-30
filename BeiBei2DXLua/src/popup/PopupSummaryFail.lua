
local PopupSummaryFail = class('PopupSummaryFail', function()
    return cc.Layer:create()
end)

function PopupSummaryFail.create(current_star, total_star)
    local layer = PopupSummaryFail.new(current_star, total_star)
    return layer
end

function PopupSummaryFail:ctor(current_star, total_star)

    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    

    
    self.ccbPopupSummaryFail = {}
    self.ccbPopupSummaryFail['onCloseButtonClicked'] = self.onCloseButtonClicked
    self.ccbPopupSummaryFail['onContinueButtonClicked'] = self.onContinueButtonClicked
    
    self.ccb = {}
    self.ccb['popup_summary_fail'] = self.ccbPopupSummaryFail
    local proxy = cc.CCBProxy:create()
    local node
    if s_CURRENT_USER.currentSelectedChapterKey == 'chapter0' then
        node = CCBReaderLoad('res/ccb/popup_summary_fail.ccbi',proxy,self.ccbPopupSummaryFail,self.ccb)
    elseif s_CURRENT_USER.currentSelectedChapterKey == 'chapter1' then
        node = CCBReaderLoad('res/ccb/popup_summary_fail2.ccbi',proxy,self.ccbPopupSummaryFail,self.ccb)
    else
        node = CCBReaderLoad('res/ccb/popup_summary_fail3.ccbi',proxy,self.ccbPopupSummaryFail,self.ccb)
    end
    
    
    -- set title
    self.ccbPopupSummaryFail['summary_boss_text']:setString(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_NEED_XXX_STARS_TO_UNLOCK_LV))
    -- add sad girl
    local girl = sp.SkeletonAnimation:create('spine/bb_yumen_public.json', 'spine/bb_yumen_public.atlas',1)
    girl:addAnimation(0, 'animation', true)
    girl:setPosition(node:getContentSize().width/3, node:getContentSize().height/4)
    node:addChild(girl, 10)
    -- set stars
    self.ccbPopupSummaryFail['current_star_count']:setString(current_star)
    self.ccbPopupSummaryFail['total_star_count']:setString(total_star) 
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
    
    -- button sound
    playSound(s_sound_buttonEffect)
end

function PopupSummaryFail:onContinueButtonClicked()
    s_logd('on continue button clicked')
    s_SCENE:removeAllPopups()
    -- button sound
    playSound(s_sound_buttonEffect)
end

return PopupSummaryFail