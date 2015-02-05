require("cocos.init")
require("common.global")

local MissionProgressLayer = class("MissionProgressLayer", function ()
    return cc.Layer:create()
end)


function MissionProgressLayer.create(share)
    local missionCount = 3
    local completeCount = 3

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local taskTotal = 120
    local taskCurrent = 120
    
    local bossNumber = 0

    
    taskTotal = (bossNumber + 2) * s_max_wrong_num_everyday
    --taskCurrent = s_CorePlayManager:getProgress() + (bossNumber - s_LocalDatabaseManager:getTodayRemainBossNum()) * s_max_wrong_num_everyday
    
    
    local startTime = 0

    local rolling 
    local swelling 
    local rollingCircle
    local finishProgress
    local enterButton
    local anotherEnterButton
    local anotherSwelling
    local buttonSpin
    local circleSpin
    
    
    local layer = MissionProgressLayer.new()
    
    
--    print("taskCurrent "..taskCurrent)
    layer.stopListener = false
    
    
    
    local missionToday = cc.Label:createWithSystemFont("今日任务","",50)
    missionToday:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 + 260)
    missionToday:setColor(cc.c4b(82,196,241,255))
    layer:addChild(missionToday)
    
    if missionCount == completeCount then
        missionToday:setString("任务完成")
        missionToday:setColor(cc.c4b(233,147,72,255))
    end
    
    local backProgress = cc.Sprite:create("image/homescene/missionprogress/white_circle.png")
    backProgress:setColor(cc.c4b(170,217,230,0))
    backProgress:setOpacity(0)
    backProgress:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 20)
    layer:addChild(backProgress)

    local back = {}
    for i = 1,missionCount do
        back[i] = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
        back[i]:setColor(cc.c4b(170,217,231,255 * 0.2 * (i % 3 + 1)))
        back[i]:setOpacity(255 * 0.2 * ((i - 1) % 3 + 1))
        back[i]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        back[i]:setPercentage(100 / missionCount)
        back[i]:setRotation(360 * (i - 1) / missionCount)
        back[i]:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
        backProgress:addChild(back[i])
        
    end

    local circle_color = {cc.c3b(76,223,204),cc.c3b(36,168,217),cc.c3b(18,128,213)}
    
    if completeCount < missionCount then
        for i = 1, completeCount + 1 do 
            local split_line = cc.Sprite:create('image/homescene/home_page_task_circle_interval.png')
            split_line:setAnchorPoint(0.5,- 161 / 80)
            split_line:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2)
            backProgress:addChild(split_line,1)
            split_line:setRotation(360 * (i - 1) / missionCount)
            split_line:setVisible(false)
            split_line:runAction(cc.Sequence:create(cc.DelayTime:create((i - 1) / missionCount),cc.Show:create()))
        end
    end

    for i = 1, completeCount do 
        local taskProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
        taskProgress:setColor(circle_color[(i - 1) % 3 + 1])
        taskProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
        taskProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        taskProgress:setReverseDirection(false)
        taskProgress:setPercentage(0)
        local runProgress = cc.ProgressTo:create(1 / missionCount ,100 / missionCount)
        taskProgress:runAction(cc.Sequence:create(cc.DelayTime:create((i - 1) / missionCount),runProgress,cc.CallFunc:create(function()
            if i < missionCount then
                return
            else--if taskTotal == taskCurrent then
                local action1 = cc.FadeOut:create(1)
                local action2 = cc.FadeOut:create(2)
                local swell = cc.CallFunc:create(anotherSwelling)
                if share then
                    local a1 = cc.DelayTime:create(0.1)
                    local a2 = cc.CallFunc:create(function ()
                        local Share = require('view.share.ShareCheckIn')
                        local shareLayer = Share.create()
                        shareLayer:setPosition(0,-s_DESIGN_HEIGHT)
                        local move = cc.MoveTo:create(0.3,cc.p(0,0))
                        shareLayer:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),move))
                        s_GAME_LAYER:addChild(shareLayer,2)
                    end,{})
                    swell = cc.Spawn:create(cc.Sequence:create(a1,a2),cc.CallFunc:create(anotherSwelling))
                end
                finishProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(1 , 100),swell))
                finishProgress:setVisible(true) 
                anotherEnterButton:setVisible(true)    

                enterButton:runAction(action1)
                taskProgress:runAction(action2)     

                
            -- else
            --     swelling()
            end
        end)))
        back[i]:addChild(taskProgress)
    end
    
    
    
    local enterGame = function ()
        s_CURRENT_USER:generateSummaryBossList()
        s_CURRENT_USER:generateChestList()
        s_CURRENT_USER:updateDataToServer()

        AnalyticsEnterLevelLayerBtn()
        AnalyticsFirst(ANALYTICS_FIRST_LEVEL, 'TOUCH')

        showProgressHUD()
        playSound(s_sound_buttonEffect)
        if layer:getChildByTag(8888) ~=nil then
            local schedule = layer:getChildByTag(8888):getScheduler()
                schedule:unscheduleScriptEntry(schedule.schedulerEntry)
        end
        s_CorePlayManager.enterLevelLayer()  
        hideProgressHUD()
    end

    local enterButtonClick = function(sender, eventType)
        if layer.stopListener == false then
            if eventType == ccui.TouchEventType.began then
                playSound(s_sound_buttonEffect)   
            elseif eventType == ccui.TouchEventType.ended then
                local action1 = cc.RotateBy:create(1,360)
                local action2 = cc.FadeOut:create(1)
                local action3 = cc.Spawn:create(action1,action2)
                sender:runAction(cc.Sequence:create(action3, cc.CallFunc:create(enterGame)))
            end
        else
            return
        end
    end
    
    enterButton = ccui.Button:create("image/homescene/missionprogress/taskstartbutton.png","image/homescene/missionprogress/taskstartbuttonclick.png","")
    enterButton:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    enterButton:addTouchEventListener(enterButtonClick)
    backProgress:addChild(enterButton)
    layer.button = enterButton
    
    local line = cc.LayerColor:create(cc.c4b(0,0,0,0),1,150)
    line:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 20)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0,0)
    line:setScale(0)
    layer:addChild(line)   
    
    rolling = function ()
        line:setScale(1)
        local action1 = cc.RotateBy:create(1,360)
        line:runAction(cc.Sequence:create(action1,cc.CallFunc:create(swelling)))
    end

    swelling = function ()
        line:setScale(0)
        local action1 = cc.ScaleTo:create(0.25,1.05)
        local action2 = cc.ScaleTo:create(0.15,1)
        local action3 = cc.ScaleTo:create(0.25,1.05)
        local action4 = cc.ScaleTo:create(0.15,1)
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
    
    finishProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/home_page_task_finished_circle.png'))
    finishProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    finishProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    finishProgress:setReverseDirection(false)
    finishProgress:setPercentage(0)
    backProgress:addChild(finishProgress)
    finishProgress:setVisible(false)

    anotherEnterButton = ccui.Button:create("image/homescene/missionprogress/taskfinishedstartbutton.png","image/homescene/missionprogress/taskfinishedstartbuttonclick.png","")
    anotherEnterButton:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    anotherEnterButton:addTouchEventListener(enterButtonClick)
    backProgress:addChild(anotherEnterButton) 
    anotherEnterButton:setVisible(false)
    
    anotherSwelling = function ()
        local action1 = cc.ScaleTo:create(0.25,1.05)
        local action2 = cc.ScaleTo:create(0.15,1)
        local action3 = cc.ScaleTo:create(0.25,1.05)
        local action4 = cc.ScaleTo:create(0.15,1)
        anotherEnterButton:runAction(cc.Sequence:create(action1,action2,action3,action4,cc.CallFunc:create(buttonSpin)))
    end
    
    buttonSpin = function ()
    	local action1 = cc.RotateBy:create(1,360)
    	anotherEnterButton:runAction(cc.Sequence:create(action1,cc.CallFunc:create(circleSpin)))
    end

    circleSpin = function ()
        local action1 = cc.RotateBy:create(1,360)
        finishProgress:runAction(cc.Sequence:create(action1,cc.CallFunc:create(anotherSwelling)))
    end
    
    -- local finishLabel = cc.Label:createWithSystemFont("已完成","",24)
    -- finishLabel:setPosition(bigWidth/2 - 80, s_DESIGN_HEIGHT/2 - 300)
    -- finishLabel:setColor(cc.c4b(134,150,159,255))
    -- layer:addChild(finishLabel)
    
    -- local blueLump = cc.LayerColor:create(cc.c4b(31,165,234,255),20,20)
    -- blueLump:setPosition(bigWidth/2 - 140, s_DESIGN_HEIGHT/2 - 310)
    -- layer:addChild(blueLump)
    
    -- local unfinishLabel = cc.Label:createWithSystemFont("未完成","",24)
    -- unfinishLabel:setPosition(bigWidth/2 + 120, s_DESIGN_HEIGHT/2 - 300)
    -- unfinishLabel:setColor(cc.c4b(134,150,159,255))
    -- layer:addChild(unfinishLabel)
    
    -- local grayLump = cc.LayerColor:create(cc.c4b(184,223,240,255),20,20)
    -- grayLump:setPosition(bigWidth/2 + 60, s_DESIGN_HEIGHT/2 - 310)
    -- layer:addChild(grayLump)
    
--    local stackButtonClick = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            playSound(s_sound_buttonEffect)   
--        elseif eventType == ccui.TouchEventType.ended then
--            AnalyticsWordsLibBtn()
--        if layer:getChildByTag(8888) ~=nil then
--            local schedule = layer:getChildByTag(8888):getScheduler()
--                schedule:unscheduleScriptEntry(schedule.schedulerEntry)
--        end            
--           s_CorePlayManager.enterWordListLayer()
--        end
--    end
--    
--    local stackButton = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
--    stackButton:setPosition(bigWidth/2 , s_DESIGN_HEIGHT/2 - 400)
--    stackButton:setTitleText("词库")
--    stackButton:setTitleColor(cc.c4b(255,255,255,255))
--    stackButton:setTitleFontSize(40)
--    stackButton:addTouchEventListener(stackButtonClick)
--    layer:addChild(stackButton)

    local ButtonClick1 = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            local Test1 = require("view.islandPopup.WordLibraryPopup")
            local boss = s_LocalDatabaseManager.getBossInfo(1)
            local test1 = Test1.create(boss)
            s_SCENE:popup(test1)
        end
    end

    local Button1 = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
    Button1:setPosition(bigWidth/2 + 300 , s_DESIGN_HEIGHT/2 - 400)
    Button1:setTitleText("library")
    Button1:setTitleColor(cc.c4b(255,255,255,255))
    Button1:setTitleFontSize(40)
    Button1:addTouchEventListener(ButtonClick1)
    layer:addChild(Button1)
    
    Button1:setScale(0.5)
    
    
    local ButtonClick2 = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            local Test2 = require("view.newreviewboss.NewReviewBossMainLayer")
            local textlist = {}
            for i = 1,10  do
                table.insert(textlist,"apple")
            end
            local test2 = Test2.create(textlist)
            s_SCENE:replaceGameLayer(test2)
        end
    end

    local Button2 = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
    Button2:setPosition(bigWidth/2 + 300 , s_DESIGN_HEIGHT/2 - 300)
    Button2:setTitleText("review")
    Button2:setTitleColor(cc.c4b(255,255,255,255))
    Button2:setTitleFontSize(40)
    Button2:addTouchEventListener(ButtonClick2)
    layer:addChild(Button2)

    Button2:setScale(0.5)
    
    local ButtonClick3 = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            local Test = require("view.newstudy.MiddleLayer")
            local test = Test.create()
            s_SCENE:replaceGameLayer(test)
        end
    end

    local Button3 = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
    Button3:setPosition(bigWidth/2 + 300 , s_DESIGN_HEIGHT/2 - 200)
    Button3:setTitleText("collect end")
    Button3:setTitleColor(cc.c4b(255,255,255,255))
    Button3:setTitleFontSize(40)
    Button3:addTouchEventListener(ButtonClick3)
    layer:addChild(Button3)

    Button3:setScale(0.5)

    local function enterSummaryBoss(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local circle = require('view.summaryboss.SummaryBossLayer').create(1,1)
            s_SCENE:replaceGameLayer(circle) 
        end
    end

    local Button_boss = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
    Button_boss:setPosition(bigWidth/2 - 300 , s_DESIGN_HEIGHT/2 - 400)
    Button_boss:setTitleText("summaryboss")
    Button_boss:setTitleColor(cc.c4b(255,255,255,255))
    Button_boss:setTitleFontSize(40)
    Button_boss:addTouchEventListener(enterSummaryBoss)
    layer:addChild(Button_boss)

    Button_boss:setScale(0.5)
    
    
    
    return layer
end

function  MissionProgressLayer:setEnabled(enabled)
    self.button:setEnabled(enabled)
end

return MissionProgressLayer
