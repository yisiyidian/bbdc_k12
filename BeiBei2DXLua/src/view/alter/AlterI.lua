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
        main:removeFromParent()
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
            cx.CXUtils:showMail(s_DataManager.getTextWithIndex(TEXT_ID_FEEDBACK_MAIL_SUGGESTION), s_CURRENT_USER.username)
        end
    end

    local button_up = ccui.Button:create("image/button/bigBlueButton.png","image/button/bigBlueButton.png","")
    button_up:setPosition(backWidth/2, backHeight/2)
    button_up:setTitleText(s_DataManager.getTextWithIndex(TEXT_ID_FEEDBACK_BTN_SUGGESTION))
    button_up:setTitleFontSize(30)
    button_up:addTouchEventListener(button_left_clicked)
    back:addChild(button_up)

    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            cx.CXUtils:showMail(s_DataManager.getTextWithIndex(TEXT_ID_FEEDBACK_MAIL_BUG), s_CURRENT_USER.username)
        end
    end

    local button_down = ccui.Button:create("image/button/bigBlueButton.png","image/button/bigBlueButton.png","")
    button_down:setPosition(backWidth/2, backHeight/2-100)
    button_down:setTitleText(s_DataManager.getTextWithIndex(TEXT_ID_FEEDBACK_BTN_BUG))
    button_down:setTitleFontSize(30)
    button_down:addTouchEventListener(button_right_clicked)
    back:addChild(button_down)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            main.close()
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           closeAnimation()
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
    
    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
           closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    onAndroidKeyPressed(main, function ()
        closeAnimation()
    end, function ()

    end)

    return main    
end


return AlterI







