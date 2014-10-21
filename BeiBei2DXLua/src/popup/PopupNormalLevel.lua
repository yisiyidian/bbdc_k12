
ccbPopupNormalLevel = ccbPopupNormalLevel or {}
ccb['popup_normal_level'] = ccbPopupNormalLevel

local PopupNormalLevel = class("PopupNormalLevel", function()
    return cc.Layer:create()
end)

function PopupNormalLevel.create()
    local layer = PopupNormalLevel.new()
    return layer
end
function PopupNormalLevel:ctor()
    ccbPopupNormalLevel['onCloseButtonClicked'] = self.onCloseButtonClicked
    ccbPopupNormalLevel['onStudyButtonClicked'] = self.onStudyButtonClicked
    ccbPopupNormalLevel['onTestButtonClicked'] = self.onTestButtonClicked
--  
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/popup_normal_level.ccbi',proxy,ccbPopupNormalLevel)
    node:setPosition(0,200)
    
    -- run action --
    --local action1 = cc.EaseBackOut:create(0.4, cc.p(0,0))
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    self:addChild(node)
end

function PopupNormalLevel:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
end

function PopupNormalLevel:onStudyButtonClicked()
    s_logd('on study button clicked')
end

function PopupNormalLevel:onTestButtonClicked()
    s_logd('on test button clicked')
end

return PopupNormalLevel