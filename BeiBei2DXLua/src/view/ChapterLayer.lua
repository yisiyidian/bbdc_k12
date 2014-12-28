require("cocos.init")
require('common.global')

local ChapterLayer = class('ChapterLayer', function() 
    return cc.Layer:create()
end)

local listView
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
    listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setBackGroundImageScale9Enabled(true)
    listView:addEventListener(listViewEvent)
    listView:addScrollViewEventListener(scrollViewEvent)
    listView:removeAllChildren()
    self:addChild(listView)
    
    local fullWidth = s_chapter_layer_width
    listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    -- add bounce
    self:addTopBounce()
    self:addBottomBounce()
    -- add chapter node
    self:addChapterIntoListView('chapter0')
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    
    if string.sub(bookProgress['chapter'],8) - 1 >= 0 then
        self:addChapterIntoListView('chapter1')
    end
    if string.sub(bookProgress['chapter'], 8) - 2 >= 0 then
        self:addChapterIntoListView('chapter2')
    end
    if string.sub(bookProgress['chapter'], 8) - 3 >= 0 then
        self:addChapterIntoListView('chapter3')
    end
    -- add player
    self:addPlayer()
    self:plotDecoration()
    -- scroll to current chapter level
    local progress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    self:scrollLevelLayer(progress['chapter'],progress['level'],0)
    -- check unlock level
    self:checkUnlockLevel()
end

function ChapterLayer:checkUnlockLevel()
    local oldProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    local currentProgress = s_CURRENT_USER.bookProgress:computeCurrentProgress()
    if currentProgress['chapter'] ~= oldProgress['chapter'] then   -- TODO unlock chapter
    
    elseif currentProgress['level'] ~= oldProgress['level'] then   -- unlock level
        local oldLevelIndex = string.sub(oldProgress['level'], 6)
        local currentLevelIndex = string.sub(currentProgress['level'],6)
        local delayTime = 0
        for index = 1, (currentLevelIndex - oldLevelIndex) do
            s_SCENE:callFuncWithDelay(delayTime,function()
                self.chapterDic[oldProgress['chapter']]:plotUnlockLevelAnimation('level'..(oldLevelIndex+index))
                -- move player
                s_SCENE:callFuncWithDelay(0.3,function()
                    local nextLevelPosition = self.chapterDic[oldProgress['chapter']]:getLevelPosition('level'..(oldLevelIndex+index))
                    local action = cc.MoveTo:create(0.5,cc.p(nextLevelPosition.x+100,nextLevelPosition.y))
                    self.player:runAction(action)
                end)
            end)
            delayTime = delayTime + 1
        end
        s_SCENE:callFuncWithDelay(1, function()
            self:scrollLevelLayer(currentProgress['chapter'],currentProgress['level'],delayTime)
            s_CURRENT_USER.bookProgress:updateDataToServer(s_CURRENT_USER.bookKey)
        end)
        s_SCENE:callFuncWithDelay(delayTime, function()
           self:addPlayerNotification("normal") 
        end)   
        
    end
end

function ChapterLayer:addPlayerNotification(type)  -- notification
    self.player:removeAllChildren()
    local notification = cc.Sprite:create('image/chapter/chapter0/notification.png')
    notification:setPosition(self.player:getContentSize().width/2,self.player:getContentSize().height+80)
    self.player:addChild(notification, 100)
    -- TODO show message according to type
    if type == 'normal' then
        local title = cc.Label:createWithSystemFont('当前任务:','',20)
        title:setColor(cc.c3b(0,0,0))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(50,100)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('当前任务:','',20)
        task_name:setColor(cc.c3b(0,0,0))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(50,100)
        notification:addChild(task_name)
    end
end

function ChapterLayer:addPlayer()
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    --self.player = cc.Sprite:create('image/chapter_level/gril_head.png')
    self.player = cc.Sprite:create('image/chapter/chapter0/player.png')
    local position = self.chapterDic[bookProgress['chapter']]:getLevelPosition(bookProgress['level'])
    self.player:setPosition(position.x+100,position.y)
    --self.player:setScale(0.4)
    self.chapterDic[bookProgress['chapter']]:addChild(self.player, 130)
end

function ChapterLayer:addChapterIntoListView(chapterKey)
--    print('chapterKey:'..chapterKey)
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
        listView:addChild(self.chapterDic['chapter0'])
   else    
        local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
        self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
        self.chapterDic[chapterKey]:setPosition(cc.p(0,0))
        --print('contentSize:'..self.chapterDic[chapterKey]:getContentSize().height)
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
        custom_item:setName(chapterKey)  
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
        listView:addChild(self.chapterDic[chapterKey]) 
        -- add connection 
--        local connectionLayer0_1 = require('view.level.connection.Connection0_1')
--        self.chapterDic['connection0_1'] = connectionLayer0_1.create()
--        if string.sub(s_CURRENT_USER.currentChapterKey,8) - string.sub(chapterKey, 8) >= 1 then
--            self.chapterDic['connection0_1']:plotUnlockChapterAnimation()
--        end
--        local item0_1 = ccui.Layout:create()
--        item0_1:setContentSize(self.chapterDic['connection0_1']:getContentSize())
--        self.chapterDic['connection0_1']:setPosition(cc.p(0,0))
--        item0_1:addChild(self.chapterDic['connection0_1'])
--        listView:addChild(item0_1)
    end
end

-- scroll listview to show the specific chapter and level
function ChapterLayer:scrollLevelLayer(chapterKey, levelKey, scrollTime)
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    -- compute listView inner height
    local itemList = listView:getItems()
    local innerHeight = 0
    for i = 1,#itemList do
        innerHeight = innerHeight + itemList[i]:getContentSize().height
    end
    listView:setInnerContainerSize(cc.size(s_chapter_layer_width, innerHeight))
    local levelIndex = string.sub(levelKey, 6)
    local currentLevelCount = levelIndex + 1
    local totalLevelCount = 0
    if bookProgress['chapter'] == 'chapter0' then
        totalLevelCount = 10
    elseif bookProgress['chapter'] == 'chapter1' then
        totalLevelCount = 30
    elseif bookProgress['chapter'] == 'chapter2' then
        totalLevelCount = 60
    else
        totalLevelCount = 100
    end
    if chapterKey == 'chapter0' then
        currentLevelCount = currentLevelCount
    elseif chapterKey == 'chapter1' then
        currentLevelCount = currentLevelCount + 10
    elseif chapterKey == 'chapter2' then
        currentLevelCount = currentLevelCount + 30
    elseif chapterKey == 'chapter3' then
        currentLevelCount = currentLevelCount + 60
    end
    local currentVerticalPercent = currentLevelCount / totalLevelCount * 100
    --print('currentPercent:'..currentVerticalPercent,','..currentLevelCount..','..totalLevelCount)
    if scrollTime - 0 == 0 then
        listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,false)
    else
        listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,true)
    end
    listView:setInertiaScrollEnabled(true)
end

function ChapterLayer:plotUnlockCloudAnimation()
    local action1 = cc.MoveBy:create(0.5, cc.p(-s_DESIGN_WIDTH,0))
    local action2 = cc.MoveBy:create(0.5, cc.p(s_DESIGN_WIDTH,0))
    self.chapterDic['leftCloud']:runAction(action1)
    self.chapterDic['rightCloud']:runAction(action2)
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
    local boat = cc.Sprite:create('image/chapter/chapter0/boat.png')
    local fan = cc.Sprite:create('image/chapter/chapter0/fan.png')
    local beibei = cc.Sprite:create('image/chapter/chapter0/startPlayer.png')
    local level0Position = self.chapterDic['chapter0']:getLevelPosition('level0')
    local boatPosition = cc.p(level0Position.x, level0Position.y+150)
    local fanPosition = cc.p(boatPosition.x+40, boatPosition.y+80)
    boat:setPosition(boatPosition)
    fan:setPosition(fanPosition)
    beibei:setPosition(cc.p(fanPosition.x-40,fanPosition.y-50))
    self.chapterDic['chapter0']:addChild(boat, 130)
    self.chapterDic['chapter0']:addChild(fan,130)
    self.chapterDic['chapter0']:addChild(beibei,130)
    
    --print('chapter0: '..self.chapterDic['chapter0']:getPosition())
--    print('boatPosition:'..boatPosition.x..','..boatPosition.y)
    --print('fanPosition:'..fanPosition)
end

function ChapterLayer:addBottomBounce()
    self.chapterDic['leftCloud'] = cc.Sprite:create('image/chapter/leftCloud.png')
    self.chapterDic['rightCloud'] = cc.Sprite:create('image/chapter/rightCloud.png')
    self.chapterDic['leftCloud']:setAnchorPoint(0, 1)
    self.chapterDic['rightCloud']:setAnchorPoint(0, 1)
    self.chapterDic['leftCloud']:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,100)
    self.chapterDic['rightCloud']:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,100)
    listView:addChild(self.chapterDic['leftCloud'],100)
    listView:addChild(self.chapterDic['rightCloud'],100)
end

return ChapterLayer