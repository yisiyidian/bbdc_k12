require("cocos.init")

DownloadSoundController = {}

----These Codes below is for downloading sounds---- 
----Booktypes are cet4, cet6, gmat, gre,gse ,ielts, middle, ncee, primary, pro4, pro8,sat, toefl
--
local storagePath = cc.FileUtils:getInstance():getWritablePath().."BookSounds"
local downloadMes = ""
local downloadPercent = 0

local function initAssetsManagerByBookType(bookType)
        
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

function DownloadSoundController.beginSoundDownloadUpdate(bookType)
    local am = initAssetsManagerByBookType(bookType)
    if not am:getLocalManifest():isLoaded() then
        updateInfo:setString("Fail to update assets, step skipped.")
    else
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then

                downloadMes = "No local manifest file found, skip assets update."
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then

                if assetId==cc.AssetsManagerExStatic.VERSION_ID then
                    downloadMes = "Version file updating."
                elseif assetId==cc.AssetsManagerExStatic.MANIFEST_ID then
                    downloadMes = "Manifest updating"
                else
                    downloadPercent = string.format("%.2f",event:getPercent())
                    downloadMes = "Updating: "..downloadPercent.."%"   
                end                
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then

                downloadMes = "Fail to download manifest file, update skipped."                
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then

                downloadMes = "Already up to date"  
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then

                downloadMes = "Update completed"     
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then

                downloadMes = "Asset ", event:getAssetId(), ", ", event:getMessage()                                                
            end
            
            print(downloadMes)
        end

        local listerner = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listerner,1)
        am:update()
    end
end

function DownloadSoundController.getBookSoundsPath(bookType)
    return storagePath.."/"..bookType
end

return DownloadSoundController