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
MoreInformationRender.ANOTHER = "MoreInformationRender.ANOTHER"

function MoreInformationRender:ctor(type)
	self.type = type
	self:init(type)
end

--初始化UI
function MoreInformationRender:init(type)
	--白色底
	--title
	--内容文本
	--other情况
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
