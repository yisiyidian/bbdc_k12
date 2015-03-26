require("cocos.init")
require("common.global")

--local LoginAlter = require("view.login.LoginAlter")
local VisitorRegister = require("view.login.VisitorRegister")
local ImproveInfo = require("view.home.ImproveInfo")
local Offline = require("view.offlinetip.OfflineTipForLogin")

local IntroLayer = class("IntroLayer", function ()
    return cc.Layer:create()
end)

local function button_qq_clicked(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        playSound(s_sound_buttonEffect)
        s_O2OController.logInByQQ()
        AnalyticsSignUp_QQ()
    end
end

function IntroLayer.create(directOnLogin)
--    local layer = IntroLayer.new()
--    
--    local currentIndex = 1
--    local moveLength = 100
--    local offlineTip
--    local isOnline = s_SERVER.isNetworkConnectedWhenInited()
--        
--    local backColor = cc.LayerColor:create(cc.c4b(30,193,239,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
--    backColor:setAnchorPoint(0.5,0.5)
--    backColor:ignoreAnchorPointForPosition(false)  
--    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
--    layer:addChild(backColor)
--
--    local intro_array = {}
--    for i = 1, 3 do
--        local intro = cc.Sprite:create("image/login/denglu_"..i.."_background.png")
--        if i == 1 then
--            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
--        else
--            intro:setPosition(s_DESIGN_WIDTH*2,s_DESIGN_HEIGHT/2)
--        end
--        layer:addChild(intro)
--        table.insert(intro_array, intro)
--    end
--
--    local intro = cc.Layer:create()
--    intro:setContentSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT)
--    intro:setAnchorPoint(0.5,0.5)
--    intro:ignoreAnchorPointForPosition(false)
--    intro:setPosition(s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2)
--    layer:addChild(intro)
--    table.insert(intro_array, intro)
--    
--    local head = cc.Sprite:create("image/login/logo_denglu.png")
--    head:setPosition(s_DESIGN_WIDTH/2, 800)
--    intro:addChild(head)
--    
--    local button_visitor_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.ended then
--            local tmpUser = DataUser.create()
--            local hasGuest = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_GUEST)
--            if hasGuest then
--                s_O2OController.logInOnline(tmpUser.username, tmpUser.password)
--            else
--                s_O2OController.signUpWithRandomUserName()
--            end
--            --button sound
--            playSound(s_sound_buttonEffect)
--        end
--    end
--
--    if IS_SNS_QQ_LOGIN_AVAILABLE and isOnline then
--        local button_qq = ccui.Button:create()
--        button_qq:loadTextures("image/button/button_white2_denglu.png", "", "")
--        button_qq:addTouchEventListener(button_qq_clicked)
--        button_qq:setPosition(s_DESIGN_WIDTH/2, 590)
--        button_qq:setTitleFontSize(36)
--        button_qq:setTitleText("QQ登陆")
--        intro:addChild(button_qq)
--    end
--    
--    local button_visitor = ccui.Button:create()
--    button_visitor:loadTextures("image/button/button_login_2.png", "", "")
--    button_visitor:addTouchEventListener(button_visitor_clicked)
--    button_visitor:setPosition(s_DESIGN_WIDTH/2, 500)
--    button_visitor:setTitleFontSize(30)
--    button_visitor:setTitleText("游客登陆")
--    intro:addChild(button_visitor)
--    
--    local button_login
--    local button_register
--    local button_login_clicked
--    local button_register_clicked
--
--    local cloud = cc.Sprite:create("image/login/cloud_denglu.png")
--    cloud:setAnchorPoint(0.5,0)
--    cloud:setPosition(s_DESIGN_WIDTH/2,-200)
--    layer:addChild(cloud)
--    
--    button_login_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.ended then
--            if s_SERVER.isNetworkConnectedNow() == false then
--                offlineTip.setTrue()
--            else
--                local loginAlter = LoginAlter.createLogin(CreateLogin_FromNormal)
--                loginAlter:setTag(1)
--                loginAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--                layer:addChild(loginAlter)
--
--                playSound(s_sound_buttonEffect)
--                loginAlter.close = function()
--                    layer:removeChildByTag(1)
--                end
--            end
--        end
--    end
--    
--    button_register_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.ended then
--            if s_SERVER.isNetworkConnectedNow() == false then
--                offlineTip.setTrue()
--            else
--            local gotoRegistNewAccount = function ()
--                local loginAlter = LoginAlter.createRegister(CreateRegister_FromNormal)
--                loginAlter:setTag(2)
--                loginAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--                layer:addChild(loginAlter)
--                -- button sound
--                playSound(s_sound_buttonEffect)
--                loginAlter.close = function() layer:removeChildByTag(2) end 
--            end
--
--            local tmpUser = DataUser.create()
--            local hasAccount = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_ALL)
--
--            if not (hasAccount and tmpUser.usertype == USER_TYPE_GUEST) then
--                gotoRegistNewAccount()
--            else
--                local visitorRegister = VisitorRegister.create()
--                visitorRegister:setTag(2)
--                visitorRegister:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--                layer:addChild(visitorRegister)
--                -- button sound
--                playSound(s_sound_buttonEffect)
--                visitorRegister.close = function(which)
--                    -- which = register,improve,close
--                    layer:removeChildByTag(2)   
--                    if which == "register" then
--                        gotoRegistNewAccount()
--                    elseif which == "improve" then
--                        playSound(s_sound_buttonEffect)
--                        local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_INTRO_LAYER)
--                        improveInfo:setTag(1)
--                        improveInfo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--                        layer:addChild(improveInfo)
--                        improveInfo.close = function()
--                            layer:removeChildByTag(1)   
--                        end                                  
--                    end
--
--                end 
--            end
--            end
--        end
--    end
--    
--    button_login = ccui.Button:create()
--    button_login:loadTextures("image/button/studyscene_blue_button.png", "", "")
--    button_login:addTouchEventListener(button_login_clicked)
--    button_login:setPosition(cloud:getContentSize().width/2-150, 125)
--    button_login:setTitleFontSize(36)
--    button_login:setTitleText("登陆")
--    button_login:setTitleColor(cc.c4b(255,255,255,255))
--    button_login:setVisible(false)
--    cloud:addChild(button_login)
--    
--    button_register = ccui.Button:create()
--    button_register:loadTextures("image/button/button_white_denglu.png", "", "")
--    button_register:addTouchEventListener(button_register_clicked)
--    button_register:setPosition(cloud:getContentSize().width/2+150, 125)
--    button_register:setTitleFontSize(36)
--    button_register:setTitleText("注册")
--    button_register:setTitleColor(cc.c4b(115,197,243,255))
--    button_register:setVisible(false)
--    cloud:addChild(button_register)
--
--    local label_hint_array = {}
--    table.insert(label_hint_array, "贝贝独创：学习就是游戏")
--    table.insert(label_hint_array, "生词进度：从此一目了然")
--    table.insert(label_hint_array, "过关斩怪兽：根本停不下来")
--    table.insert(label_hint_array, "登陆贝贝单词：发现更多精彩")
--    
--    local label_hint = cc.Label:createWithSystemFont(label_hint_array[currentIndex],"",36)
--    label_hint:setColor(cc.c4b(115,197,243,255))
--    label_hint:setPosition(cloud:getContentSize().width/2, 300)
--    cloud:addChild(label_hint)
--
--    local circle_back_array = {}
--    local circle_font_array = {}
--    local gap = 50
--    local left = cloud:getContentSize().width / 2 - gap*1.5
--    for i = 1, 4 do
--        local circle_back = cc.Sprite:create("image/login/yuan_white_denglu.png")
--        circle_back:setPosition(left+gap*(i-1),250)
--        cloud:addChild(circle_back)
--        table.insert(circle_back_array, circle_back)
--        
--        local circle_font = cc.Sprite:create("image/login/yuan_blue_denglu.png")
--        circle_font:setPosition(left+gap*(i-1),250)
--        cloud:addChild(circle_font)
--        table.insert(circle_font_array, circle_font)
--        
--        if i == currentIndex then
--           circle_back:setVisible(false)
--           circle_font:setVisible(true)
--        else
--           circle_back:setVisible(true)
--           circle_font:setVisible(false)
--        end
--    end
--    
--    
--    -- special handle the location
--    if directOnLogin then
--        print("ziaoang - Test")
--        currentIndex = 4
--        
--        circle_back_array[1]:setVisible(true)
--        circle_font_array[1]:setVisible(false)
--        circle_back_array[currentIndex]:setVisible(false)
--        circle_font_array[currentIndex]:setVisible(true)
--        print(currentIndex)
--        
--        intro_array[1]:setPosition(-s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2)
--        intro_array[2]:setPosition(-s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2)
--        intro_array[3]:setPosition(-s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2)
--        intro_array[4]:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
--        
--        label_hint:setString(label_hint_array[currentIndex])  
--        
--        cloud:setPosition(s_DESIGN_WIDTH/2, 0)
--
--        button_login:setVisible(true)
--        button_register:setVisible(true)
--    end
--        
--    local moved = false
--    local start_x = nil
--    
--    local onTouchBegan = function(touch, event)
--        local location = layer:convertToNodeSpace(touch:getLocation())
--        start_x = location.x
--        moved = false
--        return true
--    end
--    local onTouchMoved = function(touch, event)
--        if moved then
--            return
--        end
--        
--        local location = layer:convertToNodeSpace(touch:getLocation())
--        local now_x = location.x
--        if now_x - moveLength > start_x then
--            print("move right")
--            if currentIndex > 1 and currentIndex <= 4 then
--                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
--                moved = true
--                
--                if currentIndex == 4 then
--                    local action0 = cc.MoveBy:create(0.4,cc.p(0,-200))
--                    local action1 = cc.CallFunc:create(function ()
--                        button_login:setVisible(false)
--                    end)
--                    local action2 = cc.MoveBy:create(0,cc.p(0,200))
--                    local action3 = cc.Sequence:create(action0,action1,action2)
--                    button_login:runAction(action3)
--
--                    local action5 = cc.MoveBy:create(0.4,cc.p(0,-200))
--                    local action6 = cc.CallFunc:create(function ()
--                        button_register:setVisible(false)
--                    end)
--                    local action7 = cc.MoveBy:create(0,cc.p(0,200))
--                    local action8 = cc.Sequence:create(action5,action6,action7)
--                    button_register:runAction(action8)
--
--                    local action9 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*0.5, -200))
--                    cloud:runAction(action9)
--                end
--
--                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*2,s_DESIGN_HEIGHT/2))
--                intro_array[currentIndex]:runAction(action1)
--  
--                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
--                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
--                intro_array[currentIndex-1]:runAction(cc.Sequence:create(action2, action3))
--
--                circle_back_array[currentIndex]:setVisible(true)
--                circle_font_array[currentIndex]:setVisible(false)
--                currentIndex = currentIndex - 1
--                circle_back_array[currentIndex]:setVisible(false)
--                circle_font_array[currentIndex]:setVisible(true)   
--                
--                label_hint:setString(label_hint_array[currentIndex])             
--            end
--            print(currentIndex)
--        elseif now_x + moveLength < start_x then
--            print("move left")
--            if currentIndex < 4 and currentIndex >= 1 then
--                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
--                moved = true
--                
--                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH-s_DESIGN_WIDTH*2,s_DESIGN_HEIGHT/2))
--                intro_array[currentIndex]:runAction(action1)
--
--                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
--                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
--                intro_array[currentIndex+1]:runAction(cc.Sequence:create(action2, action3))
--                
--                if currentIndex == 3 then           
--                    local action0 = cc.MoveBy:create(0,cc.p(0,-200))
--                    local action1 = cc.CallFunc:create(function ()
--                        button_login:setVisible(true)
--                    end)
--                    local action2 = cc.MoveBy:create(0.5,cc.p(0,200))
--                    local action3 = cc.Sequence:create(action0,action1,action2)
--                    button_login:runAction(action3)
--
--                    local action5 = cc.MoveBy:create(0,cc.p(0,-200))
--                    local action6 = cc.CallFunc:create(function ()
--                        button_register:setVisible(true)
--                    end)
--                    local action7 = cc.MoveBy:create(0.5,cc.p(0,200))
--                    local action8 = cc.Sequence:create(action5,action6,action7)
--                    button_register:runAction(action8)
--                    local action9 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*0.5, 0))
--                    cloud:runAction(action9)
--                end
--                
--                circle_back_array[currentIndex]:setVisible(true)
--                circle_font_array[currentIndex]:setVisible(false)
--                currentIndex = currentIndex + 1
--                circle_back_array[currentIndex]:setVisible(false)
--                circle_font_array[currentIndex]:setVisible(true)
--                
--                label_hint:setString(label_hint_array[currentIndex])   
--            end 
--            print(currentIndex)
--        end
--        
--        if s_SERVER.isNetworkConnectedNow() == false then
--            if currentIndex == 4 then
--                offlineTip.setTrue()
--            elseif currentIndex == 3 then
--                offlineTip.setFalse()
--            end
--        end
--    end
--    
--    --add offline        
--    offlineTip = Offline.create()
--    layer:addChild(offlineTip)
--    if currentIndex == 4 and s_SERVER.isNetworkConnectedWhenInited() == false then
--        offlineTip.setTrue()
--    end
--    
--    local listener = cc.EventListenerTouchOneByOne:create()
--    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
--    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
--    local eventDispatcher = layer:getEventDispatcher()
--    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
--    
--
--    
----    playMusic(s_sound_Pluto,true)
--    return layer
    
    local layer = IntroLayer.new()
    cc.SimpleAudioEngine:getInstance():stopMusic()

    local offlineTip
    local isOnline = s_SERVER.isNetworkConnectedWhenInited()

    local backColor = cc.LayerColor:create(cc.c4b(30,193,239,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local intro = cc.Layer:create()
    intro:setContentSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT)
    intro:setAnchorPoint(0.5,0.5)
    intro:ignoreAnchorPointForPosition(false)
    intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(intro)

    local head = cc.Sprite:create("image/login/logo_denglu.png")
    head:setPosition(s_DESIGN_WIDTH/2, 800)
    intro:addChild(head)

    local button_visitor_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local tmpUser = DataUser.create()
            local hasGuest = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_GUEST)
            if hasGuest then
                s_O2OController.logInOnline(tmpUser.username, tmpUser.password)
            else
                s_O2OController.signUpWithRandomUserName()
            end
            playSound(s_sound_buttonEffect)
        end
    end

    if IS_SNS_QQ_LOGIN_AVAILABLE and isOnline then
        local button_qq = ccui.Button:create()
        button_qq:loadTextures("image/button/button_white2_denglu.png", "", "")
        button_qq:addTouchEventListener(button_qq_clicked)
        button_qq:setPosition(s_DESIGN_WIDTH/2, 590)
        button_qq:setTitleFontSize(36)
        button_qq:setTitleText("QQ登陆")
        intro:addChild(button_qq)
    end

    local button_visitor = ccui.Button:create()
    button_visitor:loadTextures("image/button/button_login_2.png", "", "")
    button_visitor:addTouchEventListener(button_visitor_clicked)
    button_visitor:setPosition(s_DESIGN_WIDTH/2, 500)
    button_visitor:setTitleFontSize(30)
    button_visitor:setTitleText("游客登陆")
    intro:addChild(button_visitor)

    local button_login
    local button_register
    local button_login_clicked
    local button_register_clicked

    local cloud = cc.Sprite:create("image/login/cloud_denglu.png")
    cloud:setAnchorPoint(0.5,0)
    cloud:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(cloud)

    button_login_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if s_SERVER.isNetworkConnectedNow() == false then
                offlineTip.setTrue()
            else
                playSound(s_sound_buttonEffect)
                local LoginPopup = require("view.login.LoginPopup")
                local loginPopup = LoginPopup.create()
                s_SCENE:popup(loginPopup)
                
                loginPopup:setVisible(false)
                loginPopup:setPosition(0,s_DESIGN_HEIGHT * 1.5) 

                local action2 = cc.CallFunc:create(function()
                    loginPopup:setVisible(true)
                end)
                local action3 = cc.MoveTo:create(0.5,cc.p(0,0)) 
                local action4 = cc.Sequence:create(action2, action3)
                loginPopup:runAction(action4) 
            end
        end
    end

    button_register_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if s_SERVER.isNetworkConnectedNow() == false then
                offlineTip.setTrue()
            else
                local gotoRegistNewAccount = function ()
                    playSound(s_sound_buttonEffect)
                    local RegisterPopup = require("view.login.RegisterPopup")
                    local registerPopup = RegisterPopup.create()
                    s_SCENE:popup(registerPopup)

                    registerPopup:setVisible(false)
                    registerPopup:setPosition(0,s_DESIGN_HEIGHT * 1.5) 

                    local action2 = cc.CallFunc:create(function()
                        registerPopup:setVisible(true)
                    end)
                    local action3 = cc.MoveTo:create(0.5,cc.p(0,0)) 
                    local action4 = cc.Sequence:create(action2, action3)
                    registerPopup:runAction(action4) 
                end

                local tmpUser = DataUser.create()
                local hasAccount = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_ALL)

                if not (hasAccount and tmpUser.usertype == USER_TYPE_GUEST) then
                    gotoRegistNewAccount()
                else
                    local visitorRegister = VisitorRegister.create()
                    visitorRegister:setTag(2)
                    visitorRegister:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(visitorRegister)
                    -- button sound
                    playSound(s_sound_buttonEffect)
                    visitorRegister.close = function(which)
                        -- which = register,improve,close
                        layer:removeChildByTag(2)   
                        if which == "register" then
                            gotoRegistNewAccount()
                        elseif which == "improve" then
                            playSound(s_sound_buttonEffect)
                            local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_INTRO_LAYER)
                            improveInfo:setTag(1)
                            improveInfo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                            layer:addChild(improveInfo)
                            improveInfo.close = function()
                                layer:removeChildByTag(1)   
                            end                                  
                        end

                    end 
                end
            end
        end
    end

    button_login = ccui.Button:create()
    button_login:loadTextures("image/button/studyscene_blue_button.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(cloud:getContentSize().width/2-150, 125)
    button_login:setTitleFontSize(36)
    button_login:setTitleText("登陆")
    button_login:setTitleColor(cc.c4b(255,255,255,255))
    cloud:addChild(button_login)

    button_register = ccui.Button:create()
    button_register:loadTextures("image/button/button_white_denglu.png", "", "")
    button_register:addTouchEventListener(button_register_clicked)
    button_register:setPosition(cloud:getContentSize().width/2+150, 125)
    button_register:setTitleFontSize(36)
    button_register:setTitleText("注册")
    button_register:setTitleColor(cc.c4b(115,197,243,255))
    cloud:addChild(button_register)

    local label_hint = cc.Label:createWithSystemFont("登陆贝贝单词：发现更多精彩","",36)
    label_hint:setColor(cc.c4b(115,197,243,255))
    label_hint:setPosition(cloud:getContentSize().width/2, 300)
    cloud:addChild(label_hint)

    --add offline        
    offlineTip = Offline.create()
    layer:addChild(offlineTip)
    if s_SERVER.isNetworkConnectedWhenInited() == false then
        offlineTip.setTrue()
    end

    return layer
end

return IntroLayer
