--查看更多个人信息界面的小格子

local MoreInformationRender = class("MoreInformationRender",function()
		local sprite = cc.Sprite:create()
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
end

--初始化UI
function MoreInformationRender:init(type)
	--白色底
	local bg = cc.Sprite:create("image/homescene/setup_button.png")
	local size = bg:getContentSize()
	bg:setPosition(size.width/2,size.height/2)
	self:addChild(bg)
	--title
	local titleLabel = cc.Label:createWithSystemFont("","",26)
	titleLabel:setPosition(10,30)
	self.titleLabel = titleLabel
	self.titleLabel:setAnchorPoint(cc.p(0.0,0.0))
	self.titleLabel:setTextColor(cc.c3b(0, 0, 0))
	self:addChild(titleLabel)
	
	if self.type == MoreInformationRender.SWITCH then 
		--开关
		local checkBox = ccui.CheckBox:create()
		checkBox:setTouchEnabled(true)
		checkBox:loadTextures(
			"image/newstudy/wordsbackgroundblue.png",--normal
			"image/newstudy/wordsbackgroundblue.png",--normal press
			"image/newstudy/pause_button_begin.png",--normal active
			"image/newstudy/wordsbackgroundblue.png",-- normal disable
			"image/newstudy/wordsbackgroundblue.png"--active disable
			)
		checkBox:addEventListener(handler(self, chkCallBack))
		-- checkBox:setPosition(0.5 * s_DESIGN_WIDTH - 100,s_DESIGN_HEIGHT*0.6 - 50)
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
		content:setPosition(100,20)
		self.contentLabel = content
		self:addChild(content)
	end
end

--设置显示数据
--key 属性键值
--title 标题文本
--content 内容文本  fun(type,key)
--callback 点击Render的回调
--data 自定义数据 如开关状态什么的
function MoreInformationRender:setData(key,title,content,callback,data)
	self.key = key
	self.title = title
	self.content = content
	self.callback = callback
	self.data = data

	self:updateView()
end

--更新界面
function MoreInformationRender:updateView()
	print("updateView:"..self.title)
	self.titleLabel:setString(self.title)

	if self.showContent then
		self.contentLabel:setString(self.content)
	end
	
	if self.type == MoreInformationRender.SWITCH then
		self.checkBox:setSelected(self.data)
	elseif self.type == MoreInformationRender.ICON then
		--TODO ICONS
	end
end

--点击按钮 触发回调
function MoreInformationRender:onRenderTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	if callback ~= nil then
		callback(self.type,self.key)
	end
end

--修改数据完成回调
--title 	标题
--content 	内容
--data 		数据
function MoreInformationRender:onModifyCallBack(title,content,data)
	self.title = title
	self.content = content
	self.callback = callback

	self:updateView()
end

return MoreInformationRender
