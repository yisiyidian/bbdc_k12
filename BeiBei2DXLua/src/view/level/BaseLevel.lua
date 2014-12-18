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

	local levelListview = require("view.level.LevelListview").create()
    self:addChild(levelListview)
end

function BaseLevel.setBackGround(color,size,index)
end

function BaseLevel.setObjects()

end

function BaseLevel.initObject(t)

end    

return BaseLevel