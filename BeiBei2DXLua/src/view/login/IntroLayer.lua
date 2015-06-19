require("cocos.init")
require("common.global")

--登陆引导页
--界面包含:游客登陆 登陆 注册 三个入口

local VisitorRegister = require("view.login.VisitorRegister")

local Offline = require("view.offlinetip.OfflineTipForLogin")

local RegisterAccountView = require("view.login.RegisterAccountView")

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
    if s_CURRENT_USER.summaryStep == 9 then
        AnalyticsSummaryStep(s_summary_enterApp)
    end
    local layer = IntroLayer.new()

    local offlineTip
    local isOnline = s_SERVER.isNetworkConnectedWhenInited()
    --底色
    local backColor = cc.LayerColor:create(cc.c4b(30,193,239,255), s_DESIGN_WIDTH + 2 * s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    --中间部分的容器，包含女孩logo和游客登录按钮
    local intro = cc.Layer:create()
    intro:setContentSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT)
    intro:setAnchorPoint(0.5,0.5)
    intro:ignoreAnchorPointForPosition(false)
    intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(intro)
    --小女孩的logo
    local head = cc.Sprite:create("image/login/logo_denglu.png")
    head:setPosition(s_DESIGN_WIDTH/2, 800)
    intro:addChild(head)

    -- 游客登陆点击回调
    local button_visitor_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups() 
            playSound(s_sound_buttonEffect)
        end
    end

    -- if IS_SNS_QQ_LOGIN_AVAILABLE and isOnline then
    --     local button_qq = ccui.Button:create()
    --     button_qq:loadTextures("image/button/button_white2_denglu.png", "", "")
    --     button_qq:addTouchEventListener(button_qq_clicked)
    --     button_qq:setPosition(s_DESIGN_WIDTH/2, 590)
    --     button_qq:setTitleFontSize(36)
    --     button_qq:setTitleText("QQ登陆")
    --     intro:addChild(button_qq)
    -- end
    -- 游客登陆按钮
    local button_visitor = ccui.Button:create()
    button_visitor:loadTextures("image/button/button_login_2.png", "", "")
    button_visitor:addTouchEventListener(button_visitor_clicked)
    button_visitor:setPosition(s_DESIGN_WIDTH/2, 500)
    button_visitor:setTitleFontSize(30)
    button_visitor:setTitleText("游客登陆")
    intro:addChild(button_visitor)
    
    --白色云彩
    local cloud = cc.Sprite:create("image/login/cloud_denglu.png")
    cloud:setAnchorPoint(0.5,0)
    cloud:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(cloud)

    --登陆按钮点击
    local button_login_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if s_SERVER.isNetworkConnectedNow() == false then
                offlineTip.setTrue()
            else
                playSound(s_sound_buttonEffect)
                if s_CURRENT_USER.summaryStep == 9 then
                    AnalyticsSummaryStep(s_summary_login)
                end
                --弹出RegisterAccountView的登陆界面  RegisterAccountView.STEP_6 就是登陆
                local loginView = RegisterAccountView.new(RegisterAccountView.STEP_6)
                loginView.close = function ()
                    local introLayer = IntroLayer.create()
                    s_SCENE:popup(introLayer)
                end
                s_SCENE:popup(loginView)
                --[[
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
                ]]
            end
        end
    end

    --注册按钮点击
    local button_register_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if s_SERVER.isNetworkConnectedNow() == false then
                offlineTip.setTrue()
            else

                local layer = RegisterAccountView.new()
                layer.close = function ()
                    local introLayer = IntroLayer.create()
                    s_SCENE:popup(introLayer)
                end
                s_SCENE:popup(layer)
            end
        end
    end

    --登陆按钮
    local button_login = ccui.Button:create()
    button_login:loadTextures("image/button/studyscene_blue_button.png", "", "")
    button_login:addTouchEventListener(button_login_clicked)
    button_login:setPosition(cloud:getContentSize().width/2-150, 125)
    button_login:setTitleFontSize(36)
    button_login:setTitleText("登陆")
    button_login:setTitleColor(cc.c4b(255,255,255,255))
    cloud:addChild(button_login)

    --注册按钮
    local button_register = ccui.Button:create()
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
