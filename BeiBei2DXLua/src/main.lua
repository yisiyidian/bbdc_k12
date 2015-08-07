
-- cclog
local function cclog(...) print(string.format(...)) end

function saveLuaError(msg) end
LUA_ERROR = ''

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
    local traceback = string.split(debug.traceback("",2),"\n")
    print('LOGTIME', des, os.time()," from:",string.trim(traceback[3]))
    -- LUA_ERROR = LUA_ERROR .. '\n' .. 'LOGTIME:' .. des .. ', ' .. tostring(os.time())
end

function reloadModule( moduleName )
    package.loaded[moduleName] = nil
    return require(moduleName)
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- addSkipBackupAttributeToItemAtPath
    local soundStoreDirInIOS = cc.FileUtils:getInstance():getWritablePath().."BookSounds"
    local customClass = CustomClass:create()
    local result = customClass:addSkipBackupAttributeToItemAtPath(soundStoreDirInIOS)
    print("addSkipBackupAttributeToItemAtPath msg is : " .. result)
    
    cc.Director:getInstance():setDisplayStats(false)

    app_version_debug   = 219000
    app_version_release = 219000

    g_userName = nil
    g_userPassword = nil
    s_WordDictionaryDatabase = nil

    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    cc.FileUtils:getInstance():addSearchPath("res/sound/words/")
    cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath())
    require("cocos.init")
    require("mobdebug").start() --start zerobrain debugging

    local HotUpdateController = require("hu.HotUpdateController")
    HotUpdateController.init()

    local start = reloadModule('start')
    start.init()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
