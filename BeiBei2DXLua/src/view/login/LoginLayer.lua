require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local LoginLayer = class("LoginLayer", function ()
    return cc.Layer:create()
end)


function LoginLayer.create()
    local layer = LoginLayer.new()
    
    local currentIndex = 1
    
    local backColor = cc.LayerColor:create(cc.c4b(30,193,239,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local intro_array = {}
    for i = 1,4 do
        local intro = cc.Sprite:create("image/login/denglu_"..i.."_background.png")
        intro:setPosition(s_DESIGN_WIDTH/2*(2*i-1),s_DESIGN_HEIGHT/2)
        layer:addChild(intro)
        table.insert(intro_array, intro)
    end

    local cloud = cc.Sprite:create("image/login/cloud_denglu.png")
    cloud:setAnchorPoint(0.5,0)
    cloud:setPosition(s_DESIGN_WIDTH/2,-200)
    layer:addChild(cloud)

    local circle_array = {}
    local gap = 50
    local left = s_DESIGN_WIDTH/2 - gap*2
    for i = 1, 5 do
        if i == currentIndex then
            local circle = cc.Sprite:create("image/login/yuan_blue_denglu.png")
            circle:setPosition(left+gap*(i-1),50)
            layer:addChild(circle)
            table.insert(intro_array, circle)
        else
            local circle = cc.Sprite:create("image/login/yuan_white_denglu.png")
            circle:setPosition(left+gap*(i-1),50)
            layer:addChild(circle)
            table.insert(intro_array, circle)
        end
    end
    
    local moved = false
    local start_x = nil
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        start_x = location.x
        moved = false
        return true
    end
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
        local location = layer:convertToNodeSpace(touch:getLocation())
        now_x = location.x
        if now_x - 200 > start_x then
            if currentIndex ~= 1 then
                moved = true
                for i = 1,4 do
                    local action = cc.MoveBy:create(0.5, cc.p(s_DESIGN_WIDTH,0))
                    intro_array[i]:runAction(action)
                end
                currentIndex = currentIndex - 1
            end
        elseif now_x + 200 < start_x then
            if currentIndex ~= 5 then
                moved = true
                for i = 1,4 do
                    local action = cc.MoveBy:create(0.5, cc.p(-s_DESIGN_WIDTH,0))
                    intro_array[i]:runAction(action)
                end
                currentIndex = currentIndex + 1
            end
        end
    end


    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return LoginLayer
