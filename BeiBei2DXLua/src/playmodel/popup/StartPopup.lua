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
    local titleSprite = cc.Sprite:create() 
    titleSprite:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)
    titleSprite:ignoreAnchorPointForPosition(false)
    titleSprite:setAnchorPoint(0.5,0.5)
    self.titleSprite = titleSprite
    self.back:addChild(self.titleSprite)

    local islandIndexLabel = cc.Label:createWithSystemFont("","",25)
    islandIndexLabel:ignoreAnchorPointForPosition(false)
    islandIndexLabel:setAnchorPoint(0.5,0.5)
    islandIndexLabel:setColor(cc.c4b(0,0,0,255))
    self.islandIndexLabel = islandIndexLabel
    self.titleSprite:addChild(self.islandIndexLabel)

    -- 标题
    local titleLabel = cc.Label:createWithSystemFont("","",25)
    titleLabel:ignoreAnchorPointForPosition(false)
    titleLabel:setAnchorPoint(0.5,0.5)
    titleLabel:setColor(cc.c4b(0,0,0,255))
    self.titleLabel = titleLabel
    self.titleSprite:addChild(self.titleLabel)

    local petLabel = cc.Label:createWithSystemFont("","",25)
    petLabel:ignoreAnchorPointForPosition(false)
    petLabel:setAnchorPoint(0.5,0.5)
    petLabel:setColor(cc.c4b(0,0,0,255))
    self.petLabel = petLabel
    self.back:addChild(self.petLabel)

    local missionLabel = cc.Label:createWithSystemFont("","",25)
    rewardLabel:ignoreAnchorPointForPosition(false)
    rewardLabel:setAnchorPoint(0.5,0.5)
    rewardLabel:setColor(cc.c4b(0,0,0,255))
    self.rewardLabel = rewardLabel
    self.back:addChild(self.rewardLabel)

    local limitLabel = cc.Label:createWithSystemFont("","",25)
    eggLabel:ignoreAnchorPointForPosition(false)
    eggLabel:setAnchorPoint(0.5,0.5)
    eggLabel:setColor(cc.c4b(0,0,0,255))
    self.eggLabel = eggLabel
    self.back:addChild(self.eggLabel)

    local line1 = cc.Sprite:create() 
    line1:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)
    line1:ignoreAnchorPointForPosition(false)
    line1:setAnchorPoint(0.5,0.5)
    self.line1 = line1
    self.back:addChild(self.line1)

    local line2 = cc.Sprite:create() 
    line2:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)
    line2:ignoreAnchorPointForPosition(false)
    line2:setAnchorPoint(0.5,0.5)
    self.line2 = line2
    self.back:addChild(self.line2)


    self:resetUI()

    local closeBtn = Button.new("image/playmodel/endpopup/closeButton_2.png","image/playmodel/endpopup/closeButton_1.png","image/playmodel/endpopup/closeButton_shadow.png",9,"")
    closeBtn:setPosition(self.back:getContentSize().width * 0.9 , self.back:getContentSize().height * 0.9)
    self.closeBtn = closeBtn
    self.back:addChild(self.closeBtn)

    self.closeBtn.func = function ()
        s_SCENE:removeAllPopups()
    end
end

function StartPopup:initUI()
    self.back:setTexture("image/playmodel/endpopup/broad.png")

    self.titleSprite:setTexture("image/playmodel/endpopup/title.png")
    self.titleSprite:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)

    self.islandIndexLabel:setString("unit 1-1")
    self.islandIndexLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.7)
    
    if self.type == "time" then
        self.titleLabel:setString("限时关卡")
    elseif self.type == "step" then
        self.titleLabel:setString("限步关卡")
    end

    self.titleLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.3)

    self.petLabel:setString("我的阵容")
    self.petLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.8)

    
end

return StartPopup