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
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	self.touchState = false
	self.pos = cc.p(0,0)
	self.letter = self:getRandomLetter()
	self.color = ""


	self:initUI()
end

function CocoView:initUI()
	-- 用于滑动的砖块
    local CocoSprite = cc.Sprite:create()
    CocoSprite:ignoreAnchorPointForPosition(false)
    CocoSprite:setAnchorPoint(0.5,0.5)
    self.CocoSprite = CocoSprite
    self:addChild(self.CocoSprite)

    local label = cc.Label:createWithSystemFont("","",25)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self:addChild(self.label)

    self:resetView()
end

function CocoView:resetView()
	self.CocoSprite:setTexture("image/coconut_font.png")
	local contentsizeX = self.CocoSprite:getContentSize().width
	local contentsizeY = self.CocoSprite:getContentSize().height
	self:setContentSize(contentsizeX,contentsizeY)
	self.CocoSprite:setPosition(contentsizeX/2,contentsizeY/2)
	self.label:setString(self.letter)
end

function CocoView:getRandomLetter()
	return string.char(math.random(97,123))
end

return CocoView