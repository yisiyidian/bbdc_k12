require("common.global")

local BigAlter      = require("view.alter.BigAlter")
local SmallAlter    = require("view.alter.SmallAlter")
local InputNode     = require("view.login.InputNode")

local PopupView = class("PopupView", function()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH + 2 * s_DESIGN_OFFSET_WIDTH
local strTitle = '' -- 登 陆
local strDes = '' -- 登陆可以和更多的好友一起背单词
local strBtnConfirm = '' -- 登陆
local onConfirm = function(username, password) end

local function changeAccount(username, password)
    playSound(s_sound_buttonEffect)

    if validateUsername(username) == false then
        s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT_ID_USERNAME_ERROR))
        return
    end
    if validatePassword(password) == false then
        s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT_ID_PWD_ERROR))
        return
    end

    showProgressHUD('', true)
    cx.CXAvos:getInstance():logIn(username, password, function (objectjson, e, code)
        hideProgressHUD(true)

        if e ~= nil then
            s_TIPS_LAYER:showSmall(e)
        else
            -- s_SCENE:removeAllPopups()

            AnalyticsAccountChange()
            cx.CXAvos:getInstance():logOut()
            -- s_LocalDatabaseManager.setLogOut(true)
            s_LocalDatabaseManager.close()

            g_userName = username
            g_userPassword = password
            
            local start = reloadModule('start')
            start.init()

            -- onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
        end
    end)
end

function PopupView.create()
    -- TODO : refactory
    strTitle = '切换账号'
    strDes = '请输入用户名和密码'
    strBtnConfirm = '切换'
    onConfirm = changeAccount

    local main = PopupView.new()
    -- main:AddBtnGotoRegisterPopup()
    return main
end

function PopupView:ctor()
	local back_login = cc.Sprite:create("image/login/background_white_login.png")
    back_login:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    back_login:ignoreAnchorPointForPosition(false)
    back_login:setAnchorPoint(0.5,0.5)
    self:setContentSize(back_login:getContentSize().width,s_DESIGN_HEIGHT)
    self:addChild(back_login)
    
    local back_width = back_login:getContentSize().width
    local back_height = back_login:getContentSize().height

    local circle = cc.Sprite:create("image/login/circle_head_login.png")
    circle:setPosition(back_width/2, back_height)
    back_login:addChild(circle)

    local head = cc.Sprite:create("image/login/gril_head.png")
    head:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    circle:addChild(head)

    local label1 = cc.Label:createWithSystemFont(strTitle, "", 48)
    label1:setColor(cc.c4b(115,197,243,255))
    label1:setPosition(back_width/2,680)
    back_login:addChild(label1)

    local label2 = cc.Label:createWithSystemFont(strDes, "", 24)
    label2:setColor(cc.c4b(100,100,100,255))
    label2:setPosition(back_width/2,630)
    back_login:addChild(label2)

    local username = InputNode.create("username")
    username:setPosition(back_width/2, 550)
    back_login:addChild(username)

    local password = InputNode.create("password")
    password:setPosition(back_width/2, 450)
    back_login:addChild(password)

    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            onConfirm(username.textField:getString(), password.textField:getString())
        end
    end

    local submit = ccui.Button:create("image/login/sl_button_confirm.png","image/login/sl_button_confirm.png","")
    submit:setPosition(back_width/2, 350)
    submit:addTouchEventListener(submit_clicked)
    back_login:addChild(submit)

    local label_name = cc.Label:createWithSystemFont(strBtnConfirm, "", 34)
    label_name:setColor(cc.c4b(255,255,255,255))
    label_name:ignoreAnchorPointForPosition(false)
    label_name:setAnchorPoint(0,0.5)
    label_name:setPosition(30, submit:getContentSize().height/2)
    submit:addChild(label_name)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back_login:runAction(cc.Sequence:create(action2,action3))
    end

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect) 
            closeAnimation()
        end
    end
    
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(back_width-30,back_height-10)
    button_close:addTouchEventListener(button_close_clicked)
    back_login:addChild(button_close)
    
    local onTouchBegan = function(touch, event)
        return true
    end
    
    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back_login:getBoundingBox(),location) then
           closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    onAndroidKeyPressed(self, function ()
           closeAnimation()
    end, function ()

    end)
end

function PopupView:AddBtnGotoRegisterPopup()
    local button_toggle_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            local RegisterPopup = require("view.login.RegisterPopup")
            local registerPopup = RegisterPopup.create()
            s_SCENE.popupLayer:addChild(registerPopup)  
            registerPopup:setVisible(false)
            
            local action0 = cc.OrbitCamera:create(0.5,1, 0, 0, 90, 0, 0) 
            back_login:runAction(action0) 
            
            local action1 = cc.DelayTime:create(0.5)
            local action2 = cc.CallFunc:create(function()
                registerPopup:setVisible(true)
            end)
            local action3 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0) 
            local action4 = cc.Sequence:create(action1, action2, action3)
            registerPopup:runAction(action4)   
        end
    end

    local button_toggle = ccui.Button:create()
    button_toggle:loadTextures("image/button/button_login_signup.png", "", "")
    button_toggle:addTouchEventListener(button_toggle_clicked)
    button_toggle:setPosition(back_width/2, 200)
    button_toggle:setTitleFontSize(28)
    button_toggle:setTitleText("返回注册")
    button_toggle:setTitleColor(cc.c4b(115,197,243,255))
    back_login:addChild(button_toggle)  
end

return PopupView







