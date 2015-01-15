require("cocos.init")

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
    local postion = cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height-235)
    local bookKey = s_CURRENT_USER.bookKey
    local total_size = s_DataManager.books[bookKey].music    
    local downloadState = initDownloadState(bookKey)
    print("Let me tell that the downloadState is"..downloadState)
     
    --init loading bar
    local button = DownloadSoundButton.new()
    button:loadTexture("image/soundLoadingBar/loadingbar.png",ccui.TextureResType.localType)
    button:setPosition(postion)
    
    --init the background of the loading bar 
    local button_back = ccui.Button:create("image/soundLoadingBar/loadingbar_back.png","image/soundLoadingBar/loadingbar_back_press.png","",ccui.TextureResType.localType)
    button_back:setAnchorPoint(cc.p(0.5,0.5))
    button_back:setPosition(postion)
    
    --init the label of loading bar
    local label = cc.Label:create()
    label:setAnchorPoint(0.5,0.5)    
    label:setSystemFontSize(24) 
    label:setPosition(postion)
    
    --update the state when the download state is "DOWNLOADING"
    local updateDownloadingState = function()
        local percent = SoundsDownloadingInstance[bookKey].downloadPercent
        local currentSize = string.format("%.2f", tonumber(string.sub(total_size, 1, -2))* percent/100)
        button:setPercent(percent)
        label:setString(currentSize.."M / "..total_size)    
    end
    
    --update the state when the download state is "SUCCESS"
    local updateSuccessState =function()
        button:setPercent(100) 
        label:setString("已下载")
        button:setEnabled(false)    
        SoundsDownloadingInstance[bookKey]=nil
    end
    
    local updateFailedState = function()
        SoundsDownloadingInstance[bookKey].am:releaseDownload()
        SoundsDownloadingInstance[bookKey]=nil
        print("渣网络下载失败！！！！！！！！！！！！！！！！！！！！！！")
    end
    
    --update function
    local update =function(dt)
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
    
    --touch event of the button
    local button_download_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            print("Download button touch began")
            local downloadSC = require("view.book.DownloadSoundController").create(bookKey)
            downloadSC:beginSoundDownloadUpdate()
            button_back:setEnabled(false)
            button:scheduleUpdateWithPriorityLua(update, 0)     
            downloadState = "DOWNLOADING"
        end
    end

    --update the stats when initial this layer
    if downloadState == "NOTBEGIN" then
        button:setPercent(0)
        label:setString("下载离线音频")
        button_back:addTouchEventListener(button_download_clicked)
    elseif downloadState == "DOWNLOADING" then
        button:scheduleUpdateWithPriorityLua(update, 0)     
    elseif downloadState == "SUCCESS"  then
        updateSuccessState()
    elseif downloadState == "FAILED" then
        updateFailedState()
    end
    
    parentNode:addChild(button_back)
    parentNode:addChild(button)
    parentNode:addChild(label)
    
    return button
end

return DownloadSoundButton