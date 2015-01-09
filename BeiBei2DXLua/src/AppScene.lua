require("cocos.init")

local BackgroundLayer = require("layer.BackgroundLayer")
local GameLayer = require("layer.GameLayer")
local HudLayer = require("layer.HudLayer")
local PopupLayer = require("layer.PopupLayer")
local TipsLayer = require("layer.TipsLayer")
local TouchEventBlockLayer = require("layer.TouchEventBlockLayer")
local DebugLayer = require("layer.DebugLayer")

-- define level layer state constant
s_normal_level_state = 'normalLevelState'
s_normal_next_state = 'normalNextState'
s_normal_retry_state = 'normalRetryState'
s_unlock_next_chapter_state = 'unlockNextChapterState'
s_unlock_normal_plotInfo_state = 'unlockNormalPlotInfoState'
s_unlock_normal_notPlotInfo_state = 'unlockNormalNotPlotInfoState'
s_review_boss_retry_state = 'reviewBossRetryState'
s_review_boss_appear_state = 'reviewBossAppearState'
s_review_boss_pass_state = 'reviewBossPassState'
-- define game layer state
s_normal_game_state = 'normalGameState'
s_test_game_state = 'testGameState'
s_review_boss_game_state = 'reviewBossGameState'
s_summary_boss_game_state = 'summaryBossGameState'

-- define tutorial state
s_tutorial_book_select = 0
s_tutorial_home = 1
s_tutorial_level_select = 2
s_tutorial_study = 3
s_tutorial_review_boss = 4
s_tutorial_summary_boss = 5
s_tutorial_complete = 6
-- define small tutorial state
s_smalltutorial_book_select = 0
s_smalltutorial_home = 1
s_smalltutorial_level_select = 2
s_smalltutorial_studyRepeat1_1 = 3 -- touch cloud
s_smalltutorial_studyRepeat1_2 = 4 -- 去划单词
s_smalltutorial_studyRepeat1_3 = 5 -- 划完
s_smalltutorial_studyRepeat2_1 = 6
s_smalltutorial_studyRepeat2_2 = 7
s_smalltutorial_studyRepeat2_3 = 8
s_smalltutorial_studyRepeat3_1 = 9
s_smalltutorial_studyRepeat3_2 = 10
s_smalltutorial_studyRepeat3_3 = 11
s_smalltutorial_review_boss = 12
s_smalltutorial_summary_boss = 13
s_smalltutorial_complete = 14
s_smalltutorial_complete_win = 100
s_smalltutorial_complete_lose = 101
s_smalltutorial_complete_timeout = 102

-- define review boss tutorial

local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()

    scene.currentGameLayerName = 'unknown'

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

    if RELEASE_APP == RELEASE_FOR_APPSTORE then 
        scene.debugLayer = cc.Layer:create()
        scene.debugLayer:setVisible(false) 
    else
        scene.debugLayer = DebugLayer.create()
    end
    scene.rootLayer:addChild(scene.debugLayer)
    
    -- scene global variables
    scene.levelLayerState = s_normal_level_state
    scene.gameLayerState = s_normal_game_state
    return scene
end

-- delta time : seconds
local function update(dt)
    if s_CURRENT_USER.sessionToken ~= '' and  s_CURRENT_USER.serverTime >= 0 then
        s_CURRENT_USER.serverTime = s_CURRENT_USER.serverTime + dt
        --print('serverTime:'..s_CURRENT_USER.serverTime..',energyCount:'..s_CURRENT_USER.energyCount..',lastCool:'..s_CURRENT_USER.energyLastCoolDownTime)
        -- if s_CURRENT_USER.energyCount <= s_energyMaxCount then
        --     if s_CURRENT_USER.energyLastCoolDownTime < 0 then
        --         s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.serverTime;
        --     end
        --     local cnt = math.floor((s_CURRENT_USER.serverTime - s_CURRENT_USER.energyLastCoolDownTime) / s_energyCoolDownSecs)
        --     if cnt > 0 then
        --         s_CURRENT_USER.energyCount = s_CURRENT_USER.energyCount + cnt
        --         if s_CURRENT_USER.energyCount >= s_energyMaxCount then
        --             s_CURRENT_USER.energyCount = s_energyMaxCount
        --             s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.serverTime
        --         else 
        --             s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.energyLastCoolDownTime + cnt * s_energyCoolDownSecs
        --         end
        --         s_CURRENT_USER:updateDataToServer()
        --     end
        -- end
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

    if newLayer.class ~= nil and newLayer.class.__cname ~= nil then 
        self.currentGameLayerName = newLayer.class.__cname
    else
        self.currentGameLayerName = 'unknown'
    end
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
--             hideProgressHUD()
--         elseif event:getEventName() == CUSTOM_EVENT_LOGIN then 
--             if s_CURRENT_USER.bookKey == '' then
--                 s_SCENE:gotoChooseBook()
--                 hideProgressHUD()
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

local USER_START_TYPE_NEW         = 0
local USER_START_TYPE_OLD         = 1
local USER_START_TYPE_QQ          = 2
local USER_START_TYPE_QQ_AUTHDATA = 3

local LOADING_TEXTS = {'用户登录中 30%', '加载配置中 70%', '更新单词信息中 80%', '保存用户信息中 90%'}
local _TEXT_ID_USER        = 1
local _TEXT_ID_CFG         = 2
local _TEXT_ID_UPDATE_BP   = 3
local _TEXT_ID_UPDATE_USER = 4

local function onErrorHappend(e)
    local function onError()
        s_DATABASE_MGR.close()
        s_START_FUNCTION()
    end
    s_TIPS_LAYER:showSmall(e, onError, onError)
end

function AppScene:startLoadingData(userStartType, username, password)
    local function onResponse(u, e, code)

        if e == nil and s_CURRENT_USER.tutorialStep == 0 then 
            AnalyticsTutorial(0)
            AnalyticsSmallTutorial(0)
        end

        if e ~= nil then
            if code == 202 then -- Username has already been taken [https://leancloud.cn/docs/error_code.html]
                s_TIPS_LAYER:showSmall(e)
            else
                onErrorHappend(e)
            end
            hideProgressHUD()
        elseif s_CURRENT_USER.bookKey == '' then
            self:getDataBookProgress(function ()
                s_SCENE:gotoChooseBook()
            end)
        else
            -- s_SCENE:getDailyCheckIn()
            s_SCENE:onUserServerDatasCompleted() 
        end
        
    end

    cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_USER])
    if userStartType == USER_START_TYPE_OLD then 
        s_UserBaseServer.logIn(username, password, onResponse)
    elseif userStartType == USER_START_TYPE_QQ then 
        s_UserBaseServer.onLogInByQQ(onResponse)
    elseif userStartType == USER_START_TYPE_QQ_AUTHDATA then 
        s_UserBaseServer.logInByQQAuthData(onResponse)
    else
        s_UserBaseServer.signUp(username, password, onResponse)
    end
end

function AppScene:signUp(username, password)
    self:startLoadingData(USER_START_TYPE_NEW, username, password)
end

function AppScene:logIn(username, password)
    self:startLoadingData(USER_START_TYPE_OLD, username, password)
end

function AppScene:logInByQQ()
    self:startLoadingData(USER_START_TYPE_QQ, nil, nil) 
end

function AppScene:logInByQQAuthData()
    self:startLoadingData(USER_START_TYPE_QQ_AUTHDATA, nil, nil) 
end

function AppScene:loadConfigs()
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_CFG])
    
    s_DATA_MANAGER.loadBooks()
    s_BookWord = s_DATA_MANAGER.loadBookWords()
    s_DATA_MANAGER.loadChapters()
    s_DATA_MANAGER.loadReviewBoss()

    s_WordPool = s_DATA_MANAGER.loadAllWords()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()
end

function AppScene:saveSignUpAndLogInData(onSaved)
    self:loadConfigs()

    local friendsObjId = {}
    local friends = {}
    --    print_lua_table (s_CURRENT_USER.followers)
    --    print_lua_table (s_CURRENT_USER.followees)
    for key, follower in pairs(s_CURRENT_USER.followers) do
        friendsObjId[follower.objectId] = 1
        friends[follower.objectId] = follower
    end

    for key, followee in pairs(s_CURRENT_USER.followees) do
        if friendsObjId[followee.objectId] == 1 then
            friendsObjId[followee.objectId] = 2
            friends[followee.objectId] = followee
        end
    end
    for key, var in pairs(friends) do
        if friendsObjId[key] == 2 then
            s_CURRENT_USER.friends[#s_CURRENT_USER.friends + 1] = var
        elseif friendsObjId[key] == 1 then
            s_CURRENT_USER.fans[#s_CURRENT_USER.fans + 1] = var
        end
    end
    
    s_CURRENT_USER.friendsCount = #s_CURRENT_USER.friends
    s_CURRENT_USER.fansCount = #s_CURRENT_USER.fans
    
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_UPDATE_BP])
    self:getDataBookProgress(function ()
        s_SCENE:getDataLogIn(onSaved)
    end)
end

function AppScene:getDataBookProgress(oncompleted)
    local saveuser = function ()
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER,
            function(api,result)
            end,
            function(api, code, message, description)
            end)
    end
    if s_CURRENT_USER.bookProgressObjectId == '' then
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.bookProgress,
            function(api,result)
                s_CURRENT_USER.bookProgressObjectId = s_CURRENT_USER.bookProgress.objectId
                saveuser()
                oncompleted()
            end,
            function(api, code, message, description)
                onErrorHappend(message)
                hideProgressHUD()
            end)
    else
        s_UserBaseServer.getDataBookProgress(s_CURRENT_USER.bookProgressObjectId,
            function(api, result)
                s_CURRENT_USER:parseServerDataBookProgress(result.results)
                saveuser()
                oncompleted()
            end, 
            function(api, code, message, description)
                onErrorHappend(message)
                hideProgressHUD()
            end
        )
    end
end

function AppScene:getDataLogIn(onSaved)
    local DataLogIn = require('model.user.DataLogIn')
    local function updateWeek(data, week)
        if data == nil then 
            data = DataLogIn.create()
            s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas + 1] = data
        end
        data.week = week
        data:setWeekDay(os.time())
        s_UserBaseServer.saveDataObjectOfCurrentUser(data, 
            function (api, result)
                onSaved()
                s_DATABASE_MGR.saveDataClassObject(data)
                hideProgressHUD()
            end,
            function (api, code, message, description)
                onSaved()
                s_DATABASE_MGR.saveDataClassObject(data)
                hideProgressHUD()
            end)
    end

    if s_CURRENT_USER.localTime == 0 then
        s_CURRENT_USER.localTime = os.time()
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
        updateWeek(nil, 1)
    else
        print ('os time, local time:', os.time(), s_CURRENT_USER.localTime)
        showProgressHUD(LOADING_TEXTS[_TEXT_ID_UPDATE_USER])
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
                hideProgressHUD()
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
        s_CorePlayManager.enterHomeLayer()

        showProgressHUD()
        s_HttpRequestClient.getBulletinBoard(function (index, title, content)
            local showBB = (s_CURRENT_USER.bulletinBoardMask <= 0 and index >= 0)
                       or (s_CURRENT_USER.bulletinBoardMask > 0 and math["and"](s_CURRENT_USER.bulletinBoardMask, (2 ^ index)) == 0)
            if showBB then
                local BulletinBoard = require('view.BulletinBoard')
                local bb = BulletinBoard.create() 
                bb:updateValue(index, title, content)
                s_SCENE:popup(bb)

                s_CURRENT_USER.bulletinBoardTime = s_CURRENT_USER.serverTime
            end

            hideProgressHUD()
        end)

    end)
end

function AppScene:signUpOffline(username, password)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password

    self:loadConfigs()

    local DataLogIn = require('model.user.DataLogIn')
    local data = DataLogIn.create()
    data.week = week
    data:setWeekDay(os.time())
    s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas + 1] = data
    s_DATABASE_MGR.saveDataClassObject(data)

    s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER.bookProgress)

    s_CorePlayManager.enterBookLayer()

    hideProgressHUD()
end

function AppScene:logInOffline()
    if s_CURRENT_USER.bookKey == '' then
        self:getDataBookProgress(function ()
            s_SCENE:gotoChooseBook()
        end)
    else
        s_SCENE:onUserServerDatasCompleted() 
    end
end

function applicationDidEnterBackgroundLua()
    Analytics_applicationDidEnterBackground( s_SCENE.currentGameLayerName )
end

return AppScene
