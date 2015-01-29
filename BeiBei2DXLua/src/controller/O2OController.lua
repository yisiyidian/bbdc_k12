
local DataUser -- = require('model.user.DataUser')
local DataEverydayInfo -- = require('model.user.DataEverydayInfo')
local DataDailyStudyInfo -- = require('model.user.DataDailyStudyInfo')

local BulletinBoard -- = require('view.BulletinBoard')
local IntroLayer -- = require("view.login.IntroLayer")
local LoadingView -- = require("view.LoadingView")

----------------------------------------------------------------------------------------------------------------

local function genRandomUserName()
    math.randomseed(os.time())
    local randomIndex = math.random(0, 65535)

    local userName = ''
    local udid = cx.CXNetworkStatus:getInstance():getDeviceUDID()
    local timestamp = cx.CXNetworkStatus:getInstance():getCurrentTimeMillis()
    userName = cx.CXUtils:md5(udid .. tostring(randomIndex) .. tostring(timestamp), userName)

    return userName
end

local PASSWORD = 'bbdc123#'

local USER_START_TYPE_NEW         = 0
local USER_START_TYPE_OLD         = 1
local USER_START_TYPE_QQ          = 2
local USER_START_TYPE_QQ_AUTHDATA = 3

local LOADING_TEXTS = {'用户登录中 30%', '加载配置中 70%', '更新单词信息中 80%', '保存用户信息中 90%'}
local _TEXT_ID_USER        = 1
local _TEXT_ID_CFG         = 2
local _TEXT_ID_UPDATE_BP   = 3
local _TEXT_ID_UPDATE_USER = 4

local function onError()
    if s_SERVER.hasSessionToken() then cx.CXAvos:getInstance():logOut() end
    s_LocalDatabaseManager.setLogOut(true)
    s_LocalDatabaseManager.close()
    s_START_FUNCTION()
end

local function onErrorHappend(e)
    s_TIPS_LAYER:showSmall(e, onError, onError)
end

----------------------------------------------------------------------------------------------------------------

local O2OController = {}

function O2OController.update(dt)
end

function O2OController.showRestartTipWhenOfflineToOnline()
    if s_SERVER.isNetworkConnectedNow() and (not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.hasSessionToken()) then
        s_TIPS_LAYER:showSmall('发现网络链接，您还没有登录，现在需要登录吗？', onError, nil)
    end
end

----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
-- start

function O2OController.start()
    DataUser = require('model.user.DataUser')
    DataEverydayInfo = require('model.user.DataEverydayInfo')
    DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')

    BulletinBoard = require('view.BulletinBoard')
    IntroLayer = require("view.login.IntroLayer")
    LoadingView = require("view.LoadingView")

    s_SERVER.initNetworkStatus()

    local hasUserInLocalDB = s_LocalDatabaseManager.getLastLogInUser(s_CURRENT_USER, USER_TYPE_ALL)

    if s_SERVER.isNetworkConnectedWhenInited() == false then
        if hasUserInLocalDB then
            O2OController.logInOffline()
        else
            local introLayer = IntroLayer.create(hasUserInLocalDB)
            s_SCENE:replaceGameLayer(introLayer)
        end
    else
        -- go to O2OController.onAssetsManagerCompleted()
        local loadingView = LoadingView.create(true)
        s_SCENE:replaceGameLayer(loadingView) 

    end
end

function O2OController.onAssetsManagerCompleted()
    hideProgressHUD()
    -- O2OController.start() : has got user from local database
    local hasUserInLocalDB = s_LocalDatabaseManager.getLastLogInUser(s_CURRENT_USER, USER_TYPE_ALL)

    if not s_LocalDatabaseManager.isLogOut() and hasUserInLocalDB then    
        if s_CURRENT_USER.usertype == USER_TYPE_QQ then
            O2OController.logInByQQAuthData()
        else
            O2OController.logInOnline(s_CURRENT_USER.username, s_CURRENT_USER.password)
        end
    elseif s_LocalDatabaseManager.isLogOut() and hasUserInLocalDB then
        local introLayer = IntroLayer.create(true)
        s_SCENE:replaceGameLayer(introLayer)
    else
        local introLayer = IntroLayer.create(false)
        s_SCENE:replaceGameLayer(introLayer)
    end
end

----------------------------------------------------------------------------------------------------------------
-- sign up & log in

function O2OController.signUpOnline(username, password)
    O2OController.startLoadingData(USER_START_TYPE_NEW, username, password)
end

function O2OController.logInOnline(username, password)
    O2OController.startLoadingData(USER_START_TYPE_OLD, username, password)
end

function O2OController.logInByQQ()
    O2OController.startLoadingData(USER_START_TYPE_QQ, nil, nil) 
end

function O2OController.logInByQQAuthData()
    O2OController.startLoadingData(USER_START_TYPE_QQ_AUTHDATA, nil, nil) 
end

function O2OController.startLoadingData(userStartType, username, password)
    local tmpUser = DataUser.create()
    local hasUserInLocalDB = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_ALL)
    local isLocalNewerThenServer = false

    local function onResponse(u, e, code)
        -- u is s_CURRENT_USER and u is server data
        if e == nil and s_CURRENT_USER.tutorialStep == 0 then 
            AnalyticsTutorial(0)
            AnalyticsSmallTutorial(0)
        end

        if e ~= nil then
            if code == 202 or code == 210 then 
            -- https://leancloud.cn/docs/error_code.html
            -- 202 : Username has already been taken 
            -- 210 : The username and password mismatch
                s_TIPS_LAYER:showSmall(e)
            else
                onErrorHappend(e .. '\n username: ' .. username)
            end
            hideProgressHUD()
        else -- no error
            if hasUserInLocalDB and tmpUser.objectId ~= '' and tmpUser.username == username and tmpUser.updatedAt > s_CURRENT_USER.updatedAt then
                isLocalNewerThenServer = true
            end

            if isLocalNewerThenServer then
                tmpUser.objectId = s_CURRENT_USER.objectId
                tmpUser.userId = s_CURRENT_USER.objectId
                tmpUser.sessionToken = s_CURRENT_USER.sessionToken

                synUserAfterLogIn(tmpUser, s_CURRENT_USER, function (updatedAt, error)
                    if error == nil then
                        tmpUser.updatedAt = getSecondsFromString(updatedAt)
                    end
                    s_CURRENT_USER = tmpUser
                    
                    print ('\n\n\nisLocalNewerThenServer >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
                    print_lua_table (s_CURRENT_USER)
                    print ('isLocalNewerThenServer <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n\n')

                    s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER, nil, username)
                    O2OController.getUserDatasOnline()
                end)
                
            else
                O2OController.getUserDatasOnline()
            end
        end
        
    end

    cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_USER])
    if userStartType == USER_START_TYPE_OLD then 
        print(string.format('startLoadingData: objectId:%s, username:%s, updatedAt:%f, createdAt:%f', tmpUser.objectId, tmpUser.username, tmpUser.updatedAt, tmpUser.createdAt))
        if hasUserInLocalDB and tmpUser.username == username and tmpUser.objectId == '' then
            print(string.format('startLoadingData: objectId:%s, username:%s, updatedAt:%f, createdAt:%f', tmpUser.objectId, tmpUser.username, tmpUser.updatedAt, tmpUser.createdAt))
            isLocalNewerThenServer = true
            s_UserBaseServer.signUp(username, password, onResponse)
        else
            s_UserBaseServer.logIn(username, password, onResponse)
        end
    elseif userStartType == USER_START_TYPE_QQ then 
        s_UserBaseServer.onLogInByQQ(onResponse)
    elseif userStartType == USER_START_TYPE_QQ_AUTHDATA then 
        s_UserBaseServer.logInByQQAuthData(onResponse)
    else
        s_UserBaseServer.signUp(username, password, onResponse)
    end
end

function O2OController.signUpWithRandomUserName()
    local randomUserName = genRandomUserName()

    showProgressHUD()
    if s_SERVER.isNetworkConnectedWhenInited() == false then
        s_CURRENT_USER.usertype = USER_TYPE_GUEST
        O2OController.signUpOffline(randomUserName, PASSWORD)
    else
        isUsernameExist(randomUserName, function (exist, error)
            if error then
                s_TIPS_LAYER:showSmall(error.message)
                hideProgressHUD()
            elseif not exist then -- not exist the user name
                s_CURRENT_USER.usertype = USER_TYPE_GUEST
                O2OController.signUpOnline(randomUserName, PASSWORD)
                AnalyticsSignUp_Guest()
            else -- exist the user name
                O2OController.signUpWithRandomUserName()
            end
        end)
    end
end

function O2OController.signUpOffline(username, password)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER, nil, username)

    O2OController.loadConfigs()
    O2OController.getDataLevelInfo()
    O2OController.getDataEverydayInfo()

    s_CorePlayManager.enterBookLayer()

    hideProgressHUD()
end

function O2OController.logInOffline()
    O2OController.loadConfigs()
    O2OController.getDataLevelInfo()
    O2OController.getDataEverydayInfo()

    if s_CURRENT_USER.bookKey == '' then
        s_CorePlayManager.enterBookLayer()
    else
        s_CorePlayManager.enterHomeLayer()
    end

    hideProgressHUD()
end

----------------------------------------------------------------------------------------------------------------

function O2OController.getUserDatasOnline()
    O2OController.loadConfigs()
    O2OController.getDataLevelInfo(function () 
        O2OController.getDataEverydayInfo(function ()
            if s_CURRENT_USER.bookKey == '' then
                s_CorePlayManager.enterBookLayer() 
            else
                showProgressHUD()
                s_UserBaseServer.synBookRelations(nil, function ()
                    s_UserBaseServer.synUserConfig(function ()

                        local dayString = getDayStringForDailyStudyInfo(os.time())
                        local today = s_LocalDatabaseManager.getDataDailyStudyInfo(dayString)
                        if today == nil then
                            today = DataDailyStudyInfo.createData(s_CURRENT_USER.bookKey, dayString, 0, 0, os.time(), 0)
                        end
                        s_UserBaseServer.synTodayDailyStudyInfo(today, function ()
                            s_CorePlayManager.enterHomeLayer()
                            O2OController.getBulletinBoard()    
                            hideProgressHUD()
                        end, true)

                    end)
                end)
            end 
        end)
    end)
end

function O2OController.loadConfigs()
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_CFG])
    
    s_DataManager.loadBooks()
    s_BookWord = s_DataManager.loadBookWords()
    s_DataManager.loadChapters()
    s_DataManager.loadReviewBoss()
    s_DataManager.loadProduct()

    s_WordPool = s_DataManager.loadAllWords()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()
end

function O2OController.getDataLevelInfo(oncompleted)
    -- get local data

    s_CURRENT_USER.levelInfo.userId = s_CURRENT_USER.objectId
    s_CURRENT_USER.levelInfo.username = s_CURRENT_USER.username

    local localDatas = s_LocalDatabaseManager.getDatas(s_CURRENT_USER.levelInfo.className, s_CURRENT_USER.objectId, s_CURRENT_USER.username)
    local lastLocalData = nil
    local lastTime = 0
    print ('\n\n\ngetDataLevelInfo >>>')
    print (localDatas)
    print_lua_table (localDatas)
    print ('getDataLevelInfo <<<\n\n\n')
    for key, value in ipairs(localDatas) do
        local time = value.updatedAt
        if time <= 0 and lastTime == 0 then 
            lastLocalData = value
        elseif time > lastTime then
            lastTime = time
            lastLocalData = value
        end
    end

    -- handle offline

    if not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then 
        if lastLocalData ~= nil then
            parseLocalDBDataToClientData(lastLocalData, s_CURRENT_USER.levelInfo)
        else
            s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER.levelInfo)
        end
        if oncompleted ~= nil then oncompleted() end
        return
    end

    -- handle online

    local afterGetDataLevelInfo = function ()
        print('afterGetDataLevelInfo')
        print_lua_table(s_CURRENT_USER)
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
        s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER)

        if lastLocalData ~= nil and lastLocalData.updatedAt > s_CURRENT_USER.levelInfo.updatedAt then
            -- send local to server
            lastLocalData.objectId = s_CURRENT_USER.levelInfo.objectId
            updateDataFromUser(lastLocalData, s_CURRENT_USER)
            parseLocalDBDataToClientData(lastLocalData, s_CURRENT_USER.levelInfo)
            s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.levelInfo)
        else
            -- save server to local
            s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER.levelInfo, s_CURRENT_USER.levelInfo.userId, s_CURRENT_USER.levelInfo.username)
        end

        if oncompleted ~= nil then oncompleted() end
    end

    if s_CURRENT_USER.levelInfoObjectId == '' then
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.levelInfo,
            function(api,result)
                s_CURRENT_USER.levelInfoObjectId = s_CURRENT_USER.levelInfo.objectId
                afterGetDataLevelInfo()
            end,
            function(api, code, message, description)
                onErrorHappend(message)
                hideProgressHUD()
            end)
    else
        s_UserBaseServer.getDataLevelInfo(s_CURRENT_USER.levelInfoObjectId,
            function(api, result)
                s_CURRENT_USER:parseServerDataLevelInfo(result.results)
                afterGetDataLevelInfo()
            end, 
            function(api, code, message, description)
                onErrorHappend(message)
                hideProgressHUD()
            end
        )
    end
end -- O2OController.getDataLevelInfo(oncompleted)

---------------------------------------------------------------------------------------------------

local function onUpdateWeekCompleted(serverDatas, currentWeek, onSaved)
    if serverDatas ~= nil then
        for i, v in ipairs(serverDatas) do
            local data = DataEverydayInfo.create()
            parseServerDataToClientData(v, data)
            s_LocalDatabaseManager.saveDataClassObject(data, data.userId, data.username, " and week = " .. tostring(data.week))
        end
    elseif currentWeek ~= nil then
        s_LocalDatabaseManager.saveDataClassObject(currentWeek, currentWeek.userId, currentWeek.username, " and week = " .. tostring(currentWeek.week))
    end

    DataEverydayInfo.getAllDatasFromLocalDB(function (row)
        local data = DataEverydayInfo.create()
        parseServerDataToClientData(row, data)
        s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas + 1] = data
    end)

    print('s_CURRENT_USER.logInDatas')
    print_lua_table(s_CURRENT_USER.logInDatas)

    hideProgressHUD()
    if onSaved then onSaved() end
end

-- save to local or server
local function updateWeek(localDBDatas, week, onSaved)
    local currentWeek = DataEverydayInfo.create()
    updateDataFromUser(currentWeek, s_CURRENT_USER)
    currentWeek.week = week
    currentWeek:setWeekDay(os.time())

    local localCurrentDBData = localDBDatas['currentWeek']
    if localDBData ~= nil then currentWeek:updateFrom(localCurrentData) end

    if not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then 
        onUpdateWeekCompleted(nil, currentWeek, onSaved)
    else
        local unsavedWeeks = localDBDatas['noObjectIdDatas']
        sysEverydayInfo(unsavedWeeks, currentWeek, function (serverDatas, error) 
            if error == nil then
                onUpdateWeekCompleted(serverDatas, nil, onSaved)
            else
                onUpdateWeekCompleted(nil, currentWeek, onSaved)
            end
        end)
    end
end

function O2OController.getDataEverydayInfo(onSaved)
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_UPDATE_USER])
    if s_CURRENT_USER.localTime == 0 then
        -- 1st log in
        s_CURRENT_USER.localTime = os.time()
        local userdata = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId, ['localTime']=s_CURRENT_USER.localTime}
        local localDBDatas = {['noObjectIdDatas']=noObjectIdDatas, ['currentWeek']=currentWeek}
        saveToServer(userdata, function (datas, error) updateWeek(localDBDatas, 1, onSaved) end)
    else
        local localDBDatas = DataEverydayInfo.getNoObjectIdAndCurrentWeekDatasFromLocalDB()
        updateWeek(localDBDatas, 1, onSaved)
    end
end

---------------------------------------------------------------------------------------------------

function O2OController.getBulletinBoard()
    showProgressHUD()
    s_HttpRequestClient.getBulletinBoard(function (index, title, content)
        local showBB = (s_CURRENT_USER.bulletinBoardMask <= 0 and index >= 0)
                   or (s_CURRENT_USER.bulletinBoardMask > 0 and math["and"](s_CURRENT_USER.bulletinBoardMask, (2 ^ index)) == 0)
        if showBB then
            local bb = BulletinBoard.create() 
            bb:updateValue(index, title, content)
            s_SCENE:popup(bb)

            s_CURRENT_USER.bulletinBoardTime = os.time() -- s_CURRENT_USER.serverTime
        end

        hideProgressHUD()
    end)
end

----------------------------------------------------------------------------------------------------------------

return O2OController
