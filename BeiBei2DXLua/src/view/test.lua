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

    s_logd(main:getContentSize().height)
    s_logd(main:getContentSize().width)
    s_logd(main:getPosition())
    s_logd(main:getAnchorPoint().x)
    s_logd(main:getAnchorPoint().y)
    
    s_logd(colorBlock:getContentSize().height) 
    s_logd(colorBlock:getContentSize().width)
    s_logd(colorBlock:getPosition())
    s_logd(colorBlock:getAnchorPoint().x)
    s_logd(colorBlock:getAnchorPoint().y)
    
    s_logd(sub_colorBlock:getContentSize().height) 
    s_logd(sub_colorBlock:getContentSize().width)
    s_logd(sub_colorBlock:getPosition())
    s_logd(sub_colorBlock:getAnchorPoint().x)
    s_logd(sub_colorBlock:getAnchorPoint().y)
    
    onTouchBegan1 = function(touch, event)
        s_logd("touch 1")

        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    onTouchBegan2 = function(touch, event)
        s_logd("touch 2")

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







