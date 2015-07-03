local AlternatePathController = class("AlternatePathController")

AlternatePathController.originalpath = {}
AlternatePathController.alternatepath = {}

function AlternatePathController:getPath(path)
	AlternatePathController.originalpath = path
	AlternatePathController.alternatepath = {}
	-- print("初始序列1")
	-- print_lua_table(AlternatePathController.originalpath)

	local length = #AlternatePathController.originalpath
	AlternatePathController.halfLength = math.floor(length/2)
	if AlternatePathController.halfLength == 0 or AlternatePathController.halfLength >= 8 then
		return {}
	end
	AlternatePathController.mat = {
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	}

	-- print("初始序列2")
	-- print_lua_table(AlternatePathController.originalpath)

	for i=1,#AlternatePathController.originalpath do
	 	AlternatePathController.mat[AlternatePathController.originalpath[i].x][AlternatePathController.originalpath[i].y] = 1
	end 

	-- print("初始序列3")
	-- print_lua_table(AlternatePathController.originalpath)

	for len = AlternatePathController.halfLength,1,-1 do
		for i=0,7 do
			AlternatePathController.alternatepath = AlternatePathController:getRandomPath(i,len)
			-- print("初始序列4")
			-- print_lua_table(AlternatePathController.originalpath)
			if #AlternatePathController.alternatepath ~= 0 then
				if AlternatePathController:check() == true then
					return AlternatePathController.alternatepath
				end
			end
		end
	end	
	-- print("没找到")
	return {}
end

function AlternatePathController:getRandomPath(randomNum,len)
	local temp = {}
	local rotateX = AlternatePathController.originalpath[len + 1].x
	local rotateY = AlternatePathController.originalpath[len + 1].y
	-- print("初始序列")
	-- print_lua_table(AlternatePathController.originalpath)
	for i=1,len do
		local tempP = cc.p(0,0)
		tempP.x = AlternatePathController.originalpath[i].x
		tempP.y = AlternatePathController.originalpath[i].y
		temp[#temp + 1] = tempP
	end
	-- print("point"..rotateX..rotateY)
	-- print_lua_table(temp)
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

		if temp[i].x < 1 or temp[i].x > 5 or temp[i].y < 1 or temp[i].y > 5 then
			return {}
		end
	end
	-- print("变化序列")
	-- print_lua_table(temp)
	return temp
end

function AlternatePathController:check()
	for k,v in pairs(AlternatePathController.alternatepath) do
		if 	AlternatePathController.mat[AlternatePathController.alternatepath[k].x][AlternatePathController.alternatepath[k].y] == 1 then
			return false
		end
	end
	return true
end

return AlternatePathController