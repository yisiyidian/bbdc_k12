require("common.global")

local ReviewBossAlter = class("ReviewBossAlter", function()
    return cc.Layer:create()
end)

function ReviewBossAlter.create()

    cc.SimpleAudioEngine:getInstance():pauseMusic()
    
    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(false)
        s_SCENE.popupLayer.isOtherAlter = true
    end

    s_SCENE:callFuncWithDelay(0.3,function()
        -- win sound
        playSound(s_sound_win)
    end)
    
    local bossID = s_DATABASE_MGR.getCurrentReviewBossID()
    s_DATABASE_MGR.updateReviewBossRecord(bossID)
    
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local back = cc.Sprite:create("image/alter/rb_alertBackImage.png")
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local boss = sp.SkeletonAnimation:create("res/spine/beidafeide_zhanglaoshi.json", "res/spine/beidafeide_zhanglaoshi.atlas", 1)
    boss:setPosition(150,270)
    back:addChild(boss)      
    boss:addAnimation(0, 'animation', true)

    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            s_SCENE.popupLayer.isOtherAlter = false
            s_CorePlayManager.leaveReviewBossLayer()
            
            -- stop effect
            cc.SimpleAudioEngine:getInstance():stopAllEffects()
            -- button sound
            playSound(s_sound_buttonEffect)
        end
    end

    local button_goon = ccui.Button:create("image/button/studyscene_blue_button.png","","")
    button_goon:setPosition(back:getContentSize().width/2,150)
    button_goon:setTitleText("继续")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main    
end


return ReviewBossAlter







