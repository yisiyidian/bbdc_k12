local ChapterLayerBase = require('view.level.ChapterLayerBase')

local s_chapterKey = 'chapter0'
local s_startLevelKey = 'level0'
local s_chapter0_base_height = 3014


local ChapterLayer0 = class("ChapterLayer0",function()
    return ChapterLayerBase.create(s_chapterKey, s_startLevelKey)
end)

local Chapter0ResTable = {
    back1_1 = {'res/image/chapter/chapter0/1_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height)},
    back2 = {'res/image/chapter/chapter0/2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-970)},
    back3_1 = {'res/image/chapter/chapter0/3_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-1940)}
}

function ChapterLayer0.create()
    local layer = ChapterLayer0.new()
    layer:setContentSize(cc.size(s_MAX_WIDTH, s_chapter0_base_height))
    return layer
end

function ChapterLayer0:ctor()
    
end

function ChapterLayerBase:loadResource()
    self:createObjectForResource(Chapter0ResTable['back1_1'])
    self:createObjectForResource(Chapter0ResTable['back2'])
    self:createObjectForResource(Chapter0ResTable['back3_1'])
end

return ChapterLayer0