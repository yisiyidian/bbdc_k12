require("cocos.init")
require('common.global')

local s_chapter0_base_height = 1020

local ChapterLayerBase = class('ChapterLayerBase',function() 
    local widget = ccui.Widget:create()
    return widget
end)

function ChapterLayerBase.create(chapterKey, startLevelKey)
    local layer = BaseChapterLayer.new(chapterKey, startLevelKey)
    if chapterKey == 'chapter0' then
        layer:setContentSize(cc.size(s_MAX_WIDTH, s_chapter0_base_height))
    end
    return layer
end


function ChapterLayerBase:ctor(chapterKey, startLevelKey)
    self.chapterKey = chapterKey
    self.startLevelKey = startLevelKey
    self.loadResource()
end

function ChapterLayerBase:loadResource()
    if self.chapterKey == 'chapter0' then
        local backPart1 = cc.Sprite:create('res/image/chapter/chapter0/1.png')
        ccui.Layout:create('res/image/chapter/chapter0/1.png')
        
    elseif self.chapterKey == 'chapter1' then
    
    end
end
return ChapterLayerBase