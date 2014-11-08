require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local PersonalInfo = class("PersonalInfo", function()
    return cc.Layer:create()
end)

function PersonalInfo.create()
    local layer = PersonalInfo.new()
    return layer
end

function PersonalInfo:ctor()
    self:initHead()
    local currentIndex = 1
    local moved = false
    local start_y = nil
    local colorArray = {cc.c4b(56,182,236,255 ),cc.c4b(238,75,74,255 ),cc.c4b(251,166,24,255 ),cc.c4b(143,197,46,255 )}
    local titleArray = {'单词掌握统计','单词学习增长','登陆贝贝天数','学习效率统计'}
    local intro_array = {}
    for i = 1,4 do
        
        local intro = cc.LayerColor:create(colorArray[5-i], s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        intro:ignoreAnchorPointForPosition(false)
        intro:setAnchorPoint(0.5,0.5)
--        if i == 4 then
--            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
--        else
--            intro:setPosition(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT*0.5)
--        end     
        
        if i == 1 then
            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
        else
            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT*1.5)
        end     
               
        self:addChild(intro,0,string.format('back%d',i))
        if i > 1 then
            local scrollButton = cc.Sprite:create("image/PersonalInfo/scrollHintButton.png")
            scrollButton:setPosition(s_DESIGN_WIDTH/2  ,s_DESIGN_HEIGHT * 0.08)
            scrollButton:setLocalZOrder(1)
            intro:addChild(scrollButton)
            local move = cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-30)),cc.MoveBy:create(0.5,cc.p(0,30)))
            scrollButton:runAction(cc.RepeatForever:create(move))
        
        end
        local title = cc.Label:createWithSystemFont(titleArray[5-i],'',36)
        title:setPosition(0.5 * s_DESIGN_WIDTH,0.75 * s_DESIGN_HEIGHT)
        title:setColor(cc.c3b(255,255,255))
        intro:addChild(title)
        table.insert(intro_array, intro)
    end
    
    -- 4
    self:PLVM()
    
    --1
    self:XXTJ()
    
    local onTouchBegan = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        start_y = location.y
        moved = false
        return true
    end
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
        local location = self:convertToNodeSpace(touch:getLocation())
        local now_y = location.y
        if now_y - 200 > start_y then

            if currentIndex > 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT*1.5))
                intro_array[currentIndex]:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex-1]:runAction(cc.Sequence:create(action2, action3))

                currentIndex = currentIndex - 1 
                
           
            end
        elseif now_y + 200 < start_y then
            if currentIndex < 4 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT/2))
                intro_array[currentIndex]:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex+1]:runAction(cc.Sequence:create(action2, action3))

                currentIndex = currentIndex + 1
              
  
            end
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function PersonalInfo:initHead()
    local back_color = cc.LayerColor:create(cc.c4b(255,255,255,150 ), s_RIGHT_X - s_LEFT_X, 0.2 * s_DESIGN_HEIGHT)
    back_color:ignoreAnchorPointForPosition(false)
    back_color:setAnchorPoint(0.5,1)
    back_color:setPosition(s_DESIGN_WIDTH/2 ,s_DESIGN_HEIGHT)
    back_color:setLocalZOrder(1)
    self:addChild(back_color) 

    --local node = self:getChildByName(string.format('back%d',1))

    local backButton = cc.Sprite:create("image/PersonalInfo/backButtonInPersonalInfo.png")
    backButton:ignoreAnchorPointForPosition(false)
    backButton:setAnchorPoint(0,0.5)
    backButton:setPosition(0 ,0.5 * back_color:getContentSize().height)
    backButton:setLocalZOrder(1)
    back_color:addChild(backButton)

    local girl = cc.Sprite:create("image/PersonalInfo/hj_personal_avatar.png")
    girl:setPosition(0.3 * back_color:getContentSize().width,0.5 * back_color:getContentSize().height)
    girl:setLocalZOrder(1)
    back_color:addChild(girl)

    local label_hint = cc.Label:createWithSystemFont("tester","",36)
    label_hint:ignoreAnchorPointForPosition(false)
    label_hint:setAnchorPoint(0,0)
    label_hint:setColor(cc.c4b(255 , 255, 255 ,255))
    label_hint:setPosition(0.5 * back_color:getContentSize().width,0.5 * back_color:getContentSize().height)
    label_hint:setLocalZOrder(2)
    back_color:addChild(label_hint)

    local label_study = cc.Label:createWithSystemFont("CET4","",36)
    label_study:ignoreAnchorPointForPosition(false)
    label_study:setAnchorPoint(0,1)
    label_study:setColor(cc.c4b(255 , 255, 255 ,255))
    label_study:setPosition(0.5 * back_color:getContentSize().width,0.5 * back_color:getContentSize().height)
    label_study:setLocalZOrder(2)
    back_color:addChild(label_study)

    --    local back_Button = cc.MenuItemImage("image/PersonalInfo/backButtonInPersonalInfo.png",
    --        "image/PersonalInfo/backButtonInPersonalInfo.png","image/PersonalInfo/backButtonInPersonalInfo.png")
    --    back_Button:setPosition(0,0)
    --    back_Button:setLocalZOrder(1)
    --    
    --    local menu = cc.Menu:create()
    --    menu:addChild(back_Button)
    --    
    --    local s = cc.Director:getInstance():getWinSize()
    --    menu:setPosition(cc.p(s.width/2, s.height/2))
    --
    --    self.addChild(menu)
end

function PersonalInfo:PLVM()
    local updateTime = 0
    local learnPercent = 0.6
    local masterPercent = 0.5
    local back = self:getChildByName('back4')
    local circleBack = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_circle_white.png')
    circleBack:setPosition(0.5 * s_DESIGN_WIDTH,0.42 * s_DESIGN_HEIGHT)
    back:addChild(circleBack)
    
    local toLearn = cc.ProgressTo:create(learnPercent,learnPercent * 100)
    local toMaster = cc.ProgressTo:create(masterPercent,masterPercent * 100)
    
    local backProgress = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVM/shuju_circle_ligheblue.png'))
    backProgress:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    backProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    backProgress:setReverseDirection(true)
    backProgress:setPercentage(0)
    backProgress:runAction(toLearn)
    circleBack:addChild(backProgress)
    
    local circleBackBig = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_big.png')
    circleBackBig:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(circleBackBig)
    
    local circleBackSmall = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_small.png')
    circleBackSmall:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(circleBackSmall)
    
    local learnProgress = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_big_dark.png'))
    learnProgress:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    learnProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    learnProgress:setReverseDirection(true)
    learnProgress:setPercentage(0)
    learnProgress:runAction(cc.ProgressTo:create(learnPercent,learnPercent * 100))
    circleBack:addChild(learnProgress)
    
    local masterProgress = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_small_dark.png'))
    masterProgress:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    masterProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    masterProgress:setReverseDirection(true)
    masterProgress:setPercentage(0)
    masterProgress:runAction(toMaster)
    circleBack:addChild(masterProgress)
    
    local smallCircle1 = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue1.png')
    smallCircle1:setScale(1,42 / 41)
    smallCircle1:setPosition(0.5 * circleBackBig:getContentSize().width,461.5)
    circleBackBig:addChild(smallCircle1)
    
    local smallCircle2 = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue2.png')
    smallCircle2:setScale(1,42 / 41)
    smallCircle2:setPosition(0.5 * circleBackSmall:getContentSize().width,344)
    circleBackSmall:addChild(smallCircle2)
    
    local smallCircleTail = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue1.png')
    smallCircleTail:setScale(1,42 / 41)
    smallCircleTail:setPosition(0.5 * circleBackBig:getContentSize().width + 220 * math.cos((0.5 + 2 * 0) * math.pi),0.5 * circleBackBig:getContentSize().height + 220 * math.sin((0.5 + 2 * 0) * math.pi))
    circleBackBig:addChild(smallCircleTail)
    
    local smallCircleTail2 = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue2.png')
    smallCircleTail2:setScale(1,42 / 41)
    smallCircleTail2:setPosition(0.5 * circleBackSmall:getContentSize().width + 161 * math.cos((0.5 + 2 * 0) * math.pi),0.5 * circleBackSmall:getContentSize().height + 161 * math.sin((0.5 + 2 * 0) * math.pi))
    circleBackSmall:addChild(smallCircleTail2)
    
    local line = cc.LayerColor:create(cc.c4b(0,0,0,255),200,1)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0.5,0.5)
    line:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(line)
    
    local label_study = cc.Label:createWithSystemFont("已学单词","",36)
    label_study:ignoreAnchorPointForPosition(false)
    label_study:setAnchorPoint(0.5,1)
    label_study:setColor(cc.c4b(0,0,0 ,255))
    label_study:setPosition(0.5 * circleBack:getContentSize().width,0.49 * circleBack:getContentSize().height)
    circleBack:addChild(label_study)
    
    local label_book = cc.Label:createWithSystemFont("高考","",28)
    label_book:ignoreAnchorPointForPosition(false)
    label_book:setAnchorPoint(0.5,1)
    label_book:setColor(cc.c4b(0,0,0 ,255))
    label_book:setPosition(0.5 * circleBack:getContentSize().width,0.4 * circleBack:getContentSize().height)
    circleBack:addChild(label_book)
    
    local label_percent = cc.Label:createWithSystemFont("0%","",48)
    label_percent:ignoreAnchorPointForPosition(false)
    label_percent:setAnchorPoint(0.5,0)
    label_percent:setColor(cc.c4b(0,0,0 ,255))
    label_percent:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(label_percent)
    
    local function update(delta)
        local per = '%'
        local str = string.format("%.1f%s",learnProgress:getPercentage(),per)
        label_percent:setString(str)
        smallCircleTail:setPosition(0.5 * circleBackBig:getContentSize().width + 220 * math.cos((0.5 + 0.02 * learnProgress:getPercentage()) * math.pi),0.5 * circleBackBig:getContentSize().height + 220 * math.sin((0.5 + 0.02 * learnProgress:getPercentage()) * math.pi))
        smallCircleTail2:setPosition(0.5 * circleBackSmall:getContentSize().width + 161 * math.cos((0.5 + 0.02 * masterProgress:getPercentage()) * math.pi),0.5 * circleBackSmall:getContentSize().height + 161 * math.sin((0.5 + 0.02 * masterProgress:getPercentage()) * math.pi))
    end
    self:scheduleUpdateWithPriorityLua(update, 0)
end


function PersonalInfo:XXTJ()
   local everydayWord = 20
   local totalWord = 1000
   local wordFinished = 100
   local dayToFinish = 0
   local back = self:getChildByName('back1')
   local positionX =  0.5 * s_DESIGN_WIDTH + 150
   -- > 99(mark 1) or not (mark 0)
   local mark = 0
   local string_everydayWord = "X个"
   local string_dayToFinish = "X天"
   local label_dayToFinish = ""
   
   if numberWord == 0 then 
        dayToFinish = 99
        mark = 1
   else
        dayToFinish = math.ceil((totalWord - wordFinished) / everydayWord)
        
        mark = 0
        if dayToFinish > 99 then 
        dayToFinish = 99
        mark = 1
        end
   end
   
    string_everydayWord = string.format("%s%s", tostring(everydayWord) , "个") 
    
    
    if mark == 0 then
        string_dayToFinish = string.format("%s%s", tostring(dayToFinish) , "天") 
    else
        string_dayToFinish = string.format("%s%s%s", "大于",tostring(dayToFinish) , "天") 
    end
    
   
    local girl = sp.SkeletonAnimation:create('spine/personalInfo/bb_zhuanquan_public.json','spine/personalInfo/bb_zhuanquan_public.atlas', 1)
    girl:setAnimation(0,'animation',true)
    girl:ignoreAnchorPointForPosition(false)
    girl:setAnchorPoint(0.5,0.5)
    girl:setPosition(0.5 * s_DESIGN_WIDTH - 150,0.5 * s_DESIGN_HEIGHT - 250)
    back:addChild(girl)
   
   
    local label_everydayWord = cc.Label:createWithSystemFont(everydayWord,"",60)
    label_everydayWord:ignoreAnchorPointForPosition(false)
    label_everydayWord:setPosition(positionX - 50,0.5 * s_DESIGN_HEIGHT + 50)
    label_everydayWord:setAnchorPoint(0.5,0.5)
    label_everydayWord:setColor(cc.c4b(255,255,255 ,255))
    back:addChild(label_everydayWord)
    
    local label_ge = cc.Label:createWithSystemFont("个","",36)
    label_ge:ignoreAnchorPointForPosition(false)
    label_ge:setPosition(positionX + 50,0.5 * s_DESIGN_HEIGHT + 50)
    label_ge:setAnchorPoint(0.5,0.5)
    label_ge:setColor(cc.c4b(255,255,255 ,255))
    back:addChild(label_ge)
    
    local line_up = cc.LayerColor:create(cc.c4b(255,255,255,255),200,1)
    line_up:ignoreAnchorPointForPosition(false)
    line_up:setAnchorPoint(0.5,0.5)
    line_up:setPosition(positionX,0.5 * s_DESIGN_HEIGHT )
    back:addChild(line_up)  
    
    local label_everyday = cc.Label:createWithSystemFont("每日平均","",36)
    label_everyday:ignoreAnchorPointForPosition(false)
    label_everyday:setPosition(positionX,0.5 * s_DESIGN_HEIGHT - 50)
    label_everyday:setAnchorPoint(0.5,0.5)
    label_everyday:setColor(cc.c4b(255,255,255 ,255))
    back:addChild(label_everyday)


    if mark == 0 then
    label_dayToFinish = cc.Label:createWithSystemFont(dayToFinish,"",60)
    label_dayToFinish:ignoreAnchorPointForPosition(false)
    label_dayToFinish:setPosition(positionX - 50,0.5 * s_DESIGN_HEIGHT - 150)
    label_dayToFinish:setAnchorPoint(0.5,0.5)
    label_dayToFinish:setColor(cc.c4b(255,255,255 ,255))
    back:addChild(label_dayToFinish)
    
    local label_tian = cc.Label:createWithSystemFont("天","",36)
    label_tian:ignoreAnchorPointForPosition(false)
    label_tian:setPosition(positionX + 50,0.5 * s_DESIGN_HEIGHT - 150)
    label_tian:setAnchorPoint(0.5,0.5)
    label_tian:setColor(cc.c4b(255,255,255 ,255))
    back:addChild(label_tian)
    else
        local label_dayu = cc.Label:createWithSystemFont("大于","",36)
        label_dayu:ignoreAnchorPointForPosition(false)
        label_dayu:setPosition(positionX - 100,0.5 * s_DESIGN_HEIGHT - 150)
        label_dayu:setAnchorPoint(0.5,0.5)
        label_dayu:setColor(cc.c4b(255,255,255 ,255))
        back:addChild(label_dayu)
        
         label_dayToFinish = cc.Label:createWithSystemFont(dayToFinish,"",60)
        label_dayToFinish:ignoreAnchorPointForPosition(false)
        label_dayToFinish:setPosition(positionX + 10 ,0.5 * s_DESIGN_HEIGHT - 150)
        label_dayToFinish:setAnchorPoint(0.5,0.5)
        label_dayToFinish:setColor(cc.c4b(255,255,255 ,255))
        back:addChild(label_dayToFinish)

        local label_tian = cc.Label:createWithSystemFont("天","",36)
        label_tian:ignoreAnchorPointForPosition(false)
        label_tian:setPosition(positionX + 100,0.5 * s_DESIGN_HEIGHT - 150)
        label_tian:setAnchorPoint(0.5,0.5)
        label_tian:setColor(cc.c4b(255,255,255 ,255))
        back:addChild(label_tian)   
    end
    
    
    local line_down = cc.LayerColor:create(cc.c4b(255,255,255,255),200,1)
    line_down:ignoreAnchorPointForPosition(false)
    line_down:setAnchorPoint(0.5,0.5)
    line_down:setPosition(positionX,0.5 * s_DESIGN_HEIGHT - 200)
    back:addChild(line_down) 
    
    local label_finishday = cc.Label:createWithSystemFont("完成还需","",36)
    label_finishday:ignoreAnchorPointForPosition(false)
    label_finishday:setPosition(positionX,0.5 * s_DESIGN_HEIGHT - 250)
    label_finishday:setAnchorPoint(0.5,0.5)
    label_finishday:setColor(cc.c4b(255,255,255 ,255))
    back:addChild(label_finishday)

    -- changing number
    local i = 0
    local function update(delta)
        i = i+5
        if everydayWord > 10 then
        -- 0 up to everydayWord
        label_everydayWord:setString( math.ceil(everydayWord / 100 * i))
        -- 99 down to dayToFinish
             if mark == 0 then 
                 label_dayToFinish:setString(math.ceil(99 - (99 -dayToFinish ) / 100 * i))
             end
             if i >= 100 then
             self:unscheduleUpdate()           
             end
        else
            label_everydayWord:setString(i / 5)
                if mark == 0 then 
                label_dayToFinish:setString(math.ceil(99 - (99 -dayToFinish ) / 100 * i))
                end
            if i / 5 == everydayWord then
                label_dayToFinish:setString(dayToFinish)
                self:unscheduleUpdate()           
            end
        end
        

        
    end
    

    self:scheduleUpdateWithPriorityLua(update, 0)

    
	
end

return PersonalInfo