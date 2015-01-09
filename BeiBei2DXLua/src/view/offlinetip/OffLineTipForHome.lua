local OffLineTipForHome = class("OffLineTipForHome", function()
    return cc.Layer:create()
end)

OffLineTipForHome_Feedback           = 1
OffLineTipForHome_ImproveInformation = 2
OffLineTipForHome_Logout             = 3
OffLineTipForHome_Friend             = 4

function OffLineTipForHome.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = OffLineTipForHome.new()

    local backColor = cc.LayerColor:create(cc.c4b(250,251,247,255),bigWidth,50)
    backColor:setPosition(s_LEFT_X, 415)
    backColor:setVisible(false)
    layer:addChild(backColor)
    
    local tip = cc.Label:createWithSystemFont("","",24)
    tip:setPosition(backColor:getContentSize().width / 2,backColor:getContentSize().height / 2)
    tip:setColor(cc.c4b(109,125,128,255))
    backColor:addChild(tip)
    
    layer.setTrue = function (key)
        backColor:setVisible(true)
        local action1 = cc.FadeIn:create(1)
        local action2 = cc.FadeOut:create(10)
        backColor:runAction(cc.Sequence:create(action1,action2))
        local action3 = cc.FadeIn:create(1)
        local action4 = cc.FadeOut:create(10)
        tip:runAction(cc.Sequence:create(action3,action4))
        
        if key == OffLineTipForHome_Feedback then
           tip:setString("贝贝听不到离线用户的声音，感到很沮丧。")
        elseif key == OffLineTipForHome_ImproveInformation then
           tip:setString("很抱歉，离线用户无法完善个人信息。贝贝很想和你做朋友。")
        elseif key == OffLineTipForHome_Logout then
           tip:setString("离线模式下不能登出游戏。")
        elseif key == OffLineTipForHome_Friend then
            tip:setString("贝贝做不到离线社交，哭一个。")
        end
    end


    return layer
end

return OffLineTipForHome