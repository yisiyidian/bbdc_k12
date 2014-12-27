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
    island0Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(364, 2592),"island"}
    ,island1Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(510.6, 2464.4),"island"}
    ,island2Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(203.1, 2243.5),"island"}
    ,island3Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(111.8, 1901.3),"island"}
    ,island4Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(319.2, 1654),"island"}
    ,island5Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(538.6, 1397.2),"island"}
    ,island6Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(180.5, 1119.5),"island"}
    ,island7Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(480, 909.8),"island"}
    ,island8Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(163.5, 729.1),"island"}
    ,island9Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(128.6,292.2),"island"}
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
    self.levelPos = {}
    for i= 1, 10 do
        local levelIndex = string.sub(self.startLevelKey,6) + (i-1)
        self.levelPos[levelIndex] = Chapter0ResTable['island'..(i-1)..'Table'][3]
    end
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
end

return ChapterLayer0