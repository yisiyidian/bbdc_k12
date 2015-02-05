
-- *************************************

local app_version_debug   = 180000
local app_version_release = 180000

-- All test code must in example.example
local TEST_CODE   = 1 -- constant value
local NORMAL_CODE = 0 -- constant value
local test_code = NORMAL_CODE -- switch normal or test in this line

-- *************************************

cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
cc.FileUtils:getInstance():addSearchPath("res/sound/words/")

require("cocos.init")

-- cclog
local cclog = function(...) print(string.format(...)) end

local saveLuaError = function (msg) end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    saveLuaError("LUA ERROR: " .. tostring(msg) .. '. ' .. tostring(debug.traceback()))
    LUA_ERROR = LUA_ERROR .. '\n' .. tostring(msg) .. '\n' .. tostring(debug.traceback())
    return msg
end

function LOGTIME(des)
    if BUILD_TARGET == BUILD_TARGET_RELEASE then return end
    print('LOGTIME', des, os.time())
    LUA_ERROR = LUA_ERROR .. '\n' .. 'LOGTIME:' .. des .. ', ' .. tostring(os.time())
end

local start
start = function ()
    s_APP_VERSION = app_version_release
    
    require("common.global")
    require("AppVersionInfo")
    initBuildTarget()
    initApp(start)
    if IS_SNS_QQ_LOGIN_AVAILABLE or IS_SNS_QQ_SHARE_AVAILABLE then 
        cx.CXAvos:getInstance():initTencentQQ(SNS_QQ_APPID, SNS_QQ_APPKEY) 
    end

    if BUILD_TARGET == BUILD_TARGET_RELEASE then
        -- remove print debug info when release app
        print = function ( ... )
        end

        test_code = NORMAL_CODE

        s_debugger.configLog(false, false)
        DEBUG_PRINT_LUA_TABLE     = false
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false -- TODO
        s_SERVER.production       = 1
        s_SERVER.hasLog           = false
        s_SERVER.closeNetwork     = false

        s_SERVER.appName = LEAN_CLOUD_NAME
        s_SERVER.appId = LEAN_CLOUD_ID
        s_SERVER.appKey = LEAN_CLOUD_KEY

    else
        s_debugger.configLog(true, true)
        DEBUG_PRINT_LUA_TABLE     = true
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false
        s_SERVER.production       = 0
        s_SERVER.hasLog           = true

        if BUILD_TARGET == BUILD_TARGET_RELEASE_TEST then
            test_code = NORMAL_CODE

            s_SERVER.closeNetwork = false
            
            s_SERVER.appName = LEAN_CLOUD_NAME
            s_SERVER.appId = LEAN_CLOUD_ID
            s_SERVER.appKey = LEAN_CLOUD_KEY
        else
            s_APP_VERSION = app_version_debug

            s_SERVER.appName = LEAN_CLOUD_NAME_TEST
            s_SERVER.appId = LEAN_CLOUD_ID_TEST
            s_SERVER.appKey = LEAN_CLOUD_KEY_TEST
        end
    end

    s_CURRENT_USER.appVersion = s_APP_VERSION
    if AgentManager ~= nil then s_CURRENT_USER.channelId = AgentManager:getInstance():getChannelId() end

    saveLuaError = function (msg)
        if s_SERVER.isNetworkConnectedNow() then
            local errorObj = {}
            errorObj['className'] = 'LuaError'
            local a = string.gsub(msg, ":",  "    ") 
            local b = string.gsub(a,   '"',  "'") 
            local c = string.gsub(b,   "\n", "    ") 
            local d = string.gsub(c,   "\t", "    ") 
            errorObj['msg'] = d
            errorObj['appVersion'] = s_APP_VERSION
            errorObj['RA'] = BUILD_TARGET
            s_SERVER.createData(errorObj)
        end
    end
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(s_SCENE)
    else
        cc.Director:getInstance():runWithScene(s_SCENE)
    end

    s_DataManager.loadText()
    
-- *************************************
if test_code == NORMAL_CODE then -- do NOT change this line
    local startApp = function ()
        s_O2OController.start()
    end
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        local SplashView = require("view.SplashView")
        local sv = SplashView.create()
        s_SCENE:replaceGameLayer(sv)
        sv:setOnFinished(startApp)
    else
        startApp()
    end
else    
   -- *************************************
   -- for test
   -- all test codes MUST be written in example.example.lua
   -- do NOT write any test codes in here
   -- do NOT change these lines below
   require("example.example")
   test()
   -- *************************************
end

end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    cc.Director:getInstance():setDisplayStats(false)

    start()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
