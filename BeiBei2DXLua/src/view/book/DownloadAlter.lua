require("common.global")

local DownloadAlter = class("DownloadAlter", function()
    return cc.Layer:create()
end)

function DownloadAlter.create(content)
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.cancel = function()
        
    end
    
    main.sure = function()
        
    end

    local back = cc.Sprite:create("image/download/choose_book_delete_audio_bg.png")
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height
    
    -- label info
    local label_content = cc.Label:createWithSystemFont(content,"",32)
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setDimensions(maxWidth-60,0)
    label_content:setAlignment(0)
    label_content:setPosition(maxWidth/2, maxHeight-50)
    back:addChild(label_content)

    local button_cancel_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main.cancel()
            main:removeFromParent()
        end
    end

    local button_cancel = ccui.Button:create("image/download/button_blue_small.png","image/download/button_blue_small_clicked.png","")
    button_cancel:setTitleText("取消")
    button_cancel:setTitleFontSize(30)
    button_cancel:setPosition(maxWidth/2-110,80)
    button_cancel:addTouchEventListener(button_cancel_clicked)
    back:addChild(button_cancel)

    local button_sure_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main.sure()
        end
    end

    local button_sure = ccui.Button:create("image/download/button_blue_small.png","image/download/button_blue_small_clicked.png","")
    button_sure:setTitleText("确定")
    button_sure:setTitleFontSize(30)
    button_sure:setPosition(maxWidth/2+110,80)
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


return DownloadAlter







