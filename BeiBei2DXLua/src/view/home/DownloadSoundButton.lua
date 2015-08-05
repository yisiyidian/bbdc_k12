require("cocos.init")
require("common.global")
local MissionConfig          = require("model.mission.MissionConfig") --任务的配置数据

local DownloadSoundButton = class("DownloadSoundButton", function ()
    return ccui.LoadingBar:create()
end)

local function initDownloadState(bookKey)
    --NOTBEGIN, FAILED, SUCCESS, DOWNLOADING, DECOMPRESS
    local downloadState = nil
    
    local ifExits = checkIfDownloadSoundsExist(bookKey)
    
    if SoundsDownloadingInstance[bookKey] ~= nil then
        downloadState = SoundsDownloadingInstance[bookKey].downloadState
    elseif ifExits==false then
        downloadState = "NOTBEGIN"
    else
        downloadState = "SUCCESS"
    end
    
    return downloadState
end

function DownloadSoundButton.create(parentNode,bool)
    local postion = cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height * 0.3)
    local isOffline = s_SERVER.isNetworkConnectedNow()
    local bookKey = s_CURRENT_USER.bookKey
    local total_size = s_DataManager.books[bookKey].music    
    local downloadState = initDownloadState(bookKey)
    print("Let me tell that the downloadState is"..downloadState)
     
    --init loading bar
    local button = DownloadSoundButton.new()
    button:loadTexture("image/soundLoadingBar/loadingbar.png",ccui.TextureResType.localType)
    button:setPosition(postion.x, postion.y)
    button:setTag(8888)
    
    --init the background of the loading bar 
    local button_back = ccui.Button:create("image/soundLoadingBar/loadingbar_back.png","image/soundLoadingBar/loadingbar_back_press.png","image/soundLoadingBar/no_network.png",ccui.TextureResType.localType)
    button_back:setAnchorPoint(cc.p(0.5,0.5))
    button_back:setPosition(postion)
    button.button_back = button_back
    
    --init the label of loading bar
    local label = cc.Label:create()
    label:setAnchorPoint(0.5,0.5)    
    label:setSystemFontSize(15) 
    label:setPosition(postion)
    label:setString('')

    local label_percent = cc.Label:create()
    label_percent:setAnchorPoint(0.5,0.5)    
    label_percent:setSystemFontSize(15) 
    label_percent:setPosition(postion.x + 130, postion.y)
    label_percent:setString('test')

    local button_download_clicked
    local button_offline_clicked = function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if bool == true then
                local popupOffline = require("popup.PopupSoundOfflineDownload").create()
                local parent = parentNode:getParent()
                popupOffline:setPosition(parent:getContentSize().width/2,parent:getContentSize().height+800)
                parent:addChild(popupOffline,100)
                popupOffline:runMoveInAction()   
            end
        end
    end
    local updateFailedState = function()
        if SoundsDownloadingInstance[bookKey]~=nil then
            SoundsDownloadingInstance[bookKey]:killDownload()
            SoundsDownloadingInstance[bookKey]=nil
            label:setString("下载离线音频")
            label_percent:setString('')
            button:setPercent(0)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_download_clicked)
            if bool == true then
                local popupFailed = require("popup.PopupSoundDownloadFailed").create()
                local parent = parentNode:getParent()
                popupFailed:setPosition(parent:getContentSize().width/2,parent:getContentSize().height+800)
                parent:addChild(popupFailed,100)
                popupFailed:runMoveInAction()   
                downloadState = "NOTBEGIN"    
            end    
        end            
    end

    local updateOfflineState = function()
        print ()
        local currentNetwork = s_SERVER.isNetworkConnectedNow()

        if currentNetwork == true and isOffline == false then
            label:setString("下载离线音频")
            label_percent:setString('')
            button:setPercent(0)
            button_back:loadTextureNormal("image/soundLoadingBar/loadingbar_back.png",ccui.TextureResType.localType)
            button_back:loadTexturePressed("image/soundLoadingBar/loadingbar_back_press.png",ccui.TextureResType.localType)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_download_clicked)
        elseif currentNetwork== false then
             if SoundsDownloadingInstance[bookKey]~=nil then
                updateFailedState()
            end           

            label:setString("下载离线音频")
            label_percent:setString('')
            button:setPercent(0)
            button_back:loadTextureNormal("image/soundLoadingBar/no_network.png",ccui.TextureResType.localType)
            button_back:loadTexturePressed("image/soundLoadingBar/no_network_press.png",ccui.TextureResType.localType)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_offline_clicked)           
        end

        if downloadState == "SUCCESS" then
            label:setVisible(false)
            label_percent:setVisible(false)
            button:setVisible(false)
            button_back:setVisible(false)
        end

        isOffline = currentNetwork
    end
    
    --update the state when the download state is "DOWNLOADING"
    local updateDownloadingState = function()
        -- error handle
        if SoundsDownloadingInstance[bookKey] == nil then return end

        local percent = SoundsDownloadingInstance[bookKey].downloadPercent
        local currentSize = string.format("%.2f", tonumber(string.sub(total_size, 1, -2))* percent/100)
        button:setPercent(percent)
        label_percent:setString(percent.."%")
        label:setString(currentSize.."M / "..total_size)    
    end
    
    --update the state when the download state is "SUCCESS"
    local updateSuccessState =function()
        if SoundsDownloadingInstance[bookKey] ~= nil then
            SoundsDownloadingInstance[bookKey]=nil
            if bool == true or string.find(s_CURRENT_USER.bookList,"|") ~= nil then
                local popupSuccess = require("popup.PopupSoundDownloadSuccess").create()
                local parent = parentNode:getParent()
                popupSuccess:setPosition(parent:getContentSize().width/2,parent:getContentSize().height+800)
                parent:addChild(popupSuccess,100)
                popupSuccess:runMoveInAction()
            end
        end

        s_MissionManager:updateMission(MissionConfig.MISSION_AUDIO)
        label:setVisible(false)
        label_percent:setVisible(false)
        button:setVisible(false)
        button_back:setVisible(false)
    end
    
    --update function
    local timeToCheckNetwork = 0
    local update = function(dt)
        if isOffline == true then
            if SoundsDownloadingInstance[bookKey]~=nil then
                downloadState = SoundsDownloadingInstance[bookKey].downloadState
            end
            
            if downloadState == "DOWNLOADING" then
                updateDownloadingState()
            elseif downloadState == "SUCCESS" then
                updateSuccessState()
                button:unscheduleUpdate()
            elseif downloadState =="DECOMPRESS" then
                label:setString("解压缩中..")
            elseif downloadState == "FAILED" then
                updateFailedState()            
                button:unscheduleUpdate()
            end
        else
            if timeToCheckNetwork >= 30 then
                timeToCheckNetwork = 0
                updateOfflineState()
            else
                timeToCheckNetwork = timeToCheckNetwork + dt
            end
        end
    end

    --touch event of cancel download
    button_cancel_download_clicked = function (sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print("cancel download")
            downloadState="NOTBEGIN"
            label:setString("下载离线音频")
            label_percent:setString('')
            button:setPercent(0)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_download_clicked)     
           if SoundsDownloadingInstance[bookKey]~=nil then
                SoundsDownloadingInstance[bookKey]:killDownload()
                SoundsDownloadingInstance[bookKey]=nil
            end                
        end
    end

    --touch event of the button downloadEvent
    button_download_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            AnalyticsDownloadSoundBtn()
            print("Download button touch began")
            local downloadSC = require("view.book.DownloadSoundController").create(bookKey)
            downloadSC:beginSoundDownloadUpdate()
            button_back:addTouchEventListener(button_cancel_download_clicked)     
            downloadState = "DOWNLOADING"
        end
    end

    --update the stats when initial this layer
    if downloadState == "NOTBEGIN" then
        button:setPercent(0)
        label_percent:setString('')
        label:setString("下载离线音频")
        button_back:addTouchEventListener(button_download_clicked)
    elseif downloadState == "DOWNLOADING" then

    elseif downloadState == "SUCCESS"  then
        updateSuccessState()

    elseif downloadState == "FAILED" then
        updateFailedState()
    end
    
    --update the offlineState when init
    updateOfflineState()

    --begin the update
    button:scheduleUpdateWithPriorityLua(update, 0)

    --add the components
    parentNode:addChild(button_back)
    parentNode:addChild(button)
    parentNode:addChild(label)
    parentNode:addChild(label_percent)

    if bool == false then
        local downloadSC = require("view.book.DownloadSoundController").create(bookKey)
        downloadSC:beginSoundDownloadUpdate()
        button_back:setVisible(false)
        button:setVisible(false)
        label:setVisible(false)
        label_percent:setVisible(false)
    end

    return button
end

function DownloadSoundButton:setEnabled(enabled)
    self.button_back:setEnabled(enabled)
end

return DownloadSoundButton