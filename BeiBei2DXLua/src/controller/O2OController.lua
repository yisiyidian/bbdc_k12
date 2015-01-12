
local O2OController = {}

function O2OController.start()
    s_SERVER.initNetworkStatus()

    if s_SERVER.isOnline() == false then
        local hasUserInLocalDB = s_DATABASE_MGR.getLastLogInUser(s_CURRENT_USER, USER_TYPE_ALL)
        if hasUserInLocalDB then
            s_SCENE:logInOffline()
        else
            local IntroLayer = require("view.login.IntroLayer")
            local introLayer = IntroLayer.create(hasUserInLocalDB)
            s_SCENE:replaceGameLayer(introLayer)
        end
    else
        local LoadingView = require("view.LoadingView")
        local loadingView = LoadingView.create()
        s_SCENE:replaceGameLayer(loadingView) 
    end
end

function O2OController.update(dt)
end

local function genRandomUserName()
    math.randomseed(os.time())
    local randomIndex = math.random(0, 65535)

    local userName = ''
    local udid = cx.CXNetworkStatus:getInstance():getDeviceUDID()
    local timestamp = cx.CXNetworkStatus:getInstance():getCurrentTimeMillis()
    userName = cx.CXUtils:md5(udid .. tostring(randomIndex) .. tostring(timestamp), userName)

    return userName
end

local PASSWORD = "bbdc123#"

function O2OController.signUp(visitLogin)
    local randomUserName = genRandomUserName()

    if s_SERVER.isOnline() == false then
        s_CURRENT_USER.usertype = USER_TYPE_GUEST
        s_SCENE:signUpOffline(randomUserName, PASSWORD)
        print("randomUserName: " .. randomUserName)
    else
        print("randomUserName: " .. randomUserName)
        showProgressHUD()
        s_UserBaseServer.isUserNameExist(randomUserName, function (api, result)
            if result.count <= 0 then -- not exist the user name
                s_CURRENT_USER.usertype = USER_TYPE_GUEST
                s_SCENE:signUp(randomUserName, PASSWORD)
                AnalyticsSignUp_Guest()
            else -- exist the user name
                visitLogin()
            end
        end,
        function (api, code, message, description)
            s_TIPS_LAYER:showSmall(message)
            hideProgressHUD()
        end)
    end
end

return O2OController
