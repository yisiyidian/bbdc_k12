local ItemView = class("ItemView",function ()
	return cc.Layer:create()
end)

function ItemView:ctor(list,width)
	self.list = list
	self.width = width
	self.itemList = {}
	self.labelList = {}

	self:initUI()
end

function ItemView:initUI()
	for k,v in pairs(self.list) do
		self:createItem()
	end
	self:resetUI()
end

function ItemView:createItem()
	local sprite = cc.Sprite:create()
	sprite:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	sprite:ignoreAnchorPointForPosition(false)
    sprite:setAnchorPoint(0.5,0.5)
    self:addChild(sprite)
    self.itemList[#self.itemList + 1] = sprite

    local label = cc.Label:createWithSystemFont("","",25)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(0,0,0,255))
    self:addChild(label)
    self.labelList[#self.labelList + 1] = label
end

function ItemView:resetUI()
	for k,v in pairs(self.list) do
		if self.list[k][1] == "boss" then
			self.itemList[k]:setTexture("image/playmodel/endpopup/boss.png")
		elseif self.list[k][1] == "dimamond" then
			self.itemList[k]:setTexture("image/playmodel/endpopup/Diamond.png")
		elseif self.list[k][1] == "red" then
			self.itemList[k]:setTexture("image/playmodel/endpopup/redball.png")
		elseif self.list[k][1] == "green" then
			self.itemList[k]:setTexture("image/playmodel/endpopup/greenball.png")
		elseif self.list[k][1] == "blue" then
			self.itemList[k]:setTexture("image/playmodel/endpopup/blueball.png")
		elseif self.list[k][1] == "yellow" then
			self.itemList[k]:setTexture("image/playmodel/endpopup/yellowball.png")
		elseif self.list[k][1] == "orange" then	
			self.itemList[k]:setTexture("image/playmodel/endpopup/orangeball.png")				
		end

		self.labelList[k]:setString(self.list[k][2])
	end

	for i=1,#self.list do
		self.itemList[i]:setPosition(self.width / (#self.list+1) * i,50)
		self.labelList[i]:setPosition(self.width / (#self.list+1) * i,0)
	end
end

return ItemView