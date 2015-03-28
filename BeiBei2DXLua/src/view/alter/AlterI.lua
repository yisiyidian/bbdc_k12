require("common.global")
local Button                = require("view.button.longButtonInStudy")

local AlterI = class("AlterI", function()
    return cc.Layer:create()
end)

function AlterI.create(info)
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
    
    local main = cc.Layer:create()

    main.close = function()
        s_SCENE:removeAllPopups()
    end

    local back = cc.Sprite:create("image/alter/tanchu_board_big_white.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local backWidth = back:getContentSize().width
    local backHeight = back:getContentSize().height

    local label_info = cc.Label:createWithSystemFont(info,"",28)
    label_info:setColor(cc.c4b(0,0,0,255))
    label_info:setPosition(backWidth/2, backHeight/2+100)
    back:addChild(label_info)

    local button_up_func = function()
        playSound(s_sound_buttonEffect)
        cx.CXUtils:showMail(s_DataManager.getTextWithIndex(TEXT__FEEDBACK_MAIL_SUGGESTION), s_CURRENT_USER.username)
    end

    local button_up = Button.create("middle","blue",s_DataManager.getTextWithIndex(TEXT__FEEDBACK_BTN_SUGGESTION))
    button_up.func = function ()
        button_up_func()
    end

    button_up:setPosition(backWidth/2, backHeight/2)
    back:addChild(button_up)

    local button_down_func = function()
        playSound(s_sound_buttonEffect)
        cx.CXUtils:showMail(s_DataManager.getTextWithIndex(TEXT__FEEDBACK_MAIL_BUG), s_CURRENT_USER.username)
    end

    local button_down = Button.create("middle","blue",s_DataManager.getTextWithIndex(TEXT__FEEDBACK_BTN_BUG))
    button_down.func = function ()
        button_down_func()
    end

    button_down:setPosition(backWidth/2, backHeight/2-150)
    back:addChild(button_down)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
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







