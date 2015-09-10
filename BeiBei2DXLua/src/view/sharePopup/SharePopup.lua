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
	local mark = false
	--因为有时间延迟的动作 ，用于禁止时间重复触发
	self.mark = mark

	local back = cc.Sprite:create("image/sharePopup/first_share_popup.png")
    back:setPosition(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2 * 3)
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
    closeButton:addTouchEventListener(handler(self,self.closeListener))
    self.closeButton = closeButton
    self.back:addChild(self.closeButton)

    local shareButton = ccui.Button:create()
    shareButton:setPosition(self.back:getContentSize().width / 2  , 0 )
    shareButton:addTouchEventListener(handler(self,self.shareFunc))
    self.shareButton = shareButton
    self.back:addChild(self.shareButton)

    self:reset()

    onAndroidKeyPressed(self,function() self:closeFunc() end, function ()end)
	touchBackgroundClosePopup(self,self.back,function() self:closeFunc() end)

	self.back:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2))))
end

function SharePopup:reset()
	if self.type == SHARE_TYPE_TIME then
		self.back:setTexture("image/sharePopup/first_share_popup.png")
		self.shareButton:loadTextureNormal("image/sharePopup/first_normal.png")
		self.shareButton:loadTexturePressed("image/sharePopup/first_press.png")
	elseif self.type == SHARE_TYPE_DATE then
		self.back:setTexture("image/sharePopup/second_share_popup.png")
		self.shareButton:loadTextureNormal("image/sharePopup/second_normal.png")
		self.shareButton:loadTexturePressed("image/sharePopup/second_press.png")
	elseif self.type == SHARE_TYPE_FIRST_LEVEL then
		self.back:setTexture("image/sharePopup/third_share_popup.png")
		self.shareButton:loadTextureNormal("image/sharePopup/third_normal.png")
		self.shareButton:loadTexturePressed("image/sharePopup/third_press.png")
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
		self.string1:setPosition(385,374)
	end
end

function SharePopup:closeListener(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

 	self:closeFunc()
end

function SharePopup:closeFunc()
	if self.mark then
		return 
	end
	self.mark = true

	local action1 = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH/ 2 , s_DESIGN_HEIGHT / 2 * 3)))
	local action2 = cc.CallFunc:create(function ( ... )
		s_SCENE:removeAllPopups()
	end)
	self.back:runAction(cc.Sequence:create(action1,action2))
end

function SharePopup:shareFunc(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	if self.type == SHARE_TYPE_TIME then
		local randomNum = math.random(1,#ShareConfig.normalTitle)
		local per = self.score..'%'
		local title = string.format(ShareConfig.normalTitle[randomNum],per)
		print(title)
    	cx.CXUtils:getInstance():shareURLToQQFriend('http://yisiyidian.com/doubi/html5/index.php', title, '贝贝单词－根本停不下来')
	elseif self.type == SHARE_TYPE_DATE then
		local num = self.time
		if self.time >= #ShareConfig.dateTitle then
			num = #ShareConfig.dateTitle
		end
		local title = string.format(ShareConfig.dateTitle[num],self.score)
		print(title)
    	cx.CXUtils:getInstance():shareURLToQQFriend('http://yisiyidian.com/doubi/html5/index.php', title, '贝贝单词－根本停不下来')
	elseif self.type == SHARE_TYPE_FIRST_LEVEL then
		local randomNum = math.random(1,#ShareConfig.finishGuideTitle)
		local title = ShareConfig.finishGuideTitle[randomNum]
		print(title)
    	cx.CXUtils:getInstance():shareURLToQQFriend('http://yisiyidian.com/doubi/html5/index.php', title, '贝贝单词－根本停不下来')
	end 

	

	if self.func ~= nil then self:func() end
    s_CURRENT_USER:addBeans(10)
    saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
    s_CorePlayManager.enterLevelLayer()
	s_SCENE:removeAllPopups()
end

return SharePopup