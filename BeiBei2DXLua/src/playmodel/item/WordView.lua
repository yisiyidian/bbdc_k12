
local WordView = class("WordView",function ()
	return cc.Layer:create()
end)

function WordView:ctor(list,height)
	self.list = list
	self.height = height
	self.wordList = {}
	self.numList = {}

	self:initUI()
end

function WordView:initUI()
	for k,v in pairs(self.list) do
		self:createItem()
	end
	self:resetUI()
end

function WordView:createItem()
	local word = cc.Label:createWithSystemFont("","",25)
    word:ignoreAnchorPointForPosition(false)
    word:setAnchorPoint(0.5,0.5)
    word:setColor(cc.c4b(0,0,0,255))
    self:addChild(word)
    self.wordList[#self.wordList + 1] = word

    local num = cc.Label:createWithSystemFont("","",25)
    num:ignoreAnchorPointForPosition(false)
    num:setAnchorPoint(0.5,0.5)
    num:setColor(cc.c4b(0,0,0,255))
    self:addChild(num)
    self.numList[#self.numList + 1] = num
end

function WordView:resetUI()
	for k,v in pairs(self.list) do
		self.wordList[k]:setString(self.list[k][1])
		self.numList[k]:setString(self.list[k][2])
	end

	for i=1,#self.list do
		self.wordList[i]:setPosition(100,self.height / (#self.list + 1) * (#self.list + 1 - i))
		self.numList[i]:setPosition(300,self.height / (#self.list + 1) * (#self.list + 1 - i))
	end
end

return WordView