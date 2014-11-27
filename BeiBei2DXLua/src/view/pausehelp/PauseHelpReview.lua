local  PauseHelpReview = class("PauseHelpReview", function()
    return cc.Layer:create()
end)

function PauseHelpReview.create()
    local layer = PauseHelpReview.new()
    return layer
end

function PauseHelpReview:ctor()
    self.ccbPauseHelpReview = {}
    self.ccbPauseHelpReview['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPauseHelpReview['onBlueButtonClicked'] = function()
        self:onBlueButtonClicked()
    end
    
    self.ccb = {} 
    self.ccb['pause_Review'] = self.ccbPauseHelpReview
    self.ccb['closeButton'] = self.ccbPauseHelpReview_closeButton
    self.ccb['blueButton'] = self.ccbPauseHelpReview_blueButton
    self.ccb['popupWindow'] = self.ccbPauseHelpReview_popupWindow
    
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('ccb/pause_help_review.ccbi', proxy, self.ccbPauseHelpReview, self.ccb)
    node:setPosition(0,600)
    self:addChild(node)
    
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)

    local label_ok  = cc.Label:createWithSystemFont("继续","",36)
    label_ok:setPosition(0.5 * self.ccbPauseHelpReview['blueButton']:getContentSize().width ,0.5 * self.ccbPauseHelpReview['blueButton']:getContentSize().height)
    self.ccbPauseHelpReview['blueButton']:addChild(label_ok)
    
 end   
    function PauseHelpReview:onCloseButtonClicked()

        s_SCENE.popupLayer.layerpaused = false
        cc.Director:getInstance():getActionManager():resumeTargets(s_SCENE.popupLayer.pauseLayer.targets)
        s_SCENE:removeAllPopups()
    end

    function PauseHelpReview:onBlueButtonClicked()

    local action1 = cc.MoveTo:create(0.3, cc.p(-400,0))      
    self:runAction(action1) 


    s_SCENE:callFuncWithDelay(0.3,function()
        
        local IntroLayer = require("view.pausehelp.PauseHelpReviewSecond")
        local introLayer = IntroLayer.create()
        s_SCENE.popupLayer:addChild(introLayer)
    end)


    end
    


return PauseHelpReview