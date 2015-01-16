require("cocos.init")

----These Codes below is for downloading sounds---- 
----Booktypes are cet4, cet6, gmat, gre,gse ,ielts, middle, ncee, primary, pro4, pro8,sat, toefl
----

if SoundsDownloadingInstance == nil then
    SoundsDownloadingInstance = {}
end

local function createController(bookkey)
    local dowloadsc = {}
    dowloadsc.bookkey = bookkey
    dowloadsc.downloadMes = ""

    --States: NOTBEGIN, FAILED, SUCCESS, DOWNLOADING, DECOMPRESS
    dowloadsc.downloadState = "DOWNLOADING"
    dowloadsc.am = nil
    dowloadsc.listener = nil
    dowloadsc.downloadPercent = 0
    dowloadsc.listener = nil

    return dowloadsc
end

local DownloadSoundController = class("DownloadSoundController", function (bookkey)
    return createController(bookkey)
end)

function DownloadSoundController.create(bookkey)
    local dowloadsc = DownloadSoundController.new(bookkey)
    
    return dowloadsc
end

function DownloadSoundController:initAssetsManagerByBookType(storagePath)
        
    if self.bookkey == "cet4" then
        SoundsDownloadingInstance["cet4"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_cet4.manifest",storagePath)   
    elseif self.bookkey == "cet6" then
        SoundsDownloadingInstance["cet6"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_cet6.manifest",storagePath)       
    elseif self.bookkey == "gmat" then
        SoundsDownloadingInstance["gmat"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_gmat.manifest",storagePath)   
    elseif self.bookkey == "gre" then
        SoundsDownloadingInstance["gre"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_gre.manifest",storagePath)   
    elseif self.bookkey == "gse" then
        SoundsDownloadingInstance["gse"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_gse.manifest",storagePath)   
    elseif self.bookkey == "ielts" then
        SoundsDownloadingInstance["ielts"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_ielts.manifest",storagePath)   
    elseif self.bookkey == "middle" then
        SoundsDownloadingInstance["middle"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_middle.manifest",storagePath)   
    elseif self.bookkey == "ncee" then
        SoundsDownloadingInstance["ncee"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_ncee.manifest",storagePath)   
    elseif self.bookkey == "primary" then
        SoundsDownloadingInstance["primary"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary.manifest",storagePath)   
    elseif self.bookkey == "pro4" then
        SoundsDownloadingInstance["pro8"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_pro4.manifest",storagePath)   
    elseif self.bookkey == "pro8" then
        SoundsDownloadingInstance["pro8"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_pro8.manifest",storagePath)   
    elseif self.bookkey == "sat" then
        SoundsDownloadingInstance["sat"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_sat.manifest",storagePath)   
    elseif self.bookkey == "toefl" then
        SoundsDownloadingInstance["toefl"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_toefl.manifest",storagePath)       
    end
end

function DownloadSoundController:beginSoundDownloadUpdate()    
    
    local storagePath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..self.bookkey
    
    if checkIfDownloadSoundsExist(self.bookkey) then
        return
    end
    
    self.am = self:initAssetsManagerByBookType(storagePath)
    self.am:retain()
    
    print("Booksound storagePath is "..storagePath)
    if not self.am:getLocalManifest():isLoaded() then
        self.downloadMes = "贝贝找不到下载配置文件，下载失败"
        self.downloadState = "FAILED"
    else
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then

                self.downloadMes = "贝贝找不到本地单词包清单配置文件，下载取消"
                self.downloadState = "FAILED"
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then

                if assetId==cc.AssetsManagerExStatic.VERSION_ID then
                    self.downloadMes = "贝贝正在挑选新的单词包版本文件"
                    self.downloadState = "DOWNLOADING"
                elseif assetId==cc.AssetsManagerExStatic.MANIFEST_ID then
                    self.downloadMes = "贝贝正在获取新的单词包清单文件"
                    self.downloadState = "DOWNLOADING"
                else
                    self.downloadPercent = string.format("%.2f",event:getPercent())                                        
                    self.downloadState = "DOWNLOADING"
                    self.downloadMes = "单词打包运送中: "..self.downloadPercent.."%"
                    if event:getPercent() >= 100 then
                        self.downloadState = "DECOMPRESS"
                    end   
                end                               
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then

                self.downloadMes = "获取单词包清单文件失败, 下载取消." 
                self.downloadState = "FAILED"               
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then

                self.downloadMes = "已是最新单词包"  
                self.downloadState = "SUCCESS"
                self:releaseDownload()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then

                self.downloadMes = "最新的单词包到货了"     
                self.downloadState = "SUCCESS"
                self:releaseDownload()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then

                self.downloadMes = "文件: "..event:getAssetId()..", 下载失败，失败信息为"..event:getMessage()  
                self.downloadState = "FAILED"     
            end  
            print(self.downloadMes)
        end

        self.listener = cc.EventListenerAssetsManagerEx:create(self.am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener,1)
        self.am:update()
    end
end

function DownloadSoundController:releaseDownload()
    if self.listener ~= nil then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
    end

    if self.am ~= nil then
        self.am:release()
        self.am =nil
    end
end

function DownloadSoundController:killDownload()
    
    self:deleteBookSound()    
    self:releaseDownload()
end


function DownloadSoundController:deleteBookSound()

    local bookKey = self.bookkey
    cc.FileUtils:getInstance():removeDirectory(cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..bookKey.."/")
    print("删除单词包成功")
end

return DownloadSoundController