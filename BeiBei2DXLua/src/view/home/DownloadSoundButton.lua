require("cocos.init")
require("common.global")

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

function DownloadSoundButton.create(parentNode)
    local postion = cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height-255)
    local isOffline = s_SERVER.isNetworkConnectedNow()
    local bookKey = s_CURRENT_USER.bookKey
    local total_size = s_DataManager.books[bookKey].music    
    local downloadState = initDownloadState(bookKey)
    print("Let me tell that the downloadState is"..downloadState)
     
    --init loading bar
    local button = DownloadSoundButton.new()
    button:loadTexture("image/soundLoadingBar/loadingbar.png",ccui.TextureResType.localType)
    button:setPosition(postion.x, postion.y+2)
    button:setTag(8888)
    
    --init the background of the loading bar 
    local button_back = ccui.Button:create("image/soundLoadingBar/loadingbar_back.png","image/soundLoadingBar/loadingbar_back_press.png","image/soundLoadingBar/no_network.png",ccui.TextureResType.localType)
    button_back:setAnchorPoint(cc.p(0.5,0.5))
    button_back:setPosition(postion)
    
    --init the label of loading bar
    local label = cc.Label:create()
    label:setAnchorPoint(0.5,0.5)    
    label:setSystemFontSize(24) 
    label:setPosition(postion)

    local button_download_clicked
    local button_offline_clicked = function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local popupOffline = require("popup.PopupSoundOfflineDownload").create()
            local parent = parentNode:getParent()
            popupOffline:setPosition(parent:getContentSize().width/2,parent:getContentSize().height+800)
            parent:addChild(popupOffline,100)
            popupOffline:runMoveInAction()   
        end
    end
    local updateFailedState = function()
        if SoundsDownloadingInstance[bookKey]~=nil then
            SoundsDownloadingInstance[bookKey]:killDownload()
            SoundsDownloadingInstance[bookKey]=nil
            label:setString("下载离线音频")
            button:setPercent(0)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_download_clicked)
            local popupFailed = require("popup.PopupSoundDownloadFailed").create()
            local parent = parentNode:getParent()
            popupFailed:setPosition(parent:getContentSize().width/2,parent:getContentSize().height+800)
            parent:addChild(popupFailed,100)
            popupFailed:runMoveInAction()   
            downloadState = "NOTBEGIN"        
        end            
    end

    local updateOfflineState = function()

        if isOffline == true then
            label:setString("下载离线音频")
            button:setPercent(0)
            button_back:loadTextureNormal("image/soundLoadingBar/loadingbar_back.png",ccui.TextureResType.localType)
            button_back:loadTexturePressed("image/soundLoadingBar/loadingbar_back_press.png",ccui.TextureResType.localType)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_download_clicked)
        else
            if SoundsDownloadingInstance[bookKey]~=nil then
                updateFailedState()
            end
            label:setString("下载离线音频")
            button:setPercent(0)
            button_back:loadTextureNormal("image/soundLoadingBar/no_network.png",ccui.TextureResType.localType)
            button_back:loadTexturePressed("image/soundLoadingBar/no_network_press.png",ccui.TextureResType.localType)
            button_back:setEnabled(true)
            button_back:setBright(true)
            button_back:addTouchEventListener(button_offline_clicked)
        end

        if downloadState == "SUCCESS" then
            label:setString("已完成")
            button:setPercent(0)
            button_back:setEnabled(false)
            button_back:setBright(false)
        end
    end
    
    --update the state when the download state is "DOWNLOADING"
    local updateDownloadingState = function()
        local percent = SoundsDownloadingInstance[bookKey].downloadPercent
        local currentSize = string.format("%.2f", tonumber(string.sub(total_size, 1, -2))* percent/100)
        button:setPercent(percent)
        label:setString(currentSize.."M / "..total_size)    
    end
    
    --update the state when the download state is "SUCCESS"
    local updateSuccessState =function()
        if SoundsDownloadingInstance[bookKey] ~=nil then
            SoundsDownloadingInstance[bookKey]=nil
            local popupSuccess = require("popup.PopupSoundDownloadSuccess").create()
            local parent = parentNode:getParent()
            popupSuccess:setPosition(parent:getContentSize().width/2,parent:getContentSize().height+800)
            parent:addChild(popupSuccess,100)
            popupSuccess:runMoveInAction()
        end
            button:setPercent(0)
            label:setString("已下载")
            button_back:setEnabled(false)   
            button_back:setBright(false)
    end
    
    --update function
    local update =function(dt)

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
        end
    end
    
    local checkIfNetworkUpdate = function(dt)
        isOffline = s_SERVER.isNetworkConnectedNow()
        updateOfflineState()
    end

    --touch event of cancel download
    button_cancel_download_clicked = function (sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print("cancel download")
            button:unscheduleUpdate()
            downloadState="NOTBEGIN"
            label:setString("下载离线音频")
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
        label:setString("下载离线音频")
        button_back:addTouchEventListener(button_download_clicked)
    elseif downloadState == "DOWNLOADING" then
        -- button:scheduleUpdateWithPriorityLua(update, 0)     
    elseif downloadState == "SUCCESS"  then
        updateSuccessState()
    elseif downloadState == "FAILED" then
        updateFailedState()
    end
    
    --update the offlineState when init
    updateOfflineState()

    --begin the update
    button:scheduleUpdateWithPriorityLua(update, 0)
    local scheduler = button:getScheduler()
    scheduler.schedulerEntry = scheduler:scheduleScriptFunc(checkIfNetworkUpdate,2,false)

    --add the components
    parentNode:addChild(button_back)
    parentNode:addChild(button)
    parentNode:addChild(label)
    
    return button
end

return DownloadSoundButton