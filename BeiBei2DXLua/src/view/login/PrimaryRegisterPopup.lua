require("common.global")

local BigAlter      = require("view.alter.BigAlter")
local SmallAlter    = require("view.alter.SmallAlter")
local InputNode     = require("view.login.InputNode")
local Button                = require("view.button.longButtonInStudy")

local PrimaryRegisterPopup = class("PrimaryRegisterPopup", function()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

function PrimaryRegisterPopup.create()
    local main = PrimaryRegisterPopup.new()
    return main
end

function PrimaryRegisterPopup:ctor()

    local name_text = ""
    local password_text = ""
    local teacher_text = ""

	local back_login = cc.Sprite:create("image/login/store_tanchu_background.png")
    back_login:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    back_login:ignoreAnchorPointForPosition(false)
    back_login:setAnchorPoint(0.5,0.5)
    self:setContentSize(back_login:getContentSize().width,s_DESIGN_HEIGHT)
    self:addChild(back_login)
    
    local back_width = back_login:getContentSize().width
    local back_height = back_login:getContentSize().height

    local girl = cc.Sprite:create("image/login/girl.png")
    girl:setPosition(back_width / 2,back_height * 0.72)
    back_login:addChild(girl)

    local addTeacherTextField = function ()    
        local teachername = InputNode.create("teachername")
        teachername:setPosition(back_width/2, 250)
        back_login:addChild(teachername)
        
        local teacherButton_func = function()
            playSound(s_sound_buttonEffect)
            teacher_text = teachername.textField:getString()
            print("hello "..teacher_text.."teacher,I'm "..name_text.."and my password is "..password_text)
        end

        local teacherButton = Button.create("long","blue","完成")
        teacherButton.func = function ()
            teacherButton_func()
        end

        teacherButton:setPosition(back_width/2, 100)
        back_login:addChild(teacherButton)
    end

    local addPasswordTextField = function ()
        local passwordButton
        local password = InputNode.create("password")
        password:setPosition(back_width/2, 250)
        back_login:addChild(password)

        local passwordButton_func = function()
            playSound(s_sound_buttonEffect)

            if validatePassword(password.textField:getString()) == false then
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT_ID_PWD_ERROR))
                return
            end

            addTeacherTextField()
            password_text = password.textField:getString()
            password:removeFromParent()
            passwordButton:removeFromParent()
        end

        passwordButton = Button.create("long","blue","下一步")
        passwordButton.func = function ()
            passwordButton_func()
        end
        passwordButton:setPosition(back_width/2, 100)
        back_login:addChild(passwordButton)
    end
    
    local addUsernameTextField = function ()
        local nameButton
        local username = InputNode.create("username")
        username:setPosition(back_width/2, 250)
        back_login:addChild(username)

        local nameButton_func = function()
            playSound(s_sound_buttonEffect)

            if validateUsername(username.textField:getString()) == false then
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT_ID_USERNAME_ERROR))
                return
            end

            name_text = username.textField:getString()
            addPasswordTextField()
            username:removeFromParent()
            nameButton:removeFromParent()
        end

        nameButton = Button.create("long","blue","下一步")
        nameButton.func = function ()
            nameButton_func()
        end
        nameButton:setPosition(back_width/2, 100)
        back_login:addChild(nameButton)
    end

    addUsernameTextField()
    
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

return PrimaryRegisterPopup







