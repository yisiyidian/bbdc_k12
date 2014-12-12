

local ImproveInfoNode = class("ImproveInfoNode", function()
    return cc.Layer:create()
end)

function ImproveInfoNode.create(type)
    local width = 450
    local height = 80

    local main = ImproveInfoNode.new()
    main:setContentSize(width, height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local backImage
    local cursor
    local hint1 = "请输入新的用户名"
    local hint2 = "请输入新的密码"
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


    eventHandle = function(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            --            print("in text field")
            main.textField:setPlaceHolder("")
            cursor:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            --            print("out text field")
            if type == "username" then
                main.textField:setPlaceHolder(hint1)
            else
                main.textField:setPlaceHolder(hint2)
            end
            cursor:setVisible(false)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            cursor:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            cursor:setVisible(true)
        end
    end

    main.textField = ccui.TextField:create()
    main.textField:setTouchSize(backImage:getContentSize())
    main.textField:setTouchAreaEnabled(true)
    main.textField:setFontSize(30)
    main.textField:setMaxLengthEnabled(true)
    main.textField:setColor(cc.c4b(0,0,0,255))
    if type == "username" then
        main.textField:setPlaceHolder(hint1)
        main.textField:setMaxLength(10)
    else
        main.textField:setPlaceHolder(hint2)
        main.textField:setMaxLength(16)
        main.textField:setPasswordEnabled(true)
        main.textField:setPasswordStyleText("*")
    end
    main.textField:setPosition(cc.p(backImage:getContentSize().width / 2, backImage:getContentSize().height / 2))
    main.textField:addEventListener(eventHandle)
    backImage:addChild(main.textField)

    cursor = cc.Label:createWithSystemFont("|","",30)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    cursor:setPosition(main.textField:getContentSize().width,main.textField:getContentSize().height/2)
    cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    main:addChild(cursor)

    local update = function(dt)
        cursor:setPosition(backImage:getContentSize().width/2+main.textField:getContentSize().width/2, height/2)
    end
    main:scheduleUpdateWithPriorityLua(update, 0)

    return main    
end


return ImproveInfoNode
