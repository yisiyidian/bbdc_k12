local  PopupStarInfo = class("PopupStarInfo", function()
    return cc.Layer:create()
end)


function PopupStarInfo.create()
    local layer = PopupStarInfo.new()
    return layer
end



function PopupStarInfo:ctor()
    --   print("213215111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    
    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    --control volune
   if s_DATABASE_MGR.isMusicOn() then
      cc.SimpleAudioEngine:getInstance():setMusicVolume(0.25)
   end

    local  starNumber = s_CURRENT_USER:getUserBookObtainedStarCount()
    local  totalNumber = 255
    
    self.ccbPopupStarInfo = {}

    self.ccbPopupStarInfo['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPopupStarInfo['onContinueButtonClicked'] = function()
        self:onContinueButtonClicked()
    end

    self.ccb = {} 
    self.ccb['rightTopNode_Star'] = self.ccbPopupStarInfo
    self.ccb['title'] = self.ccbPopupStarInfo_title
    self.ccb['starNumber'] = self.ccbPopupStarInfo_starNumber
    self.ccb['totalNumber'] = self.ccbPopupStarInfo_totalNumber
    self.ccb['closeButton'] = self.ccbPopupStarInfo_closeButton
    self.ccb['collectButton'] = self.ccbPopupStarInfo_collectButton
    self.ccb['popupWindow'] = self.ccbPopupStarInfo_popupWindow
    




    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad('res/ccb/righttopnode_star.ccbi', proxy, self.ccbPopupStarInfo, self.ccb)
    self.ccbPopupStarInfo['title']:setString('贝贝收集的星星')
    self.ccbPopupStarInfo['starNumber']:setString(starNumber)
    self.ccbPopupStarInfo['totalNumber']:setString(totalNumber)
    node:setPosition(0,600)
    self:addChild(node)


    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    local label_collect  = cc.Label:createWithSystemFont("继续收集","",36)
    label_collect:setPosition(0.5 * self.ccbPopupStarInfo['collectButton']:getContentSize().width ,0.5 * self.ccbPopupStarInfo['collectButton']:getContentSize().height)
    self.ccbPopupStarInfo['collectButton']:addChild(label_collect)
end



function PopupStarInfo:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
    
    -- button sound
    playSound(s_sound_buttonEffect)
end

function PopupStarInfo:onContinueButtonClicked()
    s_logd('on collect button clicked')
    local action1 = cc.MoveTo:create(0.3, cc.p(0,600))      
    self:runAction(action1) 
    
    -- button sound
    playSound(s_sound_buttonEffect)
    --control volune
    if s_DATABASE_MGR.isMusicOn() then
       cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5)
    end
    s_SCENE:callFuncWithDelay(0.3,function()
    s_SCENE:removeAllPopups()
    end)

end

return PopupStarInfo