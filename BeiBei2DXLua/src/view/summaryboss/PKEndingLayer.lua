local MeetOpponentLayer = require('view.summaryboss.MeetOpponentLayer')

local PKEndingLayer = class("PKEndingLayer", function ()
    return cc.Layer:create()
end)

function PKEndingLayer.create()
    local layer = PKEndingLayer.new()
    return layer
end

function PKEndingLayer:ctor()

	self.myname = MeetOpponentLayer:rename()
	self.myschool = MeetOpponentLayer:reschool()
	self.mytime = s_CURRENT_USER.pkMyTime
	self.mygrade = "失败"
	if s_CURRENT_USER.pkMyGrade then
		self.mygrade = "通关"
	end

	self.opname = s_CURRENT_USER.pkPlayer
	self.opschool = s_CURRENT_USER.schoolName
	self.optime = s_CURRENT_USER.pkPlayerTime
	self.opgrade = "失败"
	if s_CURRENT_USER.pkPlayerGrade then
		self.opgrade = "通关"
	end

	self.pkUnitID = s_CURRENT_USER.pkUnitID
    self.unit = s_LocalDatabaseManager.getUnitInfo(self.pkUnitID)

	self:resetData()
	self:init()
end

function PKEndingLayer:init()
	local back = cc.Sprite:create()
    back:setPosition((s_RIGHT_X - s_LEFT_X) / 2 , s_DESIGN_HEIGHT / 2)
	self.back = back
	self:addChild(self.back)


	self.win = false

	self.back:setTexture("image/pk/lose.png")
	if self.mygrade == "通关" then
		if self.opgrade == "失败" or (self.opgrade == "通关" and self.mytime <= self.optime) then
			self.back:setTexture("image/pk/win.png")
			self.win = true
		end
	end

    local offset = 107
	local mynameLabel = cc.Label:createWithSystemFont(self.myname,'',40)
    mynameLabel:ignoreAnchorPointForPosition(false)
    mynameLabel:setAnchorPoint(1,0.5)
    mynameLabel:setColor(cc.c4b(255,255,255,255))
    mynameLabel:setPosition(self.back:getContentSize().width /2 - 20,850)
    self.mynameLabel = mynameLabel
    self.back:addChild(self.mynameLabel)

	local opnameLabel = cc.Label:createWithSystemFont(self.opname,'',40)
    opnameLabel:setColor(cc.c4b(255,255,255,255))
    opnameLabel:ignoreAnchorPointForPosition(false)
    opnameLabel:setAnchorPoint(0,0.5)
    opnameLabel:setPosition(self.back:getContentSize().width /2 + 20,850)
    self.opnameLabel = opnameLabel
    self.back:addChild(self.opnameLabel)

    local mygradeLabel = cc.Label:createWithSystemFont(self.mygrade,'',40)
    mygradeLabel:setColor(cc.c4b(255,255,255,255))
    mygradeLabel:setPosition(180+ offset,745)
    self.mygradeLabel = mygradeLabel
    self.back:addChild(self.mygradeLabel)

    local opgradeLabel = cc.Label:createWithSystemFont(self.opgrade,'',40)
    opgradeLabel:setColor(cc.c4b(255,255,255,255))
    opgradeLabel:setPosition(460+ offset,745)
    self.opgradeLabel = opgradeLabel
    self.back:addChild(self.opgradeLabel)

    local mytimeLabel = cc.Label:createWithSystemFont("用时："..math.floor(self.mytime / 60).."分"..math.floor(self.mytime % 60).."秒",'',30)
    mytimeLabel:setColor(cc.c4b(255,255,255,255))
    mytimeLabel:setPosition(175+ offset,650)
    self.mytimeLabel = mytimeLabel
    self.back:addChild(self.mytimeLabel)

    local optimeLabel = cc.Label:createWithSystemFont("用时："..math.floor(self.optime / 60).."分"..math.floor(self.optime % 60).."秒",'',30)
    optimeLabel:setColor(cc.c4b(255,255,255,255))
    optimeLabel:setPosition(435+ offset,650)
    self.optimeLabel = optimeLabel
    self.back:addChild(self.optimeLabel)

    local getbeanLabel = cc.Label:createWithSystemFont("0",'',30)
    getbeanLabel:setColor(cc.c4b(255,255,255,255))
    getbeanLabel:setPosition(330+ offset,515)
    self.getbeanLabel = getbeanLabel
    self.back:addChild(self.getbeanLabel)

    local beanSprite = cc.Sprite:create("image/pk/bean.png")
    beanSprite:setPosition(460+ offset,530)
	self.beanSprite = beanSprite
	self.back:addChild(self.beanSprite)

    if self.win then
    	self.getbeanLabel:setString("10")
    end

    if self.mygrade == "失败" then
        self.mytimeLabel:setVisible(false)
    end

    if self.opgrade == "失败" then
        self.optimeLabel:setVisible(false)
    end

    local ok_button = ccui.Button:create("image/pk/okNormal.png","image/pk/okPress.png","")
    ok_button:setPosition(self.back:getContentSize().width /2, 385)
    ok_button:addTouchEventListener(handler(self,self.goClick))
    self.ok_button = ok_button
    self.back:addChild(self.ok_button)

    local more_button = ccui.Button:create("image/pk/moreNormal.png","image/pk/morePress.png","")
    more_button:setPosition(self.back:getContentSize().width /2, 250)
    more_button:addTouchEventListener(handler(self,self.moreClick))
    self.more_button = more_button
    self.back:addChild(self.more_button)

    local share_button = ccui.Button:create("image/pk/shareNormal.png","image/pk/sharePress.png","")
    share_button:setPosition(self.back:getContentSize().width /2, 115)
    share_button:addTouchEventListener(handler(self,self.shareClick))
    self.share_button = share_button
    self.back:addChild(self.share_button)

    local target = cc.RenderTexture:create(s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    target:retain()
    target:setPosition(cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2))
    self.target = target
    self:addChild(self.target)

    self.beans = cc.Sprite:create('image/chapter/chapter0/background_been_white.png')
    self.beans:setPosition(self.back:getContentSize().width /2 + 220, self.back:getContentSize().height-70)
    self.back:addChild(self.beans) 
    self.beanCount = s_CURRENT_USER:getBeans()
    self.beanCountLabel = cc.Label:createWithSystemFont(self.beanCount,'',24)
    self.beanCountLabel:setColor(cc.c4b(0,0,0,255))
    self.beanCountLabel:ignoreAnchorPointForPosition(false)
    self.beanCountLabel:setPosition(self.beans:getContentSize().width * 0.65 , self.beans:getContentSize().height/2)
    self.beans:addChild(self.beanCountLabel)
end

function PKEndingLayer:goClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self.win then
        s_CURRENT_USER:addBeans(10)
        saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
        local bean = s_CURRENT_USER:getBeans()
        self.beanCount = bean
        self.beanCountLabel:setString(bean)
    end

    s_CorePlayManager.enterLevelLayer()
end

function PKEndingLayer:moreClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    local SearchLayer = require('view.summaryboss.SearchLayer')
    local searchLayer = SearchLayer.create(self.unit,"other")
    s_SCENE:replaceGameLayer(searchLayer) 
end

function PKEndingLayer:addTop()
    local top = cc.LayerColor:create(cc.c4b(211,239,254,255),s_RIGHT_X - s_LEFT_X,280)
    top:ignoreAnchorPointForPosition(false)
    top:setAnchorPoint(0,0)
    top:setPosition(0,0)
    self:addChild(top)

    local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
    head:setPosition(top:getContentSize().width * 0.25, top:getContentSize().height * 0.5)
    top:addChild(head)

    local logoWord = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/title_shouye_name.png'))
    logoWord:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    logoWord:setMidpoint(cc.p(0.5, 1))
    logoWord:setBarChangeRate(cc.p(0, 1))
    logoWord:setPercentage(80) 
    logoWord:setScale(0.8)
    logoWord:setAnchorPoint(0,0.5)
    logoWord:setPosition(top:getContentSize().width * 0.4 + 30, top:getContentSize().height * 0.55)
    top:addChild(logoWord)

    local name = cc.Label:createWithSystemFont(s_CURRENT_USER:getNameForDisplay(),'',36)
    name:setAnchorPoint(0,1)
    name:setPosition(top:getContentSize().width * 0.4 + 30, top:getContentSize().height * 0.5 - 15)
    name:setColor(cc.c3b(92,130,140))
    top:addChild(name)

    self.target:begin()
    self:visit()
    self.target:endToLua()
    top:removeFromParent()
end

function PKEndingLayer:shareClick(sender,eventType)
    if eventType == ccui.TouchEventType.began then
        self:addTop()
    end
    if eventType == ccui.TouchEventType.ended then
        local ShareDataInfo = require('view.share.ShareDataInfo')
        local shareDataInfo = ShareDataInfo.create(self.target,0)
        self:addChild(shareDataInfo)
    end
end

function PKEndingLayer:resetData()
	s_CURRENT_USER.pkPlayer = ""
	saveUserToServer({['pkPlayer']=s_CURRENT_USER.pkPlayer})

	s_CURRENT_USER.schoolName = ""
	saveUserToServer({['schoolName']=s_CURRENT_USER.schoolName})

	s_CURRENT_USER.pkTime = 0
	saveUserToServer({['pkTime']=s_CURRENT_USER.pkTime})

	s_CURRENT_USER.pkPlayerTime = 0
	saveUserToServer({['pkPlayerTime']=s_CURRENT_USER.pkPlayerTime})

	s_CURRENT_USER.pkMyTime = 0
	saveUserToServer({['pkMyTime']=s_CURRENT_USER.pkMyTime})

	s_CURRENT_USER.pkMyGrade = false
	saveUserToServer({['pkMyGrade']=s_CURRENT_USER.pkMyGrade})

	s_CURRENT_USER.pkPlayerGrade = false
	saveUserToServer({['pkPlayerGrade']=s_CURRENT_USER.pkPlayerGrade})

	s_CURRENT_USER.pkUnitID = 0
    saveUserToServer({['pkUnitID']=s_CURRENT_USER.pkUnitID})
end



return PKEndingLayer
