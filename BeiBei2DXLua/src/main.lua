
local RELEASE_APP = false

require "Cocos2d"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

local saveLuaError = function (msg)
    
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    saveLuaError("LUA ERROR: " .. tostring(msg) .. '. ' .. tostring(debug.traceback()))
    return msg
end

local start
start = function ()
    require("common.global")
    initApp(start)

    local LEAN_CLOUD_ID_TEST   = "gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
    local LEAN_CLOUD_KEY_TEST  = "x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

    local LEAN_CLOUD_ID        = "94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp"
    local LEAN_CLOUD_KEY       = "lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz"

    if RELEASE_APP then
        -- remove print debug info when release app
        print = function ( ... )
        end

        s_debugger.configLog(false, false)
        DEBUG_PRINT_LUA_TABLE = false
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false -- TODO
        s_SERVER.production       = 1

        s_APP_VERSION = 150000
        s_CONFIG_VERSION = 150000

        s_SERVER.appId = LEAN_CLOUD_ID
        s_SERVER.appKey = LEAN_CLOUD_KEY

    else
        s_debugger.configLog(true, true)
        DEBUG_PRINT_LUA_TABLE = true
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false
        s_SERVER.production       = 0


        s_APP_VERSION = 150006
        s_CONFIG_VERSION = 150000 -- do NOT change this

        s_SERVER.appId = LEAN_CLOUD_ID_TEST
        s_SERVER.appKey = LEAN_CLOUD_KEY_TEST
    end

    saveLuaError = function (msg)
        local errorObj = {}
        errorObj['className'] = 'LuaError'
        local a = string.gsub(msg, ":",  "..") 
        local b = string.gsub(a,   '"',  "'") 
        local c = string.gsub(b,   "\n", "___") 
        local d = string.gsub(c,   "\t", "___") 
        errorObj['msg'] = d
        s_SERVER.createData(errorObj)
    end
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(s_SCENE)
    else
        cc.Director:getInstance():runWithScene(s_SCENE)
    end

    s_DATA_MANAGER.loadText()
    
-- *************************************
-- All test code must in example.example
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- |||||||||||||||||||||||||||||||||||||
-- vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
local test_code = 0
-- *************************************
    local IntroLayer = require("view.LoadingView")
    local introLayer = IntroLayer.create()
    s_SCENE:replaceGameLayer(introLayer) 
    

if test_code == 0 then
   local startApp = function ()
       if not s_DATABASE_MGR.isLogOut() and s_DATABASE_MGR.getLastLogInUser(s_CURRENT_USER) then
           s_SCENE:logIn(s_CURRENT_USER.username, s_CURRENT_USER.password)
       else
           local IntroLayer = require("view.login.IntroLayer")
           local introLayer = IntroLayer.create()
           s_SCENE:replaceGameLayer(introLayer)
       end
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
   --for test
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
    
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    cc.Director:getInstance():setDisplayStats(false)

    start()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
