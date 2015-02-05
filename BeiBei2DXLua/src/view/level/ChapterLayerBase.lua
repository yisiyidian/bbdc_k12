require("cocos.init")
require('common.global')

s_chapter_resource_start_type = "start"
s_chapter_resource_middle_type = "middle" 
s_chapter_resource_end_type = "end"
s_chapter0_base_height = 3014
s_chapter_layer_width = 854

local ChapterLayerBase = class('ChapterLayerBase',function() 
    return ccui.Widget:create()
    --return cc.Layer:create()
end)

function ChapterLayerBase.create(chapterKey, startLevelKey)
    local layer = ChapterLayerBase.new(chapterKey, startLevelKey)
    return layer
end


function ChapterLayerBase:ctor(chapterKey, startLevelKey)
    self.chapterKey = chapterKey
    self.startLevelKey = startLevelKey
    self.levelPos = {}
end

function ChapterLayerBase:getLevelPosition(levelKey)
    for k, v in pairs(self.levelPos) do
        if string.sub(levelKey, 6) - k == 0 then
            return v
        end
    end
end

--t[1]: res
--t[2]: anchorPoint
--t[3]: position
function ChapterLayerBase:createObjectForResource(t)
    local object
    if t[1]~=nil then 
        if t[4] ~=nil and t[4]=='island' then
            -- define touchEvent
            local function touchEvent(sender,eventType)
                if eventType == ccui.TouchEventType.ended then
                    print('levelbutton '..sender.getName()..' touched...')
                end
            end
            print('create level button')
            object = ccui.Button:create(t[1],t[1],t[1])
            object:setScale9Enabled(true)
            object:setName(t[5])
            object:addTouchEventListener(touchEvent)
        else
            object = cc.Sprite:create(t[1])
        end
        
        if t[2]~=nil then 
            object:setAnchorPoint(t[2].x,t[2].y)
        end

        if t[3]~=nil then
            object:setPosition(t[3].x,t[3].y)
        end
--        if t[4]~=nil and t[4]== "island" then
--            object:setTag(islandTag)
--            islandTag=islandTag + 1
--        end
        self:addChild(object,50)
    end
    return object
end

function ChapterLayerBase:plotUnlockLevelAnimation(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local lockSprite = self:getChildByName('lock'..levelIndex)
    local lockLayer = self:getChildByName('lockLayer'..levelIndex)
    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),2)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0))  
    local action6 = cc.FadeOut:create(0.1)
    local action = cc.Sequence:create(action1, action4, action5, action6, nil)
    if lockSprite ~= nil then
        lockSprite:runAction(action)
    end

    local action7 = cc.DelayTime:create(0.6)
    local action8 = cc.FadeOut:create(0.1)
    if lockLayer ~= nil then
        lockLayer:runAction(cc.Sequence:create(action7, action8))
    end
    if lockSprite ~= nil or lockLayer ~= nil then
        s_SCENE:callFuncWithDelay(0.7,function()
            self:plotDecorationOfLevel(levelIndex-0)
        end)
    end
end


function ChapterLayerBase:plotDecorationOfLevel(levelIndex)
    --local levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,self.chapterKey,'level'..levelIndex
    local levelPosition = self.levelPos[levelIndex]
    -- plot level number
    self:plotLevelNumber('level'..levelIndex)

    local currentIndex = levelIndex
    -- to do get level state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local levelState
    for bossID, bossInfo in pairs(bossList) do
        if bossID - (levelIndex + 1) == 0 then
            levelState = bossInfo["typeIndex"] 
        end
    end
    -- check active
    local todayReviewBoss = s_LocalDatabaseManager.getTodayReviewBoss()
    local active
    if #todayReviewBoss == 0 or todayReviewBoss[0] - (levelIndex + 1) ~= 0 then
        active = 0
    else
        active = 1
    end
    print('####active'..active..','..levelState)
--    if levelConfig['type'] == 1 then
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 0
    local currentChapterKey = 'chapter'..math.floor(currentProgress/10)
    
    
    -- TODO add review boss position
    -- TODO check level state
--    local levelState = math.random(0, 3)
    if levelState == 0 then
        local deco = cc.Sprite:create('image/chapter/elements/big_tubiao_daizi_tanchu_xiaoguan.png')
        deco:setPosition(levelPosition.x+10,levelPosition.y+20)
        self:addChild(deco, 130)
    elseif levelState == 1 then
        local deco = cc.Sprite:create('image/chapter/elements/big_tubiao_chuizi_tanchu_xiaoguan.png')
        deco:setPosition(levelPosition.x+10,levelPosition.y+20)
        self:addChild(deco, 130)
    elseif levelState == 2 then
        local reviewBoss = sp.SkeletonAnimation:create('spine/3fxzlsxuanxiaoguandiaoluo.json', 'spine/3fxzlsxuanxiaoguandiaoluo.atlas', 1)
        reviewBoss:addAnimation(0, '1', false)
        s_SCENE:callFuncWithDelay(1,function()
            reviewBoss:addAnimation(1, '2', true)
        end)
        reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
        self:addChild(reviewBoss, 140)
    elseif levelState == 3 then 
        local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
        summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
        summaryboss:setAnchorPoint(1,1)
        summaryboss:addAnimation(0, 'jianxiao', true)
        summaryboss:setScale(0.7)
        self:addChild(summaryboss, 140)
    end
end

function ChapterLayerBase:addPopup(levelIndex)
    -- TODO check level state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local state
    for bossID, bossInfo in pairs(bossList) do
        if bossID - (levelIndex + 1) == 0 then
            state = bossInfo["typeIndex"] 
        end
    end
    -- check active
    local todayReviewBoss = s_LocalDatabaseManager.getTodayReviewBoss()
    local active
--    print('###todayReviewBoss'..#todayReviewBoss)
    if #todayReviewBoss == 0 or todayReviewBoss[0] - (levelIndex + 1) ~= 0 then
        active = 0
    else
        active = 1
    end
    
    local levelPosition = self:getLevelPosition('level'..levelIndex)
    local function taskEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            -- TODO add response
            local info = split(sender:getName(), '|')
            local bossID = info[1] + 1
            local state = info[2] + 0
            local active = info[3] + 0
            
            if state == 0 then
            elseif state == 1 then
            elseif state == 2 then
            elseif state == 3 then
            elseif state == 4 then
            elseif state == 5 then
                if active == 0 then
                elseif active == 1 then
                end
            elseif state == 6 then
                if active == 0 then
                elseif active == 1 then
                end
            elseif state == 7 then
                if active == 0 then
                elseif active == 1 then
                end
            end
        end
    end
--    state = math.random(0, 7)
--    print('state is '..state)
    local back, taskButton, tick
    if state == 0 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_1.png')       
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_1.png','image/chapter/popup/button_unpressed_xiaoguantancu_1.png','image/chapter/popup/button_unpressed_xiaoguantancu_1.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-200)
    elseif state == 1 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_2.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_2.png','image/chapter/popup/button_pressed_xiaoguantancu_2.png','image/chapter/popup/button_unpressed_xiaoguantancu_2.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-280)
    elseif state == 2 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_3.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_3.png','image/chapter/popup/button_unpressed_xiaoguantancu_3.png','image/chapter/popup/button_unpressed_xiaoguantancu_3.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-360)
    elseif state == 3 then    
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_4.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_4.png','image/chapter/popup/button_unpressed_xiaoguantancu_4.png','image/chapter/popup/button_unpressed_xiaoguantancu_4.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-450)
    elseif state == 4 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_5.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_5.png','image/chapter/popup/button_unpressed_xiaoguantancu_5.png','image/chapter/popup/button_unpressed_xiaoguantancu_5.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-540)
    elseif state == 5 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_6.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_6.png','image/chapter/popup/button_unpressed_xiaoguantancu_6.png','image/chapter/popup/button_unpressed_xiaoguantancu_6.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-630)
    elseif state == 6 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_7.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_7.png','image/chapter/popup/button_unpressed_xiaoguantancu_7.png','image/chapter/popup/button_unpressed_xiaoguantancu_7.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-720)
    elseif state == 7 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_8.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_8.png','image/chapter/popup/button_unpressed_xiaoguantancu_8.png','image/chapter/popup/button_unpressed_xiaoguantancu_8.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-810) 
    elseif state == 8 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_9.png')
    end
    
    if state ~= 8 then
        taskButton:setScale9Enabled(true)
        taskButton:setName(levelIndex..'|'..state..'|'..active)
        taskButton:addTouchEventListener(taskEvent)
        back:addChild(taskButton)
        if state ~= 0 then
            tick = cc.Sprite:create('image/chapter/popup/duigo_green_xiaoguan_tanchu.png')
            tick:setPosition(taskButton:getPositionX()+165, taskButton:getPositionY() + 125)
            tick:setScale(2.0)
            local action1 = cc.ScaleTo:create(0.5, 2.0)
            local action2 = cc.ScaleTo:create(0.5, 1.0)
            local action3 = cc.Sequence:create(action1, action2)
            tick:runAction(action2)
            back:addChild(tick, 10) 
        end
    end
    -- add close button
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end
    
    local function wordEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local WordLibrary = require("view.islandPopup.WordLibraryPopup")
            local boss = s_LocalDatabaseManager.getBossInfo(levelIndex + 1)
            local wordLibrary = WordLibrary.create(boss)
            s_SCENE:popup(wordLibrary)    
        end
    end
    
    local closeButton = ccui.Button:create('image/button/button_close.png','image/button/button_close.png','image/button/button_close.png')
    closeButton:setScale9Enabled(true)
    closeButton:setPosition(back:getContentSize().width-40, back:getContentSize().height-40)
    closeButton:addTouchEventListener(touchEvent)
    
    local wordButton = ccui.Button:create('image/chapter/popup/button_change_to_ciku.png','image/chapter/popup/button_change_to_ciku.png','image/chapter/popup/button_change_to_ciku.png')
    wordButton:setScale9Enabled(true)
    wordButton:setPosition(100, back:getContentSize().height-50)
    wordButton:addTouchEventListener(wordEvent)
    
    back:setPosition(cc.p((s_DESIGN_WIDTH-s_LEFT_X)/2, 500))
    back:addChild(closeButton)
    back:addChild(wordButton)
    s_SCENE:popup(back)

end

function ChapterLayerBase:plotDecoration()
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentLevelIndex = levelInfo
    local currentChapterIndex = math.floor(levelInfo / s_islands_per_page)
    local chapterIndex = string.sub(self.chapterKey, 8)
    -- add state information
--    local bossList = s_LocalDatabaseManager.getAllBossInfo()
--    print('######## boss list ########')
--    print_lua_table(bossList)
    
    for levelIndex, levelPosition in pairs(self.levelPos) do
        -- add level button
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                print('BaseLayer:levelbutton '..sender:getName()..' touched...')                
                -- TODO check level state
                --if state == 1 then
                self:addPopup(sender:getName())
            end
        end
        
        if (levelIndex - currentLevelIndex) > 0 then
            local lockIsland = cc.Sprite:create('image/chapter/chapter0/lockisland2.png')
            lockIsland:setName('lockLayer'..levelIndex)
            local lock = cc.Sprite:create('image/chapter/chapter0/lock.png')
            lock:setName('lock'..levelIndex)
            lockIsland:setPosition(levelPosition)
            lock:setPosition(levelPosition)
            self:addChild(lockIsland,120)
            self:addChild(lock,130)
        else
            local levelButton = ccui.Button:create('image/chapter/chapter0/island.png','image/chapter/chapter0/island.png','image/chapter/chapter0/island.png')
            levelButton:setScale9Enabled(true)
            levelButton:setPosition(levelPosition)
            levelButton:setName(levelIndex)
            levelButton:addTouchEventListener(touchEvent)
            self:addChild(levelButton, 40)
            self:plotDecorationOfLevel(levelIndex)
        end  
    end
end

function ChapterLayerBase:plotLevelNumber(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelPosition = self:getLevelPosition(levelKey)
    local chapterIndex = string.sub(self.chapterKey, 8)
    if levelIndex - 0 == 0 and chapterIndex - 0 == 0 then  -- start 
        local start = cc.Sprite:create('image/chapter/chapter0/start.png')
        start:setPosition(levelPosition.x, levelPosition.y)
        self:addChild(start, 130)
    else
        local number = ccui.TextBMFont:create()
        number:setFntFile('font/number_inclined.fnt')
        --number:setColor(cc.c3b(56,26,23))
        number:setString(levelIndex+1)
        number:setPosition(levelPosition.x, levelPosition.y+3)
        self:addChild(number,130)
    end

 
end

function ChapterLayerBase:loadResource()
end

return ChapterLayerBase
