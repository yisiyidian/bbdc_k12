--封装的输入框
local InputNode = class("InputNode", function()
    return cc.Layer:create()
end)

InputNode.type_username = 'username'
InputNode.type_pwd = 'pwd'
InputNode.type_teachername = "teachername"

--构造
--backgroundImage 未输入完成的背景
--backgroundImageOver 输入完成后的背景
--placeHolder 文本占位符
--callback 输入回调时间
--width   宽
--height  高
--isPwd   密码格式
--maxLength 最大长度
--minLength 最小长度 eq 输入密码时,最小密码位数是6位,输入6位即点亮输入框
function InputNode:ctor(backgroundImage,backgroundImageOver,placeHolder,callback,width,height,isPwd,maxLength,minLength)
    if backgroundImage then
        self:init(backgroundImage,backgroundImageOver,placeHolder,callback,width,height,isPwd,maxLength,minLength)
    end
end

--初始化
--backgroundImage   背景图片
--placeHolder       文本占位符
function InputNode:init(backgroundImage,backgroundImageOver,placeHolder,callback,width,height,isPwd,maxLength,minLength)
    self.width = width or 450    --宽 默认450
    self.height = height or 80    --高 默认80
    self.isPwd = isPwd or false  --是否密码格式  默认false
    self.callback = callback
    self.placeHolder = placeHolder
    self.maxLength = maxLength
    self.minLength = minLength or 0

    self.backgroundImage = backgroundImage
    self.backgroundImageOver = backgroundImageOver

    self:setContentSize(self.width, self.height)
    self:setAnchorPoint(0.5,0.5)
    self:ignoreAnchorPointForPosition(false)
    --背景图
    local backImage = cc.Sprite:create(backgroundImage)
    backImage:setPosition(self.width/2, self.height/2)
    self.backImage = backImage
    self:addChild(backImage)
    --输入框

    --[[
    self.textField = ccui.TextField:create()
    self.textField:ignoreAnchorPointForPosition(false)
    self.textField:setAnchorPoint(0.5,0.5)
    self.textField:setTouchSize(backImage:getContentSize())
    self.textField:setTouchAreaEnabled(true)
    self.textField:setFontSize(34)
    self.textField:setMaxLengthEnabled(true)
    self.textField:setPlaceHolderColor(cc.c3b(255,255,255))
    self.textField:setTextColor(cc.c4b(0,0,0,255))
    self.textField:setPlaceHolder(placeHolder)--占位文本
    ]]




    local sizeBg = backImage:getContentSize()
    self.textField = ccui.EditBox:create(cc.size(sizeBg.width - 90,sizeBg.height),"image/login/blank_btn.png")
    -- self.textField = cc.EditBox:create(cc.size(editBoxSize.width, editBoxSize.height), cc.Scale9Sprite:create("extensions/yellow_edit.png"))
    -- self.textField:setPosition(cc.p(visibleOrigin.x+visibleSize.width/2, visibleOrigin.y+visibleSize.height/4))
    self.textField:setAnchorPoint(cc.p(0.5, 0.5))
    self.textField:setFontColor(cc.c3b(0,0,0))
    -- self.textField:setPlaceholderFont(".HelveticaNeueInterface-Regular",20)
    -- self.textField:setPlaceholderFontName("MSYH")
    -- self.textField:setPlaceholderFontSize(20)
    self.textField:setPlaceHolder(self.placeHolder)
    self.textField:registerScriptEditBoxHandler(handler(self,self.editBoxTextEventHandle))
    -- newLayer:addChild(EditEmail)   
    -- newLayer:setPosition(cc.p(10, 20))


    --设置长度限制
    local tlen = maxLength or 10
    if self.isPwd then
        local tlen = maxLength or 16 
        --密码格式
        self.textField:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
        -- self.textField:setPasswordStyleText("*")
        self.textField:setMaxLength(tlen)
    else
        local tlen = maxLength or 10
        --非密码格式
        self.textField:setMaxLength(tlen)
    end

    self.textField:setPosition(cc.p(backImage:getContentSize().width / 2, backImage:getContentSize().height / 2))
    -- self.textField:addEventListener(handler(self,self.onTextEvent))
    backImage:addChild(self.textField)
    --光标
    --[[
    local cursor = cc.Label:createWithSystemFont("|","",34)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setPosition(0,34)
    cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    self.cursor = cursor
    cursor:setVisible(false)
    self:addChild(cursor)
    
    local update = function(dt)
        if self.textField:getText() == "" then
            cursor:setPosition(self.width / 2 - self.textField:getContentSize().width/2 - 2, self.height/2)
        else
            cursor:setPosition(self.width / 2 + self.textField:getContentSize().width/2 + 2, self.height/2)
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0)
    ]]
end

--文本框事件处理
-- function InputNode:onTextEvent(sender,eventType)
--     self:processInput()

--     if eventType == ccui.TextFiledEventType.attach_with_ime then
--         print("ccui.TextFiledEventType.attach_with_ime")
--         self.cursor:setVisible(true)
--     elseif eventType == ccui.TextFiledEventType.detach_with_ime then
--         print("ccui.TextFiledEventType.detach_with_ime")
--         self.textField:setPlaceHolder(self.placeHolder)
--         self.cursor:setVisible(false)
--     elseif eventType == ccui.TextFiledEventType.insert_text then
--         print("ccui.TextFiledEventType.insert_text")
--         self.cursor:setVisible(true)
--     elseif eventType == ccui.TextFiledEventType.delete_backward then
--         print("ccui.TextFiledEventType.delete_backward")
--         self.cursor:setVisible(true)
--     end
-- end

function InputNode:editBoxTextEventHandle(strEventName,pSender)
    if not tolua.isnull(self) then
        self:processInput()
    end
    local edit = pSender
    local strFmt 
    if strEventName == "began" then
        strFmt = string.format("editBox %s DidBegin !", strEventName)
        print(strFmt)
    elseif strEventName == "ended" then
        strFmt = string.format("editBox %s DidEnd !", strEventName)
        print(strFmt)
    elseif strEventName == "return" then
        strFmt = string.format("editBox %s was returned !",strEventName)
        print(strFmt)
    elseif strEventName == "changed" then
        strFmt = string.format("editBox %s TextChanged, text: %s ", strEventName, edit:getText())
        print(strFmt)
    end
end

--处理输入事件
function InputNode:processInput()
    local text = self.textField:getText()
    print("string.len(text):"..string.len(text))
    print("self.minLength:"..self.minLength)
    if string.len(text) == self.maxLength then
        if self.callback ~= nil then 
            self.callback(text,string.len(text),self.maxLength)
        end
        -- self.textField:setTextFon
        self.backImage:setTexture(self.backgroundImageOver)
    else
        if self.minLength ~= 0 then
            if string.len(text) >= self.minLength then
                if self.callback ~= nil then 
                    self.callback(text,string.len(text),self.minLength)
                end
                self.backImage:setTexture(self.backgroundImageOver)        
                return
            end
        end
        self.backImage:setTexture(self.backgroundImage)
        if self.callback ~= nil then 
           self.callback(text,string.len(text),self.maxLength)
        end
    end
end


--开关键盘
function InputNode:openIME()
    -- self.textField:getVirtualRenderer():attachWithIME()
    -- cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)
    -- if self.bMode then
    --     -- print("弹出软键盘")
    --     -- local parent = self:getParent()
    --     -- parent:addChild(self.keyboard)
    -- else
    -- end
    self.textField:touchDownAction(self.textField,ccui.TouchEventType.ended)
end

function InputNode:closeIME()
    -- self.textField:closeIME()
end

function InputNode:getText()
    return self.textField:getText()
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

--设置文本
function InputNode:setText(text)
    self.textField:setText(text)
    self:processInput()
end

--设置是否响应触摸时间
function InputNode:setEnabled(enable)
    self.textField:setTouchEnabled(enable)
end

function InputNode:setPlaceHolderColor()
    self.textField:setPlaceholderFontColor(cc.c3b(153,168,181))
    -- self.textField:setPlaceHolderColor(cc.c3b(255,255,255))
end


-- cc.EDITBOX_INPUT_MODE_ANY = 0
-- cc.EDITBOX_INPUT_MODE_EMAILADDR = 1
-- cc.EDITBOX_INPUT_MODE_NUMERIC = 2
-- cc.EDITBOX_INPUT_MODE_PHONENUMBER = 3
-- cc.EDITBOX_INPUT_MODE_URL = 4
-- cc.EDITBOX_INPUT_MODE_DECIMAL = 5
-- cc.EDITBOX_INPUT_MODE_SINGLELINE = 6
--设置输入模式
function InputNode:setInputMode(mode)
    self.textField:setInputMode(mode)
end

return InputNode

