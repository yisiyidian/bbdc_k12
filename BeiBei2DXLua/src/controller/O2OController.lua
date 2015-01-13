
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

local function onErrorHappend(e)
    local function onError()
        cx.CXAvos:getInstance():logOut()
        s_LocalDatabaseManager.setLogOut(true)
        s_LocalDatabaseManager.close()
        s_START_FUNCTION()
    end
    s_TIPS_LAYER:showSmall(e, onError, onError)
end

----------------------------------------------------------------------------------------------------------------

local O2OController = {}

function O2OController.update(dt)
end

----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
-- start

function O2OController.start()
    s_SERVER.initNetworkStatus()

    local hasUserInLocalDB = s_LocalDatabaseManager.getLastLogInUser(s_CURRENT_USER, USER_TYPE_ALL)

    if s_SERVER.isOnline() == false then
        if hasUserInLocalDB then
            O2OController.logInOffline()
        else
            local IntroLayer = require("view.login.IntroLayer")
            local introLayer = IntroLayer.create(hasUserInLocalDB)
            s_SCENE:replaceGameLayer(introLayer)
        end
    else
        -- go to O2OController.onAssetsManagerCompleted()
        local LoadingView = require("view.LoadingView")
        local loadingView = LoadingView.create()
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
        local IntroLayer = reloadModule("view.login.IntroLayer")
        local introLayer = IntroLayer.create(true)
        s_SCENE:replaceGameLayer(introLayer)
    else
        local IntroLayer = reloadModule("view.login.IntroLayer")
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
    local DataUser = require('model.user.DataUser')
    local tmpUser = DataUser.create()
    local hasUserInLocalDB = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_ALL)
    local isLocalNewerThenServer = false

    local function onResponse(u, e, code)

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
                s_CURRENT_USER = tmpUser
                print ('\n\n\nisLocalNewerThenServer >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
                print_lua_table (s_CURRENT_USER)
                print ('isLocalNewerThenServer <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n\n')
                s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER, nil, username)
                s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER, 
                    function (api, result) 
                        O2OController.getUserDatasOnline()
                    end, 
                    function (api, code, message, description)
                        O2OController.getUserDatasOnline()
                    end
                )
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
    if s_SERVER.isOnline() == false then
        s_CURRENT_USER.usertype = USER_TYPE_GUEST
        O2OController.signUpOffline(randomUserName, PASSWORD)
    else
        s_UserBaseServer.isUserNameExist(randomUserName, function (api, result)
            if result.count <= 0 then -- not exist the user name
                s_CURRENT_USER.usertype = USER_TYPE_GUEST
                O2OController.signUpOnline(randomUserName, PASSWORD)
                AnalyticsSignUp_Guest()
            else -- exist the user name
                O2OController.signUpWithRandomUserName()
            end
        end,
        function (api, code, message, description)
            s_TIPS_LAYER:showSmall(message)
            hideProgressHUD()
        end)
    end
end

function O2OController.signUpOffline(username, password)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER, nil, username)

    O2OController.loadConfigs()
    O2OController.getDataBookProgress()
    O2OController.getDataLogIn()

    s_CorePlayManager.enterBookLayer()

    hideProgressHUD()
end

function O2OController.logInOffline()
    O2OController.loadConfigs()
    O2OController.getDataBookProgress()
    O2OController.getDataLogIn()

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
    O2OController.getDataBookProgress(function () 
        O2OController.getDataLogIn(function ()
            if s_CURRENT_USER.bookKey == '' then
                s_CorePlayManager.enterBookLayer() 
            else
                s_CorePlayManager.enterHomeLayer()
                O2OController.getBulletinBoard()    
            end 
        end)
    end)
end

function O2OController.loadConfigs()
    showProgressHUD(LOADING_TEXTS[_TEXT_ID_CFG])
    
    s_DATA_MANAGER.loadBooks()
    s_BookWord = s_DATA_MANAGER.loadBookWords()
    s_DATA_MANAGER.loadChapters()
    s_DATA_MANAGER.loadReviewBoss()

    s_WordPool = s_DATA_MANAGER.loadAllWords()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()
end

function O2OController.getDataBookProgress(oncompleted)
    -- get local data

    s_CURRENT_USER.bookProgress.userId = s_CURRENT_USER.objectId
    s_CURRENT_USER.bookProgress.username = s_CURRENT_USER.username

    local localDatas = s_LocalDatabaseManager.getDatas(s_CURRENT_USER.bookProgress.className, s_CURRENT_USER.objectId, s_CURRENT_USER.username)
    local lastLocalData = nil
    local lastTime = 0
    print ('\n\n\ngetDataBookProgress >>>')
    print (localDatas)
    print_lua_table (localDatas)
    print ('getDataBookProgress <<<\n\n\n')
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

    if s_SERVER.isOnline() == false then 
        if lastLocalData ~= nil then
            parseLocalDatabaseToUserData(lastLocalData, s_CURRENT_USER.bookProgress)
        end
        if oncompleted ~= nil then oncompleted() end
        return
    end

    -- handle online

    local afterGetDataBookProgress = function ()
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
        s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER)

        if lastLocalData ~= nil and lastLocalData.updatedAt > s_CURRENT_USER.bookProgress.updatedAt then
            -- send local to server
            lastLocalData.objectId = s_CURRENT_USER.bookProgress.objectId
            updateDataFromUser(lastLocalData, s_CURRENT_USER)
            parseLocalDatabaseToUserData(lastLocalData, s_CURRENT_USER.bookProgress)
            s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.bookProgress)
        else
            -- save server to local
            s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER.bookProgress)
        end

        if oncompleted ~= nil then oncompleted() end
    end

    if s_CURRENT_USER.bookProgressObjectId == '' then
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.bookProgress,
            function(api,result)
                s_CURRENT_USER.bookProgressObjectId = s_CURRENT_USER.bookProgress.objectId
                afterGetDataBookProgress()
            end,
            function(api, code, message, description)
                onErrorHappend(message)
                hideProgressHUD()
            end)
    else
        s_UserBaseServer.getDataBookProgress(s_CURRENT_USER.bookProgressObjectId,
            function(api, result)
                s_CURRENT_USER:parseServerDataBookProgress(result.results)
                afterGetDataBookProgress()
            end, 
            function(api, code, message, description)
                onErrorHappend(message)
                hideProgressHUD()
            end
        )
    end
end -- O2OController.getDataBookProgress(oncompleted)

function O2OController.getDataLogIn(onSaved)
    local DataLogIn = require('model.user.DataLogIn')

    local function onUpdateWeekCompleted(data)
        onSaved()
        s_LocalDatabaseManager.saveDataClassObject(data)
        hideProgressHUD()
    end

    -- save to local or server
    local function updateWeek(data, week)
        if data == nil then 
            data = DataLogIn.create()
            s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas + 1] = data
        end
        updateDataFromUser(data, s_CURRENT_USER)
        data.week = week
        data:setWeekDay(os.time())

        if s_SERVER.isOnline() == false then
            onUpdateWeekCompleted(data)
        else
            s_UserBaseServer.saveDataObjectOfCurrentUser(
                data, 
                function (api, result) onUpdateWeekCompleted(data) end, 
                function (api, code, message, description) onUpdateWeekCompleted(data) end
            )
        end
    end

    local className = 'DataLogIn'
    local localDatas = s_LocalDatabaseManager.getDatas(className, s_CURRENT_USER.objectId, s_CURRENT_USER.username)

    if s_CURRENT_USER.localTime == 0 then
        s_CURRENT_USER.localTime = os.time()
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
        updateWeek(nil, 1)
    else
        print ('os time, local time:', os.time(), s_CURRENT_USER.localTime)
        showProgressHUD(LOADING_TEXTS[_TEXT_ID_UPDATE_USER])
        
        local currentWeeks = getCurrentLogInWeek(os.time() - s_CURRENT_USER.localTime)
        -- local database
        local localCurrentData = nil
        for i, v in ipairs(localDatas) do
            if v.week == currentWeeks then
                localCurrentData = v
                break
            end
        end

        if s_SERVER.isOnline() == false then -- offline
            if localCurrentData ~= nil then
                updateWeek(localCurrentData, localCurrentData.week)
            else
                updateWeek(nil, currentWeeks)
            end
        else -- online
            s_UserBaseServer.getDataLogIn(s_CURRENT_USER.objectId, currentWeeks,
                function (api, result)
                    s_CURRENT_USER:parseServerDataLogIn(result.results)
                    if #(result.results) <= 0 then
                        if localCurrentData ~= nil then
                            updateWeek(localCurrentData, localCurrentData.week)
                            s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas + 1] = data
                        else
                            updateWeek(nil, currentWeeks)
                        end
                    else
                        local data = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
                        if localCurrentData ~= nil then
                            data:updateFrom(localCurrentData)
                        end
                        updateWeek(data, data.week)
                    end
                end,
                function (api, code, message, description)
                    onSaved()
                    hideProgressHUD()
                end)
        end
    end
end

function O2OController.getBulletinBoard()
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
end

----------------------------------------------------------------------------------------------------------------

return O2OController
