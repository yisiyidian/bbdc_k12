require("common.global")

local LoginAlter = class("LoginAlter", function()
    return cc.Layer:create()
end)

function LoginAlter.create()
    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local back = cc.Sprite:create("image/login/background_white_login.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local back_width = back:getContentSize().width
    local back_height = back:getContentSize().height

    local circle = cc.Sprite:create("image/login/circle_head_login.png")
    circle:setPosition(back_width/2, back_height)
    back:addChild(circle)
    
    local head = cc.Sprite:create("image/login/gril_head.png")
    head:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    circle:addChild(head)

    
    local username = cc.Sprite:create("image/login/sl_username.png")
    username:setPosition(back_width/2, 550)
    back:addChild(username)
      
    local textField_username
    local textField_password  
      
    local function textFieldEvent_username(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_username:setPlaceHolder("")
            back:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+100)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_username:setPlaceHolder("用户名")
            back:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
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
    back:addChild(password)
    
    local function textFieldEvent_password(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            textField_password:setPlaceHolder("") 
            back:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2+200)))
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            textField_password:setPlaceHolder("密码")
            back:runAction(cc.MoveTo:create(0.25, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)))
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
            
        end
    end
    
    local submit = ccui.Button:create("image/login/sl_button_confirm.png","","")
    submit:setPosition(back_width/2, 350)
    submit:setTitleText("登陆")
    submit:setTitleFontSize(30)
    submit:addTouchEventListener(submit_clicked)
    back:addChild(submit)
    
    
    local button_login_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_login = ccui.Button:create()
    button_login:loadTextures("image/button/button_white_denglu.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(back_width/2, 200)
    button_login:setTitleFontSize(36)
    button_login:setTitleText("注册")
    button_login:setTitleColor(cc.c4b(0,0,0,255))
    button_login:setScale(0.5)
    back:addChild(button_login)

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


return LoginAlter







