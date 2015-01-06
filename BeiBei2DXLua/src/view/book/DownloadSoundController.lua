require("cocos.init")

DownloadSoundController = {}

----These Codes below is for downloading sounds---- 
----Booktypes are cet4, cet6, gmat, gre,gse ,ielts, middle, ncee, primary, pro4, pro8,sat, toefl
--
local downloadMes = ""
local downloadState = false
local am = nil
local listener
local downloadPercent = 0

local function initAssetsManagerByBookType(bookType,storagePath)
        
    if bookType == "cet4" then
        return cc.AssetsManagerEx:create("manifest/book_sound_cet4.manifest",storagePath)   
    elseif bookType == "cet6" then
        return cc.AssetsManagerEx:create("manifest/book_sound_cet6.manifest",storagePath)       
    elseif bookType == "gmat" then
        return cc.AssetsManagerEx:create("manifest/book_sound_gmat.manifest",storagePath)   
    elseif bookType == "gre" then
        return cc.AssetsManagerEx:create("manifest/book_sound_gre.manifest",storagePath)   
    elseif bookType == "gse" then
        return cc.AssetsManagerEx:create("manifest/book_sound_gse.manifest",storagePath)   
    elseif bookType == "ielts" then
        return cc.AssetsManagerEx:create("manifest/book_sound_ielts.manifest",storagePath)   
    elseif bookType == "middle" then
        return cc.AssetsManagerEx:create("manifest/book_sound_middle.manifest",storagePath)   
    elseif bookType == "ncee" then
        return cc.AssetsManagerEx:create("manifest/book_sound_ncee.manifest",storagePath)   
    elseif bookType == "primary" then
        return cc.AssetsManagerEx:create("manifest/book_sound_primary.manifest",storagePath)   
    elseif bookType == "pro4" then
        return cc.AssetsManagerEx:create("manifest/book_sound_pro4.manifest",storagePath)   
    elseif bookType == "pro8" then
        return cc.AssetsManagerEx:create("manifest/book_sound_pro8.manifest",storagePath)   
    elseif bookType == "sat" then
        return cc.AssetsManagerEx:create("manifest/book_sound_sat.manifest",storagePath)   
    elseif bookType == "toefl" then
        return cc.AssetsManagerEx:create("manifest/book_sound_toefl.manifest",storagePath)       
    end
end

function DownloadSoundController.beginSoundDownloadUpdate(bookType, setPercentCallback, setStateCallback)

    print("bookType is: ",bookType)
    local storagePath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..bookType
    am = initAssetsManagerByBookType(bookType,storagePath)
    am:retain()
    
    print("Booksound storagePath is "..storagePath)
    if not am:getLocalManifest():isLoaded() then
        downloadMes = "贝贝找不到下载配置文件，下载失败"
        downloadState = false
    else
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then

                downloadMes = "贝贝找不到本地单词包清单配置文件，下载取消"
                downloadState = false
                setStateCallback(downloadState)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then

                if assetId==cc.AssetsManagerExStatic.VERSION_ID then
                    downloadMes = "贝贝正在挑选新的单词包版本文件"
                elseif assetId==cc.AssetsManagerExStatic.MANIFEST_ID then
                    downloadMes = "贝贝正在获取新的单词包清单文件"
                else
                    downloadPercent = string.format("%.2f",event:getPercent())
                    setPercentCallback(downloadPercent)
                    downloadMes = "单词打包运送中: "..downloadPercent.."%"   
                end                
                
                downloadState = false
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then

                downloadMes = "获取单词包清单文件失败, 下载取消." 
                downloadState = false               
                setStateCallback(downloadState)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then

                downloadMes = "已是最新单词包"  
                downloadState = true
                setStateCallback(downloadState)
                DownloadSoundController.releaseDownload()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then

                downloadMes = "最新的单词包到货了"     
                downloadState = true
                setStateCallback(downloadState)
                DownloadSoundController.releaseDownload()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then

                downloadMes = "文件: "..event:getAssetId()..", 下载失败，失败信息为"..event:getMessage()  
                downloadState = false                                              
                setStateCallback(downloadState)
            end  
            print(downloadMes)
        end

        listener = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener,1)
        am:update()
    end
end

function DownloadSoundController.getDownloadMessage()
    return downloadMes
end

function DownloadSoundController.getDownloadState()
    return downloadState
end 

function DownloadSoundController.getDownloadPercent()
    return downloadPercent
end

function DownloadSoundController.releaseDownload()
    if listener ~= nil then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(listener)
    end

    if am ~= nil then
        am:release()
    end
end

function DownloadSoundController.killDownload(bookType)
    
    DownloadSoundController.releaseDownload()
    DownloadSoundController.deleteBookSound(bookType)    
end


function DownloadSoundController.deleteBookSound(bookType)

    cc.FileUtils:getInstance():removeDirectory(cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..bookType.."/")
    print("删除单词包成功")
end

return DownloadSoundController