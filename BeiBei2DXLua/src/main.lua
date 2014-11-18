
local RELEASE_APP = false

require "Cocos2d"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

-- remove print debug info when release app
local sysPrint = print
print = function ( ... )
    if RELEASE_APP then return end
    sysPrint('BEIBEI:' .. string.format(...))
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    cc.Director:getInstance():setDisplayStats(false)

    --------------------------------------------------------------------------------

    require("common.global")
    initApp()

    if RELEASE_APP then
        s_debugger.configLog(false, false)
        DEBUG_PRINT_LUA_TABLE = false
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false -- TODO
        s_SERVER.production       = 1
        s_APP_VERSION = 150000
    else
        s_debugger.configLog(true, true)
        DEBUG_PRINT_LUA_TABLE = true
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false
        s_SERVER.production       = 0
        s_APP_VERSION = 150000
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
if test_code == 0 then
   local startApp = function ()
       if s_DATABASE_MGR.getUserDataFromLocalDB(s_CURRENT_USER) then
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


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
