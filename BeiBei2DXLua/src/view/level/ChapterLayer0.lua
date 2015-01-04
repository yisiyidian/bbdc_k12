local ChapterLayerBase = require('view.level.ChapterLayerBase')

local s_chapterKey = 'chapter0'
local s_startLevelKey = 'level0'

local ChapterLayer0 = class("ChapterLayer0",function()
    return ChapterLayerBase.create(s_chapterKey, s_startLevelKey)
end)

local Chapter0ResTable = {
    back1_1 = {'res/image/chapter/chapter0/1_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height)},
    back1_2 = {'res/image/chapter/chapter0/1_2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height)},
    back2 = {'res/image/chapter/chapter0/2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-970)},
    back3_1 = {'res/image/chapter/chapter0/3_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-1940)},
    back3_2 = {'res/image/chapter/chapter0/3_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-1940)},
    island0Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(527, 2662),"island"}
    ,island1Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(533, 2344),"island"}
    ,island2Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(333, 2071),"island"}
    ,island3Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(230, 1811),"island"}
    ,island4Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(395, 1536),"island"}
    ,island5Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(597, 1268),"island"}
    ,island6Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(482, 941),"island"}
    ,island7Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(300, 652),"island"}
    ,island8Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(223, 315),"island"}
    ,island9Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(382,80),"island"}
    ,whale1 = {"image/chapter/chapter0/whale.png",cc.p(0,1),cc.p(220,1200),"whale1"}
    ,whale2 = {"image/chapter/chapter0/whale.png",cc.p(0,1),cc.p(500,2100),"whale2"}
}
-- resourceType "start" / "middle" / "end"
function ChapterLayer0.create(resourceType)
    local layer = ChapterLayer0.new(resourceType)
    layer:setContentSize(cc.size(s_MAX_WIDTH, s_chapter0_base_height))
    return layer
end

function ChapterLayer0:ctor(resourceType)
    self.resourceType = resourceType
    self:loadResource()
end

function ChapterLayer0:loadLevelPosition(startLevelKey)
    self.startLevelKey = startLevelKey
    for i= 1, 10 do
        local levelIndex = string.sub(self.startLevelKey,6) + (i-1)
        self.levelPos[levelIndex] = Chapter0ResTable['island'..(i-1)..'Table'][3]
    end
end

function ChapterLayer0:addWaveAnimation(position)
    local wave1 = cc.Sprite:create('image/chapter/chapter0/wave.png')
    local wave2 = cc.Sprite:create('image/chapter/chapter0/wave.png')
    -- wave 1
    wave1:setPosition(cc.p(position.x-20, position.y+20))
    self:addChild(wave1,120)
    local scale = math.random(4, 10) / 10 + 0.7
    wave1:setScale(scale)
    
    local action1 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(-100, 0)))
    local action2 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(100, 0)))
    local action3 = cc.RepeatForever:create(cc.Sequence:create(action1, action2))
    wave1:runAction(action3)
    -- wave 2
    wave2:setPosition(cc.p(position.x-20, position.y))
    self:addChild(wave2,130)
    local action4 = cc.MoveBy:create(5, cc.p(80, 0))
    local action5 = cc.MoveBy:create(5, cc.p(-80, 0))
    local action6 = cc.RepeatForever:create(cc.Sequence:create(action4, action5))
    wave2:runAction(action6)
    scale = math.random(4, 10) / 10 + 0.7
    wave2:setScale(scale)
    
end

function ChapterLayer0:loadResource()
    if self.resourceType == s_chapter_resource_start_type then
        self:createObjectForResource(Chapter0ResTable['back1_1'])
        self:createObjectForResource(Chapter0ResTable['back2'])
        self:createObjectForResource(Chapter0ResTable['back3_1'])
    elseif self.resourceType == s_chapter_resource_end_type then
        self:createObjectForResource(Chapter0ResTable['back1_2'])
        self:createObjectForResource(Chapter0ResTable['back2'])
        self:createObjectForResource(Chapter0ResTable['back3_1'])
    end
    
    -- add whale
    self:createObjectForResource(Chapter0ResTable['whale1'])
    self:createObjectForResource(Chapter0ResTable['whale2'])
    -- plot boat
    local boat1 = sp.SkeletonAnimation:create('spine/boat_xuanxiaoguan1.json', 'spine/boat_xuanxiaoguan1.atlas',1)
    boat1:addAnimation(0, 'animation', true)
    boat1:setPosition(250, 2380)
    self:addChild(boat1, 140)
    local boat2 = sp.SkeletonAnimation:create('spine/boat_xuanxiaoguan1.json', 'spine/boat_xuanxiaoguan1.atlas',1)
    boat2:addAnimation(0, 'animation', true)
    boat2:setPosition(550, 690)
    self:addChild(boat2, 140)
    
    -- wave action
    self:addWaveAnimation(cc.p(280, 1050))
    self:addWaveAnimation(cc.p(600, 2000))
    self:addWaveAnimation(cc.p(300, 2200))
    self:addWaveAnimation(cc.p(600, 600))
    self:addWaveAnimation(cc.p(300, 200))
    self:addWaveAnimation(cc.p(350, 1660))
    self:addWaveAnimation(cc.p(600, 2500))
end

return ChapterLayer0