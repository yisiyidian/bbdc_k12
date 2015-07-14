-- 由于个人水平有限，这个控制器不一定能生成第二条路径
-- by侯琪
-- 另一条路径的控制器
local AlternatePathController = class("AlternatePathController")

-- 初始路径，这里载入的是第一条路径控制器生成的结果
AlternatePathController.originalpath = {}

-- 结果路径，这里生成最后的结果
AlternatePathController.alternatepath = {}

-- 获取路径
function AlternatePathController:getPath(path)
	-- 初始化原始路径
	AlternatePathController.originalpath = path
	-- 初始化结果路径
	AlternatePathController.alternatepath = {}
	-- print("初始序列1")
	-- print_lua_table(AlternatePathController.originalpath)

	-- 获取路径的长度
	local length = #AlternatePathController.originalpath
	-- 路径只取一半
	AlternatePathController.halfLength = math.floor(length/2)
	-- 单词长度基本在1～16之间，其余状况不考虑
	if AlternatePathController.halfLength == 0 or AlternatePathController.halfLength >= 8 then
		return {}
	end

	-- 矩阵工具，初始化原始路径时，对应位置填充1
	-- 生成新的分支时，判断分支上的每一个点是不是在原有的矩阵上已经是1了
	-- 如果是，该路径作废
	AlternatePathController.mat = {
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	}

	-- print("初始序列2")
	-- print_lua_table(AlternatePathController.originalpath)

	-- 如上所述，对应位置填充1
	for i=1,#AlternatePathController.originalpath do
	 	AlternatePathController.mat[AlternatePathController.originalpath[i].x][AlternatePathController.originalpath[i].y] = 1
	end 

	-- print("初始序列3")
	-- print_lua_table(AlternatePathController.originalpath)

	-- 从一半的长度到一结束，循环
	for len = AlternatePathController.halfLength,1,-1 do
		-- 按照旋转镜像的方法找到对应的点，8种
		for i=0,7 do
			-- 获取随机路径分支
			AlternatePathController.alternatepath = AlternatePathController:getRandomPath(i,len)
			-- print("初始序列4")
			-- print_lua_table(AlternatePathController.originalpath)

			-- 没有获得路径，进入下次循环
			if #AlternatePathController.alternatepath ~= 0 then
				-- 自检函数
				if AlternatePathController:check() == true then
					-- 找到了
					return AlternatePathController.alternatepath
				end
			end
		end
	end	
	-- print("没找到")
	-- 没找到
	return {}
end


-- 获取随机路径（旋转于镜像的方式，分支路径长度）
function AlternatePathController:getRandomPath(randomNum,len)
	-- 容器
	local temp = {}
	-- 旋转点，默认为分支路径长度加一的点
	local rotateX = AlternatePathController.originalpath[len + 1].x
	local rotateY = AlternatePathController.originalpath[len + 1].y
	-- print("初始序列")
	-- print_lua_table(AlternatePathController.originalpath)

	-- 原始路径的一部分加入容器
	for i=1,len do
		local tempP = cc.p(0,0)
		tempP.x = AlternatePathController.originalpath[i].x
		tempP.y = AlternatePathController.originalpath[i].y
		temp[#temp + 1] = tempP
	end
	-- print("point"..rotateX..rotateY)
	-- print_lua_table(temp)

	-- 旋转景象操作
	-- 在5*5的矩阵中，一个点的对应点一共有8个
	for i=1,#temp do
		local tempP = cc.p(0,0)
		temp[i].x = temp[i].x - rotateX
		temp[i].y = temp[i].y - rotateY

		if randomNum == 0 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y
			temp[i].x = tempP.x
			temp[i].y = tempP.y
		elseif randomNum == 1 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y
			temp[i].x = -tempP.x
			temp[i].y = tempP.y
		elseif randomNum == 2 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y
			temp[i].x = tempP.x
			temp[i].y = -tempP.y
		elseif randomNum == 3 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y			
			temp[i].x = -tempP.x
			temp[i].y = -tempP.y
		elseif randomNum == 4 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y
			temp[i].x = tempP.y
			temp[i].y = tempP.x
		elseif randomNum == 5 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y
			temp[i].x = -tempP.y
			temp[i].y = tempP.x
		elseif randomNum == 6 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y
			temp[i].x = tempP.y
			temp[i].y = -tempP.x
		elseif randomNum == 7 then
			tempP.x = temp[i].x
			tempP.y = temp[i].y			
			temp[i].x = -tempP.y
			temp[i].y = -tempP.x
		end

		temp[i].x = temp[i].x + rotateX
		temp[i].y = temp[i].y + rotateY

		-- 如果操作后的点已经不在5*5的矩阵中，返回空
		if temp[i].x < 1 or temp[i].x > 5 or temp[i].y < 1 or temp[i].y > 5 then
			return {}
		end
	end
	-- print("变化序列")
	-- print_lua_table(temp)
	return temp
end


-- 自检函数
function AlternatePathController:check()
	-- 如果新生成的分支，检查点是否跟以前的路径重复
	for k,v in pairs(AlternatePathController.alternatepath) do
		if 	AlternatePathController.mat[AlternatePathController.alternatepath[k].x][AlternatePathController.alternatepath[k].y] == 1 then
			return false
		end
	end
	return true
end

return AlternatePathController