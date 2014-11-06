require("Cocos2d")
require("Cocos2dConstants")

local BackgroundLayer = require("layer.BackgroundLayer")
local GameLayer = require("layer.GameLayer")
local HudLayer = require("layer.HudLayer")
local PopupLayer = require("layer.PopupLayer")
local TipsLayer = require("layer.TipsLayer")
local TouchEventBlockLayer = require("layer.TouchEventBlockLayer")
local LoadingCircleLayer = require('layer.LoadingCircleLayer')
local DebugLayer = require("layer.DebugLayer")

-- define level layer state constant
s_normal_level_state = 'normalLevelState'
s_normal_next_state = 'normalNextState'
s_normal_retry_state = 'normalRetryState'
s_unlock_normal_plotInfo_state = 'unlockNormalPlotInfoState'
s_unlock_normal_notPlotInfo_state = 'unlockNormalNotPlotInfoState'
s_review_boss_appear_state = 'reviewBossAppearState'
s_review_boss_pass_state = 'reviewBossPassState'

local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()

    scene.rootLayer = cc.Layer:create()
    scene.rootLayer:setPosition(s_DESIGN_OFFSET_WIDTH, 0)
    scene:addChild(scene.rootLayer)
    
    scene.bgLayer = BackgroundLayer.create()
    scene.rootLayer:addChild(scene.bgLayer)

    scene.gameLayer = GameLayer.create()
    scene.rootLayer:addChild(scene.gameLayer)

    scene.hudLayer = HudLayer.create()
    scene.rootLayer:addChild(scene.hudLayer)

    scene.popupLayer = PopupLayer.create()
    scene.rootLayer:addChild(scene.popupLayer)
    
    scene.tipsLayer = TipsLayer.create()
    scene.rootLayer:addChild(scene.tipsLayer)

    scene.touchEventBlockLayer = TouchEventBlockLayer.create()
    scene.rootLayer:addChild(scene.touchEventBlockLayer)

    scene.loadingCircleLayer = LoadingCircleLayer.create()
    scene.rootLayer:addChild(scene.loadingCircleLayer)

    scene.debugLayer = DebugLayer.create()
    scene.rootLayer:addChild(scene.debugLayer)
    
    -- scene global variables
    scene.levelLayerState = s_normal_level_state
    
    return scene
end

-- delta time : seconds
local function update(dt)
    -- print(dt)
end

function AppScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
    
    self:scheduleUpdateWithPriorityLua(update, 0)
    self:registerCustomEvent()
end

function AppScene:replaceGameLayer(newLayer)
    self.gameLayer:removeAllChildren()
    self.gameLayer:addChild(newLayer)
end

function AppScene:popup(popupNode)
    self.popupLayer.listener:setSwallowTouches(true)
    self.popupLayer:removeAllChildren()
    self.popupLayer:addChild(popupNode) 
end

function AppScene:removeAllPopups()
    self.popupLayer.listener:setSwallowTouches(false)
    self.popupLayer:removeAllChildren()
end

function AppScene:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

function AppScene:dispatchCustomEvent(eventName)
    local event = cc.EventCustom:new(eventName)
    self:getEventDispatcher():dispatchEvent(event)
end

function AppScene:registerCustomEvent()
    local customEventHandle = function (event)
        s_LOADING_CIRCLE_LAYER:show()
        if event:getEventName() == CUSTOM_EVENT_SIGNUP then 

        elseif event:getEventName() == CUSTOM_EVENT_LOGIN then 
            s_UserBaseServer.getLevelsOfCurrentUser(
                function (api, result)
                    s_CURRENT_USER:parseServerLevelData(result.results)
                    
                    s_DATA_MANAGER.loadLevels(s_CURRENT_USER.bookKey)
                    local level = require('view/LevelLayer')
                    layer = level.create()
                    s_SCENE:replaceGameLayer(layer)

                    s_LOADING_CIRCLE_LAYER:hide()
                end,
                function (api, code, message, description)
                end
            )
        end
    end

    local eventDispatcher = self:getEventDispatcher()
    self.listenerSignUp = cc.EventListenerCustom:create(CUSTOM_EVENT_SIGNUP, customEventHandle)
    eventDispatcher:addEventListenerWithFixedPriority(self.listenerSignUp, 1)

    self.listenerLogIn = cc.EventListenerCustom:create(CUSTOM_EVENT_LOGIN, customEventHandle)
    eventDispatcher:addEventListenerWithFixedPriority(self.listenerLogIn, 1)
end

return AppScene
