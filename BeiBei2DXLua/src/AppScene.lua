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
    if s_CURRENT_USER.sessionToken ~= '' and  s_CURRENT_USER.serverTime >= 0 then
        s_CURRENT_USER.serverTime = s_CURRENT_USER.serverTime + dt
        if s_CURRENT_USER.energyCount <= s_energyMaxCount then
            if s_CURRENT_USER.energyLastCoolDownTime < 0 then
                s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.serverTime;
            end
            local cnt = (s_CURRENT_USER.serverTime - s_CURRENT_USER.energyLastCoolDownTime) / s_energyCoolDownSecs
            if cnt > 0 then
                s_CURRENT_USER.energyCount = s_CURRENT_USER.energyCount + cnt
                if s_CURRENT_USER.energyCount >= s_energyMaxCount then
                    s_CURRENT_USER.energyCount = s_energyMaxCount
                    s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.serverTime
                else 
                    s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.energyLastCoolDownTime + cnt * s_energyCoolDownSecs
                end
            end
        end
    end 
end

function AppScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
    
    self:scheduleUpdateWithPriorityLua(update, 0)
    -- self:registerCustomEvent()
end

function AppScene:replaceGameLayer(newLayer)
    self.gameLayer:removeAllChildren()
    self.gameLayer:addChild(newLayer)
end

function AppScene:popup(popupNode)
    self.popupLayer.listener:setSwallowTouches(true)
    self.popupLayer:removeAllChildren()
    self.popupLayer:addBackground()
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

---- custom event

-- function AppScene:dispatchCustomEvent(eventName)
--     local event = cc.EventCustom:new(eventName)
--     self:getEventDispatcher():dispatchEvent(event)
-- end

-- function AppScene:registerCustomEvent()
--     local customEventHandle = function (event)
--         if event:getEventName() == CUSTOM_EVENT_SIGNUP then 
--             s_SCENE:gotoChooseBook()
--             s_LOADING_CIRCLE_LAYER:hide()
--         elseif event:getEventName() == CUSTOM_EVENT_LOGIN then 
--             if s_CURRENT_USER.bookKey == '' then
--                 s_SCENE:gotoChooseBook()
--                 s_LOADING_CIRCLE_LAYER:hide()
--             else
--                 s_SCENE:getDailyCheckIn()
--             end
--         end
--     end

--     local eventDispatcher = self:getEventDispatcher()
--     self.listenerSignUp = cc.EventListenerCustom:create(CUSTOM_EVENT_SIGNUP, customEventHandle)
--     eventDispatcher:addEventListenerWithFixedPriority(self.listenerSignUp, 1)

--     self.listenerLogIn = cc.EventListenerCustom:create(CUSTOM_EVENT_LOGIN, customEventHandle)
--     eventDispatcher:addEventListenerWithFixedPriority(self.listenerLogIn, 1)
-- end

---- sign up & log in

function AppScene:signUp(username, password)
    local function onResponse(u, e, code)
        if e then
            s_TIPS_LAYER:showSmall(e)
            s_LOADING_CIRCLE_LAYER:hide()
        else
            s_SCENE:gotoChooseBook()
        end
    end
    s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_USER_DATA))
    s_UserBaseServer.signup(username, password, onResponse)
end

function AppScene:logIn(username, password)
    local function onResponse(u, e, code)
        if e then                  
            s_TIPS_LAYER:showSmall(e)
            s_LOADING_CIRCLE_LAYER:hide()
        else
            if s_CURRENT_USER.bookKey == '' then
                s_SCENE:gotoChooseBook()
            else
                s_SCENE:getDailyCheckIn()
            end
        end
    end
    s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_USER_DATA))
    s_UserBaseServer.login(username, password, onResponse)
end

function AppScene:getDailyCheckIn()
    s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_DAILY_LOGIN_DATA))
    s_UserBaseServer.getDailyCheckInOfCurrentUser( 
        function (api, result)
            s_CURRENT_USER:parseServerDailyCheckInData(result.results)
            self:getFollowees()
        end,
        function (api, code, message, description) 
            self:getFollowees()
        end
    )
end

-- TODO : configs

function AppScene:getFollowees()
    s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_FRIEND_DATA))
    s_UserBaseServer.getFolloweesOfCurrentUser( 
        function (api, result)
            s_CURRENT_USER:parseServerFolloweesData(result.results)
            self:getFollowers()
        end,
        function (api, code, message, description)
            self:getFollowers()
        end
    )
end

function AppScene:getFollowers()
    s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_FRIEND_DATA))
    s_UserBaseServer.getFollowersOfCurrentUser( 
        function (api, result)
            s_CURRENT_USER:parseServerFollowersData(result.results)
            self:getLevels()
        end,
        function (api, code, message, description)
            self:getLevels()
        end
    )
end

function AppScene:getLevels()
    s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_LEVEL_DATA))
    s_UserBaseServer.getLevelsOfCurrentUser(
        function (api, result)
            s_CURRENT_USER:parseServerLevelData(result.results)
            self:onUserServerDatasCompleted()            
        end,
        function (api, code, message, description)
            self:onUserServerDatasCompleted()
        end
    )
end

function AppScene:loadConfigs()
    s_DATA_MANAGER.loadBooks()
    s_DATA_MANAGER.loadChapters()
    s_DATA_MANAGER.loadDailyCheckIns()
    s_DATA_MANAGER.loadEnergy()
    s_DATA_MANAGER.loadItems()
    s_DATA_MANAGER.loadReviewBoss()
    s_DATA_MANAGER.loadStarRules()

    s_WordPool = s_DATA_MANAGER.loadAllWords()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()
end

function AppScene:saveSignUpAndLogInData(onSaved)
    self:loadConfigs()

    local DataLogIn = require('model/user/DataLogIn')
    local function updateWeek(data, week)
        if data == nil then 
            data = DataLogIn.create()
        end
        data.week = week
        data:setWeekDay(os.time())
        s_DATABASE_MGR.saveDataClassObject(data)
        s_UserBaseServer.saveDataObjectOfCurrentUser(data, 
            function (api, result)
                onSaved()
                s_LOADING_CIRCLE_LAYER:hide()
            end,
            function (api, code, message, description)
                onSaved()
                s_LOADING_CIRCLE_LAYER:hide()
            end)
    end

    if s_CURRENT_USER.localTime == 0 then
        s_CURRENT_USER.localTime = os.time()
        updateWeek(nil, 1)
    else
        local currentWeeks = getCurrentLogInWeek(os.time() - s_CURRENT_USER.localTime)
        s_UserBaseServer.getDataLogIn(s_CURRENT_USER.objectId, currentWeeks,
            function (api, result)
                s_CURRENT_USER:parseServerDataLogIn(result.results)
                if #(result.results) <= 0 then
                    updateWeek(nil, currentWeeks)
                else
                    local data = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
                    updateWeek(data, data.week)
                end
            end,
            function (api, code, message, description)
                onSaved()
                s_LOADING_CIRCLE_LAYER:hide()
            end)
    end
end

-- no book key
function AppScene:gotoChooseBook()
    self:saveSignUpAndLogInData(function ()
        s_CorePlayManager.enterBookLayer()
    end)
end

-- with book key
function AppScene:onUserServerDatasCompleted()    
    self:saveSignUpAndLogInData(function ()
        s_DATA_MANAGER.loadLevels(s_CURRENT_USER.bookKey)
        s_CorePlayManager.enterHomeLayer()
    end)
end

return AppScene
