
local SplashView = class("SplashView", function()
    return cc.Layer:create()
end)

function SplashView.create()
    local layer = SplashView.new()
    local s = cc.Sprite:create('image/splash.png')
    s:setAnchorPoint(0.5, 0.5)
    s:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    layer:addChild(s) 
    return layer
end

function SplashView:setOnFinished(func)
    local fadeOut = cc.FadeOut:create(0.2)
    local callback = cc.CallFunc:create(func)
    local seq = cc.Sequence:create(fadeOut, callback)
    self:runAction(seq)
end

return SplashView
