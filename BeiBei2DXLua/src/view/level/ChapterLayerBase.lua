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
        self:addChild(object,100)
    end
    return object
end


function ChapterLayerBase:plotDecoration()
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    local currentLevelIndex = string.sub(bookProgress['level'],6)
    local currentChapterIndex = string.sub(bookProgress['chapter'],8)
    local chapterIndex = string.sub(self.chapterKey, 8)
    for levelIndex, levelPosition in pairs(self.levelPos) do
        local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,self.chapterKey,'level'..levelIndex)
--        print('!!!!!levelConfigType:'..levelConfig)
--        print_lua_table(levelConfig)
        -- is locked
        if levelIndex - currentLevelIndex > 0 or chapterIndex - currentChapterIndex > 0 then
            local lockIsland = cc.Sprite:create('image/chapter/chapter0/lockisland2.png')
            local lock = cc.Sprite:create('image/chapter/chapter0/lock.png')
            lockIsland:setPosition(levelPosition)
            lock:setPosition(levelPosition)
            self:addChild(lockIsland,120)
            self:addChild(lock,130)
        else
            -- plot level number
            self:plotLevelNumber('level'..levelIndex)
            -- check summary boss
            if levelConfig['type'] == 1 then
                local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
                summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
--                summaryboss:setAnchorPoint(1,1)
                print('summaryboss position:'..summaryboss:getPosition())
                summaryboss:setName('summaryboss'..string.sub('level'..levelIndex, 6))
                summaryboss:addAnimation(0, 'jianxiao', true)
                summaryboss:setScale(0.7)
                self:addChild(summaryboss, 125)
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
                deco:setPosition(levelPosition.x+60,levelPosition.y+40)
                self:addChild(deco, 130)    
            elseif levelIndex % 8 == 7 then
                local deco = cc.Sprite:create('image/chapter_level/xuanxiaoguan1_youyongquan.png')
                deco:setPosition(levelPosition.x+100,levelPosition.y+ 40)
                self:addChild(deco, 130)       
            end
        end
        -- decoration
        
    end
end

function ChapterLayerBase:plotLevelNumber(levelKey)
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,self.chapterKey,levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelPosition = self:getLevelPosition(levelKey)
    local chapterIndex = string.sub(self.chapterKey, 8)
    local avgWordCount = math.floor(s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words / 100)

    
    local levelNumber = (chapterIndex * 10 + levelIndex + 1) * avgWordCount
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    if bookProgress['level'] == 'level39' and bookProgress['chapter'] == 'chapter3' then
        levelNumber = s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words
    end
        if levelConfig['type'] == 1 then -- summary boss
--            local summaryboss = levelButton:getChildByName('summaryboss'..string.sub(levelKey,6))
--            local number = ccui.TextBMFont:create()
--            number:setFntFile('font/number_straight.fnt')
--            number:setScale(1.6)
--            number:setString(levelNumber)
--            number:setPosition(125, 100)
--            summaryboss:addChild(number)
        else 
            local number = ccui.TextBMFont:create()
            number:setFntFile('font/number_inclined.fnt')
            number:setString(levelNumber)
            number:setPosition(levelPosition.x, levelPosition.y+3)
            self:addChild(number,130)
        end
--    else
--        local lockSprite = levelButton:getChildByName('lockSprite'..levelIndex)
--        local lockNumber = ccui.TextBMFont:create()        
--        lockNumber:setFntFile('font/number_brown.fnt')
--        lockNumber:setString(levelNumber)
--        lockNumber:setPosition(lockSprite:getContentSize().width/2, lockSprite:getContentSize().height/2-6)
--        lockSprite:addChild(lockNumber)
--    end

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
