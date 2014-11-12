

local InputNode = class("InputNode", function()
    return cc.Layer:create()
end)

function InputNode.create(type)
    local width = 450
    local height = 80

    local main = InputNode.new()
    main:setContentSize(width, height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)
    
    local backImage
    local cursor
    main.textField = nil
    
    local cursorShowUp
    local eventHandle
    
    if type == "username" then
        backImage = cc.Sprite:create("image/login/sl_username.png")
    else
        backImage = cc.Sprite:create("image/login/sl_password.png")
    end    
    backImage:setPosition(width/2, height/2)
    main:addChild(backImage)
      
    cursorShowUp = function()
        cursor:stopAllActions()
        cursor:setVisible(false)
        local action1 = cc.DelayTime:create(0.1)
        local action2 = cc.CallFunc:create(
            function()
                cursor:setPosition(main.textField:getContentSize().width,main.textField:getContentSize().height/2)
                cursor:setVisible(true)
            end
        )
        local action3 = cc.FadeIn:create(0.5)
        local action4 = cc.FadeOut:create(0.5)
        local action5 = cc.RepeatForever:create(cc.Sequence:create(action3,action4))
        cursor:runAction(cc.Sequence:create(action1, action2))
        cursor:runAction(action5)
    end

    eventHandle = function(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            print("in text field")
            main.textField:setPlaceHolder("")
            cursorShowUp()
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            print("out text field")
            cursor:stopAllActions()
            cursor:setVisible(false)
            if type == "username" then
                main.textField:setPlaceHolder("用户名")
            else
                main.textField:setPlaceHolder("密码")
            end
        elseif eventType == ccui.TextFiledEventType.insert_text then
            cursorShowUp()
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            cursorShowUp()
        end
    end

    main.textField = ccui.TextField:create()
    main.textField:setTouchEnabled(true)
    main.textField:setTouchSize(cc.size(width,height))
    main.textField:setTouchAreaEnabled(true)
    main.textField:setFontSize(30)
    main.textField:setMaxLengthEnabled(true)
    main.textField:setMaxLength(16)
    main.textField:setColor(cc.c4b(0,0,0,255))
    if type == "username" then
        main.textField:setPlaceHolder("用户名")
    else
        main.textField:setPlaceHolder("密码")
        main.textField:setPasswordEnabled(true)
        main.textField:setPasswordStyleText("*")
    end
    main.textField:setPosition(cc.p(backImage:getContentSize().width / 2.0, backImage:getContentSize().height / 2.0))
    main.textField:addEventListener(eventHandle)
    backImage:addChild(main.textField)

    cursor = cc.Label:createWithSystemFont("|","",30)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    main.textField:addChild(cursor)

    return main    
end


return InputNode







