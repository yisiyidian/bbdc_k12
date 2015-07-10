-- 备用类
-- 很有可能要去掉

local PetView = class("PetView",function ()
	return cc.Layer:create()
	end)

function PetView:ctor(list,width)
	self.list = list
	self.width = width
	self.petList = {}
	self.itemList = {}
	self.labelList = {}

	self:initUI()
end

function PetView:initUI()
	for k,v in pairs(self.list) do
		self:createItem()
	end
	self:resetUI()
end

function PetView:createItem()
	local petSprite = cc.Sprite:create()
	petSprite:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	petSprite:ignoreAnchorPointForPosition(false)
	petSprite:setAnchorPoint(0.5,0.5)
	self:addChild(petSprite)
	self.petList[#self.petList + 1] = petSprite

	local pointSprite = cc.Sprite:create()
	pointSprite:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	pointSprite:ignoreAnchorPointForPosition(false)
	pointSprite:setAnchorPoint(0.5,0.5)
	self:addChild(pointSprite)
	self.itemList[#self.itemList + 1] = pointSprite

	local label = cc.Label:createWithSystemFont("","",25)
	label:ignoreAnchorPointForPosition(false)
	label:setAnchorPoint(0.5,0.5)
	label:setColor(cc.c4b(0,0,0,255))
	self:addChild(label)
	self.labelList[#self.labelList + 1] = label
end

function PetView:resetUI()
	for k,v in pairs(self.list) do
		if self.list[k][1] == "red" then
			self.petList[k]:setTexture("image/playmodel/endpopup/redPet.png")
			self.itemList[k]:setTexture("image/playmodel/endpopup/redball.png")
		elseif self.list[k][1] == "green" then
			self.petList[k]:setTexture("image/playmodel/endpopup/greenPet.png")
			self.itemList[k]:setTexture("image/playmodel/endpopup/greenball.png")
		elseif self.list[k][1] == "blue" then
			self.petList[k]:setTexture("image/playmodel/endpopup/bluePet.png")
			self.itemList[k]:setTexture("image/playmodel/endpopup/blueball.png")
		elseif self.list[k][1] == "yellow" then
			self.petList[k]:setTexture("image/playmodel/endpopup/yellowPet.png")
			self.itemList[k]:setTexture("image/playmodel/endpopup/yellowball.png")
		elseif self.list[k][1] == "orange" then	
			self.petList[k]:setTexture("image/playmodel/endpopup/orangePet.png")
			self.itemList[k]:setTexture("image/playmodel/endpopup/orangeball.png")				
		end
		self.itemList[k]:setScale(0.5)
		self.labelList[k]:setString(self.list[k][2])
	end

	for i=1,#self.list do
		self.petList[i]:setPosition(self.width / (#self.list+1) * i,70)
		self.itemList[i]:setPosition(self.width / (#self.list+1) * i - 10,0)
		self.labelList[i]:setPosition(self.width / (#self.list+1) * i + 10,0)
	end
end

return PetView