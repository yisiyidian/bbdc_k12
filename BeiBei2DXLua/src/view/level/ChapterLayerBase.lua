require("cocos.init")
require('common.global')

s_chapter_resource_start_type = "start"
s_chapter_resource_middle_type = "middle" 
s_chapter_resource_end_type = "end"
s_chapter0_base_height = 3014

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
        object = cc.Sprite:create(t[1])
        if t[2]~=nil then 
            object:setAnchorPoint(t[2].x,t[2].y)
        end

        if t[3]~=nil then
            object:setPosition(t[3].x,t[3].y)
        end
        if t[4]~=nil and t[4]== "island" then
            object:setTag(islandTag)
            islandTag=islandTag+1
        end
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
            self:plotDecorationOfLevel(levelIndex-'0')
        end)
    end
end


function ChapterLayerBase:plotDecorationOfLevel(levelIndex)
    --local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,self.chapterKey,'level'..levelIndex
    local levelPosition = self.levelPos[levelIndex]
    -- plot level number
    self:plotLevelNumber('level'..levelIndex)
    -- check random summary boss

    local currentIndex = levelIndex
    if self.chapterKey == 'chapter1' then
        currentIndex = currentIndex + 10
    elseif self.chapterKey == 'chapter2' then
        currentIndex = currentIndex + 30
    elseif self.chapterKey == 'chapter3' then
        currentIndex = currentIndex + 60
    end
    
    local bossList = s_CURRENT_USER.bookProgress:getBossList(s_CURRENT_USER.bookKey)
    local summaryboss = split(bossList,'|')
    local checkSummaryBoss = false
    for i = 1, #summaryboss do
--        print('summarybossIndex:'..summaryboss[i])
        if summaryboss[i] == '' then break end
        if summaryboss[i] - currentIndex == 0 then
            checkSummaryBoss = true
            break
        end
    end
--    print('######check summaryboss#####')
--    print(bossList)
    
    -- chest
    local chestList = split(s_CURRENT_USER.chestList, '|')
    local checkChest = false
    for i = 1, #chestList do
        --print('summarybossIndex:'..summaryboss[i])
        if chestList[i] == '' then break end
        if chestList[i] - currentIndex == 0 then
            checkChest = true
            break
        end
    end

    AnalyticsChestGeneratedCnt(#chestList)
    
--    if levelConfig['type'] == 1 then
    local currentProgress = s_CURRENT_USER.bookProgress:computeCurrentProgress()
    if s_DATABASE_MGR.getGameState() == s_gamestate_reviewbossmodel and currentProgress['chapter'] == self.chapterKey and currentProgress['level'] == 'level'..levelIndex then
        -- plot review boss
        local reviewBoss = sp.SkeletonAnimation:create('spine/3fxzlsxuanxiaoguandiaoluo.json', 'spine/3fxzlsxuanxiaoguandiaoluo.atlas', 1)
        reviewBoss:addAnimation(0, '1', false)
        s_SCENE:callFuncWithDelay(1,function()
            reviewBoss:addAnimation(1, '2', true)
        end)
        reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
        self:addChild(reviewBoss, 140)
    elseif checkSummaryBoss then
        local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
        summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
--                summaryboss:setAnchorPoint(1,1)
        -- chapter layer
        local notification = cc.Sprite:create('image/chapter/chapter0/notification.png')
        notification:setPosition(summaryboss:getContentSize().width+130,summaryboss:getContentSize().height+320)
        summaryboss:addChild(notification, 100)
        summaryboss:setName('summaryboss'..currentIndex)
        local title = cc.Label:createWithSystemFont('当前任务','',28)
        title:setColor(cc.c3b(0,0,0))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(30,110)
        notification:addChild(title)
        
        
        local task_name = cc.Label:createWithSystemFont('打败鲶鱼boss','',25)
        task_name:setColor(cc.c3b(0,0,0))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(30,80)
        notification:addChild(task_name)
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                -- TODO go to summaryboss
--                s_CorePlayManager.initTotalPlay()
                    local index = string.sub(sender:getName(),12)
                    local summaryboss = require('view.summaryboss.SummaryBossLayer')
                    local layer = summaryboss.create(index,1)
                    
                    layer:setAnchorPoint(0.5,0)
                    s_SCENE:replaceGameLayer(layer)
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)
        start:setName('summaryboss'..string.sub('level'..levelIndex, 6))
        -- add button title
        local button_title = cc.Label:createWithSystemFont('开始挑战','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
--        print('summaryboss position:'..summaryboss:getPosition())
        
        summaryboss:addAnimation(0, 'jianxiao', true)
        summaryboss:setScale(0.7)
        self:addChild(summaryboss, 150)
    elseif checkChest then
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then                
                local beansCount = 3
                local i = string.sub(sender:getName(), 6)
                s_CURRENT_USER:removeChest(i)
                -- add beans
                s_CURRENT_USER:addBeans(beansCount)
                sender:setVisible(false)

                local box
                local callback1 = function()
                    box = sp.SkeletonAnimation:create("spine/baoxiangdakai.json", 'spine/baoxiangdakai.atlas',1)
                    box:addAnimation(0, 'animation', false)
                    box:setPosition(sender:getPosition())
                    self:addChild(box,130)
                    box:setScale(0.9)
                end

                local partical
                local callback2 = function()
                    partical = cc.ParticleSystemQuad:create('image/chapter/chapter0/chest.plist')
                    partical:setPositionX(box:getPositionX()+80)
                    partical:setPositionY(box:getPositionY()+80)
                    partical:setScale(0.8)
                    self:addChild(partical,130)
                end
                
                -- add beans
                local beanParticle
                local callback4 = function(sender,table)
                    local bean = table[1]
                    beanParticle = cc.ParticleSystemQuad:create("image/chapter/chapter0/beanParticle.plist")
                    beanParticle:setPosition(bean:getPosition())
                    beanParticle:setScale(0.4)
                    self:addChild(beanParticle,140)
                end

                local callback5 = function(sender,table)
                    local bean = table[1]
                    if bean ~=nil then
                        bean:removeFromParent() 
                    end
                end

                local callback3 = function()
                    for var=0, beansCount-1 do

                        local offsetHeight
                        if var%2 ==0 then
                            offsetHeight = -20
                        else
                            offsetHeight = 20
                        end

                        bean = cc.Sprite:create('image/chapter/chapter0/bean.png')
                        bean:setScale(0.9)
                        local beanWidth = bean:getContentSize().width * bean:getScale() *4/(beansCount-1)
                        bean:setPosition(box:getPositionX()+60, box:getPositionY()+50)
                        self:addChild(bean,130)

                        local offsetWidth = beanWidth * var
                        local moveAct1 = cc.MoveTo:create(0.3,cc.p(box:getPositionX()+offsetWidth,bean:getPositionY()+120+offsetHeight))
                        local moveAct2 = cc.MoveBy:create(0.1,cc.p(0,-4))
                        bean:runAction(cc.Sequence:create(moveAct1,
                                                          moveAct2,
                                                          cc.DelayTime:create(0.4),
                                                          cc.CallFunc:create(callback4,{bean}),
                                                          cc.DelayTime:create(0.05),
                                                          cc.CallFunc:create(callback5,{bean})))
                    end
                end

                local sequence =  cc.Sequence:create(cc.CallFunc:create(callback1),
                                                     cc.DelayTime:create(0.6),
                                                     cc.CallFunc:create(callback2),
                                                     cc.DelayTime:create(0.1),
                                                     cc.CallFunc:create(callback3))
                self:runAction(sequence)
                AnalyticsChestCollectedCnt(sender:getName())
            end
        end
        local chestButton = ccui.Button:create('image/chapter/chapter0/chest.png','image/chapter/chapter0/chest.png','image/chapter/chapter0/chest.png')
        chestButton:setScale9Enabled(true)
        chestButton:setPosition(levelPosition.x-75, levelPosition.y-55)
        chestButton:setAnchorPoint(0,0)
        chestButton:setName('chest'..currentIndex)
        chestButton:setScale(0.9)
        self:addChild(chestButton,150)
        chestButton:addTouchEventListener(touchEvent)
    elseif levelIndex % 8 == 0 then
        local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_san_1.json','spine/xuanxiaoguan1_san_1.atlas',1)
        deco:addAnimation(0,'animation',true)
        deco:setPosition(levelPosition.x+10,levelPosition.y+20)
        self:addChild(deco, 130)
    elseif levelIndex % 8 == 1 then
        local deco = cc.Sprite:create('res/image/chapter_level/xuanxiaoguan1_yezi.png')
        deco:setPosition(levelPosition.x+10, levelPosition.y-30)
        self:addChild(deco, 130)    
    elseif levelIndex % 8 == 2 then
        local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_san_2.json','spine/xuanxiaoguan1_san_2.atlas',1)
        deco:addAnimation(0,'animation',true)
        deco:setPosition(levelPosition.x-85,levelPosition.y)
        self:addChild(deco, 130)    
    elseif levelIndex % 8 == 3 then
            local deco = cc.Sprite:create('res/image/chapter_level/xuanxiaoguan1_pangxie.png')
        deco:setPosition(levelPosition.x+50, levelPosition.y)
        self:addChild(deco, 130)    
    elseif levelIndex % 8 == 4 then
        local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_shu_1.json','spine/xuanxiaoguan1_shu_1.atlas',1)
        deco:addAnimation(0,'animation',true)
        deco:setPosition(levelPosition.x-30,levelPosition.y+10)
        self:addChild(deco, 130)    
    elseif levelIndex % 8 == 5 then
        local deco = cc.Sprite:create('res/image/chapter_level/xuanxiaoguan1_yinliao.png')
        deco:setPosition(levelPosition.x+70,levelPosition.y+ 40)
        self:addChild(deco, 130)    
    elseif levelIndex % 8 == 6 then
        local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_shu_2.json','spine/xuanxiaoguan1_shu_2.atlas',1)
        deco:addAnimation(0,'animation',true)
        deco:setPosition(levelPosition.x,levelPosition.y-20)
        self:addChild(deco, 130)    
    elseif levelIndex % 8 == 7 then
        local deco = cc.Sprite:create('image/chapter_level/xuanxiaoguan1_youyongquan.png')
        deco:setPosition(levelPosition.x+100,levelPosition.y+ 40)
        self:addChild(deco, 130)       
    end
end

function ChapterLayerBase:plotDecoration()
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    local currentLevelIndex = string.sub(bookProgress['level'],6)
    local currentChapterIndex = string.sub(bookProgress['chapter'],8)
    local chapterIndex = string.sub(self.chapterKey, 8)
    for levelIndex, levelPosition in pairs(self.levelPos) do
        if (levelIndex - currentLevelIndex > 0 and chapterIndex == currentChapterIndex)  or chapterIndex - currentChapterIndex > 0 then
            local lockIsland = cc.Sprite:create('image/chapter/chapter0/lockisland2.png')
            lockIsland:setName('lockLayer'..levelIndex)
            local lock = cc.Sprite:create('image/chapter/chapter0/lock.png')
            lock:setName('lock'..levelIndex)
            lockIsland:setPosition(levelPosition)
            lock:setPosition(levelPosition)
            self:addChild(lockIsland,120)
            self:addChild(lock,130)
        else
            self:plotDecorationOfLevel(levelIndex)
        end
        -- decoration
        
    end
end

function ChapterLayerBase:plotLevelNumber(levelKey)
    --local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,self.chapterKey,levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelPosition = self:getLevelPosition(levelKey)
    local chapterIndex = string.sub(self.chapterKey, 8)
    local avgWordCount = math.floor(s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words / 99)
    --print('####levelIndex:',levelIndex,',',chapterIndex)
    if levelIndex - 0 == 0 and chapterIndex - 0 == 0 then  -- start 
--        local title = cc.Label:createWithSystemFont('Start','',40)
--        title:setColor(cc.c3b(255,255,255))
--        title:ignoreAnchorPointForPosition(false)
--        title:setAnchorPoint(0,0)
--        title:setPosition(levelPosition.x, levelPosition.y)
--        self:addChild(title, 130)
        local start = cc.Sprite:create('image/chapter/chapter0/start.png')
        start:setPosition(levelPosition.x, levelPosition.y)
        self:addChild(start, 130)
        return 
    end
    
    local levelNumber = (chapterIndex * 10 + levelIndex) * avgWordCount
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    if bookProgress['level'] == 'level39' and bookProgress['chapter'] == 'chapter3' then
        levelNumber = s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words
    end
    -- check random summary boss
    local bossList = s_CURRENT_USER.bookProgress:getBossList(s_CURRENT_USER.bookKey)
    local summaryboss = split(bossList,'|')
    local currentIndex = levelIndex
    if self.chapterKey == 'chapter1' then
        currentIndex = currentIndex + 10
    elseif self.chapterKey == 'chapter2' then
        currentIndex = currentIndex + 30
    elseif self.chapterKey == 'chapter3' then
        currentIndex = currentIndex + 60
    end
    local checkSummaryBoss = false
    for i = 1, #summaryboss do
        if summaryboss[i] == '' then break end
        if summaryboss[i] - currentIndex == 0 then
            checkSummaryBoss = true
            break
        end
    end
    if not checkSummaryBoss then
        local number = ccui.TextBMFont:create()
        number:setFntFile('font/number_inclined.fnt')
        --number:setColor(cc.c3b(56,26,23))
        number:setString(levelNumber)
        number:setPosition(levelPosition.x, levelPosition.y+3)
        self:addChild(number,130)
    end
end

function ChapterLayerBase:loadResource()
    if self.chapterKey == 'chapter0' then
--        self:createObjectForResource(Chapter0ResTable['back1_1'])
--        self:createObjectForResource(Chapter0ResTable['back2'])
--        self:createObjectForResource(Chapter0ResTable['back3_1'])
        --ccui.Layout:create('res/image/chapter/chapter0/1.png')
        
    elseif self.chapterKey == 'chapter1' then
        print('hello')
    end
end

return ChapterLayerBase
