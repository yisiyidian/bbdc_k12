local FriendPopup = class ("FriendPopup",function ()
	return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

function FriendPopup.create()

    local reason = ''
    local solution = ''
    
    reason = "游客身份无法使用好友系统\n请完善您的账号信息"
    reason = "你至少得在任意一本书内玩到\n20关才能解锁此功能"
    
    solution = "完善个人信息"
    solution = "继续闯关"

    local backColor = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    
    local popup_friend = cc.Sprite:create("image/friend/broad.png")
    popup_friend:setAnchorPoint(0.5,0.5)
    popup_friend:ignoreAnchorPointForPosition(false)
    popup_friend:setPosition(s_LEFT_X + bigWidth , s_DESIGN_HEIGHT)
    backColor:addChild(popup_friend)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            s_SCENE:removeAllPopups()
        end
    end
    
    local button_close = ccui.Button:create("image/friend/close.png")
    button_close:setPosition(popup_friend:getContentSize().width - 20 , popup_friend:getContentSize().height - 20 )
    button_close:addTouchEventListener(button_close_clicked)
    popup_friend:addChild(button_close)
    
    local label_friend_forbidden = cc.Label:createWithSystemFont("好友系统已被锁定","",40)
    label_friend_forbidden:setColor(cc.c4b(0,0,0,255))
    label_friend_forbidden:setPosition(popup_friend:getContentSize().width / 2 ,680)
    popup_friend:addChild(label_friend_forbidden)
    
    local picture_friend = cc.Sprite:create("image/homescene/setup_information.png")
    picture_friend:setPosition(popup_friend:getContentSize().width / 2 ,500)
    popup_friend:addChild(picture_friend)
    
    local label_friend_reason = cc.Label:createWithSystemFont(reason,"",28)
    label_friend_reason:setColor(cc.c4b(0,0,0,255))
    label_friend_reason:setPosition(popup_friend:getContentSize().width / 2 ,380)
    popup_friend:addChild(label_friend_reason)
    
    local button_solution_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            s_SCENE:removeAllPopups()
        end
    end
    
    local button_solution = ccui.Button:create("image/friend/longbutton.png")
    button_solution:setPosition(popup_friend:getContentSize().width / 2  , 280 )
    button_solution:addTouchEventListener(button_solution_clicked)
    popup_friend:addChild(button_solution)
    
    local label_button = cc.Label:createWithSystemFont(solution,"",28)
    label_button:setColor(cc.c4b(255,255,255,255))
    label_button:setPosition(button_solution:getContentSize().width / 2 ,button_solution:getContentSize().height / 2)
    button_solution:addChild(label_button)
    
    return backColor
end



return FriendPopup