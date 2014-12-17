require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local LoginAlter = require("view.login.LoginAlter")
local VisitorRegister = require("view.login.VisitorRegister")
local ImproveInfo = require("view.home.ImproveInfo")

local IntroLayer = class("IntroLayer", function ()
    return cc.Layer:create()
end)


function IntroLayer.create(directOnLogin)
    local layer = IntroLayer.new()
    
    local currentIndex = 1
    local moveLength = 100
    
    local backColor = cc.LayerColor:create(cc.c4b(30,193,239,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local intro_array = {}
    for i = 1, 3 do
        local intro = cc.Sprite:create("image/login/denglu_"..i.."_background.png")
        if i == 1 then
            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
        else
            intro:setPosition(s_DESIGN_WIDTH*2,s_DESIGN_HEIGHT/2)
        end
        layer:addChild(intro)
        table.insert(intro_array, intro)
    end

    local intro = cc.Layer:create()
    intro:setContentSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT)
    intro:setAnchorPoint(0.5,0.5)
    intro:ignoreAnchorPointForPosition(false)
    intro:setPosition(s_DESIGN_WIDTH*1.5,s_DESIGN_HEIGHT/2)
    layer:addChild(intro)
    table.insert(intro_array, intro)
    
    local head = cc.Sprite:create("image/login/logo_denglu.png")
    head:setPosition(s_DESIGN_WIDTH/2, 800)
    intro:addChild(head)
    
    local genRandomUserName = function()
        local userNameLength = 8
        local userName = ""
        
        math.randomseed(os.time())
        for i = 1, userNameLength do
            local randomIndex = math.random(0, 25)
            local randomSmallCharIndex = string.byte('a') + randomIndex
            local randomBigCharIndex   = string.byte('A') + randomIndex
            
            randomIndex = math.random(1, 2)
            if randomIndex == 1 then
                userName = userName .. string.char(randomSmallCharIndex)
            else
                userName = userName .. string.char(randomBigCharIndex)
            end
        end
        
        return userName
    end
    
    local visitLogin
    visitLogin = function()
        local randomUserName = genRandomUserName()
        s_logd("randomUserName: "..randomUserName)

        showProgressHUD()
        s_UserBaseServer.isUserNameExist(randomUserName, function (api, result)
            if result.count <= 0 then -- not exist the user name
                s_CURRENT_USER.isGuest = 1
                s_SCENE:signUp(randomUserName, "bbdc123#")
                AnalyticsSignUp_Guest()
            else -- exist the user name
                visitLogin()
            end
        end,
        function (api, code, message, description)
            s_TIPS_LAYER:showSmall(message)
            hideProgressHUD()
        end)
    end
    
    local button_visitor_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local hasGuest = s_DATABASE_MGR.getLastLogInGuest(s_CURRENT_USER)
            if hasGuest then
                s_SCENE:logIn(s_CURRENT_USER.username, s_CURRENT_USER.password)
            else
                visitLogin()
            end
            --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    
    local button_visitor = ccui.Button:create()
    button_visitor:loadTextures("image/button/button_white2_denglu.png", "", "")
    button_visitor:addTouchEventListener(button_visitor_clicked)
    button_visitor:setPosition(s_DESIGN_WIDTH/2, 500)
    button_visitor:setTitleFontSize(36)
    button_visitor:setTitleText("游客登陆")
    intro:addChild(button_visitor)
    
    local button_login
    local button_register
    local button_login_clicked
    local button_register_clicked

    local cloud = cc.Sprite:create("image/login/cloud_denglu.png")
    cloud:setAnchorPoint(0.5,0)
    cloud:setPosition(s_DESIGN_WIDTH/2,-200)
    layer:addChild(cloud)
    
    button_login_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local loginAlter = LoginAlter.createLogin()
            loginAlter:setTag(1)
            loginAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
            layer:addChild(loginAlter)
            -- button sound
            playSound(s_sound_buttonEffect)
            loginAlter.close = function()
                layer:removeChildByTag(1)
            end
        end
    end
    
    button_register_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then

            local gotoRegistNewAccount = function ()
                local loginAlter = LoginAlter.createRegister()
                loginAlter:setTag(2)
                loginAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                layer:addChild(loginAlter)
                -- button sound
                playSound(s_sound_buttonEffect)
                loginAlter.close = function() layer:removeChildByTag(2) end 
            end

            local hasAccount = s_DATABASE_MGR.getLastLogInUser(s_CURRENT_USER)

            if not (hasAccount and s_CURRENT_USER.isGuest == 1) then
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
    
    button_login = ccui.Button:create()
    button_login:loadTextures("image/button/studyscene_blue_button.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(cloud:getContentSize().width/2-150, 200)
    button_login:setTitleFontSize(36)
    button_login:setTitleText("登陆")
    button_login:setTitleColor(cc.c4b(255,255,255,255))
    button_login:setVisible(false)
    cloud:addChild(button_login)
    
    button_register = ccui.Button:create()
    button_register:loadTextures("image/button/button_white_denglu.png", "", "")
    button_register:addTouchEventListener(button_register_clicked)
    button_register:setPosition(cloud:getContentSize().width/2+150, 200)
    button_register:setTitleFontSize(36)
    button_register:setTitleText("注册")
    button_register:setTitleColor(cc.c4b(115,197,243,255))
    button_register:setVisible(false)
    cloud:addChild(button_register)

    local label_hint_array = {}
    table.insert(label_hint_array, "一关一城市 贝贝带你游美国")
    table.insert(label_hint_array, "随时随地 消消记记")
    table.insert(label_hint_array, "生词错词分类 数据私人定制")
    table.insert(label_hint_array, "登陆贝贝单词 发现更多精彩")
    
    local label_hint = cc.Label:createWithSystemFont(label_hint_array[currentIndex],"",36)
    label_hint:setColor(cc.c4b(115,197,243,255))
    label_hint:setPosition(s_DESIGN_WIDTH/2, 100)
    layer:addChild(label_hint)

    local circle_back_array = {}
    local circle_font_array = {}
    local gap = 50
    local left = s_DESIGN_WIDTH/2 - gap*1.5
    for i = 1, 4 do
        local circle_back = cc.Sprite:create("image/login/yuan_white_denglu.png")
        circle_back:setPosition(left+gap*(i-1),50)
        layer:addChild(circle_back)
        table.insert(circle_back_array, circle_back)
        
        local circle_font = cc.Sprite:create("image/login/yuan_blue_denglu.png")
        circle_font:setPosition(left+gap*(i-1),50)
        layer:addChild(circle_font)
        table.insert(circle_font_array, circle_font)
        
        if i == currentIndex then
           circle_back:setVisible(false)
           circle_font:setVisible(true)
        else
           circle_back:setVisible(true)
           circle_font:setVisible(false)
        end
    end
    
    
    -- special handle the location
    if directOnLogin then
        print("ziaoang - Test")
        currentIndex = 4
        
        circle_back_array[1]:setVisible(true)
        circle_font_array[1]:setVisible(false)
        circle_back_array[currentIndex]:setVisible(false)
        circle_font_array[currentIndex]:setVisible(true)
        print(currentIndex)
        
        intro_array[1]:setPosition(-s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2)
        intro_array[2]:setPosition(-s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2)
        intro_array[3]:setPosition(-s_DESIGN_WIDTH,s_DESIGN_HEIGHT/2)
        intro_array[4]:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
        
        label_hint:setString(label_hint_array[currentIndex])  
        
        cloud:setPosition(s_DESIGN_WIDTH/2, 0)

        button_login:setVisible(true)
        button_register:setVisible(true)
    end
        
    local moved = false
    local start_x = nil
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        start_x = location.x
        moved = false
        return true
    end
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
        local location = layer:convertToNodeSpace(touch:getLocation())
        local now_x = location.x
        if now_x - moveLength > start_x then
            print("move right")
            if currentIndex > 1 and currentIndex <= 4 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true
                
                if currentIndex == 4 then
                    button_login:setVisible(false)
                    button_register:setVisible(false)

                    local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*0.5, -200))
                    cloud:runAction(action2)
                end

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*2,s_DESIGN_HEIGHT/2))
                intro_array[currentIndex]:runAction(action1)
  
                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex-1]:runAction(cc.Sequence:create(action2, action3))

                circle_back_array[currentIndex]:setVisible(true)
                circle_font_array[currentIndex]:setVisible(false)
                currentIndex = currentIndex - 1
                circle_back_array[currentIndex]:setVisible(false)
                circle_font_array[currentIndex]:setVisible(true)   
                
                label_hint:setString(label_hint_array[currentIndex])             
            end
            print(currentIndex)
        elseif now_x + moveLength < start_x then
            print("move left")
            if currentIndex < 4 and currentIndex >= 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true
                
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH-s_DESIGN_WIDTH*2,s_DESIGN_HEIGHT/2))
                intro_array[currentIndex]:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex+1]:runAction(cc.Sequence:create(action2, action3))
                
                if currentIndex == 3 then            
                    local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH*0.5, 0))
                    local action3 = cc.CallFunc:create(function()
                        button_login:setVisible(true)
                        button_register:setVisible(true)
                    end)
                    cloud:runAction(cc.Sequence:create(action2, action3))
                end
                
                circle_back_array[currentIndex]:setVisible(true)
                circle_font_array[currentIndex]:setVisible(false)
                currentIndex = currentIndex + 1
                circle_back_array[currentIndex]:setVisible(false)
                circle_font_array[currentIndex]:setVisible(true)
                
                label_hint:setString(label_hint_array[currentIndex])   
            end 
            print(currentIndex)
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
--    playMusic(s_sound_Pluto,true)
    return layer
end



    


return IntroLayer
