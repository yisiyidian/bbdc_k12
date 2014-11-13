require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)


function HomeLayer.create()
    local layer = HomeLayer.new()

    local backImage = cc.Sprite:create("image/homescene/main_backGround.png")
    backImage:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backImage)
   
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            
        end
    end

    local button_left = ccui.Button:create("image/homescene/main_set.png","image/homescene/main_set.png","")
    button_left:setPosition(50, s_DESIGN_HEIGHT-75)
    button_left:addTouchEventListener(button_left_clicked)
    layer:addChild(button_left)
    
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_right = ccui.Button:create("image/homescene/main_friends.png","image/homescene/main_friends.png","")
    button_right:setPosition(s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT-75)
    button_right:addTouchEventListener(button_right_clicked)
    layer:addChild(button_right)   
    
    local container = cc.Sprite:create("image/homescene/main_wordstore.png")
    container:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(container)
    
    local button_change_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_change = ccui.Button:create("image/homescene/main_switchbutton.png","image/homescene/main_switchbutton.png","")
    button_change:setPosition(10, container:getContentSize().height/2)
    button_change:addTouchEventListener(button_change_clicked)
    container:addChild(button_change)
    
    local data = cc.Sprite:create("image/homescene/main_bottom.png")
    data:setAnchorPoint(0.5,0)
    data:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(data)
    
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        
        return true
    end
    
    local onTouchMoved = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return HomeLayer
