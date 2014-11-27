local  PauseHelpReviewSecond = class("PauseHelpReviewSecond", function()
    return cc.Layer:create()
end)

function PauseHelpReviewSecond.create()
    local layer = PauseHelpReviewSecond.new()
    return layer
end

function PauseHelpReviewSecond:ctor()

    -- interface
    local unfamiliarNumber = 1
    local studyNumber = 3
    local masterNumber = 2

    self.ccbPauseHelpReviewSecond = {}
    self.ccbPauseHelpReviewSecond['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPauseHelpReviewSecond['onBlueButtonClicked'] = function()
        self:onBlueButtonClicked()
    end

    self.ccb = {} 
    self.ccb['pause_ReviewSecond'] = self.ccbPauseHelpReviewSecond
    self.ccb['closeButton'] = self.ccbPauseHelpReviewSecond_closeButton
    self.ccb['blueButton'] = self.ccbPauseHelpReviewSecond_blueButton
    self.ccb['popupWindow'] = self.ccbPauseHelpReviewSecond_popupWindow
    self.ccb['unfamiliarWord'] = self.ccbPauseHelpReviewSecond_unfamiliarWord
    self.ccb['studyWord'] = self.ccbPauseHelpReviewSecond_studyWord
    self.ccb['masterWord'] = self.ccbPauseHelpReviewSecond_masterWord
    

    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('ccb/pause_help_review_second.ccbi', proxy, self.ccbPauseHelpReviewSecond, self.ccb)
    node:setPosition(400,0)
    self:addChild(node)

    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)

    local label_ok  = cc.Label:createWithSystemFont("继续","",36)
    label_ok:setPosition(0.5 * self.ccbPauseHelpReviewSecond['blueButton']:getContentSize().width ,0.5 * self.ccbPauseHelpReviewSecond['blueButton']:getContentSize().height)
    self.ccbPauseHelpReviewSecond['blueButton']:addChild(label_ok)
    
    self.ccbPauseHelpReviewSecond['unfamiliarWord']:setString(unfamiliarNumber)
    self.ccbPauseHelpReviewSecond['studyWord']:setString(studyNumber) 
    self.ccbPauseHelpReviewSecond['masterWord']:setString(masterNumber) 
    
    
    

end   
function PauseHelpReviewSecond:onCloseButtonClicked()

    s_SCENE.popupLayer.layerpaused = false
    cc.Director:getInstance():getActionManager():resumeTargets(s_SCENE.popupLayer.pauseLayer.targets)
    s_SCENE:removeAllPopups()
end

function PauseHelpReviewSecond:onBlueButtonClicked()

    local action1 = cc.MoveTo:create(0.3, cc.p(-400,0))      
    self:runAction(action1) 

    s_SCENE:callFuncWithDelay(0.3,function()
        local IntroLayer = require("view.pausehelp.PauseHelpReviewThird")
        local introLayer = IntroLayer.create()
        s_SCENE.popupLayer:removeAllChildren()
        s_SCENE.popupLayer:addChild(introLayer)
    end)
end

return PauseHelpReviewSecond