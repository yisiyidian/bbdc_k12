local ChapterLayerBase = require('view.level.ChapterLayerBase')

local s_chapterKey = 'chapter1'
local s_startLevelKey = 'level1'
local s_chapter1_base_height = 3014*2


local ChapterLayer1 = class("ChapterLayer1",function()
    return ChapterLayerBase.create(s_chapterKey, s_startLevelKey)
end)

local Chapter1ResTable = {
    back1 = {'res/image/chapter/chapter0/1_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height)},
    back2 = {'res/image/chapter/chapter0/2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-970)},
    back3 = {'res/image/chapter/chapter0/3_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-1940)},
    back4 = {'res/image/chapter/chapter0/1_2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-3014)},
    back5 = {'res/image/chapter/chapter0/1_2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-3984)},
    back6 = {'res/image/chapter/chapter0/1_2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-4954)}
}

function ChapterLayer1.create()
    local layer = ChapterLayer1.new()
    layer:setContentSize(cc.size(s_MAX_WIDTH, s_chapter1_base_height))
    return layer
end

function ChapterLayer1:ctor()
    
end

function ChapterLayer2:loadResource()
--    self:createObjectForResource(Chapter1ResTable['back1'])
--    self:createObjectForResource(Chapter1ResTable['back2'])
--    self:createObjectForResource(Chapter1ResTable['back3'])
--    self:createObjectForResource(Chapter1ResTable['back'])
end

return ChapterLayer1