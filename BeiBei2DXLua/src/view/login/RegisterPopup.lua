require("common.global")

local BigAlter      = require("view.alter.BigAlter")
local SmallAlter    = require("view.alter.SmallAlter")
local InputNode     = require("view.login.InputNode")

local RegisterPopup = class("RegisterPopup", function()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

function RegisterPopup.create()
    local main = RegisterPopup.new()
    return main
end

function RegisterPopup:ctor()
    local back_register = cc.Sprite:create("image/login/background_white_login.png")
    back_register:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    back_register:ignoreAnchorPointForPosition(false)
    back_register:setAnchorPoint(0.5,0.5)
    self:setContentSize(back_register:getContentSize().width,s_DESIGN_HEIGHT)
    self:addChild(back_register)

    local back_width = back_register:getContentSize().width
    local back_height = back_register:getContentSize().height

    local circle = cc.Sprite:create("image/login/circle_head_login.png")
    circle:setPosition(back_width/2, back_height)
    back_register:addChild(circle)

    local head = cc.Sprite:create("image/login/gril_head.png")
    head:setPosition(circle:getContentSize().width/2, circle:getContentSize().height/2)
    circle:addChild(head)

    local label1 = cc.Label:createWithSystemFont("注 册","",48)
    label1:setColor(cc.c4b(115,197,243,255))
    label1:setPosition(back_width/2,680)
    back_register:addChild(label1)

    local label2 = cc.Label:createWithSystemFont("注册可以和更多的好友一起背单词","",24)
    label2:setColor(cc.c4b(100,100,100,255))
    label2:setPosition(back_width/2,630)
    back_register:addChild(label2)

    local username = InputNode.create(InputNode.type_username, '请输入用户名')
    username:setPosition(back_width/2, 550)
    back_register:addChild(username)

    local password = InputNode.create(InputNode.type_pwd, '请输入密码')
    password:setPosition(back_width/2, 450)
    back_register:addChild(password)

    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- button sound
            playSound(s_sound_buttonEffect)
            if validateUsername(username.textField:getString()) == false then
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR))
                return
            end
            if validatePassword(password.textField:getString()) == false then
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))
                return
            end
            s_CURRENT_USER.usertype = USER_TYPE_MANUAL
            s_O2OController.signUpOnline(username.textField:getString(), password.textField:getString())
            AnalyticsSignUp_Normal()
            s_SCENE:removeAllPopups()
        end
    end

    local submit = ccui.Button:create("image/login/sl_button_confirm.png","image/login/sl_button_confirm.png","")
    submit:setPosition(back_width/2, 350)
    submit:addTouchEventListener(submit_clicked)
    back_register:addChild(submit)

    local label_name = cc.Label:createWithSystemFont("注册","",34)
    label_name:setColor(cc.c4b(255,255,255,255))
    label_name:ignoreAnchorPointForPosition(false)
    label_name:setAnchorPoint(0,0.5)
    label_name:setPosition(30, submit:getContentSize().height/2)
    submit:addChild(label_name)

    local button_toggle_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            local LoginPopup = require("view.login.LoginPopup")
            local loginPopup = LoginPopup.create()
            s_SCENE.popupLayer:addChild(loginPopup)  
            loginPopup:setVisible(false)

            local action0 = cc.OrbitCamera:create(0.5,1, 0, 0, 90, 0, 0) 
            back_register:runAction(action0) 

            local action1 = cc.DelayTime:create(0.5)
            local action2 = cc.CallFunc:create(function()
                loginPopup:setVisible(true)
            end)
            local action3 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0) 
            local action4 = cc.Sequence:create(action1, action2, action3)
            loginPopup:runAction(action4)   
        end
    end

    local button_toggle = ccui.Button:create()
    button_toggle:loadTextures("image/button/button_login_signup.png", "", "")
    button_toggle:addTouchEventListener(button_toggle_clicked)
    button_toggle:setPosition(back_width/2, 200)
    button_toggle:setTitleFontSize(28)
    button_toggle:setTitleText("返回登陆")
    button_toggle:setTitleColor(cc.c4b(115,197,243,255))
    back_register:addChild(button_toggle) 

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back_register:runAction(cc.Sequence:create(action2,action3))
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
    back_register:addChild(button_close)

    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back_register:getBoundingBox(),location) then
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
return RegisterPopup







