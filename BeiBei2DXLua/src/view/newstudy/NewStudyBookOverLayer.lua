require("cocos.init")
require("common.global")



local  NewStudyBookOverLayer = class("NewStudyBookOverLayer", function ()
    return cc.Layer:create()
end)

function NewStudyBookOverLayer.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    --pause music
    cc.SimpleAudioEngine:getInstance():pauseMusic()

    -- ui 
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = NewStudyBookOverLayer.new()

    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT+45)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)

    local label_hint = cc.Label:createWithSystemFont("恭喜你已经完成这本书的单词学习","",40)
    label_hint:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)

    local button_go_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_go = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button_go:setPosition(bigWidth/2, 153)
    button_go:setTitleText("返回")
    button_go:setTitleColor(cc.c4b(255,255,255,255))
    button_go:setTitleFontSize(32)
    button_go:addTouchEventListener(button_go_click)
    backColor:addChild(button_go) 

    return layer
end

return NewStudyBookOverLayer