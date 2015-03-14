local PopupModel = class ("PopupModel",function ()
    return cc.Layer:create()
end)

local ImproveInfo = require("view.home.ImproveInfo")
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

Site_From_Information = "Site_From_Information"
Site_From_Book = "Site_From_Book"
Site_From_Friend_Guest = "Site_From_Friend_Guest"
Site_From_Friend_Not_Enough_Level = "Site_From_Friend_Not_Enough_Level"


function PopupModel.create(site)
    local layer = PopupModel.new()
    
    layer.update = function()
    end

    local title = ''
    local reason = ''
    local solution = ''
    local picture_site = ''
    
    title = "好友功能已锁定"
    reason = "你至少得在任意一本书内玩到\n10关才能解锁此功能"
    solution = "继续闯关"
    picture_site = "image/homescene/setup_information.png"
    
    if site == Site_From_Book then
        title = "书库功能已锁定"
        reason = "你至少得在任意一本书内玩到\n4关才能解锁此功能"
        solution = "继续闯关"
        picture_site = "image/popupwindow/book.png"
    elseif site == Site_From_Information then
        title = "信息功能已锁定"
        reason = "你至少得在任意一本书内玩到\n7关才能解锁此功能"
        solution = "继续闯关"
        picture_site = "image/popupwindow/yuan.png"
    elseif site == Site_From_Friend_Not_Enough_Level then
        title = "好友功能已锁定"
        reason = "你至少得在任意一本书内玩到\n10关才能解锁此功能"
        solution = "继续闯关"
        picture_site = "image/homescene/setup_information.png"
    elseif site == Site_From_Friend_Guest then
        title = "好友功能已锁定"
        reason = "游客身份无法使用好友系统\n请完善您的账号信息"
        solution = "完善个人信息"
        picture_site = "image/homescene/setup_information.png"
    end

    local popup_window = cc.Sprite:create("image/friend/broad.png")
    popup_window:setAnchorPoint(0.5,0.5)
    popup_window:ignoreAnchorPointForPosition(false)
    popup_window:setPosition(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2 * 3)
    layer:addChild(popup_window)

    local action1 = cc.MoveTo:create(0.3, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2))
    local action2 = cc.EaseBackOut:create(action1)
    popup_window:runAction(action2)

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then 
            local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            popup_window:runAction(action2)

            local action3 = cc.DelayTime:create(0.5)
            local action4 = cc.CallFunc:create(function()s_SCENE:removeAllPopups()end)
            popup_window:runAction(cc.Sequence:create(action3,action4))
        end
    end

    local button_close = ccui.Button:create("image/friend/close.png")
    button_close:setPosition(popup_window:getContentSize().width - 20 , popup_window:getContentSize().height - 20 )
    button_close:addTouchEventListener(button_close_clicked)
    popup_window:addChild(button_close)

    local label_title = cc.Label:createWithSystemFont(title,"",40)
    label_title:setColor(cc.c4b(0,0,0,255))
    label_title:setPosition(popup_window:getContentSize().width / 2 ,680)
    popup_window:addChild(label_title)

    local picture = cc.Sprite:create(picture_site)
    picture:setPosition(popup_window:getContentSize().width / 2 ,500)
    popup_window:addChild(picture)

    local label_reason = cc.Label:createWithSystemFont(reason,"",28)
    label_reason:setColor(cc.c4b(0,0,0,255))
    label_reason:setPosition(popup_window:getContentSize().width / 2 ,380)
    popup_window:addChild(label_reason)

    local button_solution_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then

            if site == Site_From_Friend_Guest then
            
                local action1 = cc.MoveTo:create(0.3, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2 * 3))
                local action2 = cc.EaseBackIn:create(action1)
                popup_window:runAction(action2)
                
                s_SCENE:callFuncWithDelay(0.3,function()
                    local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_FRIEND_LAYER)
                    improveInfo:setTag(1)
                    improveInfo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)

                    layer:addChild(improveInfo)   
                    improveInfo.close = function()
                        layer:removeChildByTag(1)  
                        layer.update()  
                        s_SCENE:removeAllPopups()
                    end  
                end)
                
            else

                local action1 = cc.MoveTo:create(0.3, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2 * 3))
                local action2 = cc.EaseBackIn:create(action1)
                popup_window:runAction(action2)

                showProgressHUD()
                -- button sound
                playSound(s_sound_buttonEffect) 

                s_SCENE:callFuncWithDelay(0.3,function() 
                    s_CorePlayManager.enterLevelLayer()  
                    hideProgressHUD()   
                    s_SCENE:removeAllPopups()          
                end)
            end

        end
    end

    local button_solution = ccui.Button:create("image/friend/longbutton.png")
    button_solution:setPosition(popup_window:getContentSize().width / 2  , 280 )
    button_solution:addTouchEventListener(button_solution_clicked)
    popup_window:addChild(button_solution)

    local label_button = cc.Label:createWithSystemFont(solution,"",28)
    label_button:setColor(cc.c4b(255,255,255,255))
    label_button:setPosition(button_solution:getContentSize().width / 2 ,button_solution:getContentSize().height / 2)
    button_solution:addChild(label_button)

    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(popup_window:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                s_SCENE:removeAllPopups()
            end)
            popup_window:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer
end



return PopupModel