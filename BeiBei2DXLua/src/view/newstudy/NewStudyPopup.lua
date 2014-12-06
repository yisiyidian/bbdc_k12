
local NewStudyPopup = class ("NewStudyPopup",function ()
    return cc.Layer:create()
end)

function NewStudyPopup.create()
    local layer = NewStudyPopup.new()
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH


    local popup_window = cc.Sprite:create("image/newstudy/popup_white.png")
    popup_window:setPosition(s_LEFT_X + bigWidth / 2 ,s_DESIGN_HEIGHT / 2 * 3)
    popup_window:ignoreAnchorPointForPosition(false)
    popup_window:setAnchorPoint(0.5,0.5)
    layer:addChild(popup_window)
    
    local action1 = cc.MoveTo:create(0.3, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2))
    local action2 = cc.EaseBackOut:create(action1)
    popup_window:runAction(action2)
    
    s_SCENE:callFuncWithDelay(2.5,function()
        local action1 = cc.MoveTo:create(0.3, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2 * 3))
        local action2 = cc.EaseBackOut:create(action1)
        popup_window:runAction(action2)
        
        s_SCENE:callFuncWithDelay(0.5,function()
            s_SCENE:removeAllPopups()
        end)
    end)
    
    local popup_text = cc.Label:createWithSystemFont("哦也，已经成功收集到"..maxWrongWordCount.."个生词了！","",30)
    popup_text:setPosition(popup_window:getContentSize().width / 2,popup_window:getContentSize().height / 2)
    popup_text:setColor(cc.c4b(0,0,0,255))
    popup_text:ignoreAnchorPointForPosition(false)
    popup_text:setAnchorPoint(0.5,0.5)
    popup_window:addChild(popup_text)

    return layer
end

return NewStudyPopup