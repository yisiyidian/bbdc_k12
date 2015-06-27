--砖块元素
local CocoView = class("CocoView", function()
	local layer = cc.Sprite:create()
	return layer
end)

function CocoView.create()
    local layer = CocoView.new()
    return layer
end

function CocoView:ctor()
	self.touchState = false
	self.pos = cc.p(0,0)
	self.letter = "a"
	self.color1 = false
	self.color2 = false
	self.color3 = false
	self.color4 = false
	self.color5 = false

	self:initUI()
end

function CocoView:initUI()
	-- 用于滑动的砖块
    local CocoSprite = cc.Sprite:create()
    CocoSprite:ignoreAnchorPointForPosition(false)
    CocoSprite:setAnchorPoint(0.5,0.5)
    self = CocoSprite

    local label = cc.Label:createWithSystemFont("","",25)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setPosition(self.pos)
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self:addChild(self.label)

    self:resetView()
end

function CocoView:resetView()
	self.CocoSprite:setTexture("image/coconut_font.png")
	self.label:setString(self.letter)
end

return CocoView