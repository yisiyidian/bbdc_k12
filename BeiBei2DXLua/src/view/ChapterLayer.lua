--选单元的界面 unit1 unit2....
-- 关卡的主界面显示，将每个单元的UI都添加到该类中，控制滚动等
local TaskView = require("view.taskview.TaskView")

local s_islands_per_page = 10
local ChapterLayer = class('ChapterLayer', function() 
    return cc.Layer:create()
end)

local s_chapter_layer_width = 854 --滚动列表宽度
local oceanBlue             = cc.c4b(61,191,244,255)
local bounceSectionSize     = cc.size(854,512)  --滚动条 回弹区域
local scrollBottomLock      = false --？
local scrollTopLock         = false --？

function ChapterLayer.create()
    local layer = ChapterLayer.new()
    return layer
end

function ChapterLayer:ctor()
    playMusic(s_sound_bgm1,true)
    -- show repeat chapter list
    self.activeChapterStartIndex = 0
    self.activeChapterEndIndex = 0
    self.biggestChapterIndex = 0
    self:initActiveChapterRange()
    self.chapterDic = {}

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            --章节列表 滑动到底端的事件
            if not scrollBottomLock then
                scrollBottomLock = true
                self:callFuncWithDelay(2.0, function()
                    scrollBottomLock = false
                end)
                print("SCROLL_TO_BOTTOM ".."self.activeChapterEndIndex:"..self.activeChapterEndIndex.." self.biggestChapterIndex:"..self.biggestChapterIndex)
                if self.activeChapterEndIndex < self.biggestChapterIndex then
                    self.activeChapterEndIndex = self.activeChapterEndIndex + 1
                    self:addChapterIntoListView("chapter"..self.activeChapterEndIndex)
                    self:callFuncWithDelay(0.1, function()
                        self:scrollLevelLayer(self.activeChapterEndIndex * s_islands_per_page,0)
                    end)
                end
            end
        elseif evenType == ccui.ScrollviewEventType.scrollToTop then
            --章节列表  滑动到顶端的事件
            if not scrollTopLock then
                scrollTopLock = true
                self:callFuncWithDelay(2.0, function()
                    scrollTopLock = false
                end)
                print("SCROLL_TO_TOP ".."self.activeChapterEndIndex:"..self.activeChapterEndIndex.." self.biggestChapterIndex:"..self.biggestChapterIndex)
                if self.activeChapterStartIndex > 0 then
                    self.activeChapterStartIndex = self.activeChapterStartIndex - 1;
                    local chapterKey = 'chapter'..self.activeChapterStartIndex
                    local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
                    self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
                    self.chapterDic[chapterKey]:setAnchorPoint(0, 0)
                    self.chapterDic[chapterKey]:setPosition(0, 0)
                    local custom_item = ccui.Layout:create()
                    custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
                    custom_item:setName(chapterKey)  
                    custom_item:addChild(self.chapterDic[chapterKey])
                    custom_item:setAnchorPoint(0,0)
                    local fullWidth = s_chapter_layer_width
                    custom_item:setPosition(cc.p((s_DESIGN_WIDTH - s_chapter_layer_width) / 2, 0))
                    self.listView:insertCustomItem(custom_item, 0)
                    self:callFuncWithDelay(0.1, function()
                        self:scrollLevelLayer((self.activeChapterStartIndex * 10 + 9) * s_islands_per_page,0)
                    end)
                end
            end
        elseif evenType == ccui.ScrollviewEventType.scrolling then

        end
    end 
    self.listView = ccui.ListView:create()
    self.listView:setDirection(ccui.ScrollViewDir.vertical)
    self.listView:setBounceEnabled(true)
    self.listView:setBackGroundImageScale9Enabled(true)
    self.listView:addScrollViewEventListener(scrollViewEvent)
    self.listView:removeAllChildren()
    self:addChild(self.listView)
    
    local fullWidth = s_chapter_layer_width
    self.listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    self.listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    -- add bounce
    self:addTopBounce()
    -- add active chapter range
    for i = self.activeChapterStartIndex, self.activeChapterEndIndex do
        self:addChapterIntoListView('chapter'..i)
    end
    -- add player
    -- scroll to current chapter level
    -- local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local taskIndex = self:getActiveTaskIndex()
    if s_game_fail_state == 1 then
        self:scrollLevelLayer(s_game_fail_level_index, 0)
        s_game_fail_state = 0
    elseif taskIndex >= 0 then
        self:scrollLevelLayer(taskIndex, 0)
    else
        self:scrollLevelLayer(progress, 0)
    end


    self:addBottomBounce()
    -- check unlock level
    self:checkUnlockLevel()
    self:addBackToHome()    --返回按钮      左上
    self:addBeansUI()       --贝贝豆图标    右上
    self:addTaskBOX()

    -- 添加引导
    if s_CURRENT_USER.guideStep <= s_guide_step_enterStory5 then
        local backColor = cc.LayerColor:create(cc.c4b(0,0,0,100), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        backColor:setPosition(s_DESIGN_WIDTH /2,s_DESIGN_HEIGHT /2)
        backColor:ignoreAnchorPointForPosition(false)
        backColor:setAnchorPoint(0.5,0.5)
        self.backColor = backColor
        self:addChild(self.backColor)

        s_CorePlayManager.enterGuideScene(5,self.backColor)
        local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
        summaryboss:setPosition(310,725)
        summaryboss:setAnchorPoint(1,1)
        summaryboss:addAnimation(0, 'jianxiao', true)
        summaryboss:setScale(0.9)
        self.backColor:addChild(summaryboss)
        s_CURRENT_USER:setGuideStep(s_guide_step_enterLevel) 


        local onTouchBegan = function(touch, event)
            self:touchFunc()
        end    
        
        local onTouchMoved = function(touch, event)
        end
        
        local onTouchEnded = function(touch, event)
        end
        
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = self.backColor:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.backColor)
        listener:setSwallowTouches(true)
    end
    -- 添加引导
    print("now guide is "..s_CURRENT_USER.guideStep)
    if s_CURRENT_USER.guideStep == s_guide_step_second then
        local GuideToTaskView = require("view.guide.GuideToTaskView")
        local guideToTaskView = GuideToTaskView.create()
        self:addChild(guideToTaskView,3)
        s_CURRENT_USER:setGuideStep(s_guide_step_bag1) 
    end
    if s_CURRENT_USER.showTaskLayer == 1 then
        self.boxButton:stopAllActions()
        self.boxButton:setBright(false)
        self.boxButton:setTouchEnabled(false)
        local taskview = TaskView.new(handler(self,self.callBox),handler(self, self.updateBean))
        s_SCENE:popup(taskview)
        s_CURRENT_USER.showTaskLayer = 0  
    end  
end

function ChapterLayer:touchFunc()
    local LevelProgressPopup = require("view.islandPopup.LevelProgressPopup")
    local levelProgressPopup = LevelProgressPopup.create("0")
    s_SCENE:popup(levelProgressPopup)
end

-- 检查是否有任务（如复习boss)
-- 如果有，返回对应的taskIndex(即levelIndex)
-- 如果没有，返回-2
function ChapterLayer:getActiveTaskIndex()
    local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    print('-------getActiveTaskIndex----------')
    print_lua_table(bossList)
    local taskIndex = -2
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] - 0 == 0 and bossInfo["unitState"] - 1 >= 0 and taskIndex == -2 and bossInfo["unitState"] - 4 < 0 then
            taskIndex = bossID - 1
        end
    end    
    return taskIndex
end

-- initialize the active range of repeatable chapter ui
function ChapterLayer:initActiveChapterRange()
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local activeLevelIndex
    -- check whether exists task
    local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    local taskIndex = -2
    local taskState = -2
    local progressIndex = progress
    local progressState = 0
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] - 0 == 0 and bossInfo["unitState"] - 1 >= 0 and taskIndex == -2 and bossInfo["unitState"] - 4 < 0 then
            taskIndex = bossID - 1
            taskState = bossInfo["unitState"] 
        end
        if (progressIndex + 1) == bossID then
            progressState = bossInfo["unitState"]
        end
    end    
    if taskIndex == -2 then
        activeLevelIndex = progress
    else
        activeLevelIndex = taskIndex
    end
    -- check active chapterindex range
    self.activeChapterIndex = math.floor(activeLevelIndex / s_islands_per_page)
    self.biggestChapterIndex = math.floor(progress / s_islands_per_page)
    if self.biggestChapterIndex < 3 then
        self.activeChapterStartIndex = 0
        self.activeChapterEndIndex = self.biggestChapterIndex
    else 
        if self.activeChapterIndex == 0 then
            self.activeChapterStartIndex = 0
            self.activeChapterEndIndex = 2
        elseif self.activeChapterIndex == self.biggestChapterIndex then
            self.activeChapterStartIndex = self.activeChapterIndex - 2
            self.activeChapterEndIndex = self.biggestChapterIndex
        else 
            self.activeChapterStartIndex = self.activeChapterIndex - 1
            self.activeChapterEndIndex = self.activeChapterIndex + 1
        end
    end
end

-- 延时调用方法
function ChapterLayer:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

-- 检查是否需要解锁关卡（分为解锁大关卡和解锁小关卡）
function ChapterLayer:checkUnlockLevel()
    -- get state --
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    -- check state
    local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    print('---BOSS list')
    print_lua_table(bossList)
    --------------------- last level ------------------------ 某本书学习完成时的逻辑
    local bookMaxUnitID = s_LocalDatabaseManager.getBookMaxUnitID(s_CURRENT_USER.bookKey)
    if progress - bookMaxUnitID == 0 then -- last level
        for bossID, bossInfo in pairs(bossList) do
            if bossID - bossMaxUnitID == 0 and bossInfo["unitState"] - 1 >= 0 then 
                local back = cc.Sprite:create("image/homescene/background_ciku_white.png")
                back:setPosition(cc.p(s_DESIGN_WIDTH/2, 550))

                local close_button_clicked = function(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        s_SCENE:removeAllPopups()
                    end
                end
                local closeButton = ccui.Button:create("image/popupwindow/closeButtonRed.png","image/popupwindow/closeButtonRed.png","")
                closeButton:setPosition(back:getContentSize().width-30, back:getContentSize().height-30)
                closeButton:addTouchEventListener(close_button_clicked)
                back:addChild(closeButton)

                local label1 = cc.Label:createWithSystemFont("恭喜你","",45)
                label1:setPosition(back:getContentSize().width/2, back:getContentSize().height-100)
                label1:setColor(cc.c4b(36,61,78,255))
                back:addChild(label1)
                local label2 = cc.Label:createWithSystemFont("完成了这本书的学习","",30)
                label2:setColor(cc.c4b(36,61,78,255))
                label2:setPosition(back:getContentSize().width/2, back:getContentSize().height-175)
                back:addChild(label2)

                local beibeiAnimation = sp.SkeletonAnimation:create("spine/bb_happy_public.json", 'spine/bb_happy_public.atlas',1)
                beibeiAnimation:addAnimation(0, 'animation', false)
                beibeiAnimation:setPosition(back:getContentSize().width/3, 320)

                local partical = cc.ParticleSystemQuad:create('image/studyscene/ribbon.plist')
                partical:setPosition(s_DESIGN_WIDTH/2-s_LEFT_X, 700)
                back:addChild(partical)
                back:addChild(beibeiAnimation)

                local change_button_clicked = function(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        -- 
                        s_CorePlayManager.enterBookLayer(s_CURRENT_USER.bookKey)
                        s_SCENE:removeAllPopups()
                    end
                end

                local changeButton = ccui.Button:create("image/homescene/attention_button.png","image/homescene/attention_button_press.png","image/setting/attention_button_press.png")
                changeButton:setPosition(back:getContentSize().width/2, 200)
                back:addChild(changeButton,10)
                local text = cc.Label:createWithSystemFont("去换本书","",36)
                text:setColor(cc.c4b(255,255,255,255))
                text:setPosition(changeButton:getContentSize().width/2, changeButton:getContentSize().height/2)
                changeButton:addChild(text)
                changeButton:addTouchEventListener(change_button_clicked)

                local layer = cc.Layer:create()
                layer:addChild(back)
                s_SCENE:popup(layer)
            end
        end
    end
    ---------------------------------------------------------
    -- 记录任务关卡索引和当前关卡索引
    local taskIndex = -2
    local taskState = -2
    local progressIndex = progress
    local progressState = 0
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] - 0 == 0 and bossInfo["unitState"] - 1 >= 0 and taskIndex == -2 and bossInfo["unitState"] - 5 < 0 then
            taskIndex = bossID - 1
            taskState = bossInfo["unitState"]
        end
        if (progressIndex + 1) == bossID then
            progressState = bossInfo["unitState"]
        end
    end
    -- get state --
    -- check max unit ID
    local oldProgress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)+0
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 0
    s_CURRENT_USER.levelInfo:updateDataToServer()  -- update book progress
    -- 解锁大关卡
    if currentProgress % s_islands_per_page == 0 and currentProgress > 0 and currentProgress - oldProgress > 0 then       
        --unlock chapter
        self:plotUnlockCloudAnimation()
        local currentChapterKey = 'chapter'..math.floor(currentProgress / s_islands_per_page)
        self:callFuncWithDelay(0.1, function() 
            self:addChapterIntoListView(currentChapterKey)
            self.activeChapterEndIndex = self.activeChapterEndIndex + 1
            self.biggestChapterIndex = self.biggestChapterIndex + 1
        end)
        self:callFuncWithDelay(1.8, function() 
            self.chapterDic[currentChapterKey]:plotUnlockLevelAnimation('level'..currentProgress)
        end)
        self:callFuncWithDelay(0.5, function() 
            self:scrollLevelLayer(currentProgress,1.3)
        end)
        self:callFuncWithDelay(2.7, function() 
            self:addBottomBounce()
        end)
    -- 解锁小关卡
    elseif currentProgress - oldProgress > 0 then   -- unlock level
        local chapterKey = 'chapter'..math.floor(oldProgress / s_islands_per_page)
        local delayTime = 0
        self.chapterDic[chapterKey]:plotUnlockLevelAnimation('level'..currentProgress)
        self:callFuncWithDelay(1, function()
            self:scrollLevelLayer(currentProgress, 1)
        end)
    else
        local chapterKey = 'chapter'..math.floor(oldProgress / s_islands_per_page)
        if taskIndex == -2 and s_level_popup_state == 1 then
            self:scrollLevelLayer(currentProgress, 0)
            s_level_popup_state = 2
                s_SCENE.touchEventBlockLayer.lockTouch()
                self:callFuncWithDelay(1.1, function()
                    s_SCENE.touchEventBlockLayer.unlockTouch()
                end)
            self:callFuncWithDelay(1.0, function() 
                local playAnimation = true
                self.chapterDic[chapterKey]:addPopup(currentProgress,playAnimation)
            end)
        elseif taskIndex ~= -2 then 
            if taskIndex - 0 == 0 then
                self:scrollLevelLayer(taskIndex, 0)
            else
                self:scrollLevelLayer(taskIndex+1,0)
            end
        end
    end
end

-- 将某个大关卡（章节）添加到滚动列表中
function ChapterLayer:addChapterIntoListView(chapterKey)
    print('add chapter list view:'..chapterKey)
    --Chapter0使用一种UI，其他Chapter使用重复的RepeatChapterLayer，方便关卡的扩展（目前只有一种逻辑）
    if chapterKey == 'chapter0' then    
        local ChapterLayer0 = require('view.level.ChapterLayer0')
        self.chapterDic['chapter0'] = ChapterLayer0.create("start")
        self.chapterDic['chapter0']:setPosition(cc.p(0,0))
        self.chapterDic['chapter0']:loadLevelPosition("level0")
        self.chapterDic['chapter0']:plotDecoration()
        self.listView:addChild(self.chapterDic['chapter0'])
   else    
        local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
        self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
        self.chapterDic[chapterKey]:setPosition(cc.p(0,0))
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
        custom_item:setName(chapterKey)  
        self.listView:pushBackCustomItem(self.chapterDic[chapterKey])
    end
end

-- scroll self.listView to show the specific chapter and level
function ChapterLayer:scrollLevelLayer(levelIndex, scrollTime)
        print('enter scrollLevelLayer...levelIndex:'..levelIndex)
        s_SCENE.touchEventBlockLayer.lockTouch()
        self:callFuncWithDelay(0.3, function()
            s_SCENE.touchEventBlockLayer.unlockTouch()
        end)
        if levelIndex <= 1 then
            return
        end
        local currentLevelCount = levelIndex + 1
        -- active chapter range
        local activeLevelCount = levelIndex + 1 - self.activeChapterStartIndex * s_islands_per_page
        local activeTotalLevelCount = (self.activeChapterEndIndex - self.activeChapterStartIndex + 1) * s_islands_per_page
        local innerHeight = s_chapter0_base_height * (self.activeChapterEndIndex - self.activeChapterStartIndex + 1)
        print('innerCount:'..(self.activeChapterEndIndex - self.activeChapterStartIndex + 1))
        self.listView:setInnerContainerSize(cc.size(s_chapter_layer_width, innerHeight))
        -- compute vertical percent
        local chapterCount = math.floor((currentLevelCount-1) / 10)
        local levelCount = math.floor((currentLevelCount-1) % 10) + 1

        if chapterCount == 0 then
            if levelCount == 3 then
                levelCount = 1.7
            elseif levelCount == 4 then
                levelCount = 2.7
            elseif levelCount == 5 then
                levelCount = 4.4
            elseif levelCount == 6 then
                levelCount = 5.7
            end
        end
        -- local currentVerticalPercent = ((chapterCount / chapterCount + 1)+ temp/(chapterCount + 1)) * 100
        local currentVerticalPercent = (chapterCount / (chapterCount + 1) + (levelCount + 1)/ (s_islands_per_page * (chapterCount + 1)) ) * 100

        if (currentVerticalPercent >= 80 and levelCount >= 8) or currentVerticalPercent > 100 then
            currentVerticalPercent = 100
        end
        print('#######currentPercent:'..currentVerticalPercent,','..chapterCount..','..levelCount)
        if scrollTime - 0 == 0 then
            self.listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,false)
        else
            self.listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,true)
        end
        self.listView:setInertiaScrollEnabled(true)
end

-- 播放解锁大关卡时云层的动画
function ChapterLayer:plotUnlockCloudAnimation()
    local action1 = cc.MoveBy:create(1.5, cc.p(-s_DESIGN_WIDTH*2,0))
    local action2 = cc.MoveBy:create(1.5, cc.p(s_DESIGN_WIDTH*2,0))
    self.chapterDic['leftCloud']:runAction(action1)
    self.chapterDic['rightCloud']:runAction(action2)
    self:callFuncWithDelay(1.6,function()
        self.chapterDic['leftCloud']:removeFromParent() 
        self.chapterDic['rightCloud']:removeFromParent()
    end)  
end

-- 添加头部的bounce
function ChapterLayer:addTopBounce()
    local blueLayerColor = cc.LayerColor:create(oceanBlue,s_chapter_layer_width,s_DESIGN_HEIGHT)
    blueLayerColor:ignoreAnchorPointForPosition(false)
    blueLayerColor:setAnchorPoint(0,1)
    blueLayerColor:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,s_DESIGN_HEIGHT)
    self:addChild(blueLayerColor,-1)
end

-- 添加界面中的元素
function ChapterLayer:plotDecoration()
    -- plot user and boat
    local level0Position = self.chapterDic['chapter0']:getLevelPosition('level0')
    local boat = sp.SkeletonAnimation:create('spine/chuan.json', 'spine/chuan.atlas',1)
    boat:addAnimation(0, 'animation', true)
    boat:setPosition(level0Position.x-200, level0Position.y+120)
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

-- 添加底部的bounce
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

--返回按钮 左上角 返回HomeLayer
function ChapterLayer:addBackToHome()
    local click_home = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local IntroLayer = require("view.home.HomeLayer")
            local introLayer = IntroLayer.create()  
            s_SCENE:replaceGameLayer(introLayer)
        end
    end
    -- return to homepage button
    local homeButton = ccui.Button:create("image/chapter/chapter0/backHome.png","image/chapter/chapter0/backHome.png","")
    homeButton:addTouchEventListener(click_home)
    homeButton:ignoreAnchorPointForPosition(false)
    homeButton:setAnchorPoint(0,1)
    homeButton:setPosition(s_LEFT_X + 30  , s_DESIGN_HEIGHT - 32 )
    self:addChild(homeButton)
    
    onAndroidKeyPressed(self, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup == 0 then
            s_CorePlayManager.enterHomeLayer()
        end
    end, function()
    end)
end

--任务按钮  宝箱样式
function ChapterLayer:addTaskBOX()
    local boxButton = ccui.Button:create("image/islandPopup/baoxiang_close.png","","image/islandPopup/baoxiang_open.png")
    boxButton:addTouchEventListener(handler(self,self.onTaskBoxTouch))
    boxButton:setAnchorPoint(0.5,0.5)
    boxButton:ignoreAnchorPointForPosition(false)
    boxButton:setPosition(s_RIGHT_X-180 ,180)
    boxButton:setTouchEnabled(true)
    self:addChild(boxButton)
    boxButton:setBright(true)
    self.boxButton = boxButton

    s_MissionManager:setCanCompleteCallBack(handler(self,self.updataBoxState))

    self:updataBoxState()
end

--更新宝箱状态  在任务界面TaskView里回调
function ChapterLayer:updataBoxState()
    
    local missionlist = s_MissionManager:getMissionList()
    local canComCount = 0
    for k,v in pairs(missionlist) do
        if v[2] == "1" and v[5] ~= 0 then
            canComCount = canComCount + 1
            if self.boxButton ~= nil and not tolua.isnull(self.boxButton) then
                --宝箱晃动
                self.boxButton:stopAllActions()
                local action1 = cc.MoveBy:create(0.1,cc.p(10,0))
                local action2 = action1:reverse()
                local action4 = cc.DelayTime:create(1)
                local action6 = cc.Sequence:create(action1,action2)
                --local action3 = cc.RepeatForever:create(cc.Sequence:create(action1, action2))
                local action3 = cc.Sequence:create(action6,action6,action6,action4)
                local action5 = cc.RepeatForever:create(action3)
                self.boxButton:runAction(action5)
                break
            end
        end
    end
    if canComCount == 0 then
        if self.boxButton ~= nil and not tolua.isnull(self.boxButton) then
            self.boxButton:stopAllActions()
        end
    end
    if s_CURRENT_USER.guideStep < s_guide_step_bag6 and self.boxButton ~= nil and not tolua.isnull(self.boxButton)then
        self.boxButton:setVisible(false)
    end
end

--关闭宝箱
function ChapterLayer:callBox()
    --改变按钮点击状态
    if not tolua.isnull(self.boxButton) then
        self.boxButton:setBright(true)
        self:updataBoxState()
        self.boxButton:setTouchEnabled(true)
    end
end

--更新贝贝豆数量 在任务界面TaskView里回调
function ChapterLayer:updateBean()
    print("更新贝贝豆")
    -- s_CURRENT_USER[DataUser.BEANSKEY]
    local bean = s_CURRENT_USER:getBeans()
    self.beanCount = bean
    self.beanCountLabel:setString(bean)
    -- local increments = tonumber(bean) - self.beanCount
    -- self:shakeBeansUI(increments)
end

--宝箱触摸事件
function ChapterLayer:onTaskBoxTouch(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    -- print("触摸箱子-------")
    --箱子停止抖动
    self.boxButton:stopAllActions()
    --弹出任务面板
    self.boxButton:setBright(false)
    --不可点击
    self.boxButton:setTouchEnabled(false)
    local delayTime = cc.DelayTime:create(0.5)
    local func = cc.CallFunc:create(function ( ... )
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    self:runAction(cc.Sequence:create(delayTime,func))
    local taskview = TaskView.new(handler(self,self.callBox),handler(self, self.updateBean))
    s_SCENE:popup(taskview)
end

-- 添加贝贝豆
function ChapterLayer:addBeansUI()
    self.beans = cc.Sprite:create('image/chapter/chapter0/background_been_white.png')
    self.beans:setPosition(s_RIGHT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(self.beans) 
    self.beanCount = s_CURRENT_USER:getBeans()
    self.beanCountLabel = cc.Label:createWithSystemFont(self.beanCount,'',24)
    self.beanCountLabel:setColor(cc.c4b(0,0,0,255))
    self.beanCountLabel:ignoreAnchorPointForPosition(false)
    self.beanCountLabel:setPosition(self.beans:getContentSize().width * 0.65 , self.beans:getContentSize().height/2)
    self.beans:addChild(self.beanCountLabel)
end

-- function ChapterLayer:shakeBeansUI(beansIncrement)
--     if self.beanLabel ~= nil and self.beanCountLabel~=nil and self.beanCount ~=nil then
--         local beanLabelPostionX = self.beanLabel:getPositionX()
--         local beanLabelPostionY = self.beanLabel:getPositionY()
--         local beanLabelAct1 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY+10))
--         local beanLabelAct2 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY-10))
--         local beanLabelAct3 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY))
--         self.beanLabel:runAction(cc.Sequence:create(beanLabelAct1,beanLabelAct2,beanLabelAct3))

--         self.beanCount = self.beanCount + beansIncrement
--         self.beanCountLabel:setString(self.beanCount)
        
--         local addBeanLabel = cc.Label:createWithSystemFont("+豆豆",'',20)
--         addBeanLabel:setPosition(self.beanCountLabel:getPositionX()-20,self.beanCountLabel:getPositionY()+50)
--         addBeanLabel:setColor(cc.c3b(0,0,0))
--         self.beans:addChild(addBeanLabel)
        
--         local addBeanLabelAct1 = cc.MoveTo:create(0.2,cc.p(addBeanLabel:getPositionX(),addBeanLabel:getPositionY()+10))
--         local addBeanLabelAct2 = cc.FadeOut:create(0.3)
--         addBeanLabel:runAction(cc.Spawn:create(addBeanLabelAct1,addBeanLabelAct2))
--     end
-- end

return ChapterLayer