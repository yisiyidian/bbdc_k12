--砖块元素
local CocoView = class("CocoView", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(100,100))
	layer:ignoreAnchorPointForPosition(false)
	layer:setAnchorPoint(0.5,0.5)
	return layer
end)

function CocoView.create()
    local layer = CocoView.new()
    return layer
end

function CocoView:ctor()
	-- 元素状态 1 静止 2 按下 3 划过 0 不显示
	self.touchState = 1
	-- 首字母 标示
	self.isFisrt = false
	-- 字母
	self.letter = ""
	-- 红0 绿1 黄2 蓝3 橙4 
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
    downSprite:setAnchorPoint(0,0)
    self.downSprite = downSprite
    self:addChild(self.downSprite)
    -- 收集性质的元素
    local collectItem = cc.Sprite:create()
    collectItem:ignoreAnchorPointForPosition(false)
    collectItem:setAnchorPoint(0.5,0.5)
    self.collectItem = collectItem
    self.downSprite:addChild(self.collectItem)
    -- 字母
    local label = cc.Label:createWithTTF("",'font/ArialRoundedBold.ttf',55)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self.downSprite:addChild(self.label)
    -- 绘制
    self:resetView()
end

function CocoView:resetView()
	-- 给sprite填充
	-- self。color用数字来区别颜色
	-- 如果是按下状态，touchState =2或3，颜色特殊
	-- 按下状态不同，砖块上层元素移动位置
	self.downSprite:setTexture("image/playmodel/dishNormal.png")
	local contentsizeX = self.downSprite:getContentSize().width
	local contentsizeY = self.downSprite:getContentSize().height

	if self.color % 5 == 0 then
		self.collectItem:setTexture("image/playmodel/chilliNormal.png")
	end	

	if self.isFisrt then
		self.collectItem:setTexture("image/playmodel/chilliFirst.png")
	end

	if self.touchState == 1 then 
		self.downSprite:setTexture("image/playmodel/dishNormal.png")
	elseif self.touchState == 2 then
		self.downSprite:setTexture("image/playmodel/dishShake.png")
		self.collectItem:setTexture("image/playmodel/chilliPress.png")
	elseif self.touchState == 3 then
		self.downSprite:setTexture("image/playmodel/dishShake.png")
		self.collectItem:setTexture("image/playmodel/chilliPress.png")
	elseif self.touchState == 0 then 
		self.collectItem:setVisible(false)
	end

	if self.isFisrt then
		if self.touchState == 1 then 
			self.downSprite:setTexture("image/playmodel/firstNormal.png")
		elseif self.touchState == 2 then
			self.downSprite:setTexture("image/playmodel/firstShake.png")
		elseif self.touchState == 3 then
			self.downSprite:setTexture("image/playmodel/firstShake.png")
		end
	end

	self.collectItem:setPosition(contentsizeX/2,contentsizeY/2)
	self.label:setString(self.letter)
	self.label:setPosition(contentsizeX/2,contentsizeY/2)
	if self.letter == 'g' or self.letter == 'j' or self.letter == 'p' or self.letter == 'q' or self.letter == 'y' then
		self.label:setPosition(contentsizeX/2,contentsizeY/2  + 3)
	end
end

return CocoView