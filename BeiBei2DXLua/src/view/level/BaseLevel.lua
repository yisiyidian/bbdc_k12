require("cocos.init")
require("common.global")

local BaseLevel = class("BaseLevel",function () 
    return cc.Layer:create()
end)  

function BaseLevel.create()
    local layer = BaseLevel.new()
    return layer
end

function BaseLevel:ctor()

	local level1 = require("view.level.LevelListview").create("level1")
    self:addChild(level1)
    level1:addTopBounce();    
end

return BaseLevel