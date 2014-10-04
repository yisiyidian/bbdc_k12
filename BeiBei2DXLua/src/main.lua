
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
    
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local w = size.width
    local h = size.height

    --------------------------------------------------------------------------------
    require("common.resource")
    initGlobal()
    s_HEIGHT_SCALE = s_HEIGHT / h
    cclog('design size:' .. w .. ',' .. h .. ',' .. s_HEIGHT_SCALE)
    
    s_debugger.configLog(true, true)
    
    --create scene 
    local scene = require("AppScene")
    s_SCENE = scene.create()
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(s_SCENE)
    else
        cc.Director:getInstance():runWithScene(s_SCENE)
    end
    
    --------------------------------------------------------------------------------
    require('example.example')
    test()
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
