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

	AlternatePathController:getRotatePath()
end

function AlternatePathController:getRotatePath()
	local temp = {}
	local rotateX = AlternatePathController.originalpath[AlternatePathController.halfLength + 1].x
	local rotateY = AlternatePathController.originalpath[AlternatePathController.halfLength + 1].y
	for i=1,AlternatePathController.halfLength do
		temp[#temp + 1] = AlternatePathController.originalpath[i]
	end
	for i=1,temp do
		local tempP = cc.p(0,0)
		temp[i].x = temp[i].x - rotateX
		temp[i].y = temp[i].y - rotateY


	end
end