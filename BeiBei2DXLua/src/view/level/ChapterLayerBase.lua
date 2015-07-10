-- 基本关卡功能结构类
-- 共享不同关卡的公共方法和数据结构
require("cocos.init")
require('common.global')

s_chapter_resource_start_type = "start"
s_chapter_resource_middle_type = "middle" 
s_chapter_resource_end_type = "end"
s_chapter0_base_height = 3014
s_chapter_layer_width = 854

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local GuideView = require ("view.guide.GuideView")

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

-- 获取某个关卡的位置
-- levelKey: 如'level0'
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

        if t[4] ~= nil then
            if t[4] == "back" then
                self:addChild(object,40)
            elseif t[4] == "add" then
                self:addChild(object,45)
            end
        else
            self:addChild(object,50)
        end
    end
    return object
end

-- 播放某个关卡解锁时的动画
-- levelKey: 关卡key
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

-- 延时调用某个方法
-- delay:延迟时间
-- func:方法
function ChapterLayerBase:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end


--摆放每个单元的小岛  eq:unit1
--levelIndex    关卡索引
function ChapterLayerBase:plotDecorationOfLevel(levelIndex)
    local levelPosition = self.levelPos[levelIndex]    
    
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print('BaseLayer:levelbutton '..sender:getName()..' touched...')                
            self:addPopup(sender:getName())
        end
    end

    local levelButton = ccui.Button:create('image/chapter/chapter0/island.png','image/chapter/chapter0/island.png','image/chapter/chapter0/island.png')
    levelButton:setScale9Enabled(true)
    levelButton:setPosition(levelPosition)
    levelButton:setName(levelIndex)
    levelButton:addTouchEventListener(touchEvent)
    self:addChild(levelButton, 129)
    
    local currentIndex = levelIndex
    -- to do get level state
    local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    local levelState = 0
    local coolingDay = 0 
    local currentTaskBossIndex = -1


    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] + 0 == 0 and currentTaskBossIndex == -1 and bossInfo["unitState"] - 5 < 0 then
            currentTaskBossIndex = bossID - 1
        end
        print('bossID:'..bossID..','..levelIndex)
        if bossID - (levelIndex + 1) == 0 then
            levelState = bossInfo["unitState"] 
            coolingDay = bossInfo["coolingDay"] + 0
        end
    end
    
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 0
    local currentChapterKey = 'chapter'..math.floor(currentProgress/10)
    
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("levelIndex"..levelIndex)
    print("currentTaskBossIndex"..currentTaskBossIndex)
    print("levelState"..levelState)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

    -- if levelState == 0 then
    --     local deco = sp.SkeletonAnimation:create("spine/chapterlevel/beibeidaizi.json","spine/chapterlevel/beibeidaizi.atlas",1)
    --     --local deco = sp.SkeletonAnimation:create("spine/tutorial/jieshao1.json","spine/tutorial/jieshao1.atlas",1)
    --     deco:setPosition(levelPosition.x-60,levelPosition.y-10)
    --     deco:setAnchorPoint(1,1)
    --     deco:addAnimation(0, 'animation', true)
    --     self:addChild(deco, 130)
    --     -- local deco = cc.Sprite:create('image/chapter/elements/tubiao_daizi_tanchu_xiaoguan.png')
    --     -- deco:setPosition(levelPosition.x,levelPosition.y+20)
    --     -- self:addChild(deco, 130)
    -- else
    -- if false then
    if levelState == 0 or (levelState >= 1 and levelState <= 4 and levelIndex == currentTaskBossIndex) then
        
        local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
        summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
        summaryboss:setAnchorPoint(1,1)
        summaryboss:addAnimation(0, 'jianxiao', true)
        summaryboss:setScale(0.7)
        self:addChild(summaryboss, 140)
    else
        -- plot level number
        self:plotLevelNumber('level'..levelIndex)
    end

end

-- -- ｛没用到 
-- function ChapterLayerBase:checkLevelStateBeforePopup(levelIndex) 

--     local bossList = s_LocalDatabaseManager.getAllUnitInfo()
--     local state, coolingDay
--     for bossID, bossInfo in pairs(bossList) do
--         if bossID - (levelIndex + 1) == 0 then
--             state = bossInfo["unitState"] + 0
--             coolingDay = bossInfo["coolingDay"] + 0
--         end
--     end
    
--     if state >= 1 and active ~= 0 then
--         local WordLibrary = require("view.islandPopup.WordLibraryPopup")
--         local wordLibrary = WordLibrary.create(levelIndex)
--         s_SCENE.popupLayer:addChild(wordLibrary)   
--         back:runAction(cc.MoveBy:create(0.2,cc.p(800,0)))
--         wordLibrary.close = function ()
--             back:runAction(cc.MoveBy:create(0.2,cc.p(-800,0)))
--         end
--     else
--         local playAnimation = true
--         self:addPopup(levelIndex,playAnimation)
--         print("self:addPopup(levelIndex,playAnimation)"..tostring(playAnimation))
--     end
-- end
-- --没用到 ｝

-- 添加某个关卡点击时的弹窗
-- levelIndex:关卡索引
-- playAnimation: 是否播放动画
function ChapterLayerBase:addPopup(levelIndex,playAnimation)
    print("ChapterLayerBase:addPopup(levelIndex,playAnimation)"..tostring(playAnimation))
    local StartPopup = require("playmodel.popup.StartPopup")
    local startPopup = StartPopup.new(levelIndex + 1)
    s_SCENE:popup(startPopup)
end

-- 为关卡上添加装饰品（如章鱼boss，恐龙boss)
function ChapterLayerBase:plotDecoration()
    print("AAAs_CURRENT_USER.bookKey:"..s_CURRENT_USER.bookKey)
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentLevelIndex = levelInfo
    
    local chapterIndex = string.sub(self.chapterKey, 8)
    -- add state information
    print("currentLevelIndex:"..currentLevelIndex)
    for levelIndex, levelPosition in pairs(self.levelPos) do
        -- add level button
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                local levelIndex = string.sub(sender:getName(), 10)
                local lockSprite = self:getChildByName('lock'..levelIndex)
                local lockLayer = self:getChildByName('lockLayer'..levelIndex)
                local action1 = cc.ScaleTo:create(0.12, 1.15, 0.85)
                local action2 = cc.ScaleTo:create(0.12, 0.85, 1.15)
                local action3 = cc.ScaleTo:create(0.12, 1.08, 0.92)
                local action4 = cc.ScaleTo:create(0.12, 0.92, 1.08)
                local action5 = cc.ScaleTo:create(0.12, 1.0, 1.0)
                local action6 = cc.Sequence:create(action1, action2, action3, action4, action5, nil)

                local l1 = cc.MoveBy:create(0.1, cc.p(10,0))
                local l2 = cc.MoveBy:create(0.1, cc.p(-20,0))
                local l3 = cc.MoveBy:create(0.1, cc.p(20,0))

                local l4 = cc.Repeat:create(cc.Sequence:create(l2, l3),3)
                local l5 = cc.MoveBy:create(0.1, cc.p(-10, 0))
                lockSprite:runAction(cc.Sequence:create(l1,l4, l5,nil))
                lockLayer:runAction(action6)
            end
        end
        if (levelIndex - currentLevelIndex) > 0 then
            print("levelIndex:"..levelIndex)
            --未开启的单元
            local bookMaxUnitID = s_LocalDatabaseManager.getBookMaxUnitID(s_CURRENT_USER.bookKey)
            if levelIndex - bookMaxUnitID < 0 then 
                local lockIsland = ccui.Button:create('image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png')
                lockIsland:setScale9Enabled(true)
                lockIsland:setName('lockLayer'..levelIndex)
                lockIsland:addTouchEventListener(touchEvent)

                local lock = cc.Sprite:create('image/chapter/chapter0/unit_lock.png')
                lock:setName('lock'..levelIndex)
                lockIsland:setPosition(levelPosition)
                lock:setPosition(levelPosition)

                print('s_book:')
                print_lua_table(s_BookUnitName[s_CURRENT_USER.bookKey])
                local unitName = split(s_BookUnitName[s_CURRENT_USER.bookKey][''..(levelIndex+1)],'_')

                -- test
                -- local unitName = split('21_3','_')
                -- add text
                local unitText = cc.Sprite:create('image/chapter/chapter0/unit_black.png')
                -- if true then
                if s_CURRENT_USER.bookKey == 'kwekwe' and #unitName > 1 and unitName[1] - 21 == 0 then
                    unitText = cc.Sprite:create('image/chapter/realwordlock.png')
                end

                unitText:setPosition(lock:getContentSize().width/2, lock:getContentSize().height/2+10)
                lock:addChild(unitText, 130)

                if #unitName == 1 then
                    local number = cc.Label:createWithSystemFont(''..unitName[1],'',35)
                    number:setPosition(lock:getContentSize().width/2, lock:getContentSize().height/2-20)
                    number:setColor(cc.c3b(164, 125, 46))
                    lock:addChild(number, 130)
                else
                    if s_CURRENT_USER.bookKey == 'kwekwe' and #unitName > 1 and unitName[1] - 21 == 0 then
                    -- if true then
                        local number2 = cc.Label:createWithSystemFont(unitName[2],'',35)
                        number2:setPosition(lock:getContentSize().width/2, lock:getContentSize().height/2-20)
                        number2:setColor(cc.c3b(164, 125, 46))
                        lock:addChild(number2, 130)
                    else
                        local number = cc.Label:createWithSystemFont(''..unitName[1],'',35)
                        number:setPosition(lock:getContentSize().width/2-5, lock:getContentSize().height/2-20)
                        number:setColor(cc.c3b(164, 125, 46))
                        lock:addChild(number, 130)
                        local number2 = cc.Label:createWithSystemFont('('..unitName[2]..')','',23)
                        -- local number2 = cc.Label:createWithSystemFont(unitName[2],'',23)
                        number2:setPosition(lock:getContentSize().width/2+23, lock:getContentSize().height/2-22)
                        number2:setColor(cc.c3b(164, 125, 46))
                        lock:addChild(number2, 130)
                    end
                end

                self:addChild(lock,130)
                self:addChild(lockIsland,120)
            end
        else
            --已开启的单元
            self:plotDecorationOfLevel(levelIndex)
        end  
    end
end

-- 添加关卡上数字显示内容
-- levelKey: 关卡索引key，如'level0'
function ChapterLayerBase:plotLevelNumber(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelPosition = self:getLevelPosition(levelKey)
    local chapterIndex = string.sub(self.chapterKey, 8)
--    if levelIndex - 0 == 0 and chapterIndex - 0 == 0 then  -- start 
--        local start = cc.Sprite:create('image/chapter/chapter0/start.png')
--        start:setPosition(levelPosition.x, levelPosition.y)
--        self:addChild(start, 130)
--    else
        -- print_lua_table(s_BookUnitName[s_CURRENT_USER.bookKey])
        local unitName = split(s_BookUnitName[s_CURRENT_USER.bookKey][''..(levelIndex+1)],'_')
        local unitText = cc.Sprite:create('image/chapter/chapter0/unit.png')
        -- if true then 
        if s_CURRENT_USER.bookKey == 'kwekwe' and #unitName > 1 and unitName[1] - 21 == 0 then
            unitText = cc.Sprite:create('image/chapter/realword.png')
        end
        unitText:setPosition(levelPosition.x-5, levelPosition.y + 35)
        self:addChild(unitText, 130)
        
        -- test 
        -- local unitName = split("3",'_')
        if #unitName == 1 then
            local number = ccui.TextBMFont:create()
            number:setFntFile('font/number_inclined.fnt')
            number:setString(unitName[1])
            number:setScale(0.85)
            number:setPosition(levelPosition.x-5, levelPosition.y-10)
            self:addChild(number,130)
        else
            -- local tag = cc.Label:createWithSystemFont('( )','',38)
            -- tag:setPosition(levelPosition.x+10, levelPosition.y - 20)
            -- tag:setColor(cc.c3b(255, 255, 255))
            -- self:addChild(tag, 130)

            -- if true then
            if s_CURRENT_USER.bookKey == 'kwekwe' and #unitName > 1 and unitName[1] - 21 == 0 then
                local number2 = ccui.TextBMFont:create()
                number2:setFntFile('font/number_inclined.fnt')
                number2:setString(unitName[2])
                number2:setScale(0.8)
                number2:setPosition(levelPosition.x, levelPosition.y-13)
                self:addChild(number2,130)
            else
                local number1 = ccui.TextBMFont:create()
                number1:setFntFile('font/number_inclined.fnt')
                --number:setColor(cc.c3b(56,26,23))
                number1:setString(unitName[1])
                number1:setScale(0.8)
                number1:setPosition(levelPosition.x-25, levelPosition.y-10)
                self:addChild(number1,130)
                local number2 = ccui.TextBMFont:create()
                number2:setFntFile('font/number_inclined.fnt')
                number2:setString(unitName[2])
                number2:setScale(0.55)
                number2:setPosition(levelPosition.x+20, levelPosition.y-18)
                self:addChild(number2,130)
                local leftBracket = cc.Sprite:create('image/chapter/leftBracket.png')
                leftBracket:setScale(0.4)
                leftBracket:setPosition(levelPosition.x+5, levelPosition.y-23)
                local rightBracket = cc.Sprite:create('image/chapter/rightBracket.png')
                rightBracket:setPosition(levelPosition.x+35, levelPosition.y-23)
                rightBracket:setScale(0.4)
                self:addChild(leftBracket,130)
                self:addChild(rightBracket,130)
            end
        end
--    end

 
end

function ChapterLayerBase:loadResource()
end

return ChapterLayerBase
