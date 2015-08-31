-- 开始面板
local Button = require("playmodel.item.Button")
local ItemView = require("playmodel.item.ItemView")
local StartPopup = class ("StartPopup",function ()
	return cc.Layer:create()
end)
-- 开始面板 
-- 参数 小岛序号
function StartPopup:ctor(islandIndex)
	self.islandIndex = islandIndex
    -- 初始化关卡信息 词库等
    self.unit = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
    -- 初始化 关卡目标
    print_lua_table(self.unit)
    s_BattleManager:initState(self.unit.wrongWordList,self.unit.unitID)
    -- 目前的关卡类型
	self.type = s_BattleManager.stageType

	self:initUI()
end

-- 初始化ui
function StartPopup:initUI()
    -- 背景面板
    local back = cc.Sprite:create()
    back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)

    -- 标题模块---------------------------------------------
    --todo 
    local levelName = cc.Label:createWithSystemFont("","",22)
    levelName:setPosition(0,0)
    levelName:ignoreAnchorPointForPosition(false)
    levelName:setAnchorPoint(0.5,0.5)
    self.levelName = levelName
    self.back:addChild(self.levelName)

    local levelNum = cc.Label:createWithSystemFont("","",22)
    levelNum:setPosition(0,0)
    levelNum:ignoreAnchorPointForPosition(false)
    levelNum:setAnchorPoint(0.5,0.5)
    self.levelNum = levelNum
    self.back:addChild(self.levelNum)

    -- 目标模块---------------------------------------------
    -- 目前写死 等待配置文件
    local boss = cc.Sprite:create()
    boss:setPosition(0,0)
    boss:ignoreAnchorPointForPosition(false)
    boss:setAnchorPoint(0.5,0.5)
    self.boss = boss
    self.back:addChild(self.boss)

    local bossNum = ccui.TextBMFont:create()
    bossNum:setPosition(0,0)
    bossNum:ignoreAnchorPointForPosition(false)
    bossNum:setAnchorPoint(0.5,0.5)
    self.bossNum = bossNum
    self.back:addChild(self.bossNum)

    local item = cc.Sprite:create()
    item:setPosition(0,0)
    item:ignoreAnchorPointForPosition(false)
    item:setAnchorPoint(0.5,0.5)
    self.item = item
    self.back:addChild(self.item)

    local itemNum = ccui.TextBMFont:create()
    itemNum:setPosition(0,0)
    itemNum:ignoreAnchorPointForPosition(false)
    itemNum:setAnchorPoint(0.5,0.5)
    self.itemNum = itemNum
    self.back:addChild(self.itemNum)

    local word = cc.Sprite:create()
    word:setPosition(0,0)
    word:ignoreAnchorPointForPosition(false)
    word:setAnchorPoint(0.5,0.5)
    self.word = word
    self.back:addChild(self.word)

    local wordNum = ccui.TextBMFont:create()
    wordNum:setPosition(0,0)
    wordNum:ignoreAnchorPointForPosition(false)
    wordNum:setAnchorPoint(0.5,0.5)
    self.wordNum = wordNum
    self.back:addChild(self.wordNum)

    -- 限制模块---------------------------------------------
    local limitCondition = cc.Label:createWithSystemFont("","",22)
    limitCondition:ignoreAnchorPointForPosition(false)
    limitCondition:setAnchorPoint(0.5,0.5)
    limitCondition:setColor(cc.c4b(255,255,255,255))
    self.limitCondition = limitCondition
    self.back:addChild(self.limitCondition)

    local alarmClock = cc.Sprite:create()
    alarmClock:ignoreAnchorPointForPosition(false)
    alarmClock:setAnchorPoint(0.5,0.5)
    self.alarmClock = alarmClock
    self.back:addChild(self.alarmClock)

    local limitNum = cc.Label:createWithSystemFont("","",90)
    limitNum:ignoreAnchorPointForPosition(false)
    limitNum:setAnchorPoint(0.5,0.5)
    limitNum:setColor(cc.c4b(255,255,255,255))
    self.limitNum = limitNum
    self.back:addChild(self.limitNum)

    local sec = cc.Label:createWithSystemFont("","",60)
    sec:ignoreAnchorPointForPosition(false)
    sec:setAnchorPoint(0.5,0.5)
    sec:setColor(cc.c4b(255,255,255,255))
    self.sec = sec
    self.back:addChild(self.sec)
    --宠物模块---------------------------------------------

    local pet = cc.Sprite:create()
    pet:setPosition(0,0)
    pet:ignoreAnchorPointForPosition(false)
    pet:setAnchorPoint(0.5,0.5)
    self.pet = pet
    self.back:addChild(self.pet)

    --开始按钮---------------------------------------------
    local startBtn = ccui.Button:create()
    startBtn:setPosition(0,0)
    startBtn:ignoreAnchorPointForPosition(false)
    startBtn:setAnchorPoint(0.5,0.5)
    self.startBtn = startBtn
    self.back:addChild(self.startBtn)
    self.startBtn:addTouchEventListener(handler(self,self.startGame))

    local heart = cc.Sprite:create()
    heart:setPosition(0,0)
    heart:ignoreAnchorPointForPosition(false)
    heart:setAnchorPoint(0.5,0.5)
    self.heart = heart
    self.startBtn:addChild(self.heart) 

    local star = cc.Sprite:create()
    star:setPosition(0,0)
    star:ignoreAnchorPointForPosition(false)
    star:setAnchorPoint(0.5,0.5)
    self.star = star
    self.startBtn:addChild(self.star) 
       
    --词库按钮---------------------------------------------
    local wordBtn = ccui.Button:create()
    wordBtn:setPosition(0,0)
    wordBtn:ignoreAnchorPointForPosition(false)
    wordBtn:setAnchorPoint(0.5,0.5)
    self.wordBtn = wordBtn
    self.back:addChild(self.wordBtn)
    self.wordBtn:addTouchEventListener(handler(self,self.enterLib))

    local bean = cc.Sprite:create()
    bean:setPosition(0,0)
    bean:ignoreAnchorPointForPosition(false)
    bean:setAnchorPoint(0.5,0.5)
    self.bean = bean
    self.wordBtn:addChild(self.bean) 

    --关闭按钮---------------------------------------------
    local closeBtn = ccui.Button:create()
    closeBtn:setPosition(0,0)
    closeBtn:ignoreAnchorPointForPosition(false)
    closeBtn:setAnchorPoint(0.5,0.5)
    self.closeBtn = closeBtn
    self.back:addChild(self.closeBtn)
    self.closeBtn:addTouchEventListener(handler(self,self.closePopup))

    -- 重置UI
    self:resetUI()

end

function StartPopup:resetUI()
    self.back:setTexture("image/playmodel/endpopup/board.png")
    self.width = self.back:getContentSize().width

    -------------------------------

    self.levelName:setString("单元")
    self.levelName:setPosition(self.width /2 + 10,865)
    self.levelName:setSystemFontSize(50)
    self.levelName:setColor(cc.c4b(255,255,255,255))
    self.levelName:enableOutline(cc.c4b(0,0,0,255),2)

    self.levelNum:setString(self.islandIndex)
    self.levelNum:setPosition(self.width /2 + 10,825)
    self.levelNum:setSystemFontSize(30)
    self.levelNum:setColor(cc.c4b(255,255,255,255))
    self.levelNum:enableOutline(cc.c4b(0,0,0,255),2)
    -------------------------------
    self.boss:setTexture("image/playmodel/endpopup/boss.png")
    self.boss:setPosition(self.width /2 - 130,693)

    self.bossNum:setFntFile('font/CourierStd-Bold.fnt')
    self.bossNum:setString("3")
    self.bossNum:setPosition(self.width /2 - 130, 645)

    self.item:setTexture("image/playmodel/endpopup/item.png")
    self.item:setPosition(self.width /2,693)

    self.itemNum:setFntFile('font/CourierStd-Bold.fnt')
    self.itemNum:setString("20")
    self.itemNum:setPosition(self.width /2, 645)

    self.word:setTexture("image/playmodel/endpopup/word.png")
    self.word:setPosition(self.width /2 + 130,693)

    self.wordNum:setFntFile('font/CourierStd-Bold.fnt')
    self.wordNum:setString("10")
    self.wordNum:setPosition(self.width /2 + 130, 645)

    ----------------------------
    if self.type == "time" then
        self.limitCondition:setString("限时关卡:")
        self.limitCondition:setPosition(240,578)
        self.limitCondition:enableOutline(cc.c4b(255,255,255,255),1)
        self.alarmClock:setTexture("image/playmodel/endpopup/clock.png")
        self.alarmClock:setPosition(190,460)
        self.limitNum:setString(s_BattleManager.totalTime)
        self.limitNum:setPosition(self.width /2,494)
        self.limitNum:enableOutline(cc.c4b(255,255,255,255),1)
        self.sec:setString("秒")
        self.sec:enableOutline(cc.c4b(255,255,255,255),1)
        self.sec:setPosition(self.width /2 + 110,477)
    elseif self.type == "step" then
        self.limitCondition:setString("限步关卡:")
        self.limitCondition:setPosition(240,578)
        self.limitCondition:enableOutline(cc.c4b(255,255,255,255),1)
        self.limitNum:setString(s_BattleManager.totalStep)
        self.limitNum:setPosition(self.width /2,494)
    end

    ---------------------------------------------
    self.pet:setTexture("image/playmodel/endpopup/pet.png")
    self.pet:setPosition(self.width /2,317)
    ---------------------------------------------
    self.startBtn:setPosition(315,138)
    self.startBtn:loadTextureNormal("image/playmodel/endpopup/startNormal.png")
    self.startBtn:loadTexturePressed("image/playmodel/endpopup/startPress.png")

    self.heart:setPosition(51,74)
    self.heart:setTexture("image/playmodel/endpopup/heart.png")

    self.star:setPosition(345,40)
    self.star:setTexture("image/playmodel/endpopup/star.png")
    ---------------------------------------------
    self.wordBtn:setPosition(555,138)
    self.wordBtn:loadTextureNormal("image/playmodel/endpopup/libNormal.png")
    self.wordBtn:loadTexturePressed("image/playmodel/endpopup/libPress.png")   

    self.bean:setPosition(75,40)
    self.bean:setTexture("image/playmodel/endpopup/bean.png")
    ---------------------------------------------
    self.closeBtn:setPosition(610,836)
    self.closeBtn:loadTextureNormal("image/playmodel/endpopup/closeNormal.png")
    self.closeBtn:loadTexturePressed("image/playmodel/endpopup/closePress.png")  

end

function StartPopup:startGame(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    --     -- 这里的逻辑
--     -- ！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
--     -- 每个关卡有5种状态 1 5 6 7 8
--     -- 1为第一次进入当前关卡
--     -- 5678为4次复习
--     -- 内容上一模一样
--     -- boss隔日生成

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

function StartPopup:enterLib(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    printline("没有词库")
end

function StartPopup:closePopup(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    s_SCENE:removeAllPopups()
end

return StartPopup