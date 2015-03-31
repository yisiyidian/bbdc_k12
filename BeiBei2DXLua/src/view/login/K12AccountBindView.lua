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

local InputNode = require("view.login.InputNode")

local K12AccountBindView = class("K12AccountBindView", function() return cc.Layer:create() end)

K12AccountBindView.Type_username = 0
K12AccountBindView.Type_password = 1
K12AccountBindView.Type_teacher = 2

function K12AccountBindView.create(viewtype, ex)
    
    local view = K12AccountBindView.new()
    view:init(viewtype, ex)
    s_SCENE:popup(view)
    view:setVisible(false)
    view:setPosition(0, s_DESIGN_HEIGHT * 1.5) 

    local action2 = cc.CallFunc:create(function() view:setVisible(true) end)
    local action3 = cc.MoveTo:create(0.4, cc.p(0, 0)) 
    local action4 = cc.Sequence:create(action2, action3)
    view:runAction(action4)

    return view
end

function K12AccountBindView:closeAnimation(cb)
    cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
    
    local action1 = cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2 * 3))
    local action2 = cc.EaseBackIn:create(action1)
    local action3 = cc.CallFunc:create(function() 
        if cb ~= nil then 
            s_SCENE.popupLayer:removeChild(self)
            cb()
        else
            s_SCENE:removeAllPopups() 
        end
    end)
    self.bg:runAction(cc.Sequence:create(action2, action3))
end

function K12AccountBindView:ctor()
    self.bg = cc.Sprite:create("image/login/background_white_login.png")
    self.bg:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    self.bg:ignoreAnchorPointForPosition(false)
    self.bg:setAnchorPoint(0.5, 0.5)
    self:setContentSize(self.bg:getContentSize().width, s_DESIGN_HEIGHT)
    self:addChild(self.bg)

    self.back_width = self.bg:getContentSize().width
    self.back_height = self.bg:getContentSize().height

    local girl_hello = sp.SkeletonAnimation:create('spine/bb_hello_public.json', 'spine/bb_hello_public.atlas', 1)
    girl_hello:setPosition(self.back_width * 0.5, self.back_height * 0.4)
    girl_hello:addAnimation(0, 'animation', true)
    self.bg:addChild(girl_hello, 5)

    ------------------------------------------------------------------------------------------

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect) 
            self:closeAnimation()
        end
    end
    
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(self.back_width - 30, self.back_height - 10)
    button_close:addTouchEventListener(button_close_clicked)
    self.bg:addChild(button_close)

    -- local onTouchBegan = function(touch, event) return true end
    -- local onTouchEnded = function(touch, event)
    --     local location = self:convertToNodeSpace(touch:getLocation())
    --     if not cc.rectContainsPoint(self.bg:getBoundingBox(), location) then
    --        self:closeAnimation()
    --     end
    -- end
    -- local listener = cc.EventListenerTouchOneByOne:create()
    -- listener:setSwallowTouches(true)
    -- listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED )
    -- local eventDispatcher = self:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    onAndroidKeyPressed(self, function () self:closeAnimation() end)
end

function K12AccountBindView:init(t, ex)
    self.ex = ex
    
    local eventHandle = function(sender, eventType)

        if eventType == ccui.TextFiledEventType.attach_with_ime then   
            local mv = cc.MoveTo:create(0.3, cc.p(0, s_DESIGN_HEIGHT * 0.5)) 
            self:runAction(mv)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local mv = cc.MoveTo:create(0.3, cc.p(0, 0)) 
            self:runAction(mv)
        elseif eventType == ccui.TextFiledEventType.insert_text then

        elseif eventType == ccui.TextFiledEventType.delete_backward then

        end
    end

    local inputnodeType = InputNode.type_username
    local hint = '请输入用户名'
    if K12AccountBindView.Type_password == t then 
        inputnodeType = InputNode.type_pwd 
        hint = '请输入密码'
    elseif K12AccountBindView.Type_teacher == t then
        hint = '请输入老师姓名'
    end

    self.inputnode = InputNode.create(inputnodeType, hint, eventHandle)
    self.inputnode:setPosition(self.back_width / 2, 200)
    self.bg:addChild(self.inputnode)

    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local str = self.inputnode.textField:getString()
            if K12AccountBindView.Type_username == t then 
                self:gotoPwd(str)
            elseif K12AccountBindView.Type_password == t then 
                self:gotoUpdateUsernameAndPassword(str)
            else
                self:gotoAddTeacher(str)
            end
        end
    end

    local submit = ccui.Button:create("image/login/sl_button_confirm.png", "image/login/sl_button_confirm.png", "")
    submit:setPosition(self.back_width / 2, 100)
    submit:addTouchEventListener(submit_clicked)
    self.bg:addChild(submit)

    local label_name = cc.Label:createWithSystemFont("下一步", "", 34)
    label_name:setColor(cc.c4b(255, 255, 255, 255))
    label_name:ignoreAnchorPointForPosition(false)
    label_name:setAnchorPoint(0, 0.5)
    label_name:setPosition(30, submit:getContentSize().height / 2)
    submit:addChild(label_name)
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
                self:closeAnimation(function () K12AccountBindView.create(K12AccountBindView.Type_password, username) end)
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
        s_UserBaseServer.updateUsernameAndPassword(self.ex, pwd, function(username, password, errordescription, errorcode )  
                -- AnalyticsAccountBind()                      
                if errordescription then                  
                    s_TIPS_LAYER:showSmallWithOneButton(errordescription)
                else        
                    -- s_CURRENT_USER.username = self.ex
                    -- s_CURRENT_USER.password = pwd
                    self:closeAnimation(function () K12AccountBindView.create(K12AccountBindView.Type_teacher) end)
                    -- AnalyticsImproveInfo()
                end     
                hideProgressHUD(true)
        end)
        
    end
end

function K12AccountBindView:gotoAddTeacher(teacherName)
    showProgressHUD('', true)

    local request = cx.CXAVCloud:new()
    -- request:searchUser(username, nickName, callback)
    request:searchUser(teacherName, teacherName, function (results, err)

        local f_user = {}
        print('gotoAddTeacher searchUser:', results, err, type(results), string.len(results) > 0)
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
                    self:closeAnimation()
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
