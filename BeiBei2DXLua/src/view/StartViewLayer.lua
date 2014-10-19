
ccbStartViewLayer = ccbStartViewLayer or {}
ccb['start_view'] = ccbStartViewLayer

local StartViewLayer = class("StartViewLayer", function ()
    return cc.Layer:create()
end)

function StartViewLayer.create()
    local layer = StartViewLayer.new()
    return layer
end

function StartViewLayer:ctor()
    ccbStartViewLayer['onPlay'] = self.onPlay
    ccbStartViewLayer['onSignUp'] = self.onSignUp
    ccbStartViewLayer['onLogIn'] = self.onLogIn

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/start_view.ccbi", proxy, ccbStartViewLayer)
    self:addChild(node)
end

function StartViewLayer:onPlay()
    local function onSucceed(api, result)
        s_logd('onSucceed:' .. api .. ', ' .. s_JSON.encode(result))
    end 
    local function onFailed(api, code, message)
        s_logd('onFailed:' ..  api .. ', ' .. code .. ', ' .. message)
    end
    s_funcLogin('yehanjie1', '111111', onSuccexed, onFailed)
    -- s_funcSignin('_test000', '111111', onSucceed, onFailed)
end

function StartViewLayer:onSignUp()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
end

function StartViewLayer:onLogIn()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
end

return StartViewLayer
