require("common.global")


--local LoginAlter = require("view.login.LoginAlter")

local BigAlter      = require("view.alter.BigAlter")
local SmallAlter    = require("view.alter.SmallAlter")


local VisitorRegister = class("VisitorRegister", function()
    return cc.Layer:create()
end)

local showWindow = nil
local showRegister = nil

local back_login = nil
local back_register = nil

local main = nil
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

function VisitorRegister.create()
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.close = function(which)
        return which
    end

    back_login = nil    
    back_register = nil

    showWindow()

    local onTouchBegan = function(touch, event)
        return true
    end
    
    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back_login:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                main.close("close")
            end)
            back_login:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end


showWindow = function()
    if back_login then
        local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
        local action2 = cc.EaseBackOut:create(action1)
        back_login:runAction(action2)
        return
    end

    back_login = cc.Sprite:create("image/login/background_white_login.png")
    back_login:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3) 
    main:addChild(back_login)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back_login:runAction(action2)

    local back_width = back_login:getContentSize().width
    local back_height = back_login:getContentSize().height


    local label1 = cc.Label:createWithSystemFont("注册账号","",40)
    label1:setColor(cc.c4b(115,197,243,255))
    label1:setPosition(back_width/2,680)
    back_login:addChild(label1)

    local label2 = cc.Label:createWithSystemFont("您已经登陆游客账号","",24)
    label2:setColor(cc.c4b(100,100,100,255))
    label2:setPosition(back_width/2,540)
    back_login:addChild(label2)
    
    local label3 = cc.Label:createWithSystemFont("建议您完善自己的信息即可","",24)
    label3:setColor(cc.c4b(100,100,100,255))
    label3:setPosition(back_width/2,490)
    back_login:addChild(label3)
    
    local label4 = cc.Label:createWithSystemFont("注册新号码会删除已有进度","",24)
    label4:setColor(cc.c4b(100,100,100,255))
    label4:setPosition(back_width/2,440)
    back_login:addChild(label4)



    local register_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then       
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                main.close("register")
            end)
            back_login:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local register = ccui.Button:create("image/button/button_blue_147x79.png","image/button/button_blue_147x79.png","")
    register:setPosition(back_width/2 - 100, 250)
    register:addTouchEventListener(register_clicked)
    back_login:addChild(register)

    local label_register = cc.Label:createWithSystemFont("注册新号","",30)
    label_register:setColor(cc.c4b(255,255,255,255))
    label_register:setPosition(70, register:getContentSize().height/2)
    register:addChild(label_register)


    local improve_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then       
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                main.close("improve")
            end)
            back_login:runAction(cc.Sequence:create(action2,action3))        
        end
    end
    
    local improve = ccui.Button:create("image/button/button_blue_147x79.png","image/button/button_blue_147x79.png","")
    improve:setPosition(back_width/2 + 100, 250)
    improve:addTouchEventListener(improve_clicked)
    back_login:addChild(improve)

    local label_improve = cc.Label:createWithSystemFont("完善信息","",30)
    label_improve:setColor(cc.c4b(255,255,255,255))
    label_improve:setPosition(70, improve:getContentSize().height/2)
    improve:addChild(label_improve)


    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                main.close("close")
            end)
            back_login:runAction(cc.Sequence:create(action2,action3))  
        end
    end
    
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(back_width-30,back_height-10)
    button_close:addTouchEventListener(button_close_clicked)
    back_login:addChild(button_close)
    
    
end


return VisitorRegister

