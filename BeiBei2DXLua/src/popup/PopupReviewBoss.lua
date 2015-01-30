
local PopupReviewBoss = class('PopupReviewBoss', function()
    return cc.Layer:create()
end)

local width = s_RIGHT_X-s_LEFT_X

function PopupReviewBoss:create()
    local layer = PopupReviewBoss.new()
    return layer
end

function PopupReviewBoss:ctor()

    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    
    self.ccbPopupReviewBoss = {}
    self.ccbPopupReviewBoss['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end 
    self.ccbPopupReviewBoss['onGoButtonClicked'] = function()
        self:onGoButtonClicked()
    end
    
    self.ccb = {}
    self.ccb['popup_review_boss'] = self.ccbPopupReviewBoss
    local proxy = cc.CCBProxy:create()
    local node
    if s_CURRENT_USER.currentSelectedChapterKey == 'chapter0' then
        node = CCBReaderLoad('ccb/popup_review_boss.ccbi',proxy,self.ccbPopupReviewBoss,self.ccb)
    elseif s_CURRENT_USER.currentSelectedChapterKey == 'chapter1' then
        node = CCBReaderLoad('ccb/popup_review_boss2.ccbi',proxy,self.ccbPopupReviewBoss,self.ccb)
    else
        node = CCBReaderLoad('ccb/popup_review_boss3.ccbi',proxy,self.ccbPopupReviewBoss,self.ccb)
    end
    self:addChild(node)
    
    -- set title
    self.ccbPopupReviewBoss['review_boss_text']:setString(s_DataManager.getTextWithIndex(TEXT_ID_YOUR_NEED_REVIEW))
    -- add review boss
    local reviewBoss = sp.SkeletonAnimation:create('spine/3zlstanchujianxiao.json', 'spine/3zlstanchujianxiao.atlas',1)
    reviewBoss:addAnimation(0,'animation',true)
    reviewBoss:ignoreAnchorPointForPosition(false)
    reviewBoss:setAnchorPoint(0.5,0.5)
    reviewBoss:setPosition(s_LEFT_X + width * 0.32, node:getContentSize().height/3+50)
    node:addChild(reviewBoss)
    
    -- run action
    node:setPosition(0, 200)
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
end

function PopupReviewBoss:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
    
    -- button sound
    playSound(s_sound_buttonEffect)
end

function PopupReviewBoss:onGoButtonClicked()
    s_logd('on go button clicked')
    s_SCENE.gameLayerState = s_review_boss_game_state

    -- button sound
    playSound(s_sound_buttonEffect)
       
    self:onCloseButtonClicked()
    --local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,levelKey)
--    print('----review tutorial step:'..s_CURRENT_USER.reviewBossTutorialStep)
--    if s_CURRENT_USER.currentLevelKey == 'level0' and s_CURRENT_USER.reviewBossTutorialStep == 0 then
--        s_CorePlayManager.enterReviewBossLayer_special()
--    else
        if s_CURRENT_USER.energyCount >= s_review_boss_energy_cost then
--            s_CURRENT_USER:useEnergys(s_review_boss_energy_cost)
            s_CorePlayManager.enterReviewBossLayer()  
            
            -- energy cost "cost"
--            s_SCENE:callFuncWithDelay(0.3,function()
--                playSound(s_sound_cost)
--            end)
--        else 
--            local energyInfoLayer = require('popup.PopupEnergyInfo')
--            local layer = energyInfoLayer.create()
--            s_SCENE:popup(layer)
        end
--    end
end

return PopupReviewBoss