require("cocos.init")

local PopupSoundOfflineDownload = class("PopupSoundOfflineDownload", function ()
    return require("popup.PopupSoundDownloadSuccess").create()
end)

function PopupSoundOfflineDownload.create()

    local layer = PopupSoundOfflineDownload.new()

    --add background
    layer:createBackground("image/soundLoadingBar/offlineDownload.png")

    --add network with earphone
    local network = cc.Sprite:create("image/soundLoadingBar/beibei_ magnifier.png")
    network:setAnchorPoint(cc.p(0.5,0.5))
    network:setPosition(cc.p(0,20))
    layer:addChild(network)

    --add confirm button
    layer:addConfirmButton("image/soundLoadingBar/confirm_button.png","image/soundLoadingBar/confirm_button_press.png","知道了")
    
    --add title
    layer:addTitle("离线下载")
    
    --add description
    layer:addDescription("请在有网络的情况下再进行下载。")

    --disable the touch event under this layer
    layer:disableTouchevent()
    
    return layer
end

function PopupSoundOfflineDownload:addConfirmButton(confirmPath,confirmPressPath,text)
    
    local button = ccui.Button:create(confirmPath,confirmPressPath,"",ccui.TextureResType.localType)
    button:setPosition(0,-125)
    button:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(button)
    
    local button_clicked = function (sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            self:runMoveOutAction()
        end
    end
    
    local buttonLabel = cc.Label:create()
    buttonLabel:setString(text)
    buttonLabel:setColor(cc.c3b(255,255,255))
    buttonLabel:setSystemFontSize(35)
    buttonLabel:setAnchorPoint(0.5,0.5)
    buttonLabel:setPosition(button:getContentSize().width/2,button:getContentSize().height/2)
    
    button:addChild(buttonLabel)
    button:addTouchEventListener(button_clicked)
end

function PopupSoundOfflineDownload:addTitle(text)
    
    local title = cc.Label:create()
    title:setString(text)
    title:setColor(cc.c3b(85,189,231))
    title:setSystemFontSize(35)
    title:setAnchorPoint(0.5,0.5)
    title:setPosition(0,180)
    
    self:addChild(title)
end

function PopupSoundOfflineDownload:addDescription(text)

    local description = cc.Label:create()
    description:setString(text)
    description:setColor(cc.c3b(85,189,231))
    description:setSystemFontSize(26)
    description:setAnchorPoint(0.5,0.5)
    description:setPosition(0,142)

    self:addChild(description)
end


return PopupSoundOfflineDownload