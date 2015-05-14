--封装的输入框
local InputNode = class("InputNode", function()
    return cc.Layer:create()
end)

InputNode.type_username = 'username'
InputNode.type_pwd = 'pwd'
InputNode.type_teachername = "teachername"


--构造
function InputNode:ctor(backgroundImage,placeHolder,callback,width,height,isPwd,maxLength)
    if backgroundImage then
        self:init(backgroundImage,placeHolder,callback,width,height,isPwd,maxLength)
    end
end

--初始化
--backgroundImage   背景图片
--placeHolder       文本占位符
function InputNode:init(backgroundImage,placeHolder,callback,width,height,isPwd,maxLength)
    self.width = width or 450    --宽 默认450
    self.height = height or 80    --高 默认80
    self.isPwd = isPwd or false  --是否密码格式  默认false
    self.callback = callbacks
    self.placeHolder = placeHolder

    self:setContentSize(self.width, self.height)
    self:setAnchorPoint(0.5,0.5)
    self:ignoreAnchorPointForPosition(false)
    --背景图
    local backImage = cc.Sprite:create(backgroundImage)
    backImage:setPosition(self.width/2, self.height/2)
    self:addChild(backImage)

    --输入框
    self.textField = ccui.TextField:create()
    self.textField:ignoreAnchorPointForPosition(false)
    self.textField:setAnchorPoint(0.5,0.5)
    self.textField:setTouchSize(backImage:getContentSize())
    self.textField:setTouchAreaEnabled(true)
    self.textField:setFontSize(34)
    self.textField:setMaxLengthEnabled(true)
    self.textField:setPlaceHolderColor(cc.c3b(153,168,181))
    self.textField:setTextColor(cc.c4b(0,0,0,255))
    self.textField:setPlaceHolder(placeHolder)--占位文本
    -- self.textField:setDetachWithIME(false)

    --设置长度限制
    local tlen = maxLength or 10
    if self.isPwd then
        local tlen = maxLength or 16 
        --密码格式
        self.textField:setPasswordEnabled(true)
        self.textField:setPasswordStyleText("*")
        self.textField:setMaxLength(tlen)
    else
        local tlen = maxLength or 10
        --非密码格式
        self.textField:setMaxLength(tlen)
    end

    self.textField:setPosition(cc.p(backImage:getContentSize().width / 2, backImage:getContentSize().height / 2))
    self.textField:addEventListener(handler(self,self.onTextEvent))
    backImage:addChild(self.textField)
    --光标
    local cursor = cc.Label:createWithSystemFont("|","",34)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    cursor:setPosition(self.textField:getContentSize().width,34)
    cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    self.cursor = cursor
    self:addChild(cursor)
    
    local update = function(dt)
        cursor:setPosition(self.width / 2 + self.textField:getContentSize().width/2 + 2, self.height/2)
    end
    self:scheduleUpdateWithPriorityLua(update, 0)

end

--文本框事件处理
function InputNode:onTextEvent(sender,eventType)
    if self.callback ~= nil then 
        self.callback(sender, eventType) 
    end

    if eventType == ccui.TextFiledEventType.attach_with_ime then   
        self.textField:setPlaceHolder("")
        self.cursor:setVisible(true)
    elseif eventType == ccui.TextFiledEventType.detach_with_ime then
        self.textField:setPlaceHolder(self.placeHolder)
        self.cursor:setVisible(false)
    elseif eventType == ccui.TextFiledEventType.insert_text then
        self.cursor:setVisible(true)
    elseif eventType == ccui.TextFiledEventType.delete_backward then
        self.cursor:setVisible(true)
    end
end

--开关键盘
function InputNode:openIME()
    -- self.textField:getVirtualRenderer():attachWithIME()
    -- cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)
    self.textField:attachWithIME()
end

function InputNode:closeIME()
    -- self.textField:closeIME()
end

function InputNode:getText()
    return self.textField:getString()
end
--设置占位文本
function InputNode:setPlaceHolder(placeHolder)
    self.placeHolder = placeHolder
    self.textField:setPlaceHolder(placeHolder)--占位文本
end
--设置最大文本输入长度
function InputNode:setMaxLength(len)
    self.textField:setMaxLength(len)
end



--deprecated
function InputNode.create(type, hint, eventHandleCB, k12)
    local width = 450
    local height = 80

    local main = InputNode.new()
    main:setContentSize(width, height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)
    
    local cursor = nil --光标
    main.textField = nil
    if k12 ~= nil and k12 then
        backImage = cc.Sprite:create("image/signup/shuru_bbchildren_white.png")
    else
        if type == "username" then
            backImage = cc.Sprite:create("image/login/sl_username.png")
        else
            backImage = cc.Sprite:create("image/login/sl_password.png")
        end   
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
    main.textField:setAnchorPoint(0.5,0.5)
    main.textField:setTouchSize(backImage:getContentSize())
    main.textField:setTouchAreaEnabled(true)
    main.textField:setFontSize(34)
    main.textField:setMaxLengthEnabled(true)
    main.textField:setPlaceHolderColor(cc.c3b(153,168,181))
    main.textField:setTextColor(cc.c4b(0,0,0,255))
    main.textField:setPlaceHolder(hint)
    main.textField:setDetachWithIME(false)
    if type ~= InputNode.type_pwd then
        main.textField:setMaxLength(10)
    else
        main.textField:setMaxLength(16)
        main.textField:setPasswordEnabled(true)
        main.textField:setPasswordStyleText("*")
    end
    main.textField:setPosition(cc.p(backImage:getContentSize().width / 2, backImage:getContentSize().height / 2))
    main.textField:addEventListener(eventHandle)
    backImage:addChild(main.textField)

    cursor = cc.Label:createWithSystemFont("|","",34)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    cursor:setPosition(main.textField:getContentSize().width,34)
    cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    main:addChild(cursor)
    
    local update = function(dt)
        cursor:setPosition(width / 2+main.textField:getContentSize().width/2 + 2, height/2)
    end
    main:scheduleUpdateWithPriorityLua(update, 0)

    return main    
end


return InputNode







