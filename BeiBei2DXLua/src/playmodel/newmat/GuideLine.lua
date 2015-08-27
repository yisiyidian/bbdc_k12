local GuideLine = class("GuideLine",function ()
	local layer = cc.Layer:create()
	return layer
end)

function GuideLine.create()
	return GuideLine.new()
end

function GuideLine:ctor()
	local layer = cc.LayerColor:create(cc.c4b(255,255,255,0),s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
	self.layer = layer
	self:addChild(self.layer)

	self.List = {}

	self:updateView()
end

function GuideLine:updateView()
 	if not tolua.isnull(self.layer) then
		self.layer:removeAllChildren()
	end

	-- print("updateView")

	-- print_lua_table(self.List)

	local pListX = {}
	local pListY = {}

	for i=1,#self.List do
		pListX[i] = self.List[i].x
		pListY[i] = self.List[i].y
	end

	if #pListX ~= #pListY or #pListX <= 1 then
		return
	end

	for i=1,#pListX - 1 do
		local position = cc.p(pListX[i]/2 + pListX[i+1]/2 - 10,     pListY[i]/2 + pListY[i+1]/2)
		local sprite = cc.Sprite:create("image/playmodel/rightArrow.png")
		sprite:setPosition(position)
		self.layer:addChild(sprite,2)
		-- print("add")

		local angle = 0
		if self:getAngle(pListX[i], pListX[i+1],     pListY[i] , pListY[i+1]) ~= nil then
			angle =  self:getAngle(pListX[i], pListX[i+1],     pListY[i] , pListY[i+1])
		end
		sprite:setRotation(angle)
	end
end

function GuideLine:showFalse()
	self.layer:removeAllChildren()
	local pListX = {}
	local pListY = {}

	for i=1,#self.List do
		pListX[i] = self.List[i]:getPositionX()
		pListY[i] = self.List[i]:getPositionY()
	end

	if #pListX ~= #pListY or #pListX <= 1 then
		return
	end

	for i=1,#pListX - 1 do
		local position = cc.p(pListX[i]/2 + pListX[i+1]/2,     pListY[i]/2 + pListY[i+1]/2)
		local sprite = cc.Sprite("image/playmodel/wrongArrow.png")
		sprite:runAction(cc.FadeOut:create(0.5))
		sprite:setPosition(position)
		self.layer:addChild(sprite)

		local angle = 0
		if self:getAngle(pListX[i], pListX[i+1],     pListY[i] , pListY[i+1]) ~= nil then
			angle =  self:getAngle(pListX[i], pListX[i+1],     pListY[i] , pListY[i+1])
		end
		sprite:setRotation(angle)
	end
end

function GuideLine:getAngle(p1x,p2x,p1y,p2y)
	if p1x > p2x and p1y == p2y then
		return 180
	elseif p1x < p2x and p1y == p2y then
		return 0
	elseif p1x == p2x and p1y > p2y then
		return 90
	elseif p1x == p2x and p1y < p2y then
		return -90
	end
	printline("坐标有问题")
	return nil
end

return GuideLine