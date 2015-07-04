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
        SoundsDownloadingInstance["pro4"] = self
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
    -- 小学  
    elseif self.bookkey == "primary_1" then
        SoundsDownloadingInstance["primary_1"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_1.manifest",storagePath)    
    elseif self.bookkey == "primary_2" then
        SoundsDownloadingInstance["primary_2"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_2.manifest",storagePath) 
    elseif self.bookkey == "primary_3" then
        SoundsDownloadingInstance["primary_3"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_3.manifest",storagePath)    
    elseif self.bookkey == "primary_4" then
        SoundsDownloadingInstance["primary_4"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_4.manifest",storagePath) 
    elseif self.bookkey == "primary_5" then
        SoundsDownloadingInstance["primary_5"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_5.manifest",storagePath)    
    elseif self.bookkey == "primary_6" then
        SoundsDownloadingInstance["primary_6"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_6.manifest",storagePath) 
    elseif self.bookkey == "primary_7" then
        SoundsDownloadingInstance["primary_7"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_7.manifest",storagePath)    
    elseif self.bookkey == "primary_8" then
        SoundsDownloadingInstance["primary_8"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_primary_8.manifest",storagePath) 
    -- 初中
    elseif self.bookkey == "junior_1" then
        SoundsDownloadingInstance["junior_1"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_junior_1.manifest",storagePath)    
    elseif self.bookkey == "junior_2" then
        SoundsDownloadingInstance["junior_2"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_junior_2.manifest",storagePath) 
    elseif self.bookkey == "junior_3" then
        SoundsDownloadingInstance["junior_3"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_junior_3.manifest",storagePath)    
    elseif self.bookkey == "junior_4" then
        SoundsDownloadingInstance["junior_4"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_junior_4.manifest",storagePath) 
    elseif self.bookkey == "junior_5" then
        SoundsDownloadingInstance["junior_5"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_junior_5.manifest",storagePath)    
    -- 高中
    elseif self.bookkey == "senior_1" then
        SoundsDownloadingInstance["senior_1"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_1.manifest",storagePath)    
    elseif self.bookkey == "senior_2" then
        SoundsDownloadingInstance["senior_2"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_2.manifest",storagePath) 
    elseif self.bookkey == "senior_3" then
        SoundsDownloadingInstance["senior_3"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_3.manifest",storagePath)    
    elseif self.bookkey == "senior_4" then
        SoundsDownloadingInstance["senior_4"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_4.manifest",storagePath) 
    elseif self.bookkey == "senior_5" then
        SoundsDownloadingInstance["senior_5"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_5.manifest",storagePath)    
    elseif self.bookkey == "senior_6" then
        SoundsDownloadingInstance["senior_6"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_6.manifest",storagePath) 
    elseif self.bookkey == "senior_7" then
        SoundsDownloadingInstance["senior_7"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_7.manifest",storagePath)    
    elseif self.bookkey == "senior_8" then
        SoundsDownloadingInstance["senior_8"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_8.manifest",storagePath) 
    elseif self.bookkey == "senior_9" then
        SoundsDownloadingInstance["senior_9"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_9.manifest",storagePath)    
    elseif self.bookkey == "senior_10" then
        SoundsDownloadingInstance["senior_10"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_10.manifest",storagePath) 
    elseif self.bookkey == "senior_11" then
        SoundsDownloadingInstance["senior_11"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_11.manifest",storagePath)    
    elseif self.bookkey == "senior_12" then
        SoundsDownloadingInstance["senior_12"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_12.manifest",storagePath) 
    elseif self.bookkey == "senior_13" then
        SoundsDownloadingInstance["senior_13"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_senior_13.manifest",storagePath)
    -- kwekwe
    elseif self.bookkey == "kwekwe" then
        SoundsDownloadingInstance["kwekwe"] = self
        return cc.AssetsManagerEx:create("manifest/book_sound_kwekwe.manifest",storagePath)
    end
end

function DownloadSoundController:beginSoundDownloadUpdate()    
    
    local storagePath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..self.bookkey
    
    if checkIfDownloadSoundsExist(self.bookkey) then
        return
    end
    
    self.am = self:initAssetsManagerByBookType(storagePath)
    if self.am == nil then
        return
    end
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
        -- self.am:release()  --release 在Android会崩溃
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