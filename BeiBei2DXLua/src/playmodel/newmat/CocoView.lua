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
	self.color = ""
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

	if self.touchState == 1 then 
		self.upSprite:setTexture("image/playmodel/wordButton_upside.png")
		self:setContentSize(contentsizeX,contentsizeY)
		self.upSprite:setPosition(contentsizeX/2,contentsizeY/2 + 10)
	elseif self.touchState == 2 then
		self.upSprite:setTexture("image/playmodel/wordButton_downside1.png")
		self:setContentSize(contentsizeX,contentsizeY)
		self.upSprite:setPosition(contentsizeX/2,contentsizeY/2)
	elseif self.touchState == 3 then
		self.upSprite:setTexture("image/playmodel/wordButton_downside1.png")
		self:setContentSize(contentsizeX,contentsizeY)
		self.upSprite:setPosition(contentsizeX/2,contentsizeY/2 + 5)
	end
	self.label:setString(self.letter)
	self.label:setPosition(contentsizeX/2,contentsizeY/2)
end

return CocoView