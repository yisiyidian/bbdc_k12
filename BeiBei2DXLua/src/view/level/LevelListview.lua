require("cocos.init")
local BaseLevel = require("view.level.BaseLevel")

local LevelListview = class("LevelListview", function ()
    return ccui.ListView:create()
end)

local oceanBlue = cc.c4b(61,191,244,255)
local blueSectionSize = cc.size(854,512)
local level1LayoutCount = 6
local level2LayoutCount = 12
local level3LayoutCount = 18
local level4LayoutCount = 24
local layoutTable ={}
local objectsTable = {}
local islandTag = 1

--Sprite = {path, anchor point, position, layout table index,island tag}
--level1ResTable
local level1ResTable ={island1Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(364, 2792),"island"}
    ,island2Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(510.6, 2464.4),"island"}
    ,island3Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(203.1, 2243.5),"island"}
    ,island4Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(111.8, 1901.3),"island"}
    ,island5Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(319.2, 1654),"island"}
    ,island6Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(538.6, 1397.2),"island"}
    ,island7Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(180.5, 1119.5),"island"}
    ,island8Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(480, 909.8),"island"}
    ,island9Table  = {"image/levelLayer/island.png",cc.p(0,1),cc.p(163.5, 729.1),"island"}
    ,island10Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(128.6,292.2),"island"}
    ,leftIslandFirstTable   = {"image/levelLayer/left1.png",cc.p(0,1),cc.p(0,blueSectionSize.height*6)}
    ,rightIslandFirstTable  = {"image/levelLayer/right1.png",cc.p(1,1),cc.p(blueSectionSize.width,2004.7)}
    ,sunkenShipTable        = {"image/levelLayer/sunkenShip.png",cc.p(0.5,0.5),cc.p(352,1444.9)}
    ,crabTable              = {"image/levelLayer/crab.png",cc.p(0.5,0.5),cc.p(584.3,1907.3)}
    ,leftIslandSecondTable  = {"image/levelLayer/left2.png",cc.p(0,1),cc.p(0,1584.1)}
    ,whaleTable             = {"image/levelLayer/whale.png", cc.p(0.5,0.5),cc.p(128.7,808.2)}
    ,rightIslandSecondTable = {"image/levelLayer/right2.png", cc.p(1,1),cc.p(blueSectionSize.width,505.2)}
    ,umbrella1Table         = {"image/levelLayer/umbrella1.png",cc.p(1,0),cc.p(451.9, 2726.0)}
    ,umbrella2Table         = {"image/levelLayer/umbrella2.png", cc.p(0.5,0.5),cc.p(182.0,268.8)}
    ,tree1Table = {"image/levelLayer/tree1.png",cc.p(1,1),cc.p(blueSectionSize.width,2091.4)}
    ,tree2Table = {"image/levelLayer/tree2.png",cc.p(0,1),cc.p(0,2829.3)}
    ,tree3Table = {"image/levelLayer/tree3.png",cc.p(1,1),cc.p(blueSectionSize.width,1898.5)}
    ,tree4Table = {"image/levelLayer/tree4.png",cc.p(0.5,0.5),cc.p(602.7,2471.4)}
    ,tree5Table = {"image/levelLayer/tree5.png",cc.p(0.5,0.5),cc.p(667.1,1391)}
    ,tree6Table = {"image/levelLayer/tree1.png",cc.p(0.5,0.5),cc.p(804.3,403.9)}} 

--t[1]: res
--t[2]: anchorPoint
--t[3]: position
--t[4]: which section of layout to add
function LevelListview:createObject(t)

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

function LevelListview:initLayout(level)
    
    if level == "level1" then
        for i=0, level1LayoutCount-1 do        
            local layout = ccui.Widget:create()
            layout:setContentSize(blueSectionSize.width,blueSectionSize.height)
            layout:ignoreAnchorPointForPosition(false)
            layout:setAnchorPoint(0,1)
            layout:setPosition(0,s_DESIGN_HEIGHT-blueSectionSize.height*i)

            local blueLayerColor = cc.LayerColor:create(oceanBlue,blueSectionSize.width,blueSectionSize.height)
            blueLayerColor:ignoreAnchorPointForPosition(false)
            blueLayerColor:setAnchorPoint(0,1)
            blueLayerColor:setPosition(0,blueSectionSize.height)
            layout:addChild(blueLayerColor)
        
            layoutTable[i+1] = layout
        
            self:pushBackCustomItem(layout)
        end
    end
end

function LevelListview:initObjects(level)

    if level == "level1" then
        for key, var in pairs(level1ResTable) do
            table.insert(objectsTable,self:createObject(var))
        end
    end
end

function LevelListview:setListViewPosition(level)
	if level == "level1" then
        self:setPosition((s_DESIGN_WIDTH-blueSectionSize.width)/2, s_DESIGN_HEIGHT)
	end
	
    if level == "level2" then
        self:setPosition((s_DESIGN_WIDTH-blueSectionSize.width)/2, s_DESIGN_HEIGHT)
    end

end

function LevelListview.create(level)
    local listview = LevelListview.new(level)
    return listview
end

function LevelListview:ctor(level)
    
    self.level = level
    self:setGravity(ccui.ListViewGravity.centerVertical)
    self:setDirection(ccui.ScrollViewDir.vertical)
    self:setTouchEnabled(true)
    self:setBounceEnabled(true)
    self:setContentSize(blueSectionSize.width, s_DESIGN_HEIGHT)
    self:initLayout(level)
    self:initObjects(level)
    self:setTouchEnabled(true)
    self:setListViewPosition(level)
    self:setAnchorPoint(cc.p(0,1))
end

function LevelListview:addTopBounce()

    if self.level == "level1" then
        local blueLayerColor = cc.LayerColor:create(oceanBlue,blueSectionSize.width,blueSectionSize.height)
        blueLayerColor:ignoreAnchorPointForPosition(false)
        blueLayerColor:setAnchorPoint(0,1)
        blueLayerColor:setPosition((s_DESIGN_WIDTH-blueSectionSize.width)/2,s_DESIGN_HEIGHT)
        self:getParent():addChild(blueLayerColor,-1)
    end
end

function LevelListview:addBottomBounce()

end

return LevelListview