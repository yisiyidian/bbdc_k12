require("common.global")
local Button                = require("view.button.longButtonInStudy")

local ShopErrorAlter = class("ShopErrorAlter", function()
    return cc.Layer:create()
end)

local button_sure

function ShopErrorAlter.create()
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local main = cc.Layer:create()

    main.sure = function() 
        main:removeFromParent()
    end

    local back = cc.Sprite:create("image/alter/tanchu_board_small_white.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height

    local label_content = cc.Label:createWithSystemFont("贝贝豆不足","",32)
    label_content:setAnchorPoint(0.5, 0.5)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setPosition(maxWidth/2, maxHeight/2+60)
    back:addChild(label_content)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           closeAnimation()
        end
    end

    button_close = ccui.Button:create("image/button/button_close.png","image/button/button_close.png","")
    button_close:setPosition(maxWidth-30,maxHeight-30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)

    local button_func = function()
        s_SCENE:removeAllPopups()
        s_CorePlayManager.enterLevelLayer()
    end

    button_sure = Button.create("image/button/middleblueback.png","image/button/middlebluefront.png",9,"赚取贝贝豆") 
    button_sure:setPosition(maxWidth/2,100)
    button_sure.func = function ()
        button_func()
    end
    back:addChild(button_sure)

    -- touch lock
    local onTouchBegan = function(touch, event)        
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

return ShopErrorAlter
