require("cocos.init")
require("common.global")

local MissionProgressLayer = class("MissionProgressLayer", function ()
    return cc.Layer:create()
end)


function MissionProgressLayer.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
--    local taskTotal = s_max_wrong_num_everyday * 2 + s_DATABASE_MGR:getTodayTotalBossNum() * 20
--    local taskCurrent
    
    local taskTotal = 120
    local taskCurrent = 120
    
    local state = s_DATABASE_MGR.getGameState()

--    if state == s_gamestate_studymodel then
--       taskCurrent =  s_CorePlayManager.wrongWordNum + s_DATABASE_MGR:getTodayTotalBossNum() * 20    
--    elseif state == s_gamestate_reviewmodel then
--        taskCurrent = s_max_wrong_num_everyday * 2 - s_CorePlayManager.candidateNum + s_DATABASE_MGR:getTodayTotalBossNum() * 20    
--    elseif state == s_gamestate_reviewbossmodel then
--        taskCurrent =  (s_DATABASE_MGR:getTodayTotalBossNum() - s_DATABASE_MGR:getTodayRemainBossNum()) * 20
--    else
--        taskCurrent = s_max_wrong_num_everyday * 2 + s_DATABASE_MGR:getTodayTotalBossNum() * 20
--    end
    
--    if taskCurrent == nil then
--        taskCurrent = 0
--    end
    
    local startTime = 0

    local rolling 
    local swelling 
    local rollingCircle
    local finishProgress
    local anotherEnterButton
    
    local layer = MissionProgressLayer.new()
    
--    print("taskCurrent "..taskCurrent)
    
    local runProgress = cc.ProgressTo:create(taskCurrent / taskTotal ,taskCurrent / taskTotal * 100)
    
    local missionToday = cc.Label:createWithSystemFont("今日任务","",40)
    missionToday:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 + 300)
    missionToday:setColor(cc.c4b(82,196,241,255))
    layer:addChild(missionToday)
    
    local backProgress = cc.Sprite:create("image/homescene/missionprogress/taskstartcirclebg.png")
    backProgress:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 20)
    layer:addChild(backProgress)
    
    local taskProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/taskstartcircle.png'))
    taskProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    taskProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    taskProgress:setReverseDirection(false)
    taskProgress:setPercentage(0)
    taskProgress:runAction(runProgress)
    backProgress:addChild(taskProgress)
    
    local enterGame = function ()
        s_CURRENT_USER:generateSummaryBossList()
        s_CURRENT_USER:generateChestList()
        s_CURRENT_USER:updateDataToServer()

        AnalyticsEnterLevelLayerBtn()
        AnalyticsFirst(ANALYTICS_FIRST_LEVEL, 'TOUCH')

        showProgressHUD()
        playSound(s_sound_buttonEffect)  
        s_CorePlayManager.enterLevelLayer()  
        hideProgressHUD()
    end

    local enterButtonClick = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            local action1 = cc.RotateBy:create(1,360)
            local action2 = cc.FadeOut:create(1)
            local action3 = cc.Spawn:create(action1,action2)
            sender:runAction(cc.Sequence:create(action3, cc.CallFunc:create(enterGame)))
        end
    end
    
    local enterButton = ccui.Button:create("image/homescene/missionprogress/taskstartbutton.png","image/homescene/missionprogress/taskstartbuttonclick.png","")
    enterButton:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    enterButton:addTouchEventListener(enterButtonClick)
    backProgress:addChild(enterButton)
    
    local line = cc.LayerColor:create(cc.c4b(0,0,0,0),1,150)
    line:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 20)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0,0)
    line:setScale(0)
    layer:addChild(line)   
    
    rolling = function ()
        line:setScale(1)
        local action1 = cc.RotateBy:create(2,360)
        line:runAction(cc.Sequence:create(action1,cc.CallFunc:create(swelling)))
    end

    swelling = function ()
        line:setScale(0)
        local action1 = cc.ScaleTo:create(0.5,1.1)
        local action2 = cc.ScaleTo:create(0.5,1)
        local action3 = cc.ScaleTo:create(0.5,1.1)
        local action4 = cc.ScaleTo:create(0.5,1)
        enterButton:runAction(cc.Sequence:create(action1, action2,action3,action4,cc.CallFunc:create(rolling)))
    end
     
    rollingCircle = cc.Sprite:create("image/homescene/missionprogress/rolling.png")
    rollingCircle:setPosition(0,150)
    line:addChild(rollingCircle)
    
    local tail = cc.Sprite:create("image/homescene/missionprogress/tail.png")
    tail:setPosition(10,20)
    tail:ignoreAnchorPointForPosition(false)
    tail:setAnchorPoint(1,1)
    tail:setRotation(-10)
    rollingCircle:addChild(tail)
    
--    s_SCENE:callFuncWithDelay(1,function()
--        if taskTotal == taskCurrent then
--            local action1 = cc.FadeOut:create(1)
--            local action2 = cc.FadeOut:create(2)
--            local action3 = cc.ScaleTo:create(0.5,1.1)
--            local action4 = cc.ScaleTo:create(0.5,1)
--            local action5 = cc.Spawn:create(action3,action4)
--
--            finishProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/taskfinishedstartcircleclick.png'))
--            finishProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
--            finishProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
--            finishProgress:setReverseDirection(false)
--            finishProgress:setPercentage(0)
--            finishProgress:runAction(cc.ProgressTo:create(taskCurrent / taskTotal ,taskCurrent / taskTotal * 100))
--            backProgress:addChild(finishProgress)
--
--            anotherEnterButton = ccui.Button:create("image/homescene/missionprogress/taskfinishedstartbutton.png","image/homescene/missionprogress/taskfinishedstartbuttonclick.png","")
--            anotherEnterButton:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
--            anotherEnterButton:addTouchEventListener(enterButtonClick)
--            backProgress:addChild(anotherEnterButton) 
--                                                    
--            enterButton:runAction(action1)
--            taskProgress:runAction(action2)    
--                              
--        else
--           swelling()
--        end
--
--        
--    end)
    
    local finishLabel = cc.Label:createWithSystemFont("已完成","",24)
    finishLabel:setPosition(bigWidth/2 - 80, s_DESIGN_HEIGHT/2 - 300)
    finishLabel:setColor(cc.c4b(134,150,159,255))
    layer:addChild(finishLabel)
    
    local blueLump = cc.LayerColor:create(cc.c4b(31,165,234,255),20,20)
    blueLump:setPosition(bigWidth/2 - 140, s_DESIGN_HEIGHT/2 - 310)
    layer:addChild(blueLump)
    
    local unfinishLabel = cc.Label:createWithSystemFont("未完成","",24)
    unfinishLabel:setPosition(bigWidth/2 + 120, s_DESIGN_HEIGHT/2 - 300)
    unfinishLabel:setColor(cc.c4b(134,150,159,255))
    layer:addChild(unfinishLabel)
    
    local grayLump = cc.LayerColor:create(cc.c4b(184,223,240,255),20,20)
    grayLump:setPosition(bigWidth/2 + 60, s_DESIGN_HEIGHT/2 - 310)
    layer:addChild(grayLump)
    
    local stackButtonClick = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsWordsLibBtn()
           s_CorePlayManager.enterWordListLayer()
        end
    end
    
    local stackButton = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
    stackButton:setPosition(bigWidth/2 , s_DESIGN_HEIGHT/2 - 400)
    stackButton:setTitleText("词库")
    stackButton:setTitleColor(cc.c4b(255,255,255,255))
    stackButton:setTitleFontSize(40)
    stackButton:addTouchEventListener(stackButtonClick)
    layer:addChild(stackButton)
    
    return layer
end

return MissionProgressLayer
