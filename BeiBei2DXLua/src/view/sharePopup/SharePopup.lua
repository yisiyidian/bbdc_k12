local ShareConfig = require("model.share.ShareConfig")
-- 载入配置

local SharePopup = class("SharePopup",function ()
	return cc.Layer:create()
end)

function SharePopup.create(type,func,time,score)
    local layer = SharePopup.new(type,func,time,score)
    return layer
end

function SharePopup:ctor(type,func,time,score)
	self.type = type
	self.func = func
	self.time = time or 0
	self.score = score or 0

	self:init()
end

function SharePopup:init()
	local back = cc.Sprite:create("image/sharePopup/first_share_popup.png")
    back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2)
    self.back = back 
    self:addChild(self.back)
	
	local string1 = cc.Label:createWithSystemFont("","",40)
    string1:setColor(cc.c4b(0,0,0,255))
    string1:setPosition(self.back:getContentSize().width / 2 ,0)
    self.string1 = string1
    self.back:addChild(self.string1)

	local string2 = cc.Label:createWithSystemFont("","",40)
    string2:setColor(cc.c4b(0,0,0,255))
    string2:setPosition(self.back:getContentSize().width / 2 ,0)
    self.string2 = string2
    self.back:addChild(self.string2)

    local string3 = cc.Label:createWithSystemFont("","",40)
    string3:setColor(cc.c4b(0,0,0,255))
    string3:setPosition(self.back:getContentSize().width / 2 ,0)
    self.string3 = string3
    self.back:addChild(self.string3)

    local closeButton = ccui.Button:create("image/sharePopup/close_button_normal.png","image/sharePopup/close_button_click.png","")
    closeButton:setPosition(self.back:getContentSize().width / 2  , 0 )
    closeButton:addTouchEventListener(handler(self,self.closeFunc))
    self.closeButton = closeButton
    self.back:addChild(self.closeButton)

    local shareButton = ccui.Button:create("image/sharePopup/share_button_normal.png","image/sharePopup/share_button_click.png","")
    shareButton:setPosition(self.back:getContentSize().width / 2  , 0 )
    shareButton:addTouchEventListener(handler(self,self.shareFunc))
    self.shareButton = shareButton
    self.back:addChild(self.shareButton)

    self:reset()

    onAndroidKeyPressed(self,function() self:closeFunc() end, function ()end)
	touchBackgroundClosePopup(self,self.back,function() self:closeFunc() end)
end

function SharePopup:reset()
	if self.type == SHARE_TYPE_TIME then
		self.back:setTexture("image/sharePopup/first_share_popup.png")
	elseif self.type == SHARE_TYPE_DATE then
		self.back:setTexture("image/sharePopup/second_share_popup.png")
	elseif self.type == SHARE_TYPE_FIRST_LEVEL then
		self.back:setTexture("image/sharePopup/third_share_popup.png")
	end

	self.closeButton:setPosition(548,576)
	self.shareButton:setPosition(292,124)

	if self.type == SHARE_TYPE_TIME then
		self.string1:setString(math.floor(self.time/60))
		self.string1:setColor(cc.c4b(61,180,191,255))
		self.string1:setSystemFontSize(40)
		self.string1:setPosition(243,369)

		self.string2:setString(math.floor(self.time%60))
		self.string2:setColor(cc.c4b(61,180,191,255))
		self.string2:setSystemFontSize(40)
		self.string2:setPosition(356,369)

		self.string3:setString(tostring(self.score)..'%')
		self.string3:setColor(cc.c4b(255,0,0,255))
		self.string3:setSystemFontSize(50)
		self.string3:setPosition(287,293)
	elseif self.type == SHARE_TYPE_DATE then
		self.string1:setString(self.time)
		self.string1:setColor(cc.c4b(255,0,0,255))
		self.string1:setSystemFontSize(40)
		self.string1:setPosition(359,374)
	end
end

function SharePopup:closeFunc(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	s_SCENE:removeAllPopups() 
end

function SharePopup:shareFunc(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	if self.type == SHARE_TYPE_TIME then
    	cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.html?time=1&wordlist=apple', '我击败了'..tostring(self.score)..'的玩家，你也来试试把！------点击开始游戏', '贝贝单词－根本停不下来')
	elseif self.type == SHARE_TYPE_DATE then
    	cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.html?time=1&wordlist=apple', '我第'..tostring(self.time)..'天玩贝贝单词，你也来试试吗！------点击开始游戏', '贝贝单词－根本停不下来')
	elseif self.type == SHARE_TYPE_FIRST_LEVEL then
    	cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.html?time=1&wordlist=apple', '发现边玩边背单词的好app，你也来试试？------点击开始游戏', '贝贝单词－根本停不下来')
	end 

	if self.func ~= nil then self:func() end
    s_CURRENT_USER:addBeans(10)
    saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
    s_CorePlayManager.enterLevelLayer()
	s_SCENE:removeAllPopups()
end

return SharePopup