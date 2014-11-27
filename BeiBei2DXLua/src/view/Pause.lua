require("Cocos2d")
require("Cocos2dConstants")
require("common.global")
require("CCBReaderLoad")
local Pause = class("Pause", function()
    return cc.Layer:create()
end)

ccbPause = ccbPause or {}

function Pause.create()
    local layer = Pause.new()
    s_SCENE.popupLayer.pauseLayer = layer
    s_SCENE.popupLayer.layerpaused = true
    return layer
end

function Pause:ctor()

    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    --control volune
    if s_DATABASE_MGR.isMusicOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.25) 
    end

    -- Pause actions
    local director = cc.Director:getInstance()
    self.targets = director:getActionManager():pauseAllRunningActions()
    s_logd(#self.targets)
    
    -- local back = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    -- back:setPosition(0, 0)
    -- self:addChild(back)
    
    self.ccb = {}
    
    ccbPause['onClose'] = self.onClose
    ccbPause['onRetry'] = self.onRetry
    ccbPause['onBack'] = self.onBack
    ccbPause['onContinue'] = self.onContinue
    ccbPause['onHelp'] = self.onHelp
    
    ccbPause['onSoundOn'] = self.onSoundOn
    ccbPause['onSoundOff'] = self.onSoundOff
    ccbPause['onMusicOn'] = self.onMusicOn
    ccbPause['onMusicOff'] = self.onMusicOff
    
    self.ccb['pause'] = ccbPause
    ccbPause['Layer'] = self

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/pause.ccbi", proxy, ccbPause, self.ccb)
    node:setPosition(0,0)
    self:addChild(node)
    
    ccbPause['soundOff']:setVisible(false)
    ccbPause['musicOff']:setVisible(false)
    ccbPause['mask']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p((s_RIGHT_X - s_LEFT_X) * 0.5,s_DESIGN_HEIGHT * 0.5))))
 end

function Pause:onClose()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p((s_RIGHT_X - s_LEFT_X) * 0.5,s_DESIGN_HEIGHT * 1.3)))
    local remove = cc.CallFunc:create(function() 
        local director = cc.Director:getInstance()
        director:getActionManager():resumeTargets(ccbPause['Layer'].targets)
        s_SCENE.popupLayer.layerpaused = false
        s_SCENE.popupLayer.listener:setSwallowTouches(false)
        ccbPause['Layer']:removeFromParent()
        s_SCENE:removeAllPopups()
    end,{})
    ccbPause['mask']:runAction(cc.Sequence:create(move,remove))
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    if s_DATABASE_MGR.isSoundOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
    end
end

function Pause:onRetry()
    
    ccbPause['Layer']:onBack()
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    if s_DATABASE_MGR.isSoundOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
    end
end

function Pause:onBack()
    --button sound
    
    playSound(s_sound_buttonEffect)
    
    --control volune
    if s_DATABASE_MGR.isSoundOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
    end
    
    local level = require('view.LevelLayer')
    local layer = level.create()
    --if self.win and isPassed == 0 then
    --    s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
    --end
    s_SCENE.popupLayer.listener:setSwallowTouches(false)
    s_SCENE.popupLayer:removeAllChildren()
    s_SCENE:replaceGameLayer(layer)
end

function Pause:onContinue()
    ccbPause['Layer']:onClose()
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    if s_DATABASE_MGR.isSoundOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
    end

end

function Pause:onHelp()
 -- judge normal / review / summary
--    if xx.class.__cname == 
--    for i=1,5 do
--        print(tostring(s_GAME_LAYER.class.__cname[i]))
--
--   end


    local site = ""
    if  s_SCENE.gameLayerState == s_review_boss_game_state then
        site = "view.pausehelp.PauseHelpReview" 
    elseif s_SCENE.gameLayerState == s_summary_boss_game_state then
        site = "view.pausehelp.PauseHelpSummary"  
    else
        site = "view.pausehelp.PauseHelpNormal"
    end

    local IntroLayer = require(site)
    local introLayer = IntroLayer.create()
    s_SCENE.popupLayer:addChild(introLayer) 
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onSoundOn()
    s_DATABASE_MGR.setSoundOn(false)

    ccbPause['soundOn']:setVisible(false)
    ccbPause['soundOff']:setVisible(true)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onSoundOff()
    s_DATABASE_MGR.setSoundOn(true)

    ccbPause['soundOn']:setVisible(true)
    ccbPause['soundOff']:setVisible(false)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onMusicOn()
    s_DATABASE_MGR.setMusicOn(false)
    
    ccbPause['musicOn']:setVisible(false)
    ccbPause['musicOff']:setVisible(true)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onMusicOff()
    s_DATABASE_MGR.setMusicOn(true)
    
    ccbPause['musicOn']:setVisible(true)
    ccbPause['musicOff']:setVisible(false)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function createPauseLayerWhenTestOrBoss()   
    if s_SCENE.gameLayerState == s_test_game_state
    or s_SCENE.gameLayerState == s_review_boss_game_state
    or s_SCENE.gameLayerState == s_summary_boss_game_state then
        local pauseLayer = Pause:create()
        s_SCENE.popupLayer.listener:setSwallowTouches(true)
        s_SCENE.popupLayer.layerPaused = true
        s_SCENE.popupLayer:removeAllChildren()
        s_SCENE.popupLayer:addChild(pauseLayer) 
    end
end

return Pause