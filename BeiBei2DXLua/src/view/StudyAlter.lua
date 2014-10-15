require("common.global")

local StudyAlter = class("StudyAlter", function()
    return cc.Layer:create()
end)

function StudyAlter.create()
    -- system variate

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local back = cc.Sprite:create("image/alter/studyscene_summary_back.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    
    for i = 1, 7 do
        for j = 1, 2 do
            local index = 2*i + j - 2
            if index <= #s_CorePlayManager.wordList then
                local label_word = cc.Label:createWithSystemFont(s_CorePlayManager.wordList[index],"",35)
                label_word:setColor(cc.c4b(0,0,0,255))
                label_word:setPosition(back:getContentSize().width*(0.5*j-0.25), back:getContentSize().height*(0.775-0.083*(i-1)))
                back:addChild(label_word)
            end
        end
    end
    
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        
        end
    end
    
    local button_left = ccui.Button:create("image/button/studyscene_blue_button.png","","")
    button_left:setPosition(140,150)
    button_left:setTitleText("重学")
    button_left:setTitleFontSize(30)
    button_left:addTouchEventListener(button_left_clicked)
    back:addChild(button_left)
    
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_CorePlayManager.currentWordIndex = 1
            s_CorePlayManager.enterTestLayer()
        end
    end
    
    local button_right = ccui.Button:create("image/button/studyscene_blue_button.png","","")
    button_right:setPosition(400,150)
    button_right:setTitleText("考试")
    button_right:setTitleFontSize(30)
    button_right:addTouchEventListener(button_right_clicked)
    back:addChild(button_right)

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main    
end


return StudyAlter







