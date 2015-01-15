local OfflineTipForHome = class("OfflineTipForHome", function()
    return cc.Layer:create()
end)

OfflineTipForHome_Feedback           = 1
OfflineTipForHome_ImproveInformation = 2
OfflineTipForHome_Logout             = 3

function OfflineTipForHome.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = OfflineTipForHome.new()
    
    local backColor  

    backColor = cc.Sprite:create("image/offline/back.png")
    backColor:setPosition(s_LEFT_X, 415)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setAnchorPoint(0,0.5)
    backColor:setVisible(false)
    layer:addChild(backColor)
    
    local tip = cc.Label:createWithSystemFont("","",24)
    tip:setPosition(backColor:getContentSize().width / 2,backColor:getContentSize().height / 2)
    tip:setColor(cc.c4b(247,247,234,255))
    backColor:addChild(tip)
    
    layer.setTrue = function (key)
        backColor:setVisible(true)
        local action1 = cc.FadeIn:create(1)
        local action2 = cc.FadeOut:create(10)
        backColor:runAction(cc.Sequence:create(action1,action2))
        local action3 = cc.FadeIn:create(1)
        local action4 = cc.FadeOut:create(10)
        tip:runAction(cc.Sequence:create(action3,action4))
        
        if s_SERVER.isNetworkConnnectedNow() and not s_SERVER.hasSessionToken() then
            if key == OfflineTipForHome_Feedback then
               tip:setString("贝贝听不到未登录用户的声音。")
            elseif key == OfflineTipForHome_ImproveInformation then
               tip:setString("未登录用户无法完善个人信息。")
            elseif key == OfflineTipForHome_Logout then
               tip:setString("离线模式下不能登出游戏。")
            end
        else
            if key == OfflineTipForHome_Feedback then
               tip:setString("贝贝听不到离线用户的声音。")
            elseif key == OfflineTipForHome_ImproveInformation then
               tip:setString("离线用户无法完善个人信息。")
            elseif key == OfflineTipForHome_Logout then
               tip:setString("离线模式下不能登出游戏。")
            end
        end
    end
    
    layer.setFalse = function ()
        backColor:setVisible(false)
    end


    return layer
end

return OfflineTipForHome
