require("common.global")

local HintAlter = class("HintAlter", function()
    return cc.Layer:create()
end)

function HintAlter.create(info)
    local main = cc.Layer:create()
    s_SCENE.popupLayer.listener:setSwallowTouches(true)
    main:setContentSize(s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)
    
    local back = cc.Sprite:create("image/alter/tanchu_board_small_white.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local label_info = cc.Label:createWithSystemFont(info,"",28)
    label_info:setColor(cc.c4b(0,0,0,255))
    label_info:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label_info:setDimensions(back:getContentSize().width*4/5,0)
    label_info:setPosition(back:getContentSize().width/2, back:getContentSize().height/2+50)
    back:addChild(label_info)
    
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            --            main.close()
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE.popupLayer.listener:setSwallowTouches(false)
            local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*3/2)))
            local remove = cc.CallFunc:create(function() 
                main:removeFromParent() 
            end,{})
            back:runAction(cc.Sequence:create(move,remove))
        end
    end

    local button_left = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
    button_left:setPosition(back:getContentSize().width/2, back:getContentSize().height/2-70)
    button_left:setTitleText("确定")
    button_left:setTitleFontSize(30)
    button_left:addTouchEventListener(button_left_clicked)
    back:addChild(button_left)

    return main    
end


return HintAlter







