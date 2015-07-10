-- 开始面板
local Button = require("playmodel.item.Button")
local ItemView = require("playmodel.item.ItemView")
local StartPopup = class ("StartPopup",function ()
	return cc.Layer:create()
end)

function StartPopup:ctor(islandIndex)
	self.islandIndex = islandIndex
    self.unit = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
    if self.unit.unitID % 2 == 1 then
        s_BattleManager:initState(100,10,20,self.unit.wrongWordList,'step')
    else
        s_BattleManager:initState(100,10,20,self.unit.wrongWordList,'time')
    end
	self.type = s_BattleManager.stageType

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
    missionLabel:ignoreAnchorPointForPosition(false)
    missionLabel:setAnchorPoint(0.5,0.5)
    missionLabel:setColor(cc.c4b(0,0,0,255))
    self.missionLabel = missionLabel
    self.back:addChild(self.missionLabel)

    local limitLabel = cc.Label:createWithSystemFont("","",25)
    limitLabel:ignoreAnchorPointForPosition(false)
    limitLabel:setAnchorPoint(0.5,0.5)
    limitLabel:setColor(cc.c4b(0,0,0,255))
    self.limitLabel = limitLabel
    self.back:addChild(self.limitLabel)

    local timeOrStep = cc.Label:createWithSystemFont("","",25)
    timeOrStep:ignoreAnchorPointForPosition(false)
    timeOrStep:setAnchorPoint(0.5,0.5)
    timeOrStep:setColor(cc.c4b(0,0,0,255))
    self.timeOrStep = timeOrStep
    self.back:addChild(self.timeOrStep)

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

function StartPopup:resetUI()
    self.back:setTexture("image/playmodel/endpopup/broad.png")

    self.titleSprite:setTexture("image/playmodel/endpopup/title.png")
    self.titleSprite:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)
    
    local titleString = string.gsub('Unit '..s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(self.islandIndex)],"_","-")
    self.islandIndexLabel:setString(titleString)
    self.islandIndexLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.7)
    
    if self.type == "time" then
        self.titleLabel:setString("限时关卡")
    elseif self.type == "step" then
        self.titleLabel:setString("限步关卡")
    end

    self.titleLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.3)

    self.petLabel:setString("我的阵容")
    self.petLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.8)

    for i=1,5 do
        local texture = ""
        if i == 1 then
            texture = "image/playmodel/endpopup/orangePet.png"
        elseif i == 2 then
            texture = "image/playmodel/endpopup/redPet.png"
        elseif i == 3 then   
            texture = "image/playmodel/endpopup/yellowPet.png"    
        elseif i == 4 then
            texture = "image/playmodel/endpopup/greenPet.png"
        elseif i == 5 then   
            texture = "image/playmodel/endpopup/bluePet.png" 
        end
        local sprite = cc.Sprite:create(texture)
        sprite:setPosition(self.back:getContentSize().width / 6 * i,self.back:getContentSize().height * 0.7)
        self.back:addChild(sprite)
    end


    self.line1:setTexture("image/playmodel/endpopup/line.png")
    self.line1:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.65)

    self.missionLabel:setString("关卡目标")
    self.missionLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.6)

    self.itemList = {
    {"boss","3"},
    {"red",''..s_BattleManager.totalCollect},
}
    
    if self.itemView ~= nil then
        self.itemView:removeFromParent()
    end
    local itemView = ItemView.new(self.itemList,self.back:getContentSize().width)
    itemView:setPosition(0 , self.back:getContentSize().height * 0.5)
    self.itemView = itemView
    self.back:addChild(self.itemView)

    self.line2:setTexture("image/playmodel/endpopup/line.png")
    self.line2:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.45)


    self.missionLabel:setString("关卡限制")
    self.missionLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.4)

    local string = ""
    if self.type == "step" then
        string = s_BattleManager.totalStep.."步"
    elseif self.type == "time" then
        string = s_BattleManager.totalTime.."秒"
    end

    self.timeOrStep:setString(string)
    self.timeOrStep:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.3)

    if self.exerciseBtn ~= nil then
        self.exerciseBtn:removeFromParent()
    end
    local exerciseBtn = Button.new("image/playmodel/endpopup/blueButton_1.png","image/playmodel/endpopup/blueButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"训练场")
    exerciseBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.2)
    self.exerciseBtn = exerciseBtn
    self.back:addChild(self.exerciseBtn)
    self.exerciseBtn.func = function ()

    end
    if self.startBtn ~= nil then
        self.startBtn:removeFromParent()
    end
    local startBtn = Button.new("image/playmodel/endpopup/redButton_1.png","image/playmodel/endpopup/redButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"开始挑战")
    startBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.09)
    self.startBtn = startBtn
    self.back:addChild(self.startBtn)
    self.startBtn.func = function ()
        local bossList = s_LocalDatabaseManager.getAllUnitInfo()
        local maxID = s_LocalDatabaseManager.getMaxUnitID()
        if self.unit.coolingDay > 0 or self.unit.unitState >= 5 then
            -- 记录用户点击的关卡号
            s_game_fail_level_index = self.unit.unitID - 1
            s_BattleManager:enterBattleView(self.unit)
            s_SCENE:removeAllPopups()  
            return
        end
        local taskIndex = -2

        for bossID, bossInfo in pairs(bossList) do
            if bossInfo["coolingDay"] == 0 and bossInfo["unitState"] - 1 >= 0 and taskIndex == -2 and bossInfo["unitState"] - 5 < 0 then
                taskIndex = bossID
            end
        end    

        if taskIndex == -2 then      
            s_CorePlayManager.initTotalUnitPlay() -- 之前没有boss
            s_SCENE:removeAllPopups()  
        elseif taskIndex == self.islandIndex then
            s_CorePlayManager.initTotalUnitPlay() -- 按顺序打第一个boss
            s_SCENE:removeAllPopups()  
        end 
    end
    self.startBtn:addSprite("image/playmodel/endpopup/heart01.png")

end

return StartPopup