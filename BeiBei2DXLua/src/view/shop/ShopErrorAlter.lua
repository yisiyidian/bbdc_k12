require("common.global")

local ShopErrorAlter = class("ShopErrorAlter", function()
    return cc.Layer:create()
end)

local button_sure

function ShopErrorAlter.create()
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.sure = function() 
        main:removeFromParent()
    end

    local back = cc.Sprite:create("image/alter/tanchu_board_small_white.png")
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height

    local label_content = cc.Label:createWithSystemFont("贝贝豆不足","",32)
    label_content:setAnchorPoint(0.5, 0.5)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setPosition(maxWidth/2, maxHeight/2+60)
    back:addChild(label_content)

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main:removeFromParent()
        end
    end

    button_close = ccui.Button:create("image/button/button_close.png","image/button/button_close.png","")
    button_close:setPosition(maxWidth-30,maxHeight-30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)

    local button_sure_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- main.sure()
            s_CorePlayManager.enterLevelLayer()
        end
    end

    button_sure = ccui.Button:create("image/shop/long_button.png","image/shop/long_button_clicked.png","")
    button_sure:setTitleText("赚取贝贝豆")
    button_sure:setTitleFontSize(30)
    button_sure:setPosition(maxWidth/2,100)
    button_sure:addTouchEventListener(button_sure_clicked)
    back:addChild(button_sure)

    -- touch lock
    local onTouchBegan = function(touch, event)        
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end

return ShopErrorAlter
