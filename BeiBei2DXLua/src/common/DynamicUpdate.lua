require("cocos.init")
DynamicUpdate = {}

local storagePath = cc.FileUtils:getInstance():getWritablePath().."AssetsManager"
local searchPath = storagePath.."/ServerAssets"
local am = nil
local listener = nil
local message = ""

function DynamicUpdate.initUpdateLabel()

    local updateInfo = cc.Label:create()
    updateInfo:setSystemFontSize(25)
    updateInfo:setString(app_version_debug)
    updateInfo:setAnchorPoint(0,0)
    updateInfo:setPosition(s_LEFT_X,0)
    updateInfo:setColor(cc.c4b(0,0,0,0))
    return updateInfo
end

function DynamicUpdate.loginUpdateCompleted()

    print("The storagePath is "..storagePath)
    cc.FileUtils:getInstance():addSearchPath(searchPath,true)

    s_O2OController.onAssetsManagerCompleted()
end

function DynamicUpdate.beginLoginUpdate(updateInfo)
    
    if RELEASE_APP==DEBUG_FOR_TEST or RELEASE_APP==RELEASE_FOR_TEST   then
        am = cc.AssetsManagerEx:create("manifest/project_debug.manifest",storagePath)
        am:retain()
        print("debug version")
    else 
        am = cc.AssetsManagerEx:create("manifest/project_release.manifest",storagePath)
        am:retain()        
        print("release version")
    end

    local message = ''

    if not am:getLocalManifest():isLoaded() then
        message = "找不到贝贝的新东东，使用旧装备"
    else
        local function onUpdateEvent(event)
            showProgressHUD(message)
            
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                
                message = "找不到贝贝的新东东，使用旧装备"
                DynamicUpdate.loginUpdateCompleted()                              
                updateInfo:setString(message)
                print(message)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                                
                if assetId==cc.AssetsManagerExStatic.VERSION_ID then
                    message = "贝贝正在检查新版本"
                elseif assetId==cc.AssetsManagerExStatic.MANIFEST_ID then
                    message = "贝贝正在获取新的版本资源列表"
                else
                    percent = string.format("%.2f",event:getPercent())
                    message = "贝贝正在给新版本添料: "..percent.."%"
                end            
                updateInfo:setString(message)
                print(message)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                
                message = "获取更新列表失败，跳过更新"
                updateInfo:setString(message)
                print(message)
                DynamicUpdate.loginUpdateCompleted()                              
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then
                
                message = "贝贝登场"
                updateInfo:setString(message)
                print(message)
                DynamicUpdate.loginUpdateCompleted()                              
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
            
                message = "天空一个巨响，贝贝最新版登场"
                updateInfo:setString(message)
                print(message)
                DynamicUpdate.loginUpdateCompleted()                           
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                
                message = "文件更新失败，失败文件: "..event:getAssetId()..", 失败信息为"..event:getMessage()
                updateInfo:setString(message)
                print(message)
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