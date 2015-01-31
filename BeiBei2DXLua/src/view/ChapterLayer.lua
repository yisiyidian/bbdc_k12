require("cocos.init")
require('common.global')
s_chapter0_base_height = 3014
s_islands_per_page = 10
local ChapterLayer = class('ChapterLayer', function() 
    return cc.Layer:create()
end)


local s_chapter_layer_width = 854
local oceanBlue = cc.c4b(61,191,244,255)
local bounceSectionSize = cc.size(854,512)

function ChapterLayer.create()
    local layer = ChapterLayer.new()
    return layer
end

function ChapterLayer:ctor()
    self.chapterDic = {}
    -- add list view
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        end
    end

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            print("SCROLL_TO_BOTTOM")
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            print("SCROLL_TO_TOP")
        elseif evenType == ccui.ScrollviewEventType.scrolling then
            --print('SCROLLING:'..sender:getPosition())
        end

    end 
    self.listView = ccui.ListView:create()
    self.listView:setDirection(ccui.ScrollViewDir.vertical)
    self.listView:setBounceEnabled(true)
    self.listView:setBackGroundImageScale9Enabled(true)
    self.listView:addEventListener(listViewEvent)
    self.listView:addScrollViewEventListener(scrollViewEvent)
    self.listView:removeAllChildren()
    self:addChild(self.listView)
    
    local fullWidth = s_chapter_layer_width
    self.listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    self.listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    -- add bounce
    self:addTopBounce()
    -- add chapter node
    self:addChapterIntoListView('chapter0')
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentChapterIndex = math.floor(levelInfo / s_islands_per_page)   
    for i = 1, currentChapterIndex do
        self.addChapterIntoListView('chapter'..i)
    end
--    if string.sub(levelInfo['chapter'],8) - 1>= 0 then
--        self:addChapterIntoListView('chapter1')
--    end
--    if string.sub(levelInfo['chapter'], 8) - 2 >= 0 then
--        self:addChapterIntoListView('chapter2')
--    end
--    if string.sub(levelInfo['chapter'], 8) - 3 >= 0 then
--        self:addChapterIntoListView('chapter3')
--    end
    -- add player
    self:addPlayer()
    self:plotDecoration()
    -- scroll to current chapter level
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    self:scrollLevelLayer(progress,0)
    self:addBottomBounce()
    -- check unlock level
    self:checkUnlockLevel()
    self:addBackToHome()
    self:addBeansUI()
   
end

function ChapterLayer:checkUnlockLevel()
    local oldProgress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress()
    s_CURRENT_USER.levelInfo:updateDataToServer()  -- update book progress
 if currentProgress % s_islands_per_page == 0 and currentProgress > 0 then       
        -- unlock chapter
        self:plotUnlockCloudAnimation()
        local currentChapterKey = 'chapter'..math.floor(currentProgress / s_islands_per_page)
        s_SCENE:callFuncWithDelay(0.1, function() 
            self:addChapterIntoListView(currentChapterKey)
        end)
        s_SCENE:callFuncWithDelay(0.3, function() 
            self.chapterDic[currentChapterKey]:plotUnlockLevelAnimation('level'..currentProgress)
        end)
        s_SCENE:callFuncWithDelay(1.0, function() 
            self:addPlayerOnLevel(currentChapterKey,'level'..currentProgress)     
            self:scrollLevelLayer(currentProgress,0.3)
            -- notification
            self:addPlayerNotification(false)
            local notification = self.player:getChildByTag(100)
            local notificationAct = cc.ScaleTo:create(0.4,1)
            notification:runAction(notificationAct)
        end)
        s_SCENE:callFuncWithDelay(2.0, function() 
            self:addBottomBounce()
        end)
        

       

    elseif currentProgress - oldProgress > 0 then   -- unlock level
--        local oldLevelIndex = string.sub(oldProgress['level'], 6)
--        local currentLevelIndex = string.sub(currentProgress['level'],6)
        local chapterKey = 'chapter'..math.floor(oldProgress / s_islands_per_page)
        local delayTime = 0
        s_SCENE:callFuncWithDelay(delayTime, 
            function()
                -- add notification
                self:addPlayerNotification(false) 
            end
        )  
        self.chapterDic[chapterKey]:plotUnlockLevelAnimation('level'..currentProgress)
        -- move player
        s_SCENE:callFuncWithDelay(0.3,function()
            local nextLevelPosition = self.chapterDic[chapterKey]:getLevelPosition('level'..currentProgress)
            local playerAction = cc.MoveTo:create(0.5,cc.p(nextLevelPosition.x+100,nextLevelPosition.y))
            local notification = self.player:getChildByTag(100)
            local notificationAction1 = function()
                local notificationAct = cc.ScaleTo:create(0.4,1)
                notification:runAction(notificationAct)
            end
            self.player:runAction(cc.Sequence:create(playerAction,
                cc.DelayTime:create(0.6),
                cc.CallFunc:create(notificationAction1)))
        end)

        s_SCENE:callFuncWithDelay(1, function()
            self:scrollLevelLayer(currentProgress, 1)
        end)
    else
        -- add notification
        self:addPlayerNotification(true) 
    end
end


function ChapterLayer:addPlayerNotification(isRunScale)  -- notification
    self.player:removeAllChildren()
    local type
    print('gameState:'..s_LocalDatabaseManager.getGameState())
    if s_LocalDatabaseManager.getGameState() == s_gamestate_reviewbossmodel_beforetoday then
        type = 'reviewboss'
--    elseif s_LocalDatabaseManager.getGameState() == s_gamestate_studymodel or s_LocalDatabaseManager.getGameState() == s_gamestate_studymodel then
--        type = 'study'
    elseif s_LocalDatabaseManager.getGameState() == s_gamestate_studymodel_extra then
        type = 'study'
    elseif s_LocalDatabaseManager.getGameState() == s_gamestate_reviewmodel_extra then
        type = 'review'
    elseif s_LocalDatabaseManager.getGameState() == s_gamestate_studymodel then
        type = 'study'
    elseif s_LocalDatabaseManager.getGameState() == s_gamestate_reviewmodel then
        type = 'review'
    end
--    type = 'reviewboss'
    local notification = cc.Sprite:create('image/chapter/chapter0/notification.png')
    notification:setPosition(self.player:getContentSize().width/2,self.player:getContentSize().height)
    notification:setAnchorPoint(cc.p(0.5,0))
    notification:setScale(0)
    if isRunScale == true then
        notification:runAction(cc.ScaleTo:create(0.4,1))
    end
    notification:setTag(100)
    self.player:addChild(notification, 100)
--    type = 'complete'
    -- TODO show message according to type
    if type == 'study' then
        local title = cc.Label:createWithSystemFont('当前任务','',28)
        title:setColor(cc.c3b(56,26,23))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(55,115)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('积累生词: ','',22)
        task_name:setColor(cc.c3b(98,195,223))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(30,85)
        notification:addChild(task_name)
        local number = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getwrongWordListSize()..' / '..s_max_wrong_num_everyday,'',25)
        number:setColor(cc.c3b(165,55,80))
        number:ignoreAnchorPointForPosition(false)
        number:setAnchorPoint(0,0)
        number:setPosition(130,85)
        notification:addChild(number)
        
        
        if s_CURRENT_USER.tutorialStep == s_tutorial_level_select then
            local finger = sp.SkeletonAnimation:create('spine/yindaoye_shoudonghua_dianji.json', 'spine/yindaoye_shoudonghua_dianji.atlas',1)
            finger:addAnimation(0, 'animation', true)
            finger:setPosition(notification:getContentSize().width/2+20,-30)
            notification:addChild(finger,10)
            s_CURRENT_USER:setTutorialStep(s_tutorial_level_select+1)
            s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_level_select+1)
        end
        
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                AnalyticsTasksBtn()
                AnalyticsFirst(ANALYTICS_FIRST_STUDY, 'TOUCH')
                
                -- TODO go to study
                s_CorePlayManager.initTotalPlay()
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)
        
        -- add button title
        local button_title = cc.Label:createWithSystemFont('继续积累','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
    elseif type == 'review' then
        local title = cc.Label:createWithSystemFont('当前任务','',28)
        title:setColor(cc.c3b(56,26,23))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(55,115)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('趁热打铁: ','',22)
        task_name:setColor(cc.c3b(98,195,223))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(30,85)
        notification:addChild(task_name)
        local number = cc.Label:createWithSystemFont((s_LocalDatabaseManager.getwrongWordListSize() - s_LocalDatabaseManager.getwordCandidateSize())..' / '..s_max_wrong_num_everyday,'',25)
        number:setColor(cc.c3b(165,55,80))
        number:ignoreAnchorPointForPosition(false)
        number:setAnchorPoint(0,0)
        number:setPosition(130,85)
        notification:addChild(number)
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                -- TODO go to study
                s_CorePlayManager.initTotalPlay()
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)
        
        -- add button title
        local button_title = cc.Label:createWithSystemFont('继续学习','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
    elseif type == 'reviewboss' then
        local title = cc.Label:createWithSystemFont('今日目标','',28)
        title:setColor(cc.c3b(56,26,23))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(55,115)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('打败章鱼如花','',25)
        task_name:setColor(cc.c3b(98,195,223))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(40,85)
        notification:addChild(task_name)
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                -- TODO go to study
                print('on review boss')
                s_CorePlayManager.initTotalPlay()
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)

        -- add button title
        local button_title = cc.Label:createWithSystemFont('开始挑战','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
    elseif type == 'complete' then
        local title = cc.Label:createWithSystemFont(' 今日目标已达成\n明天要再接再厉哦','',22)
        title:setColor(cc.c3b(74,136,184))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(20,60)
        notification:addChild(title)
    end
end

function ChapterLayer:addPlayer()
--    self.player:removeFromParent()
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentChapterKey = 'chapter'..math.floor(levelInfo/s_islands_per_page)
    local levelKey = 'level'..levelInfo
    --self.player = cc.Sprite:create('image/chapter_level/gril_head.png')
    if s_LocalDatabaseManager.getGameState() == s_gamestate_studymodel_extra then
--    if true then
        self.player = cc.Sprite:create('image/chapter/chapter0/complete.png')
    else
        self.player = cc.Sprite:create('image/chapter/chapter0/player.png')
    end
    local position = self.chapterDic[currentChapterKey]:getLevelPosition(levelKey)
    self.player:setPosition(position.x+100,position.y)
    --self.player:setScale(0.4)
    self.chapterDic[currentChapterKey]:addChild(self.player, 150)

--    print('ChapterLayer:addPlayer >>>')
--    print_lua_table(levelInfo)
--    print('ChapterLayer:addPlayer <<<')


end

function ChapterLayer:addPlayerOnLevel(chapterKey, levelKey)
    self.player:removeFromParent()
--    local levelInfo = s_CURRENT_USER.levelInfo:computeCu
    --self.player = cc.Sprite:create('image/chapter_level/gril_head.png')
    if s_LocalDatabaseManager.getGameState() == s_gamestate_studymodel_extra then
        self.player = cc.Sprite:create('image/chapter/chapter0/complete.png')
    else
        self.player = cc.Sprite:create('image/chapter/chapter0/player.png')
    end
    local position = self.chapterDic[chapterKey]:getLevelPosition(levelKey)
--    print('!!!!!!!!!!player position!!!!!!')
--    print(position)
    self.player:setPosition(position.x+100,position.y)
    --self.player:setScale(0.4)
    self.chapterDic[chapterKey]:addChild(self.player, 150)
--
--    print('ChapterLayer:addPlayerOnLevel >>>')
--    print_lua_table(levelInfo)
--    print('ChapterLayer:addPlayerOnLevel <<<')

    
end

function ChapterLayer:addChapterIntoListView(chapterKey)
    if chapterKey == 'chapter0' then    
        local ChapterLayer0 = require('view.level.ChapterLayer0')
        self.chapterDic['chapter0'] = ChapterLayer0.create("start")
        self.chapterDic['chapter0']:setPosition(cc.p(0,0))
        self.chapterDic['chapter0']:loadLevelPosition("level0")
        self.chapterDic['chapter0']:plotDecoration()
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic['chapter0']:getContentSize())  
        custom_item:setName('chapter0')  
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
        self.listView:addChild(self.chapterDic['chapter0'])
   else    
        local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
        self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
        self.chapterDic[chapterKey]:setPosition(cc.p(0,0))
        --print('contentSize:'..self.chapterDic[chapterKey]:getContentSize().height)
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
        custom_item:setName(chapterKey)  
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
        self.listView:addChild(self.chapterDic[chapterKey]) 
    end
    

end

-- scroll self.listView to show the specific chapter and level
function ChapterLayer:scrollLevelLayer(levelIndex, scrollTime)
    if levelIndex == 0 then
        return
    end
    -- compute self.listView inner height
--    local itemList = self.listView:getItems()
--    local innerHeight = 0
--    for i = 1,#itemList do
--        innerHeight = innerHeight + itemList[i]:getContentSize().height
--    end

    local currentLevelCount = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 1
    local totalLevelCount = (math.floor((currentLevelCount-1) / s_islands_per_page) + 1) * s_islands_per_page
    local innerHeight = s_chapter0_base_height * (math.floor((currentLevelCount-1) / s_islands_per_page) + 1)
    self.listView:setInnerContainerSize(cc.size(s_chapter_layer_width, innerHeight))

    local currentVerticalPercent = currentLevelCount / totalLevelCount * 100
    print('#######currentPercent:'..currentVerticalPercent,','..currentLevelCount..','..totalLevelCount)
    if scrollTime - 0 == 0 then
        self.listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,false)
    else
        self.listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,true)
    end
    self.listView:setInertiaScrollEnabled(true)
end

function ChapterLayer:plotUnlockCloudAnimation()
    local action1 = cc.MoveBy:create(1.5, cc.p(-s_DESIGN_WIDTH*2,0))
    local action2 = cc.MoveBy:create(1.5, cc.p(s_DESIGN_WIDTH*2,0))
    self.chapterDic['leftCloud']:runAction(action1)
    self.chapterDic['rightCloud']:runAction(action2)
    s_SCENE:callFuncWithDelay(1.6,function()
        self.chapterDic['leftCloud']:removeFromParent() 
        self.chapterDic['rightCloud']:removeFromParent()
    end)
   
    
end

function ChapterLayer:addTopBounce()
    --if s_CURRENT_USER.currentChapterKey == 'chapter0' then
        --local blueLayerColor = cc.LayerColor:create(oceanBlue,bounceSectionSize.width,bounceSectionSize.height)
        local blueLayerColor = cc.LayerColor:create(oceanBlue,s_chapter_layer_width,s_DESIGN_HEIGHT)
        blueLayerColor:ignoreAnchorPointForPosition(false)
        blueLayerColor:setAnchorPoint(0,1)
        blueLayerColor:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,s_DESIGN_HEIGHT)
        self:addChild(blueLayerColor,-1)
    --end
end

function ChapterLayer:plotDecoration()
    -- plot user and boat
    local level0Position = self.chapterDic['chapter0']:getLevelPosition('level0')
--    local boat = cc.Sprite:create('image/chapter/chapter0/boat.png')
--    local fan = cc.Sprite:create('image/chapter/chapter0/fan.png')
--    local beibei = cc.Sprite:create('image/chapter/chapter0/startPlayer.png')
--    local boatPosition = cc.p(level0Position.x-100, level0Position.y+150)
--    local fanPosition = cc.p(boatPosition.x+40, boatPosition.y+80)
--    boat:setPosition(boatPosition)
--    fan:setPosition(fanPosition)
--    beibei:setPosition(cc.p(fanPosition.x-40,fanPosition.y-50))
--    self.chapterDic['chapter0']:addChild(boat, 130)
--    self.chapterDic['chapter0']:addChild(fan,130)
--    self.chapterDic['chapter0']:addChild(beibei,130)
    
    
    local boat = sp.SkeletonAnimation:create('spine/chuan.json', 'spine/chuan.atlas',1)
    boat:addAnimation(0, 'animation', true)
--    local boatPosition = cc.p(level0Position.x-100, level0Position.y+150)
    boat:setPosition(level0Position.x-200, level0Position.y+100)
    self.chapterDic['chapter0']:addChild(boat,130)
    
    -- add wave
    local wave = cc.Sprite:create('image/chapter/chapter0/shuibolang.png')
    wave:setPosition(level0Position.x-130, level0Position.y+80)
    self.chapterDic['chapter0']:addChild(wave,130)
    local action1 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(-50, 0)))
    local action2 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(50, 0)))
    local action3 = cc.RepeatForever:create(cc.Sequence:create(action1, action2))
    wave:runAction(action3)

end

function ChapterLayer:addBottomBounce()
    self.chapterDic['leftCloud'] = cc.Sprite:create('image/chapter/leftCloud.png')
    self.chapterDic['rightCloud'] = cc.Sprite:create('image/chapter/rightCloud.png')
    self.chapterDic['leftCloud']:setAnchorPoint(0, 1)
    self.chapterDic['rightCloud']:setAnchorPoint(0, 1)
    self.chapterDic['leftCloud']:setPosition((s_chapter_layer_width-bounceSectionSize.width)/2,50)
    self.chapterDic['rightCloud']:setPosition((s_chapter_layer_width-bounceSectionSize.width)/2,50)
    self.listView:addChild(self.chapterDic['leftCloud'],200)
    self.listView:addChild(self.chapterDic['rightCloud'],200)
end

function ChapterLayer:addBackToHome()
    local click_home = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local IntroLayer = require("view.home.HomeLayer")
            local introLayer = IntroLayer.create()  
            s_SCENE:replaceGameLayer(introLayer)
        end
    end


    -- return to homepage button
    local homeButton = ccui.Button:create("image/chapter_level/button_home_book.png","image/chapter_level/button_home_book.png","")
    homeButton:addTouchEventListener(click_home)
    homeButton:ignoreAnchorPointForPosition(false)
    homeButton:setAnchorPoint(0,1)
    homeButton:setPosition(s_LEFT_X + 50  , s_DESIGN_HEIGHT - 50 )
    homeButton:setLocalZOrder(1)
    self:addChild(homeButton,200)
end

function ChapterLayer:addBeansUI()
    self.beans = cc.Sprite:create('image/chapter/chapter0/beanBack.png')
    self.beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(self.beans,150)
    self.beanLabel = cc.Sprite:create('image/chapter/chapter0/bean.png')
    self.beanLabel:setPosition(-self.beans:getContentSize().width/2+70, self.beans:getContentSize().height/2+5)
    self.beans:addChild(self.beanLabel)    
    self.beanCount = s_CURRENT_USER:getBeans()
    self.beanCountLabel = cc.Label:createWithSystemFont(self.beanCount,'',33)
    self.beanCountLabel:setColor(cc.c3b(13, 95, 156))
    self.beanCountLabel:ignoreAnchorPointForPosition(false)
    self.beanCountLabel:setAnchorPoint(1,0)
    self.beanCountLabel:setPosition(105,2)
    self.beans:addChild(self.beanCountLabel,10)
end

function ChapterLayer:shakeBeansUI(beansIncrement)

    if self.beanLabel ~= nil and self.beanCountLabel~=nil and self.beanCount ~=nil then
        local beanLabelPostionX = self.beanLabel:getPositionX()
        local beanLabelPostionY = self.beanLabel:getPositionY()
        local beanLabelAct1 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY+10))
        local beanLabelAct2 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY-10))
        local beanLabelAct3 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY))
        self.beanLabel:runAction(cc.Sequence:create(beanLabelAct1,beanLabelAct2,beanLabelAct3))

        self.beanCount = self.beanCount + beansIncrement
        self.beanCountLabel:setString(self.beanCount)
        
        local addBeanLabel = cc.Label:createWithSystemFont("+豆豆",'',20)
        addBeanLabel:setPosition(self.beanCountLabel:getPositionX()-20,self.beanCountLabel:getPositionY()+50)
        addBeanLabel:setColor(cc.c3b(0,0,0))
        self.beans:addChild(addBeanLabel)
        
        local addBeanLabelAct1 = cc.MoveTo:create(0.2,cc.p(addBeanLabel:getPositionX(),addBeanLabel:getPositionY()+10))
        local addBeanLabelAct2 = cc.FadeOut:create(0.3)
        addBeanLabel:runAction(cc.Spawn:create(addBeanLabelAct1,addBeanLabelAct2))
    end
end

return ChapterLayer