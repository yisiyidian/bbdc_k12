require("common.global")

local BigAlter = class("BigAlter", function()
    return cc.Layer:create()
end)

function BigAlter.create(info)
    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local back = cc.Sprite:create("image/alter/tanchu_board_big_white.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local label_info = cc.Label:createWithSystemFont(info,"",28)
    label_info:setColor(cc.c4b(0,0,0,255))
    label_info:setPosition(back:getContentSize().width/2, back:getContentSize().height/2+50)
    back:addChild(label_info)
    
    local button_middle_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_middle = ccui.Button:create("image/button/studyscene_blue_button.png","","")
    button_middle:setPosition(back:getContentSize().width/2, back:getContentSize().height/2-50)
    button_middle:setTitleText("考试")
    button_middle:setTitleFontSize(30)
    button_middle:addTouchEventListener(button_middle_clicked)
    back:addChild(button_middle)

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


return BigAlter







