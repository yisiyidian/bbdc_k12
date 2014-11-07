
local PopupSummarySuccess = class('PopupSummarySuccess', function()
    return cc.Layer:create()
end)

function PopupSummarySuccess.create(levelTag, current_star, total_star)
    local layer = PopupSummarySuccess.new(levelTag, current_star, total_star)
    return layer
end

function PopupSummarySuccess:ctor(levelTag, current_star, total_star)
    self.ccbPopupSummarySuccess = {}
    self.ccbPopupSummarySuccess['onCloseButtonClicked'] = self.onCloseButtonClicked
    self.ccbPopupSummarySuccess['onGoButtonClicked'] = self.onGoButtonClicked
    
    self.ccb = {}
    self.ccb['levelTag'] = levelTag
    self.ccb['popup_summary_success'] = self.ccbPopupSummarySuccess
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/popup_summary_success.ccbi',proxy,self.ccbPopupSummarySuccess, self.ccb)
    
    -- set title
    self.ccbPopupSummarySuccess['summary_boss_text']:setString(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_NORMAL_START_PLAY_SUMMARY_BOSS))
    -- add summary boss
    local boss = sp.SkeletonAnimation:create('spine/klschongshangdaoxia.json', 'spine/klschongshangdaoxia.atlas',1)
    boss:addAnimation(0, 'animation', true)
    boss:setPosition(node:getContentSize().width/3, node:getContentSize().height/3)
    node:addChild(boss, 10)
    
    -- set stars
    self.ccbPopupSummarySuccess['current_star_count']:setString(current_star)
    self.ccbPopupSummarySuccess['total_star_count']:setString(total_star) 
    
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
    self:onCloseButtonClicked()
    s_logd('on go button clicked')
end

return PopupSummarySuccess