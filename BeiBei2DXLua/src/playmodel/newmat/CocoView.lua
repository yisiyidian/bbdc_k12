--砖块元素
local CocoView = class("CocoView", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(120,120))
	layer:ignoreAnchorPointForPosition(false)
	layer:setAnchorPoint(0.5,0.5)
	return layer
end)

function CocoView.create()
    local layer = CocoView.new()
    return layer
end

function CocoView:ctor()
	self.touchState = 1
	-- 1 静止 2 按下 3 划过
	self.pos = cc.p(0,0)
	self.letter = ""
	-- 红0 绿1 黄2 蓝3 橙4 
	-- 按下为特殊色
	self.color = 0
	self.drop = 0

	self:initUI()
end

function CocoView:initUI()
	-- 用于滑动的砖块
    local downSprite = cc.Sprite:create()
    downSprite:ignoreAnchorPointForPosition(false)
    downSprite:setAnchorPoint(0.5,0.5)
    self.downSprite = downSprite
    self:addChild(self.downSprite)

    local upSprite = cc.Sprite:create()
    upSprite:ignoreAnchorPointForPosition(false)
    upSprite:setAnchorPoint(0.5,0.5)
    self.upSprite = upSprite
    self.downSprite:addChild(self.upSprite)

    local colorPoint = cc.Sprite:create()
    colorPoint:ignoreAnchorPointForPosition(false)
    colorPoint:setAnchorPoint(0.5,0.5)
    self.colorPoint = colorPoint
    self.upSprite:addChild(self.colorPoint)

    local label = cc.Label:createWithSystemFont("","",25)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self.upSprite:addChild(self.label)

    self:resetView()
end

function CocoView:resetView()
	self.downSprite:setTexture("image/playmodel/wordButton_downside.png")
	local contentsizeX = self.downSprite:getContentSize().width
	local contentsizeY = self.downSprite:getContentSize().height
	self:setContentSize(contentsizeX,contentsizeY)
	self.downSprite:setPosition(contentsizeX/2,contentsizeY/2)
	self.colorPoint:setTexture("image/playmodel/point.png")

	if self.color % 5 == 0 then
		self.colorPoint:setColor(cc.c4b(105,202,18,255))
	elseif self.color % 5 == 1 then
		self.colorPoint:setColor(cc.c4b(255,64,0,255))
	elseif self.color % 5 == 2 then
		self.colorPoint:setColor(cc.c4b(255,228,0,255))
	elseif self.color % 5 == 3 then
		self.colorPoint:setColor(cc.c4b(61,191,243,255))
	elseif self.color % 5 == 4 then
		self.colorPoint:setColor(cc.c4b(255,145,1,255))
	end	

	if self.touchState == 1 then 
		self.upSprite:setTexture("image/playmodel/wordButton_upside.png")
		self:setContentSize(contentsizeX,contentsizeY)
		self.upSprite:setPosition(contentsizeX/2,contentsizeY/2 + 10)
	elseif self.touchState == 2 then
		self.upSprite:setTexture("image/playmodel/wordButton_downside1.png")
		self:setContentSize(contentsizeX,contentsizeY)
		self.upSprite:setPosition(contentsizeX/2,contentsizeY/2)
		self.colorPoint:setColor(cc.c4b(255,221,84,255))
	elseif self.touchState == 3 then
		self.upSprite:setTexture("image/playmodel/wordButton_downside1.png")
		self:setContentSize(contentsizeX,contentsizeY)
		self.upSprite:setPosition(contentsizeX/2,contentsizeY/2 + 5)
		self.colorPoint:setColor(cc.c4b(255,221,84,255))
	end

	self.colorPoint:setPosition(contentsizeX - 5,contentsizeY - 5)
	self.label:setString(self.letter)
	self.label:setPosition(contentsizeX/2,contentsizeY/2)
end

return CocoView