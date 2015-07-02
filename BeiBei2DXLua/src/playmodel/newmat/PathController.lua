-- 路径控制器
local PathConfig = require("model/path/PathConfig")

local PathController = class("PathController")

PathController.path = {}


function PathController:getOriginalPath(length)
	math.randomseed(os.time)
	local randomNum = math.random(1,1000)
	PathController.path =
	PathConfig.data
end

return PathController