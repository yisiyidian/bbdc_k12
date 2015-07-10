-- 根据通关条件不同，显示不同的结束面板
local ItemView = require("playmodel.item.ItemView")
local WordView = require("playmodel.item.WordView")
local Button = require("playmodel.item.Button")
local FailPopup = class ("FailPopup",function ()
	return cc.Layer:create()
end)

function FailPopup:ctor(islandIndex,type,itemList,wordList)
	self.islandIndex = islandIndex
	self.type = type
    self.itemList = itemList
    self.wordList = wordList

	self:initUI()
end

function FailPopup:initUI()
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

    local unfinishLabel = cc.Label:createWithSystemFont("","",25)
    unfinishLabel:ignoreAnchorPointForPosition(false)
    unfinishLabel:setAnchorPoint(0.5,0.5)
    unfinishLabel:setColor(cc.c4b(0,0,0,255))
    self.unfinishLabel = unfinishLabel
    self.back:addChild(self.unfinishLabel)

    local unknowLabel = cc.Label:createWithSystemFont("","",25)
    unknowLabel:ignoreAnchorPointForPosition(false)
    unknowLabel:setAnchorPoint(0.5,0.5)
    unknowLabel:setColor(cc.c4b(0,0,0,255))
    self.unknowLabel = unknowLabel
    self.back:addChild(self.unknowLabel)

    local line = cc.Sprite:create() 
    line:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0.5,0.5)
    self.line = line
    self.back:addChild(self.line)

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

function FailPopup:resetUI()
    self.back:setTexture("image/playmodel/endpopup/broad.png")

    self.titleSprite:setTexture("image/playmodel/endpopup/title.png")
    self.titleSprite:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)

    local titleString = string.gsub('Unit '..s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(self.islandIndex)],"_","-")
    self.islandIndexLabel:setString(titleString)
    self.islandIndexLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.7)

    if self.type == "time" then
        self.titleLabel:setString("时间用完了")
    elseif self.type == "step" then
        self.titleLabel:setString("机会用完了")
    end

    self.titleLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.3)

    self.unfinishLabel:setString("任务目标未完成")
    self.unfinishLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.8)

    self.itemList = {
    {"boss","1/2"},
    {"dimamond","1/2"},
    {"red","1/2"},
}
    
    if self.itemView ~= nil then
        self.itemView:removeFromParent()
    end
    local itemView = ItemView.new(self.itemList,self.back:getContentSize().width)
    itemView:setPosition(0 , self.back:getContentSize().height * 0.7)
    self.itemView = itemView
    self.back:addChild(self.itemView)

    self.line:setTexture("image/playmodel/endpopup/line.png")
    self.line:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.65)

    self.unknowLabel:setString("不会的单词")
    self.unknowLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.6)

    self.wordList = {
    {"dimamond",3},
    {"dimamond",3},
    {"dimamond",3},
}
    
    if self.wordView ~= nil then
        self.wordView:removeFromParent()
    end

    local wordView = WordView.new(self.wordList,200)
    wordView:setPosition(100 , self.back:getContentSize().height * 0.4)
    self.wordView = wordView
    self.back:addChild(self.wordView)

    if self.exerciseBtn ~= nil then
        self.exerciseBtn:removeFromParent()
    end
    local exerciseBtn = Button.new("image/playmodel/endpopup/blueButton_1.png","image/playmodel/endpopup/blueButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"训练场")
    exerciseBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.35)
    self.exerciseBtn = exerciseBtn
    self.back:addChild(self.exerciseBtn)
    self.exerciseBtn.func = function ()

    end

    if self.addChanceBtn ~= nil then
        self.addChanceBtn:removeFromParent()
    end

    local text = ""
    if self.type == "time" then
        text = "时间用完了"
    elseif self.type == "step" then
        text = "机会用完了"
    end

    local addChanceBtn = Button.new("image/playmodel/endpopup/blueButton_1.png","image/playmodel/endpopup/blueButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,text)
    addChanceBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.22)
    self.addChanceBtn = addChanceBtn
    self.back:addChild(self.addChanceBtn)
    self.addChanceBtn.func = function ()
        self.callBack()
        s_SCENE:removeAllPopups()
        s_BattleManager:oneMoreChance()
    end

    self.addChanceBtn:addSprite("image/playmodel/endpopup/Diamond.png",10)

    if self.restartBtn ~= nil then
        self.restartBtn:removeFromParent()
    end
    local restartBtn = Button.new("image/playmodel/endpopup/redButton_1.png","image/playmodel/endpopup/redButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"重新开始")
    restartBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.09)
    self.restartBtn = restartBtn
    self.back:addChild(self.restartBtn)
    self.restartBtn.func = function ()
        s_SCENE:removeAllPopups()
        s_BattleManager:restartBattle()
    end
    self.restartBtn:addSprite("image/playmodel/endpopup/heart01.png")
end


return FailPopup