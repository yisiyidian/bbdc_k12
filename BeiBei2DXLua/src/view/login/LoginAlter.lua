require("common.global")

local BigAlter      = require("view.alter.BigAlter")
local SmallAlter    = require("view.alter.SmallAlter")
local InputNode     = require("view.login.InputNode")

local LoginAlter = class("LoginAlter", function()
    return cc.Layer:create()
end)

local showLogin = nil
local showRegister = nil

local back_login = nil
local back_register = nil

local main = nil
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

function LoginAlter.createLogin()
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.close = function()
    end
    
    back_login = nil
    back_register = nil
    
    showLogin()

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end

function LoginAlter.createRegister()
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.close = function()
    end

    back_login = nil
    back_register = nil

    showRegister()

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end


showLogin = function()
    if back_login then
        local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
        local action2 = cc.EaseBackOut:create(action1)
        back_login:runAction(action2)
        return
    end

    back_login = cc.Sprite:create("image/login/background_white_login.png")
    back_login:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back_login)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back_login:runAction(action2)

    local back_width = back_login:getContentSize().width
    local back_height = back_login:getContentSize().height

    local circle = cc.Sprite:create("image/login/circle_head_login.png")
    circle:setPosition(back_width/2, back_height)
    back_login:addChild(circle)
    
    local head = cc.Sprite:create("image/login/gril_head.png")
    head:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    circle:addChild(head)

    local label1 = cc.Label:createWithSystemFont("登陆","",40)
    label1:setColor(cc.c4b(115,197,243,255))
    label1:setPosition(back_width/2,680)
    back_login:addChild(label1)
    
    local label2 = cc.Label:createWithSystemFont("登陆可以和更多的好友一起背单词","",24)
    label2:setColor(cc.c4b(100,100,100,255))
    label2:setPosition(back_width/2,640)
    back_login:addChild(label2)
    
    local username = InputNode.create("username")
    username:setPosition(back_width/2, 550)
    back_login:addChild(username)
    
    local password = InputNode.create("password")
    password:setPosition(back_width/2, 450)
    back_login:addChild(password)
    
    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then 
            -- button sound
            playSound(s_sound_buttonEffect)
            
            if validateUsername(username.textField:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_USERNAME_ERROR))
                return
            end
            if validatePassword(password.textField:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_PWD_ERROR))
                return
            end
            s_SCENE:logIn(username.textField:getStringValue(), password.textField:getStringValue())
        end
    end
    
    local submit = ccui.Button:create("image/login/sl_button_confirm.png","image/login/sl_button_confirm.png","")
    submit:setPosition(back_width/2, 350)
    submit:addTouchEventListener(submit_clicked)
    back_login:addChild(submit)
    
    local label_name = cc.Label:createWithSystemFont("登陆","",30)
    label_name:setColor(cc.c4b(255,255,255,255))
    label_name:setPosition(submit:getContentSize().width/2, submit:getContentSize().height/2)
    submit:addChild(label_name)
    
    local button_toggle_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then            
            -- button sound
            playSound(s_sound_buttonEffect)
            local remove = function()
                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
                local action2 = cc.EaseBackIn:create(action1)
                back_login:runAction(action2)
            end
            local action1 = cc.CallFunc:create(remove)
            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(showRegister)
            local action4 = cc.Sequence:create(action1, action2, action3)
            main:runAction(action4)             
        end
    end
    
    local button_toggle = ccui.Button:create()
    button_toggle:loadTextures("image/button/button_login_signup.png", "", "")
    button_toggle:addTouchEventListener(button_toggle_clicked)
    button_toggle:setPosition(back_width/2, 200)
    button_toggle:setTitleFontSize(28)
    button_toggle:setTitleText("返回注册")
    button_toggle:setTitleColor(cc.c4b(115,197,243,255))
    back_login:addChild(button_toggle)  
    
    local button_qq_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            print("qq click")  
                  -- button sound
        playSound(s_sound_buttonEffect)
        end
    end
    
    local button_qq = ccui.Button:create("image/login/button_login_signup_qq.png")
    button_qq:setPosition(back_width/2,100)
    button_qq:addTouchEventListener(button_qq_clicked)
 --   back_login:addChild(button_qq)
    
    local button_weixin_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            print("weixin click") 
                   -- button sound
        playSound(s_sound_buttonEffect)
        end
    end

    local button_weixin = ccui.Button:create("image/login/button_login_signupwechat.png")
    button_weixin:setPosition(back_width/2-100,100)
    button_weixin:addTouchEventListener(button_weixin_clicked)
 --   back_login:addChild(button_weixin)
    
    local button_weibo_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            print("weibo click")  
                  -- button sound
            playSound(s_sound_buttonEffect)
        end
    end

    local button_weibo = ccui.Button:create("image/login/button_login_signupwechat.png")
    button_weibo:setPosition(back_width/2+100,100)
    button_weibo:addTouchEventListener(button_weibo_clicked)
 --   back_login:addChild(button_weibo)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            main.close()
        end
    end
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(back_width-30,back_height-10)
    button_close:addTouchEventListener(button_close_clicked)
    back_login:addChild(button_close)
end

showRegister = function()
    if back_register then
        local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
        local action2 = cc.EaseBackOut:create(action1)
        back_register:runAction(action2)
        return
    end

    back_register = cc.Sprite:create("image/login/background_white_login.png")
    back_register:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back_register)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back_register:runAction(action2)

    local back_width = back_register:getContentSize().width
    local back_height = back_register:getContentSize().height

    local circle = cc.Sprite:create("image/login/circle_head_login.png")
    circle:setPosition(back_width/2, back_height)
    back_register:addChild(circle)

    local head = cc.Sprite:create("image/login/gril_head.png")
    head:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    circle:addChild(head)

    local label1 = cc.Label:createWithSystemFont("注册","",40)
    label1:setColor(cc.c4b(115,197,243,255))
    label1:setPosition(back_width/2,680)
    back_register:addChild(label1)

    local label2 = cc.Label:createWithSystemFont("注册可以和更多的好友一起背单词","",24)
    label2:setColor(cc.c4b(100,100,100,255))
    label2:setPosition(back_width/2,640)
    back_register:addChild(label2)

    local username = InputNode.create("username")
    username:setPosition(back_width/2, 550)
    back_register:addChild(username)

    local password = InputNode.create("password")
    password:setPosition(back_width/2, 450)
    back_register:addChild(password)
    
    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then       
            -- button sound
            playSound(s_sound_buttonEffect)
            if validateUsername(username.textField:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_USERNAME_ERROR))
                return
            end
            if validatePassword(password.textField:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_PWD_ERROR))
                return
            end
            s_CURRENT_USER.isGuest = 0
            s_SCENE:signUp(username.textField:getStringValue(), password.textField:getStringValue())
        end
    end

    local submit = ccui.Button:create("image/login/sl_button_confirm.png","image/login/sl_button_confirm.png","")
    submit:setPosition(back_width/2, 350)
    submit:addTouchEventListener(submit_clicked)
    back_register:addChild(submit)
    
    local label_name = cc.Label:createWithSystemFont("注册","",30)
    label_name:setColor(cc.c4b(255,255,255,255))
    label_name:setPosition(submit:getContentSize().width/2, submit:getContentSize().height/2)
    submit:addChild(label_name)

    local button_toggle_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local remove = function()
                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
                local action2 = cc.EaseBackIn:create(action1)
                back_register:runAction(action2)
            end
            local action1 = cc.CallFunc:create(remove)
            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(showLogin)
            local action4 = cc.Sequence:create(action1, action2, action3)
            main:runAction(action4)  
            
            -- button sound
            playSound(s_sound_buttonEffect) 
        end
    end

    local button_toggle = ccui.Button:create()
    button_toggle:loadTextures("image/button/button_login_signup.png", "", "")
    button_toggle:addTouchEventListener(button_toggle_clicked)
    button_toggle:setPosition(back_width/2, 200)
    button_toggle:setTitleFontSize(28)
    button_toggle:setTitleText("返回登陆")
    button_toggle:setTitleColor(cc.c4b(115,197,243,255))
    back_register:addChild(button_toggle) 
    
    local button_qq_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            print("qq click")  
                  -- button sound
        playSound(s_sound_buttonEffect)
        end
    end
    
    local button_qq = ccui.Button:create("image/login/button_login_signup_qq.png")
    button_qq:setPosition(back_width/2,100)
    button_qq:addTouchEventListener(button_qq_clicked)
--    back_register:addChild(button_qq)
    
    local button_weixin_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            print("weixin click") 
                   -- button sound
        playSound(s_sound_buttonEffect)
        end
    end   
    
    
    local button_weixin = ccui.Button:create("image/login/button_login_signupwechat.png")
    button_weixin:setPosition(back_width/2-100,100)
    button_weixin:addTouchEventListener(button_weixin_clicked)
--    back_register:addChild(button_weixin)


    local button_weibo_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            print("weibo click")  
                  -- button sound
        playSound(s_sound_buttonEffect)
        end
    end   
    
    local button_weibo = ccui.Button:create("image/login/button_login_signupwechat.png")
    button_weibo:setPosition(back_width/2+100,100)
    button_weibo:addTouchEventListener(button_weibo_clicked)    
--    back_register:addChild(button_weibo)
    
    local button_close_clicked = function(sender, eventType)

        if eventType == ccui.TouchEventType.began then
            main.close()      
              -- button sound
        playSound(s_sound_buttonEffect)
        end
    end
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(back_width-30,back_height-10)
    button_close:addTouchEventListener(button_close_clicked)
    back_register:addChild(button_close)
end

return LoginAlter







