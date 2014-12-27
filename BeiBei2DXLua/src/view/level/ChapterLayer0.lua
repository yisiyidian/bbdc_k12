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