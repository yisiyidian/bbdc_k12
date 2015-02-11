local ChapterLayerBase = require('view.level.ChapterLayerBase')

local s_chapter0_base_height = 3014
s_chapterKey = 'chapter1'
s_startLevelKey = 'level0'

local RepeatChapterLayer = class("RepeatChapterLayer",function()
    return ChapterLayerBase.create(s_chapterKey, s_startLevelKey)
end)

function RepeatChapterLayer.create(chapterKey)
    local layer = RepeatChapterLayer.new(chapterKey)
    --layer:setContentSize(cc.size(s_MAX_WIDTH, s_chapter1_base_height))
    --    layer.chapterKey = chapterKey
    return layer
end

function RepeatChapterLayer:ctor(chapterKey)
    self.chapterKey = chapterKey
    --    print('repeateChapter: ')
    --    print_lua_table(s_CURRENT_USER)
    --    local chapterConfig = s_DataManager.getChapterConfig(s_CURRENT_USER.bookKey,self.chapterKey)
    local chapterSize = 1
    print('####'..chapterKey)
    local chapterIndex = string.sub(chapterKey, 8) + 0
--    if self.chapterKey == 'chapter1' then
--        chapterSize = 2
--    elseif self.chapterKey == 'chapter2' then
--        chapterSize = 3
--    elseif self.chapterKey == 'chapter3' then
--        chapterSize = 4
--    end
    local s_layer_height = s_chapter0_base_height * chapterSize
    self:setContentSize(cc.size(s_MAX_WIDTH, s_layer_height))
    for i = 1, chapterSize do
        local ChapterLayer0 = require('view.level.ChapterLayer0')
        local chapterLayer = ChapterLayer0.create("end")
        chapterLayer.chapterKey = self.chapterKey
        -- load level position
        local startLevelKey = 'level'..(i-1 + chapterIndex)*10
        chapterLayer:loadLevelPosition(startLevelKey)
        for k,v in pairs(chapterLayer.levelPos) do
            self.levelPos[k] = cc.p(v.x, v.y + s_layer_height - i*s_chapter0_base_height)
        end
        chapterLayer:setAnchorPoint(0, 0)
        chapterLayer:setPosition(0, s_layer_height - i*s_chapter0_base_height)
        self:addChild(chapterLayer)
    end

    self:plotDecoration()
end

function RepeatChapterLayer:loadResource()
--    self:createObjectForResource(Chapter1ResTable['back1'])
--    self:createObjectForResource(Chapter1ResTable['back2'])
--    self:createObjectForResource(Chapter1ResTable['back3'])
--    self:createObjectForResource(Chapter1ResTable['back'])
end

return RepeatChapterLayer