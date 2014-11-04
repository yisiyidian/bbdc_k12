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
        if i == 1 then
            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
        else
            intro:setPosition(s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2)
        end
        layer:addChild(intro)
        table.insert(intro_array, intro)
    end

--    -- 临时添加 start
--    local intro = cc.Sprite:create("image/login/denglu_4_background.png")
--    intro:setPosition(s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2)
--    layer:addChild(intro)
--    table.insert(intro_array, intro)
--    -- 临时添加 end

    local intro = cc.Layer:create()
    intro:setContentSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT)
    intro:setAnchorPoint(0.5,0.5)
    intro:ignoreAnchorPointForPosition(false)
    intro:setPosition(s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2)
    layer:addChild(intro)
    table.insert(intro_array, intro)
    
    local head = cc.Sprite:create("image/login/logo_denglu.png")
    head:setPosition(s_DESIGN_WIDTH/2, 800)
    intro:addChild(head)
    
    local button_visitor_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_logd("visitor")
        end
    end
    
    local button_visitor = ccui.Button:create()
    button_visitor:loadTextures("image/button/button_white2_denglu.png", "", "")
    button_visitor:addTouchEventListener(button_visitor_clicked)
    button_visitor:setPosition(s_DESIGN_WIDTH/2, 500)
    button_visitor:setTitleFontSize(36)
    button_visitor:setTitleText("游客登陆")
    intro:addChild(button_visitor)
    
    local button_login
    local button_register

    local cloud = cc.Sprite:create("image/login/cloud_denglu.png")
    cloud:setAnchorPoint(0.5,0)
    cloud:setPosition(s_DESIGN_WIDTH/2,-200)
    layer:addChild(cloud)
    
    local label_hint = cc.Label:createWithSystemFont("登陆贝贝单词，发现更多精彩","",36)
    label_hint:setColor(cc.c4b(0,0,0,255))
    label_hint:setPosition(s_DESIGN_WIDTH/2, 100)
    layer:addChild(label_hint)

    local circle_back_array = {}
    local circle_font_array = {}
    local gap = 50
    local left = s_DESIGN_WIDTH/2 - gap*2
    for i = 1, 5 do
        local circle_back = cc.Sprite:create("image/login/yuan_white_denglu.png")
        circle_back:setPosition(left+gap*(i-1),50)
        layer:addChild(circle_back)
        table.insert(circle_back_array, circle_back)
        
        local circle_font = cc.Sprite:create("image/login/yuan_blue_denglu.png")
        circle_font:setPosition(left+gap*(i-1),50)
        layer:addChild(circle_font)
        table.insert(circle_font_array, circle_font)
        
        if i == currentIndex then
           circle_back:setVisible(false)
           circle_font:setVisible(true)
        else
           circle_back:setVisible(true)
           circle_font:setVisible(false)
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
            if currentIndex == 5 then
                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*0.5, -200))
                cloud:runAction(action2)
                
                button_login:setVisible(false)
                button_register:setVisible(falses)
            end
        
            if currentIndex > 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2))
                intro_array[currentIndex]:runAction(action1)
  
                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex-1]:runAction(cc.Sequence:create(action2, action3))

                circle_back_array[currentIndex]:setVisible(true)
                circle_font_array[currentIndex]:setVisible(false)
                currentIndex = currentIndex - 1
                circle_back_array[currentIndex]:setVisible(false)
                circle_font_array[currentIndex]:setVisible(true)                
            end
        elseif now_x + 200 < start_x then
            if currentIndex < 5 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true
                
                local action1 = cc.MoveTo:create(0.5, cc.p(-s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2))
                intro_array[currentIndex]:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex+1]:runAction(cc.Sequence:create(action2, action3))
                
                circle_back_array[currentIndex]:setVisible(true)
                circle_font_array[currentIndex]:setVisible(false)
                currentIndex = currentIndex + 1
                circle_back_array[currentIndex]:setVisible(false)
                circle_font_array[currentIndex]:setVisible(true)
            end
            if currentIndex == 5 then                
                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*0.5, 0))
                cloud:runAction(action2)
                                
                local button_login_clicked = function(sender, eventType)
                    if eventType == ccui.TouchEventType.began then
                        s_logd("login")
                    end
                end
                
                local button_register_clicked = function(sender, eventType)
                    if eventType == ccui.TouchEventType.began then
                        s_logd("register")
                    end
                end

                if button_login then
                    button_login:setVisible(true)
                else
                    button_login = ccui.Button:create()
                    button_login:loadTextures("image/button/button_white_denglu.png", "", "")
                    button_login:addTouchEventListener(button_login_clicked)
                    button_login:setPosition(s_DESIGN_WIDTH/2-150, 200)
                    button_login:setTitleFontSize(36)
                    button_login:setTitleText("登陆")
                    button_login:setTitleColor(cc.c4b(0,0,0,255))
                    layer:addChild(button_login)
                end
                
                if button_register then
                    button_register:setVisible(true)
                else
                    button_register = ccui.Button:create()
                    button_register:loadTextures("image/button/button_white_denglu.png", "", "")
                    button_register:addTouchEventListener(button_register_clicked)
                    button_register:setPosition(s_DESIGN_WIDTH/2+150, 200)
                    button_register:setTitleFontSize(36)
                    button_register:setTitleText("注册")
                    button_register:setTitleColor(cc.c4b(0,0,0,255))
                    layer:addChild(button_register)
                end
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