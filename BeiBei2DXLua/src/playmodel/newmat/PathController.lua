-- 路径控制器
local PathConfig = require("model/path/PathConfig")
-- 路径配置文件
local PathController = class("PathController")
-- 路径控制器

-- ～～～～～～～～～～～～～～～～～～～～～
-- 注意：坐标操作时中心点会从（3，3）移动到（0，0），操作完会移动回（3，3）
-- ～～～～～～～～～～～～～～～～～～～～～

-- 路径生成容器
PathController.path = {}
-- 需要生成的长度
PathController.length = 0

-- 获取路径（参数为目标长度）
function PathController:getPath(length)

	-- 自检	
	-- for i=1,#PathConfig.data do
	-- 	print("检验资料"..i.."中")
	-- 	PathController:checkError(PathConfig.data[i])
	-- end
	
	-- 获取参数
	PathController.length = length
	math.randomseed(os.time())
	local randomNum = math.random(1,1000)
	PathController.path = PathConfig.data[randomNum % #PathConfig.data + 1]

	-- print_lua_table(PathController.path)
	-- print("cutPath")
	-- 从25单位长的路径挑选目标长度的的路径
	PathController:cutPath()
	-- print_lua_table(PathController.path)
	-- print("toCoordinate")
	PathController:toCoordinate()
	-- 坐标化处理 11 －》 cc.p（1，1）
	-- print_lua_table(PathController.path)
	-- print("rotate & symmetry")
	-- 旋转 翻转操作
	PathController:rotateAndSymmetry()
	-- print_lua_table(PathController.path)
	return PathController.path
end

-- 按照长度，产生（1～26－目标长度）的随机数
-- 作为单词起点坐标
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

-- 坐标化处理                        
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

-- 旋转镜像操作
-- 一个点对应8个点
-- 原点（1，2）
-- （1，2）（－1，2）（1，－2）（－1，－2）
-- （2，1）（－2，1）（2，－1）（－2，－1）
function PathController:rotateAndSymmetry()
	local randomNum = math.random(1,1000)%8
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
			temp[k].x = tempP.x
			temp[k].y = tempP.y
		elseif randomNum == 1 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = -tempP.x
			temp[k].y = tempP.y
		elseif randomNum == 2 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = tempP.x
			temp[k].y = -tempP.y
		elseif randomNum == 3 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y			
			temp[k].x = -tempP.x
			temp[k].y = -tempP.y
		elseif randomNum == 4 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = tempP.y
			temp[k].y = tempP.x
		elseif randomNum == 5 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = -tempP.y
			temp[k].y = tempP.x
		elseif randomNum == 6 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y
			temp[k].x = tempP.y
			temp[k].y = -tempP.x
		elseif randomNum == 7 then
			tempP.x = temp[k].x
			tempP.y = temp[k].y			
			temp[k].x = -tempP.y
			temp[k].y = -tempP.x
		end
	end
	for k,v in pairs(PathController.path) do
		temp[k].x = temp[k].x + 3
		temp[k].y = temp[k].y + 3
	end
	PathController.path = temp
end

-- 自检函数
-- 理想的路径是从（1，1）～（5，5）一共25个点
-- 读数据时，读到一个点，在矩阵里赋值为1
-- 最后矩阵数字累加
-- 25说明没问题
function PathController:checkError(data)
	local k = 0
	local mat = {
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	}

	for i=1,#data do
	 	local x = math.floor(data[i] /10)
	 	local y = math.floor(data[i] %10)
	 	mat[x][y] = 1
	end 

	for i=1,5 do
		for j=1,5 do
			k = k + mat[i][j]
		end
	end

	if k ~= 25 then
		print("资料有误")
	else
		print("并没有什么问题")
	end
end

return PathController