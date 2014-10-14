require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")

ccbLogInSignUpLayer = ccbLogInSignUpLayer or {}
ccb['signup_login'] = ccbLogInSignUpLayer

local LogInSignUpLayer = class("LogInSignUpLayer", function ()
    return cc.Layer:create()
end)

function LogInSignUpLayer.create()
    local layer = LogInSignUpLayer.new()
    return layer
end

function LogInSignUpLayer:ctor()
    ccbLogInSignUpLayer['onPlay'] = self.onPlay
    ccbLogInSignUpLayer['onSignUp'] = self.onSignUp
    ccbLogInSignUpLayer['onLogIn'] = self.onLogIn

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/signup_login.ccbi", proxy, ccbLogInSignUpLayer)
    self:addChild(node)
end

function LogInSignUpLayer:onPlay()
    s_logd('LogInSignUpLayer:onPlay')
end

function LogInSignUpLayer:onSignUp()
    s_logd('LogInSignUpLayer:onSignUp')
end

function LogInSignUpLayer:onLogIn()
    s_logd('LogInSignUpLayer:onLogIn')
end

return LogInSignUpLayer
