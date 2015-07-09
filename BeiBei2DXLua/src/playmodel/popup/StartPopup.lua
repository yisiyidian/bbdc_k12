-- 开始面板

local StartPopup = class ("StartPopup",function ()
	return cc.Layer:create()
end)

function StartPopup:ctor(type)
	self.islandIndex = islandIndex
	self.type = type

	self:initUI()
end

function StartPopup:initUI()
	-- 背景面板
	local back = cc.Sprite:create()
	back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)

    -- 小岛序号
    local islandIndexLabel = cc.Label:createWithSystemFont("","",25)
    islandIndexLabel:ignoreAnchorPointForPosition(false)
    islandIndexLabel:setAnchorPoint(0.5,0.5)
    islandIndexLabel:setColor(cc.c4b(0,0,0,255))
    self.islandIndexLabel = islandIndexLabel
    self.back:addChild(self.islandIndexLabel)

    -- 标题
    local titleLabel = cc.Label:createWithSystemFont("","",25)
    titleLabel:ignoreAnchorPointForPosition(false)
    titleLabel:setAnchorPoint(0.5,0.5)
    titleLabel:setColor(cc.c4b(0,0,0,255))
    self.titleLabel = titleLabel
    self.back:addChild(self.titleLabel)

    -- 收集的目标
    local showItemLabel = cc.Label:createWithSystemFont("","",25)
    showItemLabel:ignoreAnchorPointForPosition(false)
    showItemLabel:setAnchorPoint(0.5,0.5)
    showItemLabel:setColor(cc.c4b(0,0,0,255))
    self.showItemLabel = showItemLabel
    self.back:addChild(self.showItemLabel)

    -- 限制
    local showLimitLabel = cc.Label:createWithSystemFont("","",25)
    showLimitLabel:ignoreAnchorPointForPosition(false)
    showLimitLabel:setAnchorPoint(0.5,0.5)
    showLimitLabel:setColor(cc.c4b(0,0,0,255))
    self.showLimitLabel = showLimitLabel
    self.back:addChild(self.showLimitLabel)

    -- 阵容
    local showPetLabel = cc.Label:createWithSystemFont("","",25)
    showPetLabel:ignoreAnchorPointForPosition(false)
    showPetLabel:setAnchorPoint(0.5,0.5)
    showPetLabel:setColor(cc.c4b(0,0,0,255))
    self.showPetLabel = showPetLabel
    self.back:addChild(self.showPetLabel)


    -- 玩按钮
    local startButton = ccui.Button:create()

    -- 练习按钮
    local exerciseButton = ccui.Button:create()
end

return StartPopup