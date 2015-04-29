--查看更多个人信息界面
--从左侧菜单栏进入

--小格子
local MoreInformationRender = require("view.home.ui.MoreInformationRender")

local MoreInfomationView = class("MoreInfomationView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)

function MoreInfomationView:ctor()
	self:init()
end

function MoreInfomationView:init()
	local title = cc.Label:createWithSystemFont("个人信息","",60)
	title:setTextColor(cc.c3b(121,200,247))
	title:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT * 0.9)
	self.title = title
	self:addChild(title)

	local btnReturn = ccui.Button:create("image/shop/button_back.png")
	btnReturn:setPosition(0.1*s_DESIGN_WIDTH,0.9*s_DESIGN_HEIGHT)
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self:addChild(btnReturn)



end

--返回按钮点击
function MoreInfomationView:onReturnClick(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	s_SCENE:removeAllPopups()
end

--maybe not use
function MoreInfomationView:onEditTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

end

return MoreInfomationView