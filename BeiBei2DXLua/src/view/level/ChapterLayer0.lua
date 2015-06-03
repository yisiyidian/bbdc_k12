-- 第一大关（章节）的实现，使用了ChapterLayerBase的公共方法
local ChapterLayerBase = require('view.level.ChapterLayerBase')

local s_chapterKey = 'chapter0'
local s_startLevelKey = 'level0'

local ChapterLayer0 = class("ChapterLayer0",function()
    return ChapterLayerBase.create(s_chapterKey, s_startLevelKey)
end)

-- 关卡的资源
local Chapter0ResTable = {
    back1_1 = {'res/image/chapter/chapter0/1_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height),"back"},
    back1_2 = {'res/image/chapter/chapter0/1_2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height),"back"},
    back2 = {'res/image/chapter/chapter0/2.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-970),"back"},
    back3_1 = {'res/image/chapter/chapter0/3_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-1940),"back"},
    back3_2 = {'res/image/chapter/chapter0/3_1.png',cc.p(0,1),cc.p(0,s_chapter0_base_height-1940),"back"},
    rest = {'res/image/chapter/chapter0/rest.png',cc.p(0,1),cc.p(200,2630)},
    swim = {'image/chapter_level/youyongquan.png',cc.p(0,1),cc.p(530,1930)},
    island2 = {'res/image/chapter/island2.png',cc.p(0,1),cc.p(395,2040),"add"},
    island3 = {'res/image/chapter/island3.png',cc.p(0,1),cc.p(470,630),"add"},
    leftIsland = {'image/chapter/leftIsland.png',cc.p(0,1),cc.p(0,2900),"add"},
    rightIsland = {'image/chapter/rightIsland.png',cc.p(1,1),cc.p(s_DESIGN_WIDTH,2030),"add"},
    island0Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(527, 2662),"island","level0"}
    ,island1Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(533, 2344),"island","level1"}
    ,island2Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(333, 2071),"island","level2"}
    ,island3Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(230, 1811),"island","level3"}
    ,island4Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(395, 1536),"island","level4"}
    ,island5Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(597, 1268),"island","level5"}
    ,island6Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(482, 941),"island","level6"}
    ,island7Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(300, 652),"island","level7"}
    ,island8Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(223, 315),"island","level8"}
    ,island9Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(382,80),"island","level9"}
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

-- 从资源中导入每个关卡的位置
function ChapterLayer0:loadLevelPosition(startLevelKey)
    self.startLevelKey = startLevelKey
    for i= 1, 10 do
        local levelIndex = string.sub(self.startLevelKey,6) + (i-1)
        self.levelPos[levelIndex] = Chapter0ResTable['island'..(i-1)..'Table'][3]
    end
end

-- 添加波浪的动画
function ChapterLayer0:addWaveAnimation(position)
    local wave1 = cc.Sprite:create('image/chapter/chapter0/wave.png')
    local wave2 = cc.Sprite:create('image/chapter/chapter0/wave.png')
    -- wave 1
    wave1:setPosition(cc.p(position.x-20, position.y+20))
    self:addChild(wave1,120)
    local scale = math.random(4, 6) / 10 + 0.7
    wave1:setScale(scale)
    
    local action1 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(-20, 0)))
    local action2 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(20, 0)))
    local action3 = cc.RepeatForever:create(cc.Sequence:create(action1, action2))
    wave1:runAction(action3)
    -- wave 2
    wave2:setPosition(cc.p(position.x-20, position.y))
    self:addChild(wave2,130)
    local action4 = cc.MoveBy:create(5, cc.p(20, 0))
    local action5 = cc.MoveBy:create(5, cc.p(-20, 0))
    local action6 = cc.RepeatForever:create(cc.Sequence:create(action4, action5))
    wave2:runAction(action6)
    scale = math.random(4, 6) / 10 + 0.7
    wave2:setScale(scale)
    
end

-- 导入关卡的资源
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
    
    self:createObjectForResource(Chapter0ResTable['rest'])
    self:createObjectForResource(Chapter0ResTable['swim'])
    self:createObjectForResource(Chapter0ResTable['island2'])
    self:createObjectForResource(Chapter0ResTable['island3'])
    self:createObjectForResource(Chapter0ResTable['leftIsland'])
--    self:createObjectForResource(Chapter0ResTable['rightIsland'])
    -- plot boat
    local boat1 = sp.SkeletonAnimation:create('spine/boat_xuanxiaoguan1.json', 'spine/boat_xuanxiaoguan1.atlas',1)
    boat1:addAnimation(0, 'animation', true)
    boat1:setPosition(250, 2330)
    self:addChild(boat1, 140)
    local boat2 = sp.SkeletonAnimation:create('spine/boat_xuanxiaoguan1.json', 'spine/boat_xuanxiaoguan1.atlas',1)
    boat2:addAnimation(0, 'animation', true)
    boat2:setPosition(550, 690)
    self:addChild(boat2, 140)

    -- whales
    local whale1 = sp.SkeletonAnimation:create('spine/chapterlevel/jingyu.json', 'spine/chapterlevel/jingyu.atlas',1)
    whale1:addAnimation(0, 'animation', true)
    whale1:setPosition(300,1200)
    self:addChild(whale1, 140)

    local whale2 = sp.SkeletonAnimation:create('spine/chapterlevel/jingyu.json', 'spine/chapterlevel/jingyu.atlas',1)
    whale2:addAnimation(0, 'animation', true)
    whale2:setPosition(500,2100)
    self:addChild(whale2, 140)
    
    --crab
    local crab = sp.SkeletonAnimation:create('spine/chapterlevel/pangxie.json', 'spine/chapterlevel/pangxie.atlas',1)
    crab:addAnimation(0, 'animation', true)
    crab:setPosition(500,1760)
    self:addChild(crab, 140)  
    local crabAction1 = cc.MoveBy:create(2,cc.p(50,-10))  
    local crabAction2 = cc.MoveBy:create(2,cc.p(-50,10))  
    local crabAction3 = cc.RotateBy:create(2,-10)
    local crabAction4 = cc.RotateBy:create(2,10)
    local crabAction5 = cc.RepeatForever:create(cc.Sequence:create(crabAction1,crabAction2))
    local crabAction6 = cc.RepeatForever:create(cc.Sequence:create(crabAction3,crabAction4))
    crab:runAction(crabAction5)
    crab:runAction(crabAction6)
    
    -- tree animation
    local tree1 = sp.SkeletonAnimation:create('spine/chapterlevel/xinxuanxiaoguan.json', 'spine/chapterlevel/xinxuanxiaoguan.atlas',1)
    tree1:addAnimation(0, 'animation', true)
    tree1:setPosition(570,1820)
    self:addChild(tree1, 140)
    local tree2 = sp.SkeletonAnimation:create('spine/chapterlevel/2xuanxiaoguanyizishu.json', 'spine/chapterlevel/2xuanxiaoguanyizishu.atlas',1)
    tree2:addAnimation(0, 'animation', true)
    tree2:setPosition(100,2530)
    self:addChild(tree2, 141)
    local tree3 = sp.SkeletonAnimation:create('spine/chapterlevel/3xuanxiaoguanyizishu.json', 'spine/chapterlevel/3xuanxiaoguanyizishu.atlas',1)
    tree3:addAnimation(0, 'animation', true)
    tree3:setPosition(70,2580)
    self:addChild(tree3, 140)
    
    -- wave action
    self:addWaveAnimation(cc.p(400, 200))
    self:addWaveAnimation(cc.p(600, 600))
    self:addWaveAnimation(cc.p(280, 1050))
    self:addWaveAnimation(cc.p(380, 1700))
    self:addWaveAnimation(cc.p(600, 2000))
    self:addWaveAnimation(cc.p(300, 2200))
    self:addWaveAnimation(cc.p(520, 2500))
end

return ChapterLayer0