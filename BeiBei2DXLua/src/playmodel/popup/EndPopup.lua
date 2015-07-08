-- 根据通关条件不同，显示不同的结束面板

local EndPopup = class ("EndPopup",function ()
	return cc.Layer:create()
end)

local function EndPopup:ctor(type)
	self.islandIndex = islandIndex
	self.type = type

	self:initUI()
end

local function EndPopup:initUI()
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

    -- 不熟悉的单词
    local showWordLabel = cc.Label:createWithSystemFont("","",25)
    showWordLabel:ignoreAnchorPointForPosition(false)
    showWordLabel:setAnchorPoint(0.5,0.5)
    showWordLabel:setColor(cc.c4b(0,0,0,255))
    self.showWordLabel = showWordLabel
    self.back:addChild(self.showWordLabel)

    -- 显示的帮助
    local showTipLabel = cc.Label:createWithSystemFont("","",25)
    showTipLabel:ignoreAnchorPointForPosition(false)
    showTipLabel:setAnchorPoint(0.5,0.5)
    showTipLabel:setColor(cc.c4b(0,0,0,255))
    self.showTipLabel = showTipLabel
    self.back:addChild(self.showTipLabel)

    -- 阵容
    local showPetLabel = cc.Label:createWithSystemFont("","",25)
    showPetLabel:ignoreAnchorPointForPosition(false)
    showPetLabel:setAnchorPoint(0.5,0.5)
    showPetLabel:setColor(cc.c4b(0,0,0,255))
    self.showPetLabel = showPetLabel
    self.back:addChild(self.showPetLabel)

    -- 奖励
    local showRewardLabel = cc.Label:createWithSystemFont("","",25)
    showRewardLabel:ignoreAnchorPointForPosition(false)
    showRewardLabel:setAnchorPoint(0.5,0.5)
    showRewardLabel:setColor(cc.c4b(0,0,0,255))
    self.showRewardLabel = showRewardLabel
    self.back:addChild(self.showRewardLabel)

    -- 奖励个蛋
    local showEggLabel = cc.Label:createWithSystemFont("","",25)
    showEggLabel:ignoreAnchorPointForPosition(false)
    showEggLabel:setAnchorPoint(0.5,0.5)
    showEggLabel:setColor(cc.c4b(0,0,0,255))
    self.showEggLabel = showEggLabel
    self.back:addChild(self.showEggLabel)

    -- 加行动机会，加时间限制
    local addChanceButton = ccui.Button:create()

    -- 回调函数
    self.callBack = function ()
    end

    -- 重玩按钮
    local restartButton = ccui.Button:create()

    -- 练习按钮
    local exerciseButton = ccui.Button:create()

    -- 查看奖励
    local rewardButton = ccui.Button:create()

    -- 分享
    local shareButton = ccui.Button:create()

end

return EndPopup