-- 失败面板

-- 暂时只是一个静态面板

-- 只写了重玩，加道具玩 其他功能待定

-- 根据通关条件不同，显示不同的结束面板
local ItemView = require("playmodel.item.ItemView")
local WordView = require("playmodel.item.WordView")
local Button = require("playmodel.item.Button")
local LevelConfig = require('model.level.LevelConfig') 

local FailPopup = class ("FailPopup",function ()
	return cc.Layer:create()
end)

-- 失败面板
-- 参数 小岛序号 类型 收集元素的情况 错词的列表

function FailPopup:ctor(islandIndex,type,itemList,wordList)
	self.islandIndex = islandIndex
	self.type = type
    self.itemList = itemList
    self.wordList = wordList

    self.needItem = {#LevelConfig.BossConfig[islandIndex%2 + 1], LevelConfig.PointConfig[islandIndex%2 + 1][1],LevelConfig.WordConfig[islandIndex%2 + 1],}

	self:initUI()
end


-- 初始化ui
function FailPopup:initUI()
	-- 背景面板
	local back = cc.Sprite:create()
	back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)

    -- 失败
    local label1 = cc.Sprite:create()
    label1:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    label1:ignoreAnchorPointForPosition(false)
    label1:setAnchorPoint(0.5,0.5)
    self.label1 = label1
    self.back:addChild(self.label1,3)

    local label2 = cc.Sprite:create()
    label2:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    label2:ignoreAnchorPointForPosition(false)
    label2:setAnchorPoint(0.5,0.5)
    self.label2 = label2
    self.back:addChild(self.label2,3)

    local label3 = cc.Sprite:create()
    label3:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    label3:ignoreAnchorPointForPosition(false)
    label3:setAnchorPoint(0.5,0.5)
    self.label3 = label3
    self.back:addChild(self.label3,3)

    local label4 = cc.Sprite:create()
    label4:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    label4:ignoreAnchorPointForPosition(false)
    label4:setAnchorPoint(0.5,0.5)
    self.label4 = label4
    self.back:addChild(self.label4,3)

        -- 关卡显示
    local level = cc.Label:createWithSystemFont("","",27)
    level:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    level:ignoreAnchorPointForPosition(false)
    level:setAnchorPoint(0.5,0.5)
    self.level = level
    self.back:addChild(self.level)

        -- 目标模块---------------------------------------------
    -- 目前写死 等待配置文件
    local boss = cc.Sprite:create()
    boss:setPosition(0,0)
    boss:ignoreAnchorPointForPosition(false)
    boss:setAnchorPoint(0.5,0.5)
    self.boss = boss
    self.back:addChild(self.boss)

    local bossNum = cc.Label:createWithSystemFont("",'',30)
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

    local itemNum = cc.Label:createWithSystemFont("",'',30)
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

    local wordNum = cc.Label:createWithSystemFont("",'',30)
    wordNum:setPosition(0,0)
    wordNum:ignoreAnchorPointForPosition(false)
    wordNum:setAnchorPoint(0.5,0.5)
    self.wordNum = wordNum
    self.back:addChild(self.wordNum)

    local bossComplete = cc.Sprite:create("image/playmodel/complete.png") 
    self.bossComplete = bossComplete
    self.back:addChild(self.bossComplete)
    self.bossComplete:setVisible(false)

    local itemComplete = cc.Sprite:create("image/playmodel/complete.png") 
    self.itemComplete = itemComplete
    self.back:addChild(self.itemComplete)
    self.itemComplete:setVisible(false)

    local wordComplete = cc.Sprite:create("image/playmodel/complete.png") 
    self.wordComplete = wordComplete
    self.back:addChild(self.wordComplete)
    self.wordComplete:setVisible(false)

    -- 回调函数
    self.callBack = function ()
    end

    --关闭按钮---------------------------------------------
    local closeBtn = ccui.Button:create()
    closeBtn:setPosition(0,0)
    closeBtn:ignoreAnchorPointForPosition(false)
    closeBtn:setAnchorPoint(0.5,0.5)
    self.closeBtn = closeBtn
    self.back:addChild(self.closeBtn)
    self.closeBtn:addTouchEventListener(handler(self,self.closePopup))


    --词库按钮---------------------------------------------
    local wordBtn = ccui.Button:create()
    wordBtn:setPosition(0,0)
    wordBtn:ignoreAnchorPointForPosition(false)
    wordBtn:setAnchorPoint(0.5,0.5)
    self.wordBtn = wordBtn
    self.back:addChild(self.wordBtn)
    self.wordBtn:addTouchEventListener(handler(self,self.enterLib))


    --更多机会---------------------------------------------
    local moreBtn = ccui.Button:create()
    moreBtn:setPosition(0,0)
    moreBtn:ignoreAnchorPointForPosition(false)
    moreBtn:setAnchorPoint(0.5,0.5)
    self.moreBtn = moreBtn
    self.back:addChild(self.moreBtn)
    self.moreBtn:addTouchEventListener(handler(self,self.startWithMore))

    local dianmond = cc.Sprite:create()
    self.dianmond = dianmond
    self.moreBtn:addChild(self.dianmond)

    --更多机会---------------------------------------------
    local restartBtn = ccui.Button:create()
    restartBtn:setPosition(0,0)
    restartBtn:ignoreAnchorPointForPosition(false)
    restartBtn:setAnchorPoint(0.5,0.5)
    self.restartBtn = restartBtn
    self.back:addChild(self.restartBtn)
    self.restartBtn:addTouchEventListener(handler(self,self.restart))

    local heart = cc.Sprite:create()
    self.heart = heart
    self.restartBtn:addChild(self.heart)

    self:resetUI()
end

function FailPopup:resetUI()
    self.back:setTexture("image/playmodel/endpopup/failure.png")
    self.width = self.back:getContentSize().width

    if self.type == "time" then
        self.label1:setTexture("image/playmodel/endpopup/shi.png")
        self.label1:setPosition(self.width / 2,851)

        self.label2:setTexture("image/playmodel/endpopup/jian.png")
        self.label2:setPosition(self.width / 2,851)

        self.label3:setTexture("image/playmodel/endpopup/yong.png")
        self.label3:setPosition(self.width / 2,851)

        self.label4:setTexture("image/playmodel/endpopup/jin.png")
        self.label4:setPosition(self.width / 2,851)
    else
        self.label1:setTexture("image/playmodel/endpopup/bu.png")
        self.label1:setPosition(self.width / 2,851)

        self.label2:setTexture("image/playmodel/endpopup/shu.png")
        self.label2:setPosition(self.width / 2,851)

        self.label3:setTexture("image/playmodel/endpopup/yong.png")
        self.label3:setPosition(self.width / 2,851)

        self.label4:setTexture("image/playmodel/endpopup/jin.png")
        self.label4:setPosition(self.width / 2,851)
    end

    -----关卡名---------------------------------------

    self.level:setString('Unit '..self.islandIndex)
    self.level:setPosition(self.width / 2 + 5,770)
    self.level:setColor(cc.c4b(255,255,255,255))
    self.level:enableOutline(cc.c4b(32,120,162,255),3)

    ------item-----------------------

    self.boss:setTexture("image/playmodel/endpopup/boss.png")
    self.boss:setPosition(self.width /2 - 130,663)

    -- self.bossNum:setFntFile('font/CourierStd-Bold.fnt')
    self.bossNum:setPosition(self.width /2 - 130, 615)
    self.bossNum:setColor(cc.c4b(112,109,94,255))
    if self.itemList[1] > 0 then
        self.bossNum:setString((self.needItem[1] - self.itemList[1]).."/"..self.needItem[1])
    else
        self.bossComplete:setVisible(true)
        self.bossComplete:setPosition(self.width /2 - 130, 615)
    end

    self.item:setTexture("image/playmodel/endpopup/item.png")
    self.item:setPosition(self.width /2,663)

    -- self.itemNum:setFntFile('font/CourierStd-Bold.fnt')
    self.itemNum:setPosition(self.width /2, 615)
    self.itemNum:setColor(cc.c4b(112,109,94,255))
    if self.itemList[2] > 0 then
        self.itemNum:setString((self.needItem[2] - self.itemList[2]).."/"..self.needItem[2])
    else
        self.itemComplete:setVisible(true)
        self.itemComplete:setPosition(self.width /2, 615)
    end
    
    self.word:setTexture("image/playmodel/endpopup/word.png")
    self.word:setPosition(self.width /2 + 130,663)

    -- self.wordNum:setFntFile('font/CourierStd-Bold.fnt')
    self.wordNum:setPosition(self.width /2 + 130, 615)
    self.wordNum:setColor(cc.c4b(112,109,94,255))
    if self.itemList[3] > 0 then
        self.wordNum:setString((self.needItem[3] - self.itemList[3]).."/"..self.needItem[3])
    else
        self.wordComplete:setVisible(true)
        self.wordComplete:setPosition(self.width /2 + 130,  615)
    end

    self:addWrongWord()


        --关闭--------------------------------------
    self.closeBtn:setPosition(568,840)
    self.closeBtn:loadTextureNormal("image/playmodel/endpopup/closeNormal.png")
    self.closeBtn:loadTexturePressed("image/playmodel/endpopup/closePress.png")  

    ---词库-------------------------------------------
    self.wordBtn:setPosition(182,260)
    self.wordBtn:loadTextureNormal("image/playmodel/endpopup/faillibNormal.png")
    self.wordBtn:loadTexturePressed("image/playmodel/endpopup/faillibPress.png")   
    
    ---更多机会-------------------------------------------
    self.moreBtn:setPosition(410,260)
    if self.type == "time" then
        self.moreBtn:loadTextureNormal("image/playmodel/endpopup/addTimeNormal.png")
        self.moreBtn:loadTexturePressed("image/playmodel/endpopup/addTimePress.png") 
    else
        self.moreBtn:loadTextureNormal("image/playmodel/endpopup/addStepNormal.png")
        self.moreBtn:loadTexturePressed("image/playmodel/endpopup/addStepPress.png") 
    end

    self.dianmond:setTexture("image/playmodel/endpopup/bdiamond.png")
    self.dianmond:setPosition(94,134)
    ---重开-------------------------------------------
    self.restartBtn:setPosition(298,130)
    self.restartBtn:loadTextureNormal("image/playmodel/endpopup/restartNormal.png")
    self.restartBtn:loadTexturePressed("image/playmodel/endpopup/restartPress.png")  

    self.heart:setTexture("image/playmodel/endpopup/bheart.png")
    self.heart:setPosition(357,67)
end

function FailPopup:closePopup(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    s_SCENE:removeAllPopups()
    s_BattleManager:leaveBattleView()
end

function FailPopup:addWrongWord()
    for i=#self.wordList,1,-1 do
        if #self.wordList - i >= 3 then return end
        local word = cc.Label:createWithSystemFont(self.wordList[i],'',30)
        word:setColor(cc.c4b(112,109,94,255))
        word:enableOutline(cc.c4b(0,0,0,255),1)
        word:setPosition(self.width /2, 500 - (#self.wordList - i) * 33 )
        self.back:addChild(word)
        if #self.wordList - i == 0 then word:setColor(cc.c4b(255,0,0,255)) word:enableOutline(cc.c4b(255,0,0,255),1)end 

    end
end

function FailPopup:enterLib(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    printline("没有词库")
end

function FailPopup:startWithMore(sender,event)
    if event ~= ccui.TouchEventType.ended then
        self.dianmond:setTexture("image/playmodel/endpopup/bdiamond.png")
        return 
    end

    self.dianmond:setTexture("image/playmodel/endpopup/sdiamond.png")
end

function FailPopup:restart(sender,event)
    if event ~= ccui.TouchEventType.ended then
        self.heart:setTexture("image/playmodel/endpopup/bheart.png")
        return 
    end

    self.heart:setTexture("image/playmodel/endpopup/sheart.png")
end

return FailPopup