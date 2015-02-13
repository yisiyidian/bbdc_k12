require("common.global")

local GuideAlter = class("GuideAlter", function()
    return cc.Layer:create()
end)

function GuideAlter.create(type, title, content) -- 0 for small alter and 1 for big alter
    if title == nil then
        title = "Title"
    end
    
    if content == nil then
        content = "This is content"
    end

    local backImageName
    local maxWidth
    local maxHeight
    if type == 0 then
        backImageName = "image/newstudy/popup_panel_small.png"
    else
        backImageName = "image/newstudy/popup_panel_big.png"
    end
    
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)    

    main.cancel = function()

    end
    
    main.sure = function()
        
    end
    
    main.know = function()
        
    end
    
    main.box_tag = 0
    
    local box = nil
    local box_right = nil

    local back = cc.Sprite:create(backImageName)
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)
    
    main.addbeibeiThrowHeart = function()
       local beibei = cc.Sprite:create("image/newstudy/throwheart.png")
       beibei:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
       back:addChild(beibei)
    end
    
    main.addbeibeiBreakHeart = function()
        local beibei = cc.Sprite:create("image/newstudy/breakheart.png")
        beibei:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
        back:addChild(beibei)
    end
    
    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    maxWidth = back:getContentSize().width
    maxHeight = back:getContentSize().height
    
    -- label info
    local label_title = cc.Label:createWithSystemFont(title,"",44)
    label_title:setColor(cc.c4b(0,0,0,255))
    label_title:setPosition(maxWidth/2, maxHeight-50)
    back:addChild(label_title)
    
    local label_content = cc.Label:createWithSystemFont(content,"",32)
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setDimensions(maxWidth-60,0)
    label_content:setAlignment(0)
    label_content:setPosition(maxWidth/2, maxHeight-100)
    back:addChild(label_content)
    
    -- button info
    if type == 0 then
        local button_know_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                main.know()
                s_SCENE:removeAllPopups()
            end
        end
    
        local button_know = ccui.Button:create("image/download/button_blue_small.png","image/download/button_blue_small_clicked.png","")
        button_know:setTitleText("知道了")
        button_know:setTitleFontSize(30)
        button_know:setPosition(maxWidth/2,80)
        button_know:addTouchEventListener(button_know_clicked)
        back:addChild(button_know)
    else
--        box = cc.Sprite:create("image/newstudy/guide_box.png")
--        box:setPosition(maxWidth/2, 160)
--        back:addChild(box)
--        
--        box_right = cc.Sprite:create("image/newstudy/guide_right.png")
--        box_right:setPosition(maxWidth/2, 160)
--        box_right:setVisible(false)
--        back:addChild(box_right)
--        
--        local label_box = cc.Label:createWithSystemFont("不再出现此提示","",24)
--        label_box:setAnchorPoint(0, 0.5)
--        label_box:setColor(cc.c4b(0,0,0,255))
--        label_box:setPosition(maxWidth/2+30, 160)
--        back:addChild(label_box)
    
        local button_cancel_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                main.cancel()
                s_SCENE:removeAllPopups()
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
                s_SCENE:removeAllPopups()
            end
        end
    
        local button_sure = ccui.Button:create("image/download/button_blue_small.png","image/download/button_blue_small_clicked.png","")
        button_sure:setTitleText("确定")
        button_sure:setTitleFontSize(30)
        button_sure:setPosition(maxWidth/2+110,80)
        button_sure:addTouchEventListener(button_sure_clicked)
        back:addChild(button_sure)
    end

 -- touch lock
    local onTouchBegan = function(touch, event)
--        if box ~= nil then
--            local location = box:convertToNodeSpace(touch:getLocation())
--            if cc.rectContainsPoint({x=0,y=0,width=box:getBoundingBox().width,height=box:getBoundingBox().height}, location) then
--                if main.box_tag == 0 then
--                    main.box_tag = 1
--                    box_right:setVisible(true)
--                else
--                    main.box_tag = 0
--                    box_right:setVisible(false)
--                end
--            end
--        end
        
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main    
end


return GuideAlter







