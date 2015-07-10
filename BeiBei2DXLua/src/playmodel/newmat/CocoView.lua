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
	-- 元素状态 1 静止 2 按下 3 划过
	self.touchState = 1
	-- 字母
	self.letter = ""
	-- 红0 绿1 黄2 蓝3 橙4 白5
	-- 按下为特殊色
	self.color = 0
	-- 元素下滑的长度 暂时一格60
	self.drop = 0
	-- 初始ui
	self:initUI()
end

function CocoView:initUI()
	-- 用于滑动的砖块 下层
    local downSprite = cc.Sprite:create()
    downSprite:ignoreAnchorPointForPosition(false)
    downSprite:setAnchorPoint(0.5,0.5)
    self.downSprite = downSprite
    self:addChild(self.downSprite)
	-- 用于滑动的砖块 上层 可移动
    local upSprite = cc.Sprite:create()
    upSprite:ignoreAnchorPointForPosition(false)
    upSprite:setAnchorPoint(0.5,0.5)
    self.upSprite = upSprite
    self.downSprite:addChild(self.upSprite)
    -- 元素上的彩点
    local colorPoint = cc.Sprite:create()
    colorPoint:ignoreAnchorPointForPosition(false)
    colorPoint:setAnchorPoint(0.5,0.5)
    self.colorPoint = colorPoint
    self.upSprite:addChild(self.colorPoint)
    -- 字母
    local label = cc.Label:createWithSystemFont("","",25)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self.upSprite:addChild(self.label)
    -- 绘制
    self:resetView()
end

function CocoView:resetView()
	-- 给sprite填充
	-- self。color用数字来区别颜色
	-- 如果是按下状态，touchState =2或3，颜色特殊
	-- 按下状态不同，砖块上层元素移动位置
	self.downSprite:setTexture("image/playmodel/wordButton_downside.png")
	local contentsizeX = self.downSprite:getContentSize().width
	local contentsizeY = self.downSprite:getContentSize().height
	self:setContentSize(contentsizeX,contentsizeY)
	self.downSprite:setPosition(contentsizeX/2,contentsizeY/2)
	self.colorPoint:setTexture("image/playmodel/point.png")

	if self.color % 6 == 0 then
		self.colorPoint:setColor(cc.c4b(105,202,18,255))
	elseif self.color % 6 == 1 then
		self.colorPoint:setColor(cc.c4b(255,64,0,255))
	elseif self.color % 6 == 2 then
		self.colorPoint:setColor(cc.c4b(255,228,0,255))
	elseif self.color % 6 == 3 then
		self.colorPoint:setColor(cc.c4b(61,191,243,255))
	elseif self.color % 6 == 4 then
		self.colorPoint:setColor(cc.c4b(255,145,1,255))
	elseif self.color % 6 == 5 then
		self.colorPoint:setColor(cc.c4b(255,255,255,255))
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