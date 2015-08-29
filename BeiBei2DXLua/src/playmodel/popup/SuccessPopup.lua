local ItemView = require("playmodel.item.ItemView")
local PetView = require("playmodel.item.PetView")
local WordView = require("playmodel.item.WordView")
local Button = require("playmodel.item.Button")
local SuccessPopup = class ("SuccessPopup",function ()
	return cc.Layer:create()
end)
-- 成功的面板
-- 参数 小岛序号 任务类型 收集元素列表
function SuccessPopup:ctor(islandIndex,type)
	self.islandIndex = islandIndex
	self.type = type
    -- self.itemList = itemList

	self:initUI()
end

-- 初始化ui
function SuccessPopup:initUI()
	-- 背景面板
	local back = cc.Sprite:create()
	back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
	back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)

    --通关特效
    local tong = cc.Sprite:create()
    tong:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    tong:ignoreAnchorPointForPosition(false)
    tong:setAnchorPoint(0.5,0.5)
    self.tong = tong
    self.back:addChild(self.tong,3)

    local guan = cc.Sprite:create()
    guan:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    guan:ignoreAnchorPointForPosition(false)
    guan:setAnchorPoint(0.5,0.5)
    self.guan = guan
    self.back:addChild(self.guan,3)

    local light1 = cc.Sprite:create()
    light1:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    light1:ignoreAnchorPointForPosition(false)
    light1:setAnchorPoint(0.5,0.5)
    self.light1 = light1
    self.back:addChild(self.light1,2)

    local light2 = cc.Sprite:create()
    light2:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    light2:ignoreAnchorPointForPosition(false)
    light2:setAnchorPoint(0.5,0.5)
    self.light2 = light2
    self.back:addChild(self.light2,2)

    local stars = cc.Sprite:create()
    stars:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    stars:ignoreAnchorPointForPosition(false)
    stars:setAnchorPoint(0.5,0.5)
    self.stars = stars
    self.back:addChild(self.stars)

    local pet = cc.Sprite:create()
    pet:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    pet:ignoreAnchorPointForPosition(false)
    pet:setAnchorPoint(0.5,0.5)
    self.pet = pet
    self.back:addChild(self.pet)

    -- 关卡显示
    local level = cc.Label:createWithSystemFont("","",27)
    level:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    level:ignoreAnchorPointForPosition(false)
    level:setAnchorPoint(0.5,0.5)
    self.level = level
    self.back:addChild(self.level)

    -- 阵容 

    local partner = cc.Sprite:create()
    partner:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    partner:ignoreAnchorPointForPosition(false)
    partner:setAnchorPoint(0.5,0.5)
    self.partner = partner
    self.back:addChild(self.partner)

    -- 奖励

    local starReward = cc.Sprite:create()
    starReward:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    starReward:ignoreAnchorPointForPosition(false)
    starReward:setAnchorPoint(0.5,0.5)
    self.starReward = starReward
    self.back:addChild(self.starReward)

    local starNum = ccui.TextBMFont:create()
    starNum:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    starNum:ignoreAnchorPointForPosition(false)
    starNum:setAnchorPoint(0.5,0.5)
    self.starNum = starNum
    self.back:addChild(self.starNum)

    local beanReward = cc.Sprite:create()
    beanReward:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    beanReward:ignoreAnchorPointForPosition(false)
    beanReward:setAnchorPoint(0.5,0.5)
    self.beanReward = beanReward
    self.back:addChild(self.beanReward)

    local beanNum = ccui.TextBMFont:create()
    beanNum:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    beanNum:ignoreAnchorPointForPosition(false)
    beanNum:setAnchorPoint(0.5,0.5)
    self.beanNum = beanNum
    self.back:addChild(self.beanNum)

    local diamondReward = cc.Sprite:create()
    diamondReward:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    diamondReward:ignoreAnchorPointForPosition(false)
    diamondReward:setAnchorPoint(0.5,0.5)
    self.diamondReward = diamondReward
    self.back:addChild(self.diamondReward)

    local diamondNum = ccui.TextBMFont:create()
    diamondNum:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    diamondNum:ignoreAnchorPointForPosition(false)
    diamondNum:setAnchorPoint(0.5,0.5)
    self.diamondNum = diamondNum
    self.back:addChild(self.diamondNum)

    -- 辣椒集

    local redChilli = cc.Sprite:create()
    redChilli:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    redChilli:ignoreAnchorPointForPosition(false)
    redChilli:setAnchorPoint(0.5,0.5)
    self.redChilli = redChilli
    self.back:addChild(self.redChilli,3)

    local greenChilli = cc.Sprite:create()
    greenChilli:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    greenChilli:ignoreAnchorPointForPosition(false)
    greenChilli:setAnchorPoint(0.5,0.5)
    self.greenChilli = greenChilli
    self.back:addChild(self.greenChilli,2)

    local yellowChilli = cc.Sprite:create()
    yellowChilli:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    yellowChilli:ignoreAnchorPointForPosition(false)
    yellowChilli:setAnchorPoint(0.5,0.5)
    self.yellowChilli = yellowChilli
    self.back:addChild(self.yellowChilli,2)

    local pot = cc.Sprite:create()
    pot:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    pot:ignoreAnchorPointForPosition(false)
    pot:setAnchorPoint(0.5,0.5)
    self.pot = pot
    self.back:addChild(self.pot)

    --下一关

    local nextBtn = ccui.Button:create()
    nextBtn:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    nextBtn:ignoreAnchorPointForPosition(false)
    nextBtn:setAnchorPoint(0.5,0.5)
    self.nextBtn = nextBtn
    self.back:addChild(self.nextBtn)
    self.nextBtn:addTouchEventListener(handler(self,self.startNextGame))

    -- 分享

    local shareBtn = ccui.Button:create()
    shareBtn:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    shareBtn:ignoreAnchorPointForPosition(false)
    shareBtn:setAnchorPoint(0.5,0.5)
    self.shareBtn = shareBtn
    self.back:addChild(self.shareBtn)
    self.shareBtn:addTouchEventListener(handler(self,self.shareTouch))

    --关闭按钮---------------------------------------------
    local closeBtn = ccui.Button:create()
    closeBtn:setPosition(0,0)
    closeBtn:ignoreAnchorPointForPosition(false)
    closeBtn:setAnchorPoint(0.5,0.5)
    self.closeBtn = closeBtn
    self.back:addChild(self.closeBtn)
    self.closeBtn:addTouchEventListener(handler(self,self.closePopup))

    -- 重置ui
    self:resetUI()
end
    
function SuccessPopup:resetUI()
    self.back:setTexture("image/playmodel/endpopup/success.png")
    self.width = self.back:getContentSize().width
    self.height = self.back:getContentSize().height   

    ----特效------------------------------------
    self.stars:setTexture("image/playmodel/endpopup/stars.png")
    self.stars:setPosition(self.width / 2 - 20,926)
    
    self.tong:setTexture("image/playmodel/endpopup/tong.png")
    self.tong:setPosition(self.width / 2,851)

    self.guan:setTexture("image/playmodel/endpopup/guan.png")
    self.guan:setPosition(self.width / 2,851)

    self.pet:setTexture("image/playmodel/endpopup/happyPet.png")
    self.pet:setPosition(self.width / 2 - 190,815)

    self.light1:setTexture("image/playmodel/endpopup/light1.png")
    self.light1:setPosition(self.width / 2,851)

    self.light2:setTexture("image/playmodel/endpopup/light2.png")
    self.light2:setPosition(self.width / 2,851)  

    -----关卡名---------------------------------------

    self.level:setString('Unit '..self.islandIndex)
    self.level:setPosition(self.width / 2 + 5,782)
    self.level:setColor(cc.c4b(255,255,255,255))
    self.level:enableOutline(cc.c4b(32,120,162,255),3)

    -----宠物配置---------------------------------------

    self.partner:setTexture("image/playmodel/endpopup/petShow.png")
    self.partner:setPosition(self.width / 2,650)

     -------奖励---------------------------------- 

    self.starReward:setTexture("image/playmodel/endpopup/starReward.png")
    self.starReward:setPosition(170,510)

    self.starNum:setFntFile('font/CourierStd-Bold.fnt')
    self.starNum:setString("3")
    self.starNum:setPosition(170, 450)
    self.starNum:setColor(cc.c4b(112,109,94,255))
    
    self.beanReward:setTexture("image/playmodel/endpopup/beanReward.png")
    self.beanReward:setPosition(300,510)

    self.beanNum:setFntFile('font/CourierStd-Bold.fnt')
    self.beanNum:setString("3")
    self.beanNum:setPosition(300, 450)
    self.beanNum:setColor(cc.c4b(112,109,94,255))

    self.diamondReward:setTexture("image/playmodel/endpopup/diamondReward.png")
    self.diamondReward:setPosition(430,510)

    self.diamondNum:setFntFile('font/CourierStd-Bold.fnt')
    self.diamondNum:setString("3")
    self.diamondNum:setPosition(430, 450)
    self.diamondNum:setColor(cc.c4b(112,109,94,255))

    -------锅---------------------------------- 

    self.pot:setTexture("image/playmodel/endpopup/pot.png")
    self.pot:setPosition(175,335)

    self.redChilli:setTexture("image/playmodel/endpopup/redChilli.png")
    self.redChilli:setPosition(165,330)

    self.greenChilli:setTexture("image/playmodel/endpopup/greenChilli.png")
    self.greenChilli:setPosition(165,330)

    self.yellowChilli:setTexture("image/playmodel/endpopup/yellowChilli.png")
    self.yellowChilli:setPosition(165,330)

    --下一关--------------------------------------
    self.nextBtn:setPosition(173,135)
    self.nextBtn:loadTextureNormal("image/playmodel/endpopup/nextNormal.png")
    self.nextBtn:loadTexturePressed("image/playmodel/endpopup/nextPress.png") 


    --分享--------------------------------------
    self.shareBtn:setPosition(416,135)
    self.shareBtn:loadTextureNormal("image/playmodel/endpopup/shareNormal.png")
    self.shareBtn:loadTexturePressed("image/playmodel/endpopup/sharePress.png")
    

    --关闭--------------------------------------
    self.closeBtn:setPosition(568,840)
    self.closeBtn:loadTextureNormal("image/playmodel/endpopup/closeNormal.png")
    self.closeBtn:loadTexturePressed("image/playmodel/endpopup/closePress.png")    

end

function SuccessPopup:shareTouch(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end


end

function SuccessPopup:startNextGame(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    s_SCENE:removeAllPopups()
    s_BattleManager:leaveBattleView()
end

function SuccessPopup:closePopup(sender,event)
    if event ~= ccui.TouchEventType.ended then
        return 
    end

    s_SCENE:removeAllPopups()
    s_BattleManager:leaveBattleView()
end


return SuccessPopup