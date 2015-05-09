--查看更多个人信息界面的小格子

local MoreInformationRender = class("MoreInformationRender",function()
		local sprite = ccui.Layout:create()
		return sprite
end)

--纯文本类型
MoreInformationRender.TEXT = "MoreInformationRender.TEXT"
--性别类型
MoreInformationRender.SEX  = "MoreInformationRender.SEX"
--日期类型
MoreInformationRender.DATE = "MoreInformationRender.DATE"
--滑动开关类型
MoreInformationRender.SWITCH = "MoreInformationRender.SWITCH"
--ICON
MoreInformationRender.ICON = "MoreInformationRender.ICON"

--其他的类型 如修改密码
MoreInformationRender.OTHER = "MoreInformationRender.OTHER"

function MoreInformationRender:ctor(type)
	self.type = type
	self.showContent = false
	self:init(type)
	self:setAnchorPoint(cc.p(0,0))
	self:setContentSize(cc.size(854,114))
	--自定义的触摸事件监听
	self.listener = cc.EventListenerTouchOneByOne:create()
	self.listener:registerScriptHandler(handler(self, self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN)
	self.listener:registerScriptHandler(handler(self, self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED)
	self.listener:registerScriptHandler(handler(self, self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)

	self.listener:setSwallowTouches(false)
end

--初始化UI
function MoreInformationRender:init(type)
	--白色底
	--local bg = cc.Sprite:create("image/homescene/setup_button.png")
	local bg = cc.Sprite:create("image/login/login_white_background.png")
	local size = bg:getContentSize()
	bg:setPosition(size.width/2,size.height/2)
	self:addChild(bg)
	--title
	local titleLabel = cc.Label:createWithSystemFont("","",26)
	titleLabel:setPosition(20,30)
	self.titleLabel = titleLabel
	self.titleLabel:setAnchorPoint(cc.p(0.0,0.0))
	self.titleLabel:setTextColor(cc.c3b(0, 0, 0))
	self:addChild(titleLabel)
	
	if self.type == MoreInformationRender.SWITCH then 
		--开关
		local checkBox = ccui.CheckBox:create()
		-- TODO 目前禁用这个功能
		-- checkBox:setTouchEnabled(true)
		checkBox:setTouchEnabled(false)
		checkBox:loadTextures(
			"image/login/button_left_login.png",--normal
			"image/login/button_left_login.png",--normal press
			"image/login/button_right_login.png",--normal active
			"image/login/button_left_login.png",-- normal disable
			"image/login/button_left_login.png"--active disable
			)
		checkBox:addEventListener(handler(self, self.onCheckBoxTouch))
		checkBox:setPosition(size.width*0.8 + 20 , 45)
		checkBox:setSelected(true)	--默认选中
		self.checkBox = checkBox
		self:addChild(checkBox)
	elseif self.type == MoreInformationRender.ICON  then
		--TODO  icons
	elseif self.type == MoreInformationRender.OTHER then
		--
	else
		self.showContent = true
		--内容文本
		local content = cc.Label:createWithSystemFont("","",26)
		content:setPosition(size.width*0.8 - 20,30)
		content:setAnchorPoint(cc.p(0.0,0.0))
		self.contentLabel = content
		self.contentLabel:setTextColor(cc.c3b(0, 0, 0))
		self:addChild(self.contentLabel)
	end
end

--设置显示数据,data的属性
--key 属性键值
--title 标题文本
--content 内容文本  fun(type,key)
--callback 点击Render的回调 
--		MoreInfomationView:onRenderTouch(renderType,key,data,callback)
--		type 显示类型
--		key  键值
--		data 数据	
--		callback 回调 	在修改界面完成输入之后,回调给Render去更新显示内容
--		checkCallBack   数据格式检查的函数
--data 自定义数据 如开关状态什么的
--checkCallBack 检查数据格式
function MoreInformationRender:setData(data)
	-- v.key,v.title,v.content,v.callback,v.data,v.check
	self.key 			= data.key
	self.title 			= data.title
	self.content 		= data.content
	self.callback 		= data.callback
	self.data 			= data.data
	self.checkCallBack 	= data.check
	self:updateView()
end
--更新界面
function MoreInformationRender:updateView()
	print("updateView:"..self.title)
	self.titleLabel:setString(self.title)

	if self.showContent then
		if self.content and self.content~="" and self.content ~= 0 and self.content ~= 1 then
			self.contentLabel:setString(self.content)
		elseif self.content == 1 then
			self.contentLabel:setString("男")
		elseif self.content == 0 then
			self.contentLabel:setString("女")
			elseif self
		else
			self.contentLabel:setString("未设置 >")
		end
	end

	
	if self.type == MoreInformationRender.SWITCH then
		self.checkBox:setSelected(self.data)
	elseif self.type == MoreInformationRender.ICON then
		--TODO ICONS
	end
end

--复选框事件处理
function MoreInformationRender:onCheckBoxTouch(sender,eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		
	elseif eventType == ccui.CheckBoxEventType.unselected then
		
	end
end

--修改数据完成回调
--title 	key 没啥用
--content 	内容
--data 		数据
function MoreInformationRender:onModifyCallBack(key,content,data)
	-- self.title = title
	self.content = content
	self.data = data
	self:updateView()
end

--自己处理 触摸事件三个阶段
function MoreInformationRender:onTouchBegan(touch,event)
	local target = event:getCurrentTarget()
	local locationInNode = target:convertToNodeSpace(touch:getLocation())
	local s = target:getContentSize()
	local pos =  target:convertToWorldSpace(cc.p(0,0))
	--hack一下,如果移动距离超出Began时候 Render的大小则不响应ended
	local rect = cc.rect(0,0,s.width,s.height)
	if cc.rectContainsPoint(rect,locationInNode) then
		self.rect = cc.rect(pos.x,pos.y,s.width,s.height)
		return true
	end
	return false
end

function MoreInformationRender:onTouchMoved(touch,event)
	
end

function MoreInformationRender:onTouchEnded(touch,event)
	local target = event:getCurrentTarget()
	local touchp = touch:getLocation()
	-- local locationInNode = target:convertToWorldSpace(touch:getLocation())
	if not cc.rectContainsPoint(self.rect,touchp) then
		self.rect = nil
		return
	end

	if self.type == MoreInformationRender.SWITCH then
		--TODO checkBox
		--return
	end
	if self.callback ~= nil then
		--调用外部回调函数 
		--同时把自己的回调函数也传过去
		local t = nil --数据
		if self.showContent then
			t = self.content
		else
			t = self.data
		end
		print("RenderTouch:"..self.key)
		self.callback(self.type,
			self.key,
			t,
			self.title,
			handler(self,self.onModifyCallBack),
			self.checkCallBack --检查数据格式的回调
			)
	end
end

return MoreInformationRender
