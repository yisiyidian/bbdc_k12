

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
    
    local cursor
    local hint1 = "用户名"
    local hint2 = "密码"
    local hint3 = "教师姓名"
    main.textField = nil
    
    local cursorShowUp
    local eventHandle
    

    local backImage = cc.Sprite:create("image/login/white_shurukuang_zhuce.png")

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
            elseif type == "password" then
                main.textField:setPlaceHolder(hint2)
            else
                main.textField:setPlaceHolder(hint3)
            end
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
    if type == "username" then
        main.textField:setPlaceHolder(hint1)
        main.textField:setMaxLength(10)
    elseif type == "password" then
        main.textField:setPlaceHolder(hint2)
        main.textField:setMaxLength(16)
        main.textField:setPasswordEnabled(true)
        main.textField:setPasswordStyleText("*")
    else
        main.textField:setPlaceHolder(hint3)
        main.textField:setMaxLength(10)
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
        cursor:setPosition(15+main.textField:getContentSize().width, height/2)
    end
    main:scheduleUpdateWithPriorityLua(update, 0)

    return main    
end


return InputNode







