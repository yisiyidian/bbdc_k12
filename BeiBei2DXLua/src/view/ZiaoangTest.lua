require "common.global"

local InputNode = require("src.view.login.InputNode")

local ZiaoangTest = class("ZiaoangTest", function()
    return cc.Layer:create()
end)

function ZiaoangTest.create()
    local main = ZiaoangTest.new()
    --main:setContentSize(640,640)
    --main:setAnchorPoint(0,0)
    
    
    local a = InputNode.create("username")
    a:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    main:addChild(a)
    
--    local b = InputNode.create("password")
--    b:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2-200)
--    main:addChild(b)

--    local back = cc.LayerColor:create(cc.c4b(255,255,0,255),400,400)
--    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--    back:ignoreAnchorPointForPosition(false)
--    main:addChild(back)
--   
--    
--    local onTouchBegan = function(touch, event)
--        s_logd("touch")
--        return true
--    end
--    
--    local onTouchEnded = function(touch, event)
--        s_logd("ended")
--    end
--    
--
--    local listener = cc.EventListenerTouchOneByOne:create()
--    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )
--    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED )
--    listener:setSwallowTouches(true)
--    local eventDispatcher2 = back:getEventDispatcher()
--    eventDispatcher2:addEventListenerWithSceneGraphPriority(listener, back)
--    
--    
--    local button_donotknow_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            print("button")
--        end
--    end
--    
--    local button_donotknow = ccui.Button:create("image/testscene/testscene_donotkonw.png","","")
--    button_donotknow:setAnchorPoint(1,0.5)
--    button_donotknow:setPosition(s_DESIGN_WIDTH,896)
--    button_donotknow:addTouchEventListener(button_donotknow_clicked)
--    main:addChild(button_donotknow)
    
    return main
end


return ZiaoangTest







