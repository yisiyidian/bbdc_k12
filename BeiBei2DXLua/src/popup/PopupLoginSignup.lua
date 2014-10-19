
ccbPopupLoginSignup = ccbPopupLoginSignup or {}
ccb['signup_login'] = ccbPopupLoginSignup

local PopupLoginSignup = class("PopupLoginSignup", function ()
    return cc.Layer:create()
end)

function PopupLoginSignup.create()
    local layer = PopupLoginSignup.new()
    return layer
end

function PopupLoginSignup:ctor()
    ccbPopupLoginSignup['onConfirm'] = self.onConfirm

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/signup_login.ccbi", proxy, ccbPopupLoginSignup)
    self:addChild(node)
end

function PopupLoginSignup:onConfirm()
    s_SCENE:removeAllPopups()
end

return PopupLoginSignup
