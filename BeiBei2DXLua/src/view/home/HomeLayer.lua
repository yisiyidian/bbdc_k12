require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)


function HomeLayer.create()
    local layer = HomeLayer.new()

    local backColor = cc.LayerColor:create(cc.c4b(30,193,239,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

   
    local button_middle_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_middle = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
    button_middle:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    button_middle:setTitleText("进入关卡选择界面")
    button_middle:setTitleFontSize(30)
    button_middle:addTouchEventListener(button_middle_clicked)
    layer:addChild(button_middle)
    
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
