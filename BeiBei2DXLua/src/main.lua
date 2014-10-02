
require "Cocos2d"
require "src/model/randomMat"

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
    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(480, 320, 0)
    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(320 * 2, 480 * 2, cc.ResolutionPolicy.FIXED_HEIGHT)
    
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local w = size.width
    local h = size.height
    cclog('design size:', w, h)
    
    --create scene 
    local scene = require("AppScene")
    local gameScene = scene.create()
    gameScene:test()
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
    
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
