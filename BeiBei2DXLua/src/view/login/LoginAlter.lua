require("common.global")

local BigAlter = require("view.alter.BigAlter")
local SmallAlter = require("view.alter.SmallAlter")

local LoginAlter = class("LoginAlter", function()
    return cc.Layer:create()
end)

local showLogin = nil
local showRegister = nil

local back_login = nil
local back_register = nil

local main = nil

function LoginAlter.createLogin()
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
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
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
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
        s_logd("login exist")
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
        local action2 = cc.EaseBackOut:create(action1)
        back_login:runAction(action2)

        return
    end
    s_logd("login not exist")

    back_login = cc.Sprite:create("image/login/background_white_login.png")
    back_login:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back_login)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
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
    
    local username = cc.Sprite:create("image/login/sl_username.png")
    username:setPosition(back_width/2, 550)
    back_login:addChild(username)
      
    local textField_username
    local textField_password  
    local cursor
      
    local cursorShowUp = function()
        cursor:stopAllActions()
        cursor:setVisible(false)
        local action1 = cc.DelayTime:create(0.1)
        local action2 = cc.CallFunc:create(
            function()
                cursor:setPosition(textField_username:getContentSize().width,textField_username:getContentSize().height/2)
                cursor:setVisible(true)
            end
        )
        local action3 = cc.FadeIn:create(0.5)
        local action4 = cc.FadeOut:create(0.5)
        local action5 = cc.RepeatForever:create(cc.Sequence:create(action3,action4))
        cursor:runAction(cc.Sequence:create(action1, action2))
        cursor:runAction(action5)
    end
      
    local function textFieldEvent_username(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_username:setPlaceHolder("")
            cursorShowUp()
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            cursor:setVisible(false)
            textField_username:setPlaceHolder("用户名")
        elseif eventType == ccui.TextFiledEventType.insert_text then
            cursorShowUp()
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            cursorShowUp()
        end
    end

    textField_username = ccui.TextField:create()
    textField_username:setTouchEnabled(true)
    textField_username:setFontSize(30)
    textField_username:setMaxLengthEnabled(true)
    textField_username:setMaxLength(10)
    textField_username:setColor(cc.c4b(0,0,0,255))
    textField_username:setPlaceHolder("用户名")
    textField_username:setPosition(cc.p(username:getContentSize().width / 2.0, username:getContentSize().height / 2.0))
    textField_username:addEventListener(textFieldEvent_username)
    username:addChild(textField_username)
    
    cursor = cc.Label:createWithSystemFont("|","",30)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    textField_username:addChild(cursor)
    
    local password = cc.Sprite:create("image/login/sl_password.png")
    password:setPosition(back_width/2, 450)
    back_login:addChild(password)
    
    local function textFieldEvent_password(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_password:setPlaceHolder("") 
            --back_login:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+200)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_password:setPlaceHolder("密码")
            --back_login:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
        elseif eventType == ccui.TextFiledEventType.insert_text then
            
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            
        end
    end

    textField_password = ccui.TextField:create()
    textField_password:setPasswordEnabled(true)
    textField_password:setPasswordStyleText("*")
    textField_password:setMaxLengthEnabled(true)
    textField_password:setMaxLength(10)
    textField_password:setTouchEnabled(true)
    textField_password:setFontSize(30)
    textField_password:setColor(cc.c4b(0,0,0,255))
    textField_password:setPlaceHolder("密码")
    textField_password:setPosition(cc.p(password:getContentSize().width / 2.0, password:getContentSize().height / 2.0))
    textField_password:addEventListener(textFieldEvent_password)
    password:addChild(textField_password)


    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if validateUsername(textField_username:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_USERNAME_ERROR))
                return
            end
            if validatePassword(textField_password:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_PWD_ERROR))
                return
            end

            s_SCENE:logIn(textField_username:getStringValue(), textField_password:getStringValue())
        	
--		    local function onResponse(u, e, code)
--                if e then                  
--                    local smallAlter = SmallAlter.create(e)
--                    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--                    smallAlter:setTag(1)
--                    main:addChild(smallAlter)
--                   
--                    s_LOADING_CIRCLE_LAYER:hide()
--                else
--                    s_SCENE:dispatchCustomEvent(CUSTOM_EVENT_LOGIN)
--                end
--            end
--            s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_USER_DATA))
--            s_UserBaseServer.login(textField_username:getStringValue(), textField_password:getStringValue(), onResponse)
        end
    end
    
    local submit = ccui.Button:create("image/login/sl_button_confirm.png","","")
    submit:setPosition(back_width/2, 350)
    submit:setTitleText("登陆")
    submit:setTitleFontSize(30)
    submit:addTouchEventListener(submit_clicked)
    back_login:addChild(submit)
    
    
    local button_login_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local remove = function()
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
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
    
    local button_login = ccui.Button:create()
    button_login:loadTextures("image/button/button_login_signup.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(back_width/2, 200)
    button_login:setTitleFontSize(28)
    button_login:setTitleText("返回注册")
    button_login:setTitleColor(cc.c4b(115,197,243,255))
    back_login:addChild(button_login)  
    
    local button_qq_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
           
        end
    end
    local button_qq = ccui.Button:create("image/login/button_login_signup_qq.png")
    button_qq:setPosition(back_width/2,100)
    button_qq:addTouchEventListener(button_qq_clicked)
    back_login:addChild(button_qq)
    
    local button_weixin_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    local button_weixin = ccui.Button:create("image/login/button_login_signupwechat.png")
    button_weixin:setPosition(back_width/2-100,100)
    button_weixin:addTouchEventListener(button_weixin_clicked)
    back_login:addChild(button_weixin)
    
    local button_weibo_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    local button_weibo = ccui.Button:create("image/login/button_login_signupweibo.png")
    button_weibo:setPosition(back_width/2+100,100)
    button_weibo:addTouchEventListener(button_weibo_clicked)
    back_login:addChild(button_weibo)
    

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
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
        s_logd("register exist")
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
        local action2 = cc.EaseBackOut:create(action1)
        back_register:runAction(action2)
        
        return
    end
    s_logd("register not exist")

    back_register = cc.Sprite:create("image/login/background_white_login.png")
    back_register:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back_register)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
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

    local username = cc.Sprite:create("image/login/sl_username.png")
    username:setPosition(back_width/2, 550)
    back_register:addChild(username)

    local textField_username
    local textField_password  

    local function textFieldEvent_username(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_username:setPlaceHolder("")
            --back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+100)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_username:setPlaceHolder("用户名")
            --back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
        elseif eventType == ccui.TextFiledEventType.insert_text then
            --self._displayValueLabel:setString("insert words")
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            --self._displayValueLabel:setString("delete word")
        end
    end

    textField_username = ccui.TextField:create()
    textField_username:setTouchEnabled(true)
    textField_username:setFontSize(30)
    textField_username:setMaxLengthEnabled(true)
    textField_username:setMaxLength(10)
    textField_username:setColor(cc.c4b(0,0,0,255))
    textField_username:setPlaceHolder("用户名")
    textField_username:setPosition(cc.p(username:getContentSize().width / 2.0, username:getContentSize().height / 2.0))
    textField_username:addEventListener(textFieldEvent_username)
    username:addChild(textField_username)

    local password = cc.Sprite:create("image/login/sl_password.png")
    password:setPosition(back_width/2, 450)
    back_register:addChild(password)

    local function textFieldEvent_password(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_password:setPlaceHolder("") 
            --back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+200)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_password:setPlaceHolder("密码")
            --back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
        elseif eventType == ccui.TextFiledEventType.insert_text then
            --self._displayValueLabel:setString("insert words")
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            --self._displayValueLabel:setString("delete word")
        end
    end

    textField_password = ccui.TextField:create()
    textField_password:setPasswordEnabled(true)
    textField_password:setPasswordStyleText("*")
    textField_password:setMaxLengthEnabled(true)
    textField_password:setMaxLength(10)
    textField_password:setTouchEnabled(true)
    textField_password:setFontSize(30)
    textField_password:setColor(cc.c4b(0,0,0,255))
    textField_password:setPlaceHolder("密码")
    textField_password:setPosition(cc.p(password:getContentSize().width / 2.0, password:getContentSize().height / 2.0))
    textField_password:addEventListener(textFieldEvent_password)
    password:addChild(textField_password)
    
    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then       
            if validateUsername(textField_username:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_USERNAME_ERROR))
                return
            end
            if validatePassword(textField_password:getStringValue()) == false then
                s_TIPS_LAYER:showSmall(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_PWD_ERROR))
                return
            end
                
            local function onResponse(u, e, code)
                if e then
                    s_TIPS_LAYER:showSmall(e)
                    s_LOADING_CIRCLE_LAYER:hide()
                else
                    s_SCENE:dispatchCustomEvent(CUSTOM_EVENT_SIGNUP)
                end
            end
            s_LOADING_CIRCLE_LAYER:show(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_USER_DATA))
            s_UserBaseServer.signup(textField_username:getStringValue(), textField_password:getStringValue(), onResponse)
        end
    end

    local submit = ccui.Button:create("image/login/sl_button_confirm.png","","")
    submit:setPosition(back_width/2, 350)
    submit:setTitleText("注册")
    submit:setTitleFontSize(30)
    submit:addTouchEventListener(submit_clicked)
    back_register:addChild(submit)

    local button_login_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local remove = function()
                local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
                local action2 = cc.EaseBackIn:create(action1)
                back_register:runAction(action2)
            end

            local action1 = cc.CallFunc:create(remove)
            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(showLogin)
            local action4 = cc.Sequence:create(action1, action2, action3)

            main:runAction(action4)   
        end
    end

    local button_login = ccui.Button:create()
    button_login:loadTextures("image/button/button_login_signup.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(back_width/2, 200)
    button_login:setTitleFontSize(28)
    button_login:setTitleText("返回登陆")
    button_login:setTitleColor(cc.c4b(115,197,243,255))
    back_register:addChild(button_login) 
    
    local button_qq_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    local button_qq = ccui.Button:create("image/login/button_login_signup_qq.png")
    button_qq:setPosition(back_width/2,100)
    button_qq:addTouchEventListener(button_qq_clicked)
    back_register:addChild(button_qq)

    local button_weixin_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    local button_weixin = ccui.Button:create("image/login/button_login_signupwechat.png")
    button_weixin:setPosition(back_width/2-100,100)
    button_weixin:addTouchEventListener(button_weixin_clicked)
    back_register:addChild(button_weixin)

    local button_weibo_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    local button_weibo = ccui.Button:create("image/login/button_login_signupweibo.png")
    button_weibo:setPosition(back_width/2+100,100)
    button_weibo:addTouchEventListener(button_weibo_clicked)
    back_register:addChild(button_weibo)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            main.close()
        end
    end
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(back_width-30,back_height-10)
    button_close:addTouchEventListener(button_close_clicked)
    back_register:addChild(button_close)
end

return LoginAlter







