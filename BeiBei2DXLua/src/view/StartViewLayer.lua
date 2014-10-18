
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
    s_logd('StartViewLayer:onPlay')
end

function StartViewLayer:onSignUp()
    s_logd('StartViewLayer:onSignUp')
end

function StartViewLayer:onLogIn()
    s_logd('StartViewLayer:onLogIn')
end

return StartViewLayer
