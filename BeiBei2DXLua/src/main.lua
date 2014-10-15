
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

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    cc.Director:getInstance():setDisplayStats(false)
    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(480, 320, 0)
    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(320 * 2, 480 * 2, cc.ResolutionPolicy.FIXED_HEIGHT)

    --------------------------------------------------------------------------------
    require("common.global")
    initApp()
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(s_SCENE)
    else
        cc.Director:getInstance():runWithScene(s_SCENE)
    end

    -- 
    require("model.ReadAllWord")
    s_WordPool = ReadAllWord()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()
    
    -- test
    local example = require("example.example")
    test()

    --------------------------------------------------------------------------------
--    s_localSqlite = require("model.localData.LocalDatabaseManager")
--    s_localSqlite.open()
--    s_localSqlite.initTables()
--    s_localSqlite.showTables()
    --s_localSqlite.close()
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
