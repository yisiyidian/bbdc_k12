require("cocos.init")
local BaseLevel = require("view.level.BaseLevel")

local LevelListview = class("LevelListview", function ()
    return ccui.ListView:create()
end)

local oceanBlue = cc.c4b(61,191,244,255)
local blueSectionSize = cc.size(854,512)
local blueLayoutCount = 6
local layoutTable ={}
local objectsTable = {}
local listViewOcenaHeight
local islandTag = 1

--Sprite = {path, anchor point, position, layout table index,island tag}
local leftIslandFirstTable = {"image/levelLayer/left1.png",cc.p(0,1),cc.p(0,blueSectionSize.height+blueSectionSize.height*(blueLayoutCount-1))}
local rightIslandFirstTable = {"image/levelLayer/right1.png",cc.p(1,1),cc.p(blueSectionSize.width,2004.7)}
local sunkenShipTable = {"image/levelLayer/sunkenShip.png",cc.p(0.5,0.5),cc.p(352,1444.9)}
local crabTable = {"image/levelLayer/crab.png",cc.p(0.5,0.5),cc.p(584.3,1907.3)}
local leftIslandSecondTable ={"image/levelLayer/left2.png",cc.p(0,1),cc.p(0,1584.1)}
local whaleTable = {"image/levelLayer/whale.png", cc.p(0.5,0.5),cc.p(128.7,808.2)}
local rightIslandSecondTable = {"image/levelLayer/right2.png", cc.p(1,1),cc.p(blueSectionSize.width,505.2)}
local umbrella1Table = {"image/levelLayer/umbrella1.png",cc.p(1,0),cc.p(451.9, 2726.0)}
local umbrella2Table = {"image/levelLayer/umbrella2.png", cc.p(0.5,0.5),cc.p(182.0,268.8)}

--trees
local tree1Table = {"image/levelLayer/tree1.png",cc.p(1,1),cc.p(blueSectionSize.width,2091.4)}
local tree2Table = {"image/levelLayer/tree2.png",cc.p(0,1),cc.p(0,2829.3)}
local tree3Table = {"image/levelLayer/tree3.png",cc.p(1,1),cc.p(blueSectionSize.width,1898.5)}
local tree4Table = {"image/levelLayer/tree4.png",cc.p(0.5,0.5),cc.p(602.7,2471.4)}
local tree5Table = {"image/levelLayer/tree5.png",cc.p(0.5,0.5),cc.p(667.1,1391)}
local tree6Table = {"image/levelLayer/tree1.png",cc.p(0.5,0.5),cc.p(804.3,403.9)}
--islands
local island1Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(364, 2792),"island"}
local island2Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(510.6, 2464.4),"island"}
local island3Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(203.1, 2243.5),"island"}
local island4Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(111.8, 1901.3),"island"}
local island5Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(319.2, 1654),"island"}
local island6Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(538.6, 1397.2),"island"}
local island7Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(180.5, 1119.5),"island"}
local island8Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(480, 909.8),"island"}
local island9Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(163.5, 729.1),"island"}
local island10Table = {"image/levelLayer/island.png",cc.p(0,1),cc.p(128.6,292.2),"island"}

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

function LevelListview:initBlueLayout()
    
    for i=0, blueLayoutCount-1 do
                
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

function LevelListview:initObjects()

    table.insert(objectsTable,self:createObject(island1Table)) 
    table.insert(objectsTable,self:createObject(island2Table)) 
    table.insert(objectsTable,self:createObject(island3Table)) 
    table.insert(objectsTable,self:createObject(island4Table)) 
    table.insert(objectsTable,self:createObject(island5Table)) 
    table.insert(objectsTable,self:createObject(island6Table)) 
    table.insert(objectsTable,self:createObject(island7Table)) 
    table.insert(objectsTable,self:createObject(island8Table)) 
    table.insert(objectsTable,self:createObject(island9Table)) 
    table.insert(objectsTable,self:createObject(island10Table)) 

    table.insert(objectsTable,self:createObject(leftIslandFirstTable)) 
    table.insert(objectsTable,self:createObject(rightIslandFirstTable)) 
    table.insert(objectsTable,self:createObject(sunkenShipTable)) 
    table.insert(objectsTable,self:createObject(crabTable)) 
    table.insert(objectsTable,self:createObject(leftIslandSecondTable)) 
    table.insert(objectsTable,self:createObject(whaleTable)) 
    table.insert(objectsTable,self:createObject(rightIslandSecondTable)) 
    table.insert(objectsTable,self:createObject(umbrella1Table)) 
    table.insert(objectsTable,self:createObject(umbrella2Table)) 

    table.insert(objectsTable,self:createObject(tree1Table)) 
    table.insert(objectsTable,self:createObject(tree2Table)) 
    table.insert(objectsTable,self:createObject(tree3Table)) 
    table.insert(objectsTable,self:createObject(tree4Table)) 
    table.insert(objectsTable,self:createObject(tree5Table)) 
    table.insert(objectsTable,self:createObject(tree6Table)) 
end

function LevelListview.create()
    local listview = LevelListview.new()
    return listview
end

function LevelListview:ctor()
    
    self:setGravity(ccui.ListViewGravity.centerVertical)
    self:setDirection(ccui.ScrollViewDir.vertical)
    self:setTouchEnabled(true)
    self:setBounceEnabled(false)
    self:setContentSize(blueSectionSize.width, s_DESIGN_HEIGHT)
    self:initBlueLayout()
    self:initObjects()
    self:setTouchEnabled(true)
    local xOffset = (s_DESIGN_WIDTH-blueSectionSize.width)/2
    self:setPosition(xOffset, s_DESIGN_HEIGHT)
    self:setAnchorPoint(cc.p(0,1))
end

return LevelListview