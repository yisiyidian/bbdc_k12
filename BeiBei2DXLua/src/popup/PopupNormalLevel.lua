


local PopupNormalLevel = class("PopupNormalLevel", function()
    return cc.Layer:create()
end)

function PopupNormalLevel.create()
    local layer = PopupNormalLevel.new()
    return layer
end
function PopupNormalLevel:ctor()
    self.ccbPopupNormalLevel = {}
    self.ccbPopupNormalLevel['onCloseButtonClicked'] = self.onCloseButtonClicked
    self.ccbPopupNormalLevel['onStudyButtonClicked'] = self.onStudyButtonClicked
    self.ccbPopupNormalLevel['onTestButtonClicked'] = self.onTestButtonClicked

    self.ccb = {}
    self.ccb['popup_normal_level'] = self.ccbPopupNormalLevel

    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/popup_normal_level.ccbi', proxy, self.ccbPopupNormalLevel, self.ccb)
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