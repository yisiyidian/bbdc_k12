
local PetAlter = class("PetAlter", function()
    return cc.Layer:create()
end)

function PetAlter.create(petID)
    local main = cc.Layer:create()

    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/pet/pet_alter/board.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height

    local pet = cc.Sprite:create("image/pet/pet_detail/"..petID.."_1.png")
    pet:setPosition(maxWidth/2, maxHeight/2)
    back:addChild(pet)

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 1.5))
            local action2 = cc.EaseBackIn:create(action1)
            local remove = cc.CallFunc:create(function() 
                main:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,remove))
        end
    end

    button_close = ccui.Button:create("image/pet/pet_alter/closeButton_1.png","image/pet/pet_alter/closeButton_2.png","")
    button_close:setPosition(maxWidth-80,maxHeight-80)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)

    -- touch lock
    local onTouchBegan = function(touch, event)        
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local remove = cc.CallFunc:create(function()
                main:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,remove))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end


return PetAlter
