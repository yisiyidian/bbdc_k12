-- 路径控制器
local PathConfig = require("model/path/PathConfig")

local PathController = class("PathController")

PathController.path = {}
PathController.length = 0


function PathController:getPath(length)
	PathController.length = length
	math.randomseed(os.time())
	local randomNum = math.random(1,1000)
	PathController.path = PathConfig.data[randomNum % #PathConfig.data + 1]
	-- print_lua_table(PathController.path)
	-- print("cutPath")
	PathController:cutPath()
	-- print_lua_table(PathController.path)
	-- print("toCoordinate")
	PathController:toCoordinate()
	-- print_lua_table(PathController.path)
	-- print("rotate")
	PathController:rotate()
	-- print_lua_table(PathController.path)
	-- print("symmetry")
	PathController:symmetry()
	-- print_lua_table(PathController.path)
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
	local randomNum = math.random(1,1000)%4
	-- print("旋转"..(randomNum + 1)*90 )
	local tempP = cc.p(0,0)
	local temp = {}
	for k,v in pairs(PathController.path) do
		temp[#temp + 1] = PathController.path[k]
	end
	for k,v in pairs(temp) do
		temp[k].x = temp[k].x - 3
		temp[k].y = temp[k].y - 3
	end 
	for k,v in pairs(temp) do
		if randomNum == 0 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = tempP.y
			temp[k].y = -tempP.x
		-- 旋转90
		elseif randomNum == 1 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = -tempP.x
			temp[k].y = -tempP.y
		-- 旋转180
		elseif randomNum == 2 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = -tempP.y
			temp[k].y = tempP.x
		-- 旋转270
		elseif randomNum == 3 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y			
			temp[k].x = tempP.x		
			temp[k].y = tempP.y
			-- 旋转360
		end
	end
	for k,v in pairs(PathController.path) do
		temp[k].x = temp[k].x + 3
		temp[k].y = temp[k].y + 3
	end
	PathController.path = temp
end

function PathController:symmetry()
	local randomNum = math.random(1,1000)%4
	-- print("对称"..(randomNum + 1)*45 )
	local temp = {}
	local tempP = cc.p(0,0)
	for k,v in pairs(PathController.path) do
		temp[#temp + 1] = PathController.path[k]
	end
	for k,v in pairs(temp) do
		temp[k].x = temp[k].x - 3
		temp[k].y = temp[k].y - 3
	end 
	for k,v in pairs(temp) do
		if randomNum == 0 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = tempP.y
			temp[k].y = tempP.x 
		-- 45对称
		elseif randomNum == 1 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = -tempP.x
			temp[k].y = tempP.y
		-- 90对称
		elseif randomNum == 2 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = -tempP.y
			temp[k].y = -tempP.x
		-- 135对称
		elseif randomNum == 3 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = tempP.x
			temp[k].y = -tempP.y
			-- 180对称	
		end
	end
	for k,v in pairs(PathController.path) do
		temp[k].x = temp[k].x + 3
		temp[k].y = temp[k].y + 3
	end
	PathController.path = temp
end

return PathController