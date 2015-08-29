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

    -------------------------------

    self.levelName:setString("单元")
    self.levelName:setPosition(303,870)
    self.levelName:setSystemFontSize(50)
    self.levelName:setColor(cc.c4b(255,255,255,255))
    self.levelName:enableOutline(cc.c4b(0,0,0,255),2)

    self.levelNum:setString(self.islandIndex)
    self.levelNum:setPosition(303,830)
    self.levelNum:setSystemFontSize(30)
    self.levelNum:setColor(cc.c4b(255,255,255,255))
    self.levelNum:enableOutline(cc.c4b(0,0,0,255),2)
    -------------------------------
    self.boss:setTexture("image/playmodel/endpopup/boss.png")
    self.boss:setPosition(173,693)

    self.bossNum:setFntFile('font/CourierStd-Bold.fnt')
    self.bossNum:setString("3")
    self.bossNum:setPosition(173, 645)

    self.item:setTexture("image/playmodel/endpopup/item.png")
    self.item:setPosition(303,693)

    self.itemNum:setFntFile('font/CourierStd-Bold.fnt')
    self.itemNum:setString("10")
    self.itemNum:setPosition(303, 645)

    self.word:setTexture("image/playmodel/endpopup/word.png")
    self.word:setPosition(433,693)

    self.wordNum:setFntFile('font/CourierStd-Bold.fnt')
    self.wordNum:setString("10")
    self.wordNum:setPosition(433, 645)

    ----------------------------
    if self.type == "time" then
        self.limitCondition:setString("限时关卡:")
        self.limitCondition:setPosition(188,578)
        self.limitCondition:enableOutline(cc.c4b(255,255,255,255),1)
        self.alarmClock:setTexture("image/playmodel/endpopup/clock.png")
        self.alarmClock:setPosition(126,449)
        self.limitNum:setString(s_BattleManager.totalTime)
        self.limitNum:setPosition(286,494)
        self.limitNum:enableOutline(cc.c4b(255,255,255,255),1)
        self.sec:setString("秒")
        self.sec:enableOutline(cc.c4b(255,255,255,255),1)
        self.sec:setPosition(400,477)
    elseif self.type == "step" then
        self.limitCondition:setString("限步关卡:")
        self.limitCondition:setPosition(188,578)
        self.limitCondition:enableOutline(cc.c4b(255,255,255,255),1)
        self.limitNum:setString(s_BattleManager.totalStep)
        self.limitNum:setPosition(296,494)
    end

    ---------------------------------------------
    self.pet:setTexture("image/playmodel/endpopup/pet.png")
    self.pet:setPosition(300,317)
    ---------------------------------------------
    self.startBtn:setPosition(250,138)
    self.startBtn:loadTextureNormal("image/playmodel/endpopup/startNormal.png")
    self.startBtn:loadTexturePressed("image/playmodel/endpopup/startPress.png")

    self.heart:setPosition(51,74)
    self.heart:setTexture("image/playmodel/endpopup/heart.png")

    self.star:setPosition(345,40)
    self.star:setTexture("image/playmodel/endpopup/star.png")
    ---------------------------------------------
    self.wordBtn:setPosition(492,138)
    self.wordBtn:loadTextureNormal("image/playmodel/endpopup/libNormal.png")
    self.wordBtn:loadTexturePressed("image/playmodel/endpopup/libPress.png")   

    self.bean:setPosition(75,40)
    self.bean:setTexture("image/playmodel/endpopup/bean.png")
    ---------------------------------------------
    self.closeBtn:setPosition(542,836)
    self.closeBtn:loadTextureNormal("image/playmodel/endpopup/closeNormal.png")
    self.closeBtn:loadTexturePressed("image/playmodel/endpopup/closePress.png")  


    ---------------------------------------------
--     self.titleSprite:setTexture("image/playmodel/endpopup/title.png")
--     self.titleSprite:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.9)
    
--     local titleString = string.gsub('Unit '..s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(self.islandIndex)],"_","-")
--     self.islandIndexLabel:setString(titleString)
--     self.islandIndexLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.7)
    
--     if self.type == "time" then
--         self.titleLabel:setString("限时关卡")
--     elseif self.type == "step" then
--         self.titleLabel:setString("限步关卡")
--     end

--     self.titleLabel:setPosition(self.titleSprite:getContentSize().width/ 2 , self.titleSprite:getContentSize().height * 0.3)

--     -- ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
--     -- 这里少做了宠物配置更改，以及纪录宠物小队的配置
--     -- ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
--     for i=1,5 do
--         local texture = ""
--         if i == 1 then
--             texture = "image/playmodel/endpopup/orangePet.png"
--         elseif i == 2 then
--             texture = "image/playmodel/endpopup/redPet.png"
--         elseif i == 3 then   
--             texture = "image/playmodel/endpopup/yellowPet.png"    
--         elseif i == 4 then
--             texture = "image/playmodel/endpopup/greenPet.png"
--         elseif i == 5 then   
--             texture = "image/playmodel/endpopup/bluePet.png" 
--         end
--         local sprite = cc.Sprite:create(texture)
--         sprite:setPosition(self.back:getContentSize().width / 6 * i,self.back:getContentSize().height * 0.7)
--         self.back:addChild(sprite)
--     end


--     self.line1:setTexture("image/playmodel/endpopup/line.png")
--     self.line1:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.65)

--     self.missionLabel:setString("001")
--     self.missionLabel:setFntFile('font/CourierStd-Bold.fnt')
--     self.missionLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.6)

--     -- 关卡目标
--     -- 最多3种
--     self.itemList = {
--     -- {"boss","3"},
--     -- {"red",''..s_BattleManager.totalCollect},
-- }
    
--     if self.itemView ~= nil then
--         self.itemView:removeFromParent()
--     end
--     local itemView = ItemView.new(self.itemList,self.back:getContentSize().width)
--     itemView:setPosition(0 , self.back:getContentSize().height * 0.5)
--     self.itemView = itemView
--     self.back:addChild(self.itemView)

--     self.line2:setTexture("image/playmodel/endpopup/line.png")
--     self.line2:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.45)


--     self.limitLabel:setString("关卡限制")
--     self.limitLabel:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.4)

--     local string = ""
--     if self.type == "step" then
--         string = s_BattleManager.totalStep.."步"
--     elseif self.type == "time" then
--         string = s_BattleManager.totalTime.."秒"
--     end

--     self.timeOrStep:setString(string)
--     self.timeOrStep:setPosition(self.back:getContentSize().width/ 2 , self.back:getContentSize().height * 0.3)

--     if self.exerciseBtn ~= nil then
--         self.exerciseBtn:removeFromParent()
--     end
--     local exerciseBtn = Button.new("image/playmodel/endpopup/blueButton_1.png","image/playmodel/endpopup/blueButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"训练场")
--     exerciseBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.2)
--     self.exerciseBtn = exerciseBtn
--     self.back:addChild(self.exerciseBtn)
--     self.exerciseBtn.func = function ()

--     end
--     if self.startBtn ~= nil then
--         self.startBtn:removeFromParent()
--     end
--     local startBtn = Button.new("image/playmodel/endpopup/redButton_1.png","image/playmodel/endpopup/redButton_2.png","image/playmodel/endpopup/longButton_shadow.png",9,"开始挑战")
--     startBtn:setPosition(self.back:getContentSize().width * 0.5 , self.back:getContentSize().height * 0.09)
--     self.startBtn = startBtn
--     self.back:addChild(self.startBtn)


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