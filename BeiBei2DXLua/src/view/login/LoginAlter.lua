require("common.global")

local LoginAlter = class("LoginAlter", function()
    return cc.Layer:create()
end)

local showLogin
local showRegister

local back_login
local back_register

local main = nil

function LoginAlter.createLogin()
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

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

    
    local username = cc.Sprite:create("image/login/sl_username.png")
    username:setPosition(back_width/2, 550)
    back_login:addChild(username)
      
    local textField_username
    local textField_password  
      
    local function textFieldEvent_username(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_username:setPlaceHolder("")
            back_login:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+100)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_username:setPlaceHolder("用户名")
            back_login:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
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
    back_login:addChild(password)
    
    local function textFieldEvent_password(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_password:setPlaceHolder("") 
            back_login:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+200)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_password:setPlaceHolder("密码")
            back_login:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
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
            local function onResponse(u, e, code)
                if e then
                    print("login fail")
                    print(e)
                    print(code)
                else
                    print("login success")
                end
            end
            s_UserBaseServer.login(textField_username:getStringValue(), textField_password:getStringValue(), onResponse)
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
    button_login:loadTextures("image/button/button_white_denglu.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(back_width/2, 200)
    button_login:setTitleFontSize(36)
    button_login:setTitleText("返回注册")
    button_login:setTitleColor(cc.c4b(0,0,0,255))
    button_login:setScale(0.5)
    back_login:addChild(button_login)  
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


    local username = cc.Sprite:create("image/login/sl_username.png")
    username:setPosition(back_width/2, 550)
    back_register:addChild(username)

    local textField_username
    local textField_password  

    local function textFieldEvent_username(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_username:setPlaceHolder("")
            back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+100)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_username:setPlaceHolder("用户名")
            back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
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
            back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+200)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_password:setPlaceHolder("密码")
            back_register:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
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
            local function onResponse(u, e, code)
                if e then
                    print("register fail")
                else
                    print("register success")
                end
            end
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
    button_login:loadTextures("image/button/button_white_denglu.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(back_width/2, 200)
    button_login:setTitleFontSize(36)
    button_login:setTitleText("返回登陆")
    button_login:setTitleColor(cc.c4b(0,0,0,255))
    button_login:setScale(0.5)
    back_register:addChild(button_login) 
end

return LoginAlter







