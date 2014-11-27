local  PauseHelpReviewThird = class("PauseHelpReviewThird", function()
    return cc.Layer:create()
end)

function PauseHelpReviewThird.create()
    local layer = PauseHelpReviewThird.new()
    return layer
end

function PauseHelpReviewThird:ctor()

    -- interface
    local unfamiliarNumber = 1
    local studyNumber = 3
    local masterNumber = 2

    self.ccbPauseHelpReviewThird = {}
    self.ccbPauseHelpReviewThird['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPauseHelpReviewThird['onBlueButtonClicked'] = function()
        self:onBlueButtonClicked()
    end

    self.ccb = {} 
    self.ccb['pause_ReviewThird'] = self.ccbPauseHelpReviewThird
    self.ccb['closeButton'] = self.ccbPauseHelpReviewThird_closeButton
    self.ccb['blueButton'] = self.ccbPauseHelpReviewThird_blueButton
    self.ccb['popupWindow'] = self.ccbPauseHelpReviewThird_popupWindow



    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('ccb/pause_help_review_third.ccbi', proxy, self.ccbPauseHelpReviewThird, self.ccb)
    node:setPosition(400,0)
    self:addChild(node)

    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)

    local label_ok  = cc.Label:createWithSystemFont("OK","",36)
    label_ok:setPosition(0.5 * self.ccbPauseHelpReviewThird['blueButton']:getContentSize().width ,0.5 * self.ccbPauseHelpReviewThird['blueButton']:getContentSize().height)
    self.ccbPauseHelpReviewThird['blueButton']:addChild(label_ok)





end   
function PauseHelpReviewThird:onCloseButtonClicked()
    s_SCENE.popupLayer.layerpaused = false
    cc.Director:getInstance():getActionManager():resumeTargets(s_SCENE.popupLayer.pauseLayer.targets)
    s_SCENE:removeAllPopups()
end

function PauseHelpReviewThird:onBlueButtonClicked()
    s_logd('on collect button clicked')
    local action1 = cc.MoveTo:create(0.3, cc.p(0,600))      
    self:runAction(action1) 


    s_SCENE:callFuncWithDelay(0.3,function()
       s_SCENE.popupLayer.layerpaused = false
       cc.Director:getInstance():getActionManager():resumeTargets(s_SCENE.popupLayer.pauseLayer.targets)
       s_SCENE:removeAllPopups()
    end)


end



return PauseHelpReviewThird