require("cocos.init")
require('common.global')



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
    self:loadResource()
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
