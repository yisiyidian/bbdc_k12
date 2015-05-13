-- local ChangeAccountPopup = require('view.login.ChangeAccountPopup')
-- local loginPopup = ChangeAccountPopup.create()
-- s_SCENE:popup(loginPopup)

-- loginPopup:setVisible(false)
-- loginPopup:setPosition(0,s_DESIGN_HEIGHT * 1.5) 

-- local action2 = cc.CallFunc:create(function()
--     loginPopup:setVisible(true)
-- end)
-- local action3 = cc.MoveTo:create(0.5,cc.p(0,0)) 
-- local action4 = cc.Sequence:create(action2, action3)
-- loginPopup:runAction(action4)

--新安装用户需要提升他注册帐号，
--第一步输入姓名
--第二步输入密码
--。。。。。
--现在这些东西都需要改掉


local InputNode = require("view.login.InputNode")
local Button    = require("view.button.longButtonInStudy")

local K12AccountBindView = class("K12AccountBindView", function() return cc.Layer:create() end)

K12AccountBindView.Type_username = 0
K12AccountBindView.Type_password = 1
K12AccountBindView.Type_teacher = 2

function K12AccountBindView.create(viewtype, ex)
    AnalyticsK12SmallStep(s_K12_inputUserName)
    -- 打点
    local view = K12AccountBindView.new()
    view:init(K12AccountBindView.Type_username, ex)
    view:init(K12AccountBindView.Type_password, ex)
    view:init(K12AccountBindView.Type_teacher, ex)
    --create出来的时候，就pop出来了
    s_SCENE:popup(view)
    view:setPosition(0, 0) 

    return view
end

function K12AccountBindView:ctor()

    self.back_width = 854
    self.back_height = 912

    local backColor = cc.LayerColor:create(cc.c4b(35,167,227,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setAnchorPoint(0.5,0)
    backColor:setPosition(0.5 * s_DESIGN_WIDTH,0)
    self:addChild(backColor)

    local background = ccui.Scale9Sprite:create('image/signup/frontground_children_login.png',cc.rect(0,0,854,87),cc.rect(0, 43, 854, 1))
    background:setContentSize(cc.size(854,87+825))
    background:ignoreAnchorPointForPosition(false)
    background:setAnchorPoint(0.5,0)
    background:setPosition(0.5 * s_DESIGN_WIDTH,0)
    self:addChild(background)

    self.bg = cc.Node:create()
    self.bg:setPosition(0,0)
    background:addChild(self.bg)

    self.back = background

    local girl = sp.SkeletonAnimation:create("res/spine/signup/bbchildren2.json", "res/spine/signup/bbchildren2.atlas", 1)
    girl:setAnimation(0,'animation',true)
    background:addChild(girl)
    girl:setPosition(self.back_width / 2,s_DESIGN_HEIGHT / 2)
    self.girl = girl

    local bubble = cc.Sprite:create('image/signup/dauglog_bbchildren_background.png')
    bubble:setAnchorPoint(0,0.15)
    bubble:setPosition(0.5 * s_DESIGN_WIDTH - 49,s_DESIGN_HEIGHT - 10 - 0.85 * bubble:getContentSize().height)
    self:addChild(bubble)

    local welcome = cc.Label:createWithSystemFont('欢迎来到\n贝贝单词','',38)
    welcome:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    welcome:setPosition(bubble:getContentSize().width / 2,bubble:getContentSize().height / 2)
    bubble:addChild(welcome)
    self.welcome = welcome

    bubble:setScale(0)
    local appear = cc.ScaleTo:create(1.0,1)
    local shake = cc.RepeatForever:create(cc.Sequence:create(cc.RotateBy:create(0.5,3),cc.RotateBy:create(1,-6),cc.RotateBy:create(0.5,3)))
    bubble:runAction(appear)
    bubble:runAction(shake)
    bubble:setName('bubble0')

    local boss = sp.SkeletonAnimation:create("res/spine/signup/bbchildren_login_zhangyu1.json", "res/spine/signup/bbchildren_login_zhangyu1.atlas", 1)
    boss:setPosition(self.back_width / 2,s_DESIGN_HEIGHT /2 + 50)
    background:addChild(boss)
    boss:setAnimation(0,'animation',true)
    self.boss = boss

    self.glView = cc.Director:getInstance():getOpenGLView()
    self.glView:setIMEKeyboardState(true)

    -----------------------------------------------------------------------------------------

    onAndroidKeyPressed(self, function () s_SCENE:removeAllPopups()  end)
end

function K12AccountBindView:init(t, ex)
    self.ex = ex
    
    local eventHandle = function(sender, eventType)

        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            local mv = cc.MoveTo:create(0.3, cc.p(self.back_width / 2, s_DESIGN_HEIGHT / 2 + 50)) 
            self.boss:runAction(mv)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local mv = cc.MoveTo:create(0.3, cc.p(self.back_width / 2, s_DESIGN_HEIGHT / 2 - 450)) 
            self.boss:runAction(mv)
        elseif eventType == ccui.TextFiledEventType.insert_text then

        elseif eventType == ccui.TextFiledEventType.delete_backward then

        end
    end

    local inputnodeType = InputNode.type_username
    local hint = '请输入用户名'
    local offset = 0
    local step_str = "第一步\nWhat's your name?"
    if K12AccountBindView.Type_password == t then 
        inputnodeType = InputNode.type_pwd 
        hint = '请输入密码'
        offset = self.back_width
        step_str = "第二步\n设定你的专属密码！"
    elseif K12AccountBindView.Type_teacher == t then
        hint = '请输入老师姓名'
        offset = 2 * self.back_width
        step_str = "第三步\n输入你的老师姓名"
    end

    local inputnode = InputNode.create(inputnodeType, hint, eventHandle,true)
    inputnode:setPosition(self.back_width / 2 + offset, 770)
    self.bg:addChild(inputnode)
    inputnode:setName('inputNode'..t)

    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            inputnode.textField:addEventListener(function ( )
                -- body
            end)
            local str = inputnode.textField:getString()
            if K12AccountBindView.Type_username == t then 
                self:gotoPwd(str)
            elseif K12AccountBindView.Type_password == t then 
                self:gotoUpdateUsernameAndPassword(str)
            else
                self:gotoAddTeacher(str)
            end
        end
    end

    local step = cc.Label:createWithSystemFont(step_str,'',30)
    step:setColor(cc.c3b(22,84,116))
    step:setPosition(self.back_width/2 + offset, 865)
    step:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.bg:addChild(step)

    local submit = ccui.Button:create("image/signup/button_wancheng_bbchildren.png","image/signup/button_wancheng_bbchildren_pressed.png","")
    submit:setPosition(self.back_width/2 + offset, 660)
    submit:addTouchEventListener(submit_clicked)
    self.bg:addChild(submit)

    local label_name = cc.Label:createWithSystemFont("下一步", "", 34)
    label_name:setColor(cc.c4b(255,255,255,255))
    label_name:ignoreAnchorPointForPosition(false)
    label_name:setAnchorPoint(0.5,0.5)
    label_name:setPosition(submit:getContentSize().width/2, submit:getContentSize().height/2)
    submit:addChild(label_name)

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect) 
            cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
            s_SCENE:removeAllPopups() 
        end
    end
    
    local button_close = ccui.Button:create("image/signup/button_ignore_bbchildren_login.png")
    button_close:setPosition(self.back_width /2 + offset, 550)
    button_close:addTouchEventListener(button_close_clicked)
    self.bg:addChild(button_close)
    if K12AccountBindView.Type_teacher == t then
        label_name:setString('完成注册！')
        button_close:setTitleText('跳过')
    else
        button_close:setTitleText('游客登录')
    end
    button_close:setTitleFontSize(34)
    button_close:setTitleColor(cc.c3b(27,205,246))

    
end

function K12AccountBindView:gotoPwd(username)
    if validateUsername(username) == false then
        s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR))
    else
        showProgressHUD('', true)
        isUsernameExist(username, function (exist, error)
            if error ~= nil then
                s_TIPS_LAYER:showSmallWithOneButton(error.description)
            elseif not exist then
                AnalyticsK12SmallStep(s_K12_inputUserPassWord)
                -- 打点
                self.username = username
                self.bg:runAction(cc.MoveBy:create(0.3, cc.p(-self.back_width, 0)))
                cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)

                self.boss:removeFromParent()
                local boss = sp.SkeletonAnimation:create("res/spine/signup/bbchildren_login_zhangyu2.json", "res/spine/signup/bbchildren_login_zhangyu2.atlas", 1)
                boss:setPosition(self.back_width / 2,s_DESIGN_HEIGHT /2 + 50)
                self.back:addChild(boss)
                boss:setAnimation(0,'animation',true)
                self.boss = boss

                local bubble_old = self:getChildByName('bubble0')
                bubble_old:runAction(cc.Sequence:create(cc.Spawn:create(cc.FadeOut:create(0.5),cc.ScaleTo:create(0.5,0),cc.MoveBy:create(0.5,cc.p(-s_DESIGN_WIDTH*0.5,0))),cc.CallFunc:create(function ( )
                    bubble_old:removeFromParent()
                end,{})))
                local bubble = cc.Sprite:create('image/signup/dauglog_bbchildren_background.png')
                bubble:setAnchorPoint(0,0.15)
                bubble:setPosition(0.5 * s_DESIGN_WIDTH - 49,s_DESIGN_HEIGHT - 10 - 0.85 * bubble:getContentSize().height)
                self:addChild(bubble)

                local welcome = cc.Label:createWithSystemFont('Hi~\n'..username,'',38)
                welcome:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
                welcome:setPosition(bubble:getContentSize().width / 2,bubble:getContentSize().height / 2)
                bubble:addChild(welcome)

                bubble:setScale(0)
                local appear = cc.ScaleTo:create(1.0,1)
                local shake = cc.RepeatForever:create(cc.Sequence:create(cc.RotateBy:create(0.5,3),cc.RotateBy:create(1,-6),cc.RotateBy:create(0.5,3)))
                bubble:runAction(appear)
                bubble:runAction(shake)
                bubble:setName('bubble1')
                print(username, 'K12AccountBindView.create(K12AccountBindView.Type_password)')
            else
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__USERNAME_HAS_ALREADY_BEEN_TAKEN))
            end
            hideProgressHUD(true)
        end)
    end
end

function K12AccountBindView:gotoUpdateUsernameAndPassword(pwd)
    if validatePassword(pwd) == false then
        s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))
    else
        showProgressHUD('', true)
        s_UserBaseServer.updateUsernameAndPassword(self.username, pwd, function(username, password, errordescription, errorcode )  
                -- AnalyticsAccountBind()                      
                if errordescription then                  
                    s_TIPS_LAYER:showSmallWithOneButton(errordescription)
                else     
                    AnalyticsK12SmallStep(s_K12_inputTeacherName)   
                    -- 打点
                    -- s_CURRENT_USER.username = self.ex
                    -- s_CURRENT_USER.password = pwd
                    self.bg:runAction(cc.MoveBy:create(0.3, cc.p(-self.back_width, 0)))
                    cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(true)

                    self.girl:removeFromParent()
                    self.girl = sp.SkeletonAnimation:create("res/spine/signup/children_login_bb_3.json", "res/spine/signup/children_login_bb_3.atlas", 1)
                    self.girl:setAnimation(0,'animation',true)
                    self:addChild(self.girl)
                    self.girl:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)

                    self.boss:removeFromParent()
                    local boss = sp.SkeletonAnimation:create("res/spine/signup/bbchildren_konglong.json", "res/spine/signup/bbchildren_konglong.atlas", 1)
                    boss:setPosition(self.back_width / 2,s_DESIGN_HEIGHT /2 + 50)
                    self.back:addChild(boss)
                    boss:setAnimation(0,'animation',true)
                    self.boss = boss

                    local bubble_old = self:getChildByName('bubble1')
                    bubble_old:runAction(cc.Sequence:create(cc.Spawn:create(cc.FadeOut:create(0.5),cc.ScaleTo:create(0.5,0),cc.MoveBy:create(0.5,cc.p(-s_DESIGN_WIDTH*0.5,0))),cc.CallFunc:create(function ( )
                        bubble_old:removeFromParent()
                    end,{})))
                    local bubble = cc.Sprite:create('image/signup/dauglog2_bbchildren_background.png')
                    bubble:setAnchorPoint(0,0.15)
                    bubble:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT - 10 - 0.85 * bubble:getContentSize().height)
                    self:addChild(bubble)

                    local welcome = cc.Label:createWithSystemFont('哇塞 你是我\n们的新用户！','',38)
                    welcome:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
                    welcome:setPosition(bubble:getContentSize().width / 2,bubble:getContentSize().height / 2)
                    bubble:addChild(welcome)

                    bubble:setScale(0)
                    local appear = cc.ScaleTo:create(1.0,1)
                    local shake = cc.RepeatForever:create(cc.Sequence:create(cc.RotateBy:create(0.5,3),cc.RotateBy:create(1,-6),cc.RotateBy:create(0.5,3)))
                    bubble:runAction(appear)
                    bubble:runAction(shake)
                    -- AnalyticsImproveInfo()
                end     
                hideProgressHUD(true)
        end)
        
    end
end

function K12AccountBindView:gotoAddTeacher(teacherName)
    showProgressHUD('', true)

    local request = cx.CXAVCloud:create()
    -- request:searchUser(username, nickName, callback)
    request:searchUser(teacherName, teacherName, function (results, err)

        local f_user = {}
        print('gotoAddTeacher searchUser:', tostring(results), tostring(err))
        if err == nil and results ~= nil and type(results) == 'string' and string.len(results) > 0 then
            local data = s_JSON.decode(results)
            for i, user in ipairs(data.results) do
                f_user[#f_user + 1] = user
            end
        end

        if #f_user > 0 then
            local user = DataUser.create()
            parseServerDataToClientData(f_user[1], user)

            s_UserBaseServer.follow(user, function (api, result, err)
                if err == nil then
                    s_CURRENT_USER:parseServerFollowData(user)
                    s_SCENE:removeAllPopups() 
                elseif self.username == teacherName then
                    s_TIPS_LAYER:showSmallWithOneButton("请不要搜自己的名字")
                else
                    s_TIPS_LAYER:showSmallWithOneButton(err.description)
                end
                hideProgressHUD(true)
            end)
        else
            s_TIPS_LAYER:showSmallWithOneButton('找不到' .. teacherName .. '老师')
            hideProgressHUD(true)
        end

    end)
end

return K12AccountBindView
