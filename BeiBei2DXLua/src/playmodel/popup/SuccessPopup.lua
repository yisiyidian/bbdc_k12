local ItemView = require("playmodel.item.ItemView")
local PetView = require("playmodel.item.PetView")
local WordView = require("playmodel.item.WordView")
local Button = require("playmodel.item.Button")
local SuccessPopup = class ("SuccessPopup",function ()
	return cc.Layer:create()
end)

function SuccessPopup:ctor(islandIndex,type,itemList)
	self.islandIndex = islandIndex
	self.type = type
    self.itemList = itemList

	self:initUI()
end

function SuccessPopup:initUI()
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

    local rewardLabel = cc.Label:createWithSystemFont("","",25)
    rewardLabel:ignoreAnchorPointForPosition(false)
    rewardLabel:setAnchorPoint(0.5,0.5)
    rewardLabel:setColor(cc.c4b(0,0,0,255))
    self.rewardLabel = rewardLabel
    self.back:addChild(self.rewardLabel)

    local eggLabel = cc.Label:createWithSystemFont("","",25)
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

    -- 回调函数
    self.callBack = function ()
    end

    self:resetUI()

    local closeBtn = Button.new("image/playmodel/endpopup/closeButton_2.png","image/playmodel/endpopup/closeButton_1.png","image/playmodel/endpopup/closeButton_shadow.png",9,"")
    closeBtn:setPosition(self.back:getContentSize().width * 0.9 , self.back:getContentSize().height * 0.9)
    self.closeBtn = closeBtn
    self.back:addChild(self.closeBtn)
    self.closeBtn.func = function ()
        s_SCENE:removeAllPopups()
        s_BattleManager:leaveBattleView()
    end
end

function SuccessPopup:resetUI()
    self.back:setTexture("image/playmodel/endpopup/broad.png")

    self.titleSprite:setTexture("image/playmodel/endpopup/title.png")
    self.titleSprite:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)

    self.islandIndexLabel:setString("unit 1-1")
    self.islandIndexLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.7)

    self.titleLabel:setString("通关")
    self.titleLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.3)

    self.petLabel:setString("我的阵容")
    self.petLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.8)

    self.itemList = {
    {"red","1"},
    {"red","1"},
    {"red","1"},
}
    
    if self.petView ~= nil then
        self.petView:removeFromParent()
    end
    local petView = PetView.new(self.itemList,self.back:getContentSize().width)
    petView:setPosition(0 , self.back:getContentSize().height * 0.65)
    self.petView = petView
    self.back:addChild(self.petView)

    self.line1:setTexture("image/playmodel/endpopup/line.png")
    self.line1:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.63)

    self.rewardLabel:setString("关卡奖励")
    self.rewardLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.6)

    self.rewardList = {
    {"dimamond","1"},
    {"dimamond","1"},
    {"dimamond","1"},
}
    
    if self.itemView ~= nil then
        self.itemView:removeFromParent()
    end
    local itemView = ItemView.new(self.rewardList,self.back:getContentSize().width)
    itemView:setPosition(0 , self.back:getContentSize().height * 0.5)
    self.itemView = itemView
    self.back:addChild(self.itemView)

    self.line2:setTexture("image/playmodel/endpopup/line.png")
    self.line2:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.48)


    self.eggLabel:setString("额外奖励")
    self.eggLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.45)

    for i=1,3 do
        local petSprite = cc.Sprite:create("image/playmodel/endpopup/egg1.png")
        petSprite:setPosition(self.back:getContentSize().width * 0.25 * i , self.back:getContentSize().height * 0.35)
        petSprite:ignoreAnchorPointForPosition(false)
        petSprite:setAnchorPoint(0.5,0.5)
        self.back:addChild(petSprite)
    end

    if self.exerciseBtn ~= nil then
        self.exerciseBtn:removeFromParent()
    end
    local exerciseBtn = Button.new("image/playmodel/endpopup/blueButton_1.png","image/playmodel/endpopup/blueButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"训练场")
    exerciseBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.2)
    self.exerciseBtn = exerciseBtn
    self.back:addChild(self.exerciseBtn)
    self.exerciseBtn.func = function ()

    end

    if self.restartBtn ~= nil then
        self.restartBtn:removeFromParent()
    end
    local restartBtn = Button.new("image/playmodel/endpopup/redButton_1.png","image/playmodel/endpopup/redButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"重新开始")
    restartBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.09)
    self.restartBtn = restartBtn
    self.back:addChild(self.restartBtn)
    self.restartBtn.func = function ()

    end
end


return SuccessPopup