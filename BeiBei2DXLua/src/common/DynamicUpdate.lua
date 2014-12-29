require("cocos.init")
DynamicUpdate = {}

local storagePath = cc.FileUtils:getInstance():getWritablePath().."AssetsManager"
local searchPath = storagePath.."/ServerAssets"
local am = nil
local listener = nil

function DynamicUpdate.initUpdateLabel()

    local updateInfo = cc.Label:create()
    updateInfo:setSystemFontSize(25)
    updateInfo:setString(app_version_debug)
    updateInfo:setAnchorPoint(0,0)
    updateInfo:setPosition(s_LEFT_X,0)
    updateInfo:setColor(cc.c4b(0,0,0,0))
    return updateInfo
end

local function reloadModule( moduleName )

    package.loaded[moduleName] = nil

    return require(moduleName)
end

function DynamicUpdate.loginUpdateCompleted()

    if not s_DATABASE_MGR.isLogOut() and s_DATABASE_MGR.getLastLogInUser(s_CURRENT_USER, USER_TYPE_ALL) then
        cc.FileUtils:getInstance():addSearchPath(searchPath,true)
        print("The storagePath is "..storagePath)
        print("The searchPath is "..searchPath)
        if s_CURRENT_USER.usertype == USER_TYPE_QQ then
            s_SCENE:logInByQQAuthData()
        else
            s_SCENE:logIn(s_CURRENT_USER.username, s_CURRENT_USER.password)
        end
    elseif s_DATABASE_MGR.isLogOut() and s_DATABASE_MGR.getLastLogInUser(s_CURRENT_USER, USER_TYPE_ALL) then
        cc.FileUtils:getInstance():addSearchPath(searchPath,true)
        print("The storagePath is "..storagePath)
        print("The searchPath is "..searchPath)
        local IntroLayer = reloadModule("view.login.IntroLayer")
        local introLayer = IntroLayer.create(true)
        s_SCENE:replaceGameLayer(introLayer)
    else
        cc.FileUtils:getInstance():addSearchPath(searchPath,true)
        print("The storagePath is "..storagePath)
        print("The searchPath is "..searchPath)
        local IntroLayer = reloadModule("view.login.IntroLayer")
        local introLayer = IntroLayer.create(false)
        s_SCENE:replaceGameLayer(introLayer)
    end
end

function DynamicUpdate.beginLoginUpdate(updateInfo)
    
    if RELEASE_APP==DEBUG_FOR_TEST or RELEASE_APP==RELEASE_FOR_TEST   then
        am = cc.AssetsManagerEx:create("manifest/project_debug.manifest",storagePath)
        am:retain()
    else 
        am = cc.AssetsManagerEx:create("manifest/project_release.manifest",storagePath)
        am:retain()        
    end

    if not am:getLocalManifest():isLoaded() then
        updateInfo:setString("找不到贝贝的新东东，使用旧装备")
    else
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                
                updateInfo:setString("找不到贝贝的新东东，使用旧装备")
                DynamicUpdate.loginUpdateCompleted()                              
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                                
                if assetId==cc.AssetsManagerExStatic.VERSION_ID then
                    updateInfo:setString("贝贝正在检查新版本")
                elseif assetId==cc.AssetsManagerExStatic.MANIFEST_ID then
                    updateInfo:setString("贝贝正在获取新的版本资源列表")   
                else
                    percent = string.format("%.2f",event:getPercent())
                    updateInfo:setString("贝贝正在给新版本添料: "..percent.."%")   
                end                
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                
                updateInfo:setString("获取更新列表失败，跳过更新")                
                print("获取更新列表失败，跳过更新")                
                DynamicUpdate.loginUpdateCompleted()                              
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then
            
                updateInfo:setString("贝贝登场")  
                print("贝贝登场")  
                DynamicUpdate.loginUpdateCompleted()                              
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
            
                updateInfo:setString("天空一个巨响，贝贝最新版登场")     
                print("天空一个巨响，贝贝最新版登场")     
                DynamicUpdate.loginUpdateCompleted()                           
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
            
                updateInfo:setString("文件更新失败，失败文件: "..event:getAssetId()..", 失败信息为"..event:getMessage())                                                
                print("文件更新失败，失败文件: "..event:getAssetId()..", 失败信息为"..event:getMessage())     
                DynamicUpdate.loginUpdateCompleted()                              
            end
        end

        listener = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener,1)
        am:update()
    end
end

function DynamicUpdate.killUpdate()
    if listener ~= nil then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(listener)
    end

    if am ~= nil then
        am:release()
    end    
end

return DynamicUpdate