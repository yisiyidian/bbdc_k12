require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)


function HomeLayer.create()
    local layer = HomeLayer.new()

    local backImage = cc.Sprite:create("image/homescene/main_backGround.png")
    backImage:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backImage)
    
    local name = cc.Label:createWithSystemFont("贝贝单词","",40)
    name:setColor(cc.c4b(255,255,255,255))
    name:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT-75)
    layer:addChild(name)
   
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            
        end
    end

    local button_left = ccui.Button:create("image/homescene/main_set.png","image/homescene/main_set.png","")
    button_left:setPosition(50, s_DESIGN_HEIGHT-75)
    button_left:addTouchEventListener(button_left_clicked)
    layer:addChild(button_left)
    
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end
    
    local button_right = ccui.Button:create("image/homescene/main_friends.png","image/homescene/main_friends.png","")
    button_right:setPosition(s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT-75)
    button_right:addTouchEventListener(button_right_clicked)
    layer:addChild(button_right)   
    
    local heart_back = cc.Sprite:create("image/homescene/main_physicalbar.png")
    heart_back:setPosition(s_DESIGN_WIDTH-100, s_DESIGN_HEIGHT-200)
    layer:addChild(heart_back)
    
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
    container:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(container)
    
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
    
    local label = cc.Label:createWithSystemFont("第三章 拉斯维加斯 第5关","",28)
    label:setColor(cc.c4b(0,0,0,255))
    label:setPosition(s_DESIGN_WIDTH/2, 300)
    layer:addChild(label)
    
    local button_play_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

        end
    end

    local button_play = ccui.Button:create("image/homescene/main_play.png","image/homescene/main_play.png","")
    button_play:setTitleText("继续闯关   》")
    button_play:setTitleFontSize(30)
    button_play:setPosition(s_DESIGN_WIDTH/2, 200)
    button_play:addTouchEventListener(button_play_clicked)
    layer:addChild(button_play)


    local data = cc.Sprite:create("image/homescene/main_bottom.png")
    data:setAnchorPoint(0.5,0)
    data:setPosition(s_DESIGN_WIDTH/2, 0)
    layer:addChild(data)
    
    local data_name = cc.Label:createWithSystemFont("数据","",28)
    data_name:setColor(cc.c4b(0,0,0,255))
    data_name:setPosition(data:getContentSize().width/2+30, data:getContentSize().height/2-5)
    data:addChild(data_name)
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        
        return true
    end
    
    local onTouchMoved = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return HomeLayer
