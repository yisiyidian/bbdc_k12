--砖块元素
local CocoView = class("CocoView", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(120,120))
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

	self.initUI()
end

function CocoView:initUI()
	-- 用于滑动的砖块
    local CocoSprite = cc.Sprite:create()
    CocoSprite:ignoreAnchorPointForPosition(false)
    CocoSprite:setAncherPoint(0.5,0.5)
    self.CocoSprite = CocoSprite
    self:addChild(self.CocoSprite)

    

    
end

return CocoView