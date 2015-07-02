-- 路径控制器
local PathConfig = require("model/path/PathConfig")

local PathController = class("PathController")

PathController.path = {}
PathController.length = 0


function PathController:getPath(length)
	PathController.length = length
	math.randomseed(os.time)
	local randomNum = math.random(1,1000)
	PathController.path = PathConfig.data[randomNum % #PathConfig.data + 1]

	PathController:cutPath()
	PathController:toCoordinate()
	PathController:rotate()
	return PathController.path
end

function PathController:cutPath()
	local parameter = 26 - PathController.length
	local randomNum = math.random(1,parameter)
	local temp = {}
	for k,v in pairs(PathController.path) do
		if k >= randomNum and k <= randomNum + PathController.length - 1 then
			temp[#temp + 1] =  PathController.path[k]
		end
	end
	PathController.path = temp
end

function PathController:toCoordinate()
	local temp = {}
	for k,v in pairs(PathController.path) do
		local tempP = cc.p(0,0)
		tempP.x = math.floor(PathController.path[k]/10)
		tempP.y = PathController.path[k]%10
		temp[#temp + 1] =  tempP
	end
	PathController.path = temp
end

function PathController:rotate()
	for k,v in pairs(PathController.path) do
		PathController.path[k].x = PathController.path[k].x - 3
		PathController.path[k].y = PathController.path[k].y - 3
	end
	local randomNum = math.random(1,1000)%4
	for k,v in pairs(PathController.path) do
		if randomNum == 0 then
			PathController.path[k].x = PathController.path[k].y
			PathController.path[k].y = -PathController.path[k].x 
		elseif randomNum == 1 then
			PathController.path[k].x = -PathController.path[k].x
			PathController.path[k].y = -PathController.path[k].y
		elseif randomNum == 2 then
			PathController.path[k].x = -PathController.path[k].y
			PathController.path[k].y = PathController.path[k].x
		elseif randomNum == 3 then
			PathController.path[k].x = PathController.path[k].x
			PathController.path[k].y = PathController.path[k].y
		end
	end
	for k,v in pairs(PathController.path) do
		PathController.path[k].x = PathController.path[k].x + 3
		PathController.path[k].y = PathController.path[k].y + 3
	end
end

function PathController:rotate()
	for k,v in pairs(PathController.path) do
		PathController.path[k].x = PathController.path[k].x - 3
		PathController.path[k].y = PathController.path[k].y - 3
	end
	local randomNum = math.random(1,1000)%4
	for k,v in pairs(PathController.path) do
		if randomNum == 0 then
			PathController.path[k].x = PathController.path[k].y
			PathController.path[k].y = -PathController.path[k].x 
		elseif randomNum == 1 then
			PathController.path[k].x = -PathController.path[k].x
			PathController.path[k].y = -PathController.path[k].y
		elseif randomNum == 2 then
			PathController.path[k].x = -PathController.path[k].y
			PathController.path[k].y = PathController.path[k].x
		elseif randomNum == 3 then
			PathController.path[k].x = PathController.path[k].x
			PathController.path[k].y = PathController.path[k].y
		end
	end
	for k,v in pairs(PathController.path) do
		PathController.path[k].x = PathController.path[k].x + 3
		PathController.path[k].y = PathController.path[k].y + 3
	end
end

function PathController:symmetry()
	for k,v in pairs(PathController.path) do
		PathController.path[k].x = PathController.path[k].x - 3
		PathController.path[k].y = PathController.path[k].y - 3
	end
	local randomNum = math.random(1,1000)%4
	for k,v in pairs(PathController.path) do
		if randomNum == 0 then
			PathController.path[k].x = PathController.path[k].y
			PathController.path[k].y = PathController.path[k].x 
		elseif randomNum == 1 then
			PathController.path[k].x = PathController.path[k].x
			PathController.path[k].y = -PathController.path[k].y
		elseif randomNum == 2 then
			PathController.path[k].x = -PathController.path[k].y
			PathController.path[k].y = -PathController.path[k].x
		elseif randomNum == 3 then
			PathController.path[k].x = -PathController.path[k].x
			PathController.path[k].y = PathController.path[k].y
		end
	end
	for k,v in pairs(PathController.path) do
		PathController.path[k].x = PathController.path[k].x + 3
		PathController.path[k].y = PathController.path[k].y + 3
	end
end

return PathController