

local InputNode = class("InputNode", function()
    return cc.Layer:create()
end)

InputNode.type_username = 'username'
InputNode.type_pwd = 'pwd'
InputNode.type_teachername = "teachername"

function InputNode.create(type, hint, eventHandleCB)
    local width = 450
    local height = 80

    local main = InputNode.new()
    main:setContentSize(width, height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)
    
    local cursor
    main.textField = nil
    
    if type == "username" then
        backImage = cc.Sprite:create("image/login/sl_username.png")
    else
        backImage = cc.Sprite:create("image/login/sl_password.png")
    end    
    backImage:setPosition(width/2, height/2)
    main:addChild(backImage)
      

    local eventHandle = function(sender, eventType)
        if eventHandleCB ~= nil then eventHandleCB(sender, eventType) end
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
--            print("in text field")
            main.textField:setPlaceHolder("")
            cursor:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            main.textField:setPlaceHolder(hint)
            cursor:setVisible(false)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            cursor:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            cursor:setVisible(true)
        end
    end

    main.textField = ccui.TextField:create()
    main.textField:ignoreAnchorPointForPosition(false)
    main.textField:setAnchorPoint(0,0.5)
    main.textField:setTouchSize(backImage:getContentSize())
    main.textField:setTouchAreaEnabled(true)
    main.textField:setFontSize(34)
    main.textField:setMaxLengthEnabled(true)
    main.textField:setPlaceHolderColor(cc.c3b(150,150,150))
    main.textField:setTextColor(cc.c4b(0,0,0,255))
    main.textField:setPlaceHolder(hint)
    if type ~= InputNode.type_pwd then
        main.textField:setMaxLength(10)
    else
        main.textField:setMaxLength(16)
        main.textField:setPasswordEnabled(true)
        main.textField:setPasswordStyleText("*")
    end
    main.textField:setPosition(cc.p(30, backImage:getContentSize().height / 2))
    main.textField:addEventListener(eventHandle)
    backImage:addChild(main.textField)

    cursor = cc.Label:createWithSystemFont("|","",34)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    cursor:setPosition(main.textField:getContentSize().width,34)
    cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    main:addChild(cursor)
    
    local update = function(dt)
        cursor:setPosition(30+main.textField:getContentSize().width, height/2)
    end
    main:scheduleUpdateWithPriorityLua(update, 0)

    return main    
end


return InputNode







