require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)


function HomeLayer.create()
    local layer = HomeLayer.new()
    
    local offset = 500
    local viewIndex = 1

    local backImage = cc.Sprite:create("image/homescene/main_backGround.png")
    backImage:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backImage)
    
    local setting_back
    
    local bigWidth = backImage:getContentSize().width
    
    local name = cc.Label:createWithSystemFont("贝贝单词","",40)
    name:setColor(cc.c4b(255,255,255,255))
    name:setPosition(bigWidth/2, s_DESIGN_HEIGHT-75)
    backImage:addChild(name)
   
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            
                viewIndex = 2
            
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backImage:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                
                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backImage:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end
    end

    local button_left = ccui.Button:create("image/homescene/main_set.png","image/homescene/main_set.png","")
    button_left:setPosition((bigWidth-s_DESIGN_WIDTH)/2+50, s_DESIGN_HEIGHT-75)
    button_left:addTouchEventListener(button_left_clicked)
    backImage:addChild(button_left)
    
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_right = ccui.Button:create("image/homescene/main_friends.png","image/homescene/main_friends.png","")
    button_right:setPosition((bigWidth-s_DESIGN_WIDTH)/2+s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT-75)
    button_right:addTouchEventListener(button_right_clicked)
    backImage:addChild(button_right)   
    
    local heart_back = cc.Sprite:create("image/homescene/main_physicalbar.png")
    heart_back:setPosition(s_DESIGN_WIDTH, s_DESIGN_HEIGHT-200)
    backImage:addChild(heart_back)
    
    local heart = cc.Sprite:create("image/homescene/main_heart.png")
    heart:setPosition(10, heart_back:getContentSize().height/2)
    heart_back:addChild(heart)
    
    local heart_num = cc.Label:createWithSystemFont("4","",28)
    heart_num:setColor(cc.c4b(255,255,255,255))
    heart_num:setPosition(heart:getContentSize().width/2, heart:getContentSize().height/2)
    heart:addChild(heart_num)
    
    local heart_time = cc.Label:createWithSystemFont("full","",28)
    heart_time:setColor(cc.c4b(255,255,255,255))
    heart_time:setPosition(heart_back:getContentSize().width/2+10, heart_back:getContentSize().height/2)
    heart_back:addChild(heart_time)

    local container = cc.Sprite:create("image/homescene/main_wordstore.png")
    container:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
    backImage:addChild(container)
    
    local has_study = cc.ProgressTimer:create(cc.Sprite:create("image/homescene/main_learned.png"))
    has_study:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    has_study:setMidpoint(cc.p(1, 0))
    has_study:setBarChangeRate(cc.p(0, 1))
    has_study:setPosition(192, 205)
    has_study:setPercentage(50)
    container:addChild(has_study)
    
    local has_grasp = cc.ProgressTimer:create(cc.Sprite:create("image/homescene/main_mastery.png"))
    has_grasp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    has_grasp:setMidpoint(cc.p(1, 0))
    has_grasp:setBarChangeRate(cc.p(0, 1))
    has_grasp:setPosition(192, 205)
    has_grasp:setPercentage(30)
    container:addChild(has_grasp)
    
    local magnifier = cc.Sprite:create("image/homescene/main_magnifier.png")
    magnifier:setPosition(container:getContentSize().width-70, 70)
    container:addChild(magnifier)
    
    local label1 = cc.Label:createWithSystemFont("四级词汇","",28)
    label1:setColor(cc.c4b(255,255,255,255))
    label1:setPosition(container:getContentSize().width/2, 350)
    container:addChild(label1)
    
    local label2 = cc.Label:createWithSystemFont("4000词","",20)
    label2:setColor(cc.c4b(255,255,255,255))
    label2:setPosition(container:getContentSize().width/2, 320)
    container:addChild(label2)
    
    local label3 = cc.Label:createWithSystemFont("今日学习3词","",34)
    label3:setColor(cc.c4b(255,255,255,255))
    label3:setPosition(container:getContentSize().width/2, 210)
    container:addChild(label3)
    
    local label4 = cc.Label:createWithSystemFont("今日掌握1词","",34)
    label4:setColor(cc.c4b(255,255,255,255))
    label4:setPosition(container:getContentSize().width/2, 150)
    container:addChild(label4)
    
    local button_change_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_change = ccui.Button:create("image/homescene/main_switchbutton.png","image/homescene/main_switchbutton.png","")
    button_change:setPosition(10, container:getContentSize().height/2)
    button_change:addTouchEventListener(button_change_clicked)
    container:addChild(button_change)
    
    local label = cc.Label:createWithSystemFont("第一章 拉斯维加斯 第5关","",28)
    label:setColor(cc.c4b(0,0,0,255))
    label:setPosition(bigWidth/2, 300)
    backImage:addChild(label)
    
    local button_play_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button_play = ccui.Button:create("image/homescene/main_play.png","image/homescene/main_play.png","")
    button_play:setTitleText("继续闯关   》")
    button_play:setTitleFontSize(30)
    button_play:setPosition(bigWidth/2, 200)
    button_play:addTouchEventListener(button_play_clicked)
    backImage:addChild(button_play)


    local data = cc.Sprite:create("image/homescene/main_bottom.png")
    data:setAnchorPoint(0.5,0)
    data:setPosition(bigWidth/2, 0)
    backImage:addChild(data)
    
    local data_name = cc.Label:createWithSystemFont("数据","",28)
    data_name:setColor(cc.c4b(0,0,0,255))
    data_name:setPosition(data:getContentSize().width/2+30, data:getContentSize().height/2-5)
    data:addChild(data_name)
    
    
    -- setting ui
    setting_back = cc.Sprite:create("image/homescene/setup_background.png")
    setting_back:setAnchorPoint(1,0.5)
    setting_back:setPosition(s_LEFT_X, s_DESIGN_HEIGHT/2)
    layer:addChild(setting_back)
    
    
    local logo_name = {"head","book","photo","feedback","information","logout"}
    local label_name = {"游客1234","选择书籍", "拍摄头像", "用户反馈", "完善个人信息", "登出游戏"}
    for i = 1, 6 do
        local button_back_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                print(label_name[i])
            end
        end

        local button_back = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
        button_back:setAnchorPoint(0, 1)
        button_back:setPosition(0, s_DESIGN_HEIGHT-button_back:getContentSize().height * (i - 1) - 20)
        button_back:addTouchEventListener(button_back_clicked)
        setting_back:addChild(button_back)
        
        local logo = cc.Sprite:create("image/homescene/setup_"..logo_name[i]..".png")
        logo:setPosition(button_back:getContentSize().width-offset+50, button_back:getContentSize().height/2)
        button_back:addChild(logo)
        
        local label = cc.Label:createWithSystemFont(label_name[i],"",28)
        label:setColor(cc.c4b(0,0,0,255))
        label:setAnchorPoint(0, 0.5)
        label:setPosition(button_back:getContentSize().width-offset+100, button_back:getContentSize().height/2)
        button_back:addChild(label)
        
        local split = cc.Sprite:create("image/homescene/setup_line.png")
        split:setAnchorPoint(0.5,0)
        split:setPosition(button_back:getContentSize().width/2, 0)
        button_back:addChild(split)
    end
    
    local setting_shadow = cc.Sprite:create("image/homescene/setup_shadow.png")
    setting_shadow:setAnchorPoint(1,0.5)
    setting_shadow:setPosition(setting_back:getContentSize().width, setting_back:getContentSize().height/2)
    setting_back:addChild(setting_shadow)
    
   
    local moveLength = 100
    local moved = false
    local start_x = nil
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        start_x = location.x
        moved = false
        return true
    end
    
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
    
        local location = layer:convertToNodeSpace(touch:getLocation())
        local now_x = location.x
        if now_x - moveLength > start_x then
            print("right")
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                viewIndex = 2

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backImage:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        elseif now_x + moveLength < start_x then
            print("left")
            if viewIndex == 2 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backImage:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return HomeLayer
