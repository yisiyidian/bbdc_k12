require "common.global"

local TestLayer = class("TestLayer", function()
    return cc.Layer:create()
end)

function TestLayer.create()
    -- system variate
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local main = TestLayer.new()
    --main:setContentSize(640,640)
    --main:setAnchorPoint(0,0)
    
    local colorBlock = cc.LayerColor:create(cc.c4b(255,0,0,255),400,400)
    main:addChild(colorBlock)
    
    local sub_colorBlock = cc.LayerColor:create(cc.c4b(255,255,0,255),100,100)
    sub_colorBlock:setPosition(100,100)
    sub_colorBlock:ignoreAnchorPointForPosition(false)
    colorBlock:addChild(sub_colorBlock)

    print(main:getContentSize().height)
    print(main:getContentSize().width)
    print(main:getPosition())
    print(main:getAnchorPoint().x)
    print(main:getAnchorPoint().y)
    
    print(colorBlock:getContentSize().height) 
    print(colorBlock:getContentSize().width)
    print(colorBlock:getPosition())
    print(colorBlock:getAnchorPoint().x)
    print(colorBlock:getAnchorPoint().y)
    
    print(sub_colorBlock:getContentSize().height) 
    print(sub_colorBlock:getContentSize().width)
    print(sub_colorBlock:getPosition())
    print(sub_colorBlock:getAnchorPoint().x)
    print(sub_colorBlock:getAnchorPoint().y)
    
    onTouchBegan1 = function(touch, event)
        print("touch 1")

        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    onTouchBegan2 = function(touch, event)
        print("touch 2")

        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:registerScriptHandler(onTouchBegan1, cc.Handler.EVENT_TOUCH_BEGAN )
    listener1:setSwallowTouches(true)
    local eventDispatcher1 = colorBlock:getEventDispatcher()
    eventDispatcher1:addEventListenerWithSceneGraphPriority(listener1, colorBlock)
    
    
    local listener2 = cc.EventListenerTouchOneByOne:create()
    listener2:registerScriptHandler(onTouchBegan2, cc.Handler.EVENT_TOUCH_BEGAN )
    listener2:setSwallowTouches(true)
    local eventDispatcher2 = sub_colorBlock:getEventDispatcher()
    eventDispatcher2:addEventListenerWithSceneGraphPriority(listener2, sub_colorBlock)
    
    return main
end


return TestLayer







