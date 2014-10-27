
local PopupLoginSignup = class("PopupLoginSignup", function ()
    return cc.Layer:create()
end)

function PopupLoginSignup.create()
    local layer = PopupLoginSignup.new()
    return layer
end

function PopupLoginSignup:ctor()
    self.ccbPopupLoginSignup = {}
    self.ccbPopupLoginSignup['onConfirm'] = self.onConfirm

    self.ccb = {}
    self.ccb['signup_login'] = self.ccbPopupLoginSignup

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/signup_login.ccbi", proxy, self.ccbPopupLoginSignup, self.ccb)
    self:addChild(node)
end

function PopupLoginSignup:onConfirm()
    s_SCENE:removeAllPopups()
end

return PopupLoginSignup
