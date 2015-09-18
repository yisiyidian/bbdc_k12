 --游戏主场景
require("cocos.init")

local GameLayer = require("layer.GameLayer")
local HudLayer = require("layer.HudLayer")
local PopupLayer = require("layer.PopupLayer")
local TipsLayer = require("layer.TipsLayer")
local TouchEventBlockLayer = require("layer.TouchEventBlockLayer")
local LoadingLayer = require("layer.LoadingLayer")
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
s_tutorial_grade_select = 0
s_tutorial_book_select = 1
s_tutorial_home = 2
s_tutorial_level_select = 3
s_tutorial_study = 4
s_tutorial_review_boss = 5
s_tutorial_summary_boss = 6
s_tutorial_complete = 7
-- define small tutorial state
s_smalltutorial_book_select = 0
s_smalltutorial_home = 1 
s_smalltutorial_level_select = 2  -- 打点没有用到
s_smalltutorial_studyRepeat1_1 = 3 -- 收集生词
s_smalltutorial_studyRepeat1_2 = 4 -- 去划单词
s_smalltutorial_studyRepeat1_3 = 5 -- 划完
s_smalltutorial_studyRepeat2_1 = 6 -- 成功收集
s_smalltutorial_studyRepeat2_2 = 7 -- 开始打铁
s_smalltutorial_studyRepeat2_3 = 8 -- 完成打铁
s_smalltutorial_studyRepeat3_1 = 9 
s_smalltutorial_studyRepeat3_2 = 10
s_smalltutorial_studyRepeat3_3 = 11
s_smalltutorial_review_boss = 12
s_smalltutorial_summary_boss = 13
s_smalltutorial_complete = 14
s_smalltutorial_complete_win = 100
s_smalltutorial_complete_lose = 101
s_smalltutorial_complete_timeout = 102

--登陆
local USER_START_TYPE_NEW         = 0
local USER_START_TYPE_OLD         = 1
local USER_START_TYPE_QQ          = 2
local USER_START_TYPE_QQ_AUTHDATA = 3
local LOADING_TEXTS = {'用户登录中 30%', '加载配置中 70%', '保存用户信息中 80%', '更新单词信息中 90%'}

-- k12打点流程
-- 进入输入用户名界面   0
-- 进入输入密码界面    1
-- 进入输入老师名字界面  2
-- 进入选择年级界面    3
-- 进入选书界面  4
-- 进入主界面   5
-- 进入选小关   6
-- 进入趁热打铁  7
-- 进入趁热打铁胜利界面  8
-- 进入复习boss    9
-- 进入复习boss胜利界面    10
-- 进入总结boss    11
-- 进入总结boss胜利界面    12
-- 进入总结boss失败界面    13

s_K12_inputUserName = 0
s_K12_inputUserPassWord = 1
s_K12_inputTeacherName = 2
s_K12_selectGrade = 3
s_K12_selectBook = 4
s_K12_enterHomeLayer = 5
s_K12_enterLevelLayer = 6
s_K12_strikeIron = 7
s_K12_strikeIronEnd = 8
s_K12_reviewBoss = 9
s_K12_reviewBossEnd = 10
s_K12_summaryBoss = 11
s_K12_summaryBossSuccess = 12
s_K12_summaryBossFailure = 13
s_K12_end = 100

-- 畅玩版

s_summary_enterApp = 1
s_summary_login = 2
s_summary_phonenumber = 3
s_summary_phonepass = 4
s_summary_sex = 5
s_summary_anothername = 6
s_summary_password = 7
s_summary_register8 = 8

s_summary_selectGrade = 9
s_summary_selectBook = 10
s_summary_enterHomeLayer = 11
s_summary_enterTryGame = 12
s_summary_enterLevelLayer = 13
s_summary_enterFirstPopup = 14
s_summary_enterFirstLevel = 15
s_summary_doFirstWord = 16
s_summary_successFirstLevel = 17
s_summary_failFirstLevel = 18
s_summary_enterSecondPopup = 19
s_summary_enterSecondLevel = 20

-- define review boss tutorial
-- 新手引导步骤 v213
-- 选择教育程度
s_guide_step_selectGrade = 1
-- 选择课本
s_guide_step_selectBook = 2
-- 进入主页面
s_guide_step_enterHome = 3
-- 进入情景页
s_guide_step_enterStory1 = 4
s_guide_step_enterStory2 = 5
s_guide_step_enterStory3 = 6
s_guide_step_enterStory4 = 7
-- 尝试boss玩法
s_guide_step_tryBoss = 8
s_guide_step_enterStory5 = 9
-- 情景结束
-- 进入选小关
s_guide_step_enterLevel = 10
-- 进入弹出面板
s_guide_step_enterPopup = 11
-- 进入单词卡片
s_guide_step_enterCard = 12
-- 返回到弹出面板
s_guide_step_returnPopup = 13
-- boss第一个词
s_guide_step_first = 14
-- boss第二个词
s_guide_step_second = 15
-- 宝箱引导1
s_guide_step_bag1 = 16
-- 宝箱引导2
s_guide_step_bag2 = 17
-- 宝箱引导3
s_guide_step_bag3 = 18
-- 宝箱引导4
s_guide_step_bag4 = 19
-- 宝箱引导5
s_guide_step_bag5 = 20
-- 宝箱引导6
s_guide_step_bag6 = 21
-- 宝箱引导7
s_guide_step_bag7 = 22


-- 引导结束
s_guide_step_over = 100


local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()

    scene.currentGameLayerName = 'unknown'

    scene.rootLayer = cc.Layer:create()
    scene.rootLayer:setPosition(s_DESIGN_OFFSET_WIDTH, 0)
    scene:addChild(scene.rootLayer)

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
    
    scene.loadingLayer = LoadingLayer.create()
    scene.rootLayer:addChild(scene.loadingLayer)

    if BUILD_TARGET == BUILD_TARGET_RELEASE then 
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

local usingTimeSaveToLocalDB = 0
-- delta time : seconds
local function update(dt)
    -- s_O2OController.update(dt)

    -- if s_CURRENT_USER.sessionToken ~= '' and s_CURRENT_USER.serverTime >= 0 then
        -- s_CURRENT_USER.serverTime = s_CURRENT_USER.serverTime + dt
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
    -- end 

    if IS_DEVELOPMENT_MODE and s_WordDictionaryDatabase and not s_WordDictionaryDatabase.allwords and s_SCENE.currentGameLayerName == 'HomeLayer' then
        -- print(s_WordDictionaryDatabase.nextframe, 's_WordDictionaryDatabase.nextframe')
        if s_WordDictionaryDatabase.nextframe == WDD_NEXTFRAME_STATE__RM_LOAD then
            showProgressHUD('', true)
            s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__STARTLOADING
        elseif s_WordDictionaryDatabase.nextframe == WDD_NEXTFRAME_STATE__STARTLOADING then
            s_WordDictionaryDatabase.init()
            hideProgressHUD(true)
        end
    end

    if s_CURRENT_USER ~= nil and s_CURRENT_USER.dataDailyUsing:isInited() then
        if s_CURRENT_USER.dataDailyUsing:isToday() then
            s_CURRENT_USER.dataDailyUsing:update(dt)
            usingTimeSaveToLocalDB = usingTimeSaveToLocalDB + dt
            if usingTimeSaveToLocalDB > 5 * 60 then -- 5 min
                usingTimeSaveToLocalDB = 0
                s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER.dataDailyUsing, s_CURRENT_USER.objectId, s_CURRENT_USER.username)
            end
        else
            s_CURRENT_USER.dataDailyUsing:reset()
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

--替换游戏的主Layer
--此时不会释放资源
--TODO 释放资源
function AppScene:replaceGameLayer(newLayer)
    self.gameLayer:removeAllChildren()
    self.gameLayer:addChild(newLayer)
    --
    print("replace GameLayer OK")
    updateCurrentEverydayInfo()

    if newLayer.class ~= nil and newLayer.class.__cname ~= nil then 
        self.currentGameLayerName = newLayer.class.__cname
        if IS_DEVELOPMENT_MODE and newLayer.class.__cname == 'HomeLayer' then
            s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__INIT
            print(s_WordDictionaryDatabase.nextframe, 's_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__INIT')
        end
    else
        self.currentGameLayerName = 'unknown'
    end
    -- Analytics_replaceGameLayer(self.currentGameLayerName)
end

function AppScene:addLoadingView(needUpdate)
    self.loadingLayer.lockTouch()
    local k = self.loadingLayer:getChildrenCount()
    if k <= 0 then
        self.loadingLayer:removeAllChildren()
        local LoadingLayer = require("view.LoadingView")
        local loadingExtra = LoadingLayer.create(needUpdate)
        self.loadingLayer:addChild(loadingExtra)  
    end 
end

function AppScene:removeLoadingView()
    if self.loadingLayer:getChildrenCount() > 0 then
        local action = cc.DelayTime:create(0.5)
        self.loadingLayer:runAction(cc.Sequence:create(action,cc.CallFunc:create(function()
            self.loadingLayer.unlockTouch()
            self.loadingLayer:removeAllChildren()

            if IS_DEVELOPMENT_MODE and self.currentGameLayerName == 'HomeLayer' then
                s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD
                print(s_WordDictionaryDatabase.nextframe, 's_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD')
            end

        end)))
    end
end

function AppScene:popup(popupNode)
    self.popupLayer.listener:setSwallowTouches(true)
    self.popupLayer:removeAllChildren()
    if self.rpAction ~= nil then
        self:stopAction(self.rpAction)
        self.rpAction = nil
    end
    self.popupLayer:addBackground()
    self.popupLayer:addChild(popupNode)
    -- print("AppScene:popup:"..popupNode.__cname)
end

function AppScene:removeAllPopups()
    self.popupLayer.listener:setSwallowTouches(false)
    local action1 = cc.FadeOut:create(0.2)

    --移除所有的弹出面板
    -- print("AppScene:removeAllPopups()")

    --怎么能这么写！！！！
    if self.popupLayer.backColor ~= nil and not tolua.isnull(self.popupLayer.backColor) then
        self.popupLayer.backColor:runAction(action1)
    end
    s_SCENE:callFuncWithDelay(0.2, function ()
        self.rpAction = nil
        self.popupLayer:removeAllChildren()
    end)
end

function AppScene:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self.rpAction = self:runAction(sequence)
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

function applicationWillEnterForeground()
    -- s_O2OController.showRestartTipWhenOfflineToOnline()
end

function applicationDidEnterBackgroundLua()
    if s_SCENE ~= nil then
        Analytics_applicationDidEnterBackground( s_SCENE.currentGameLayerName )
    end
end

function AppScene:checkInAnimation()
    -- local DramaLayer = require("view.home.DramaLayer")
    -- local dramaLayer = DramaLayer.create()
    -- self:replaceGameLayer(dramaLayer)
    -- test
    local HomeLayer = require("view.home.HomeLayer")
    local homeLayer = HomeLayer.create(true)
    homeLayer:setName('homeLayer')
    self:replaceGameLayer(homeLayer)
    homeLayer:showDataLayer(true)
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()



    -- local delay = cc.DelayTime:create(3)
    -- local hide = cc.CallFunc:create(function()
        
    -- end,{})
    -- self:runAction(cc.Sequence:create(delay,hide))

end

function AppScene:checkInOver(homeLayer)
    s_HUD_LAYER:removeChildByName('missionComplete')
    homeLayer:hideDataLayer()
    --s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
end

--登陆
function AppScene:startLoadingData(userStartType, username, password)
    local function onResponse(u, e, code)

        if e == nil and s_CURRENT_USER.tutorialStep == 0 then 
            AnalyticsTutorial(0)
            AnalyticsSmallTutorial(0)
        end

        if e ~= nil then
            onErrorHappend(e)
            hideProgressHUD()
        elseif s_CURRENT_USER.bookKey == '' then
            s_CorePlayManager.enterEducationLayer()
        else
            -- s_SCENE:getDailyCheckIn()
            -- s_SCENE:onUserServerDatasCompleted() 
            s_O2OController.getUserDatasOnline()
        end
        
    end

    cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
    -- showProgressHUD(LOADING_TEXTS[_TEXT_ID_USER])
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


return AppScene
