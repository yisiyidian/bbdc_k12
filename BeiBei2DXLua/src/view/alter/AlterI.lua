require("common.global")

local AlterI = class("AlterI", function()
    return cc.Layer:create()
end)

function AlterI.create(info)
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
    
    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.close = function()
        main:removeFromParentAndCleanup()
    end

    local back = cc.Sprite:create("image/alter/tanchu_board_big_white.png")
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local backWidth = back:getContentSize().width
    local backHeight = back:getContentSize().height

    local label_info = cc.Label:createWithSystemFont(info,"",28)
    label_info:setColor(cc.c4b(0,0,0,255))
    label_info:setPosition(backWidth/2, backHeight/2+100)
    back:addChild(label_info)

    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            -- TODO
        end
    end

    local button_left = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
    button_left:setPosition(backWidth/2, backHeight/2)
    button_left:setTitleText("提个意见")
    button_left:setTitleFontSize(30)
    button_left:addTouchEventListener(button_left_clicked)
    back:addChild(button_left)

    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            -- TODO
            
        end
    end

    local button_right = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
    button_right:setPosition(backWidth/2, backHeight/2-100)
    button_right:setTitleText("提个bug")
    button_right:setTitleFontSize(30)
    button_right:addTouchEventListener(button_right_clicked)
    back:addChild(button_right)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main.close()
        end
    end
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(backWidth,backHeight)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main    
end


return AlterI







