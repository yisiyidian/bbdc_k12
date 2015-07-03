local AlternatePathController = class("AlternatePathController")

AlternatePathController.originalpath = {}
AlternatePathController.alternatepath = {}

function AlternatePathController:getPath(path)
	AlternatePathController.originalpath = path
	AlternatePathController.alternatepath = {}

	local length = #AlternatePathController.originalpath
	AlternatePathController.halfLength = math.floor(length/2)
	if AlternatePathController.halfLength == 0 then
		return {}
	end
	AlternatePathController.mat = {
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	{0,0,0,0,0,},
	}

	for i=1,#AlternatePathController.originalpath do
	 	AlternatePathController.mat[AlternatePathController.originalpath[i].x][AlternatePathController.originalpath[i].y] = 1
	end 

	AlternatePathController:getRandomPath()
end

function AlternatePathController:getRandomPath()
	for i=1,AlternatePathController.halfLength do
		print(i)
	end
end