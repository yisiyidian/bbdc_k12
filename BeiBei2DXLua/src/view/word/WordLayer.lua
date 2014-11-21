require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local WordLayer = class("WordLayer", function ()
    return cc.Layer:create()
end)

function WordLayer.create()
    local layer = WordLayer.new()

    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(211,239,254,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)


    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_CorePlayManager.enterHomeLayer()
        end
    end

    local button_left = ccui.Button:create("image/homescene/main_set.png","image/homescene/main_set.png","")
    button_left:setPosition((bigWidth-s_DESIGN_WIDTH)/2+50, s_DESIGN_HEIGHT-120)
    button_left:addTouchEventListener(button_left_clicked)
    backColor:addChild(button_left)
   
    return layer
end

return WordLayer
