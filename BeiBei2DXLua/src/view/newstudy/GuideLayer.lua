local  GuideLayer = class("GuideLayer", function ()
    return cc.Layer:create()
end)


function GuideLayer.create()

    local layer = GuideLayer.new()
    
    local back = cc.Sprite:create("image/newsyudy/background_yindao_big.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    layer:addChild(back)

    local beibei = cc.Sprite:create("image/newsyudy/bb_big_yindao.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*(-3))
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    layer:addChild(back)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local action3 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55))
    local action4 = cc.EaseBackOut:create(action1)
    beibei:runAction(action4)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.2, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            closeAnimation() 
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)


    onAndroidKeyPressed(layer, function ()
        closeAnimation()
    end, function ()

    end)
    
    return layer
end

return GuideLayer