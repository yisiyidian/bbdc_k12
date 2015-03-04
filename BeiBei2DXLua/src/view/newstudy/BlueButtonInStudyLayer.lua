require("cocos.init")
require("common.global")

local  BlueButtonInStudyLayer = class("BlueButtonInStudyLayer", function ()
    return ccui.Button:create()
end)

function BlueButtonInStudyLayer.create(text)
    local button = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button:ignoreAnchorPointForPosition(false)
    button:setAnchorPoint(0.5,0)
    
    local label = cc.Label:createWithSystemFont(text,"",32)
    label:setColor(cc.c4b(255,255,255,255))
    label:setPosition(button:getContentSize().width * 0.5 ,button:getContentSize().height * 0.5 + 4)
    label:enableOutline(cc.c4b(255,255,255,255),1)
    button:addChild(label)

    return button
end

return BlueButtonInStudyLayer