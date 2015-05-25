
local CompleteTask = class("CompleteTask",function()
	local layer = cc.Layer:create()
	return layer
	end)

function CompleteTask:ctor()
	self:init()
end

function CompleteTask:init()

	--背景图
	local background = cc.Sprite:create("image/islandPopup/task_background.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(background)
    self.background = background
    background:setAnchorPoint(0.5,0.5)

    local bigWidth = background:getContentSize().width
	local bigHeight = background:getContentSize().height

	--添加顶部图片(每日任务)
	local topSprite = cc.Sprite:create("image/islandPopup/task_everyday.png")
	topSprite:setAnchorPoint(0.5,0.5)
	topSprite:ignoreAnchorPointForPosition(false)
	topSprite:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self.topSprite = topSprite
	self:addChild(topSprite)



	--关闭按钮
	local closeButton = ccui.Button:create("image/islandPopup/task_closebutton.png")
	closeButton:addTouchEventListener(handler(self,self.CloseClick))
	self.closeButton = closeButton
	self.closeButton:setPosition(bigWidth,s_DESIGN_HEIGHT / 2 + bigHeight * 0.43)
	self:addChild(closeButton)

end


--关闭按钮点击
function CompleteTask:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	s_SCENE:removeAllPopups()
end


return CompleteTask

