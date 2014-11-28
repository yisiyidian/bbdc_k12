
local SplashView = class("SplashView", function()
    return cc.Layer:create()
end)

function SplashView.create()
    local layer = SplashView.new()
    local s = cc.Sprite:create('image/splash.png')
    
    local size = s:getContentSize()
    local scaleX = (s_RIGHT_X - s_LEFT_X) / size.width
    local scaleY = s_DESIGN_HEIGHT / size.height
    if scaleX > 1 and scaleX >= scaleY then
        s:setScale(scaleX)
    elseif scaleY > 1 and scaleY > scaleX then
        s:setScale(scaleY)
    end

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
