require("cocos.init")

local PopupSoundDownloadFailed = class("PopupSoundDownloadFailed", function ()
    return require("popup.PopupSoundDownloadSuccess").create()
end)

function PopupSoundDownloadFailed.create()

    local layer = PopupSoundDownloadFailed.new()
    local bookkey = s_CURRENT_USER.bookKey

    --add background
    layer:createBackground("image/soundLoadingBar/popup.png")

    --add network with earphone
    local network = cc.Sprite:create("image/soundLoadingBar/network.png")
    network:setAnchorPoint(cc.p(0.5,0.5))
    network:setPosition(cc.p(0,0))
    layer:addChild(network)

    --add confirm button
    layer:addConfirmButton("image/soundLoadingBar/confirm_button.png","image/soundLoadingBar/confirm_button_press.png","知道了")
    
    --add title
    layer:addTitle("找不到网络")
    
    --add description
    layer:addDescription("网络异常，"..bookkey.."下载失败")

    --disable the touch event under this layer
    --layer:disableTouchevent()
    
    return layer
end

function PopupSoundDownloadFailed:addDescription(text)

    local description = cc.Label:create()
    description:setString(text)
    description:setColor(cc.c3b(85,189,231))
    description:setSystemFontSize(26)
    description:setAnchorPoint(0.5,0.5)
    description:setPosition(0,70)

    self:addChild(description)
end



return PopupSoundDownloadFailed