

local InputNode = class("InputNode", function()
    return cc.Layer:create()
end)

function InputNode.create()
    local width = 450
    local height = 80

    local main = InputNode.new()
    main:setContentSize(width, height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)
    
    local backImage
    local textField
    local cursor
    
    local cursorShowUp
    local eventHandle
    
    backImage = cc.Sprite:create("image/login/sl_username.png")
    backImage:setPosition(width/2, height/2)
    main:addChild(backImage)
      
    cursorShowUp = function()
        cursor:stopAllActions()
        cursor:setVisible(false)
        local action1 = cc.DelayTime:create(0.1)
        local action2 = cc.CallFunc:create(
            function()
                cursor:setPosition(textField:getContentSize().width,textField:getContentSize().height/2)
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
        print("handle touch event of text field")
        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            print("in text field")
            textField:setPlaceHolder("")
            cursorShowUp()
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            print("out text field")
            cursor:stopAllActions()
            cursor:setVisible(false)
            textField:setPlaceHolder("用户名")
        elseif eventType == ccui.TextFiledEventType.insert_text then
            cursorShowUp()
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            cursorShowUp()
        end
    end

    textField = ccui.TextField:create()
    textField:setTouchEnabled(true)
    textField:setTouchSize(cc.size(width,height))
    textField:setTouchAreaEnabled(true)
    textField:setFontSize(30)
    textField:setMaxLengthEnabled(true)
    textField:setMaxLength(16)
    textField:setColor(cc.c4b(0,0,0,255))
    textField:setPlaceHolder("用户名")
    textField:setPosition(cc.p(backImage:getContentSize().width / 2.0, backImage:getContentSize().height / 2.0))
    textField:addEventListener(eventHandle)
    backImage:addChild(textField)

    cursor = cc.Label:createWithSystemFont("|","",30)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    textField:addChild(cursor)

    return main    
end


return InputNode







