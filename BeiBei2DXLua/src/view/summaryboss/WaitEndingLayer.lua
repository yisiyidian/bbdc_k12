local MeetOpponentLayer = require('view.summaryboss.MeetOpponentLayer')
-- 等待结果页面
local WaitEndingLayer = class("WaitEndingLayer", function ()
    return cc.Layer:create()
end)

function WaitEndingLayer.create()
    local layer = WaitEndingLayer.new()
    return layer
end

function WaitEndingLayer:ctor()
	local layer = cc.LayerColor:create(cc.c4b(255,255,255,255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
	layer:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
	self.layer = layer
	self:addChild(self.layer)

	-- 蓝底
	local blue = cc.Sprite:create("image/islandPopup/blue.png")
	blue:ignoreAnchorPointForPosition(false)
	blue:setAnchorPoint(0.5,0)
	blue:setPosition((s_RIGHT_X - s_LEFT_X)/2,0)
	self.blue = blue
	self.layer:addChild(self.blue)

	-- 姓名标签
    local name = cc.Label:createWithSystemFont("",'',100)
    name:setColor(cc.c4b(255,255,255,255))
    name:setPosition((s_RIGHT_X - s_LEFT_X)/2,330)
    self.name = name
    self.layer:addChild(self.name)
    self.name:setString(MeetOpponentLayer:rename())

    -- 学校标签
    local school = cc.Label:createWithSystemFont("",'',27)
    school:setColor(cc.c4b(255,255,255,255))
    school:setPosition((s_RIGHT_X - s_LEFT_X)/2,230)
    self.school = school
    self.layer:addChild(self.school)
    self.school:setString(MeetOpponentLayer:reschool())

    -- 红底
    local red = cc.Sprite:create("image/islandPopup/red.png")
	red:ignoreAnchorPointForPosition(false)
	red:setAnchorPoint(0.5,1)
	red:setPosition((s_RIGHT_X - s_LEFT_X)/2,s_DESIGN_HEIGHT)
	self.red = red
	self.layer:addChild(self.red)

	-- 对手名字
	local Opname = cc.Label:createWithSystemFont("",'',100)
    Opname:setColor(cc.c4b(255,255,255,255))
    Opname:setPosition((s_RIGHT_X - s_LEFT_X)/2,900)
    self.Opname = Opname
    self.layer:addChild(self.Opname)
    self.Opname:setString(self:reOpname())

    -- 对手学校
    local Opschool = cc.Label:createWithSystemFont("",'',27)
    Opschool:setColor(cc.c4b(255,255,255,255))
    Opschool:setPosition((s_RIGHT_X - s_LEFT_X)/2,800)
    self.Opschool = Opschool
    self.layer:addChild(self.Opschool)
	self.Opschool:setString(self:reOpschool())

	-- 对手还在答题中
	local state = cc.Label:createWithSystemFont("对方还在答题中……",'',30)
    state:setColor(cc.c4b(255,255,255,255))
    state:setPosition((s_RIGHT_X - s_LEFT_X)/2,680)
    self.state = state
    self.layer:addChild(self.state)


    -- 你可以通过pk按钮……
	local tip = cc.Label:createWithSystemFont("你可以通过pk按钮返回这里或查看结果。",'',30)
    tip:setColor(cc.c4b(255,255,255,255))
    tip:setPosition((s_RIGHT_X - s_LEFT_X)/2,500)
    self.tip = tip
    self.layer:addChild(self.tip)

    -- 出去逛逛按钮
   	local go_button = ccui.Button:create("image/pk/goNormal.png","image/pk/goPress.png","")
    go_button:setPosition((s_RIGHT_X - s_LEFT_X)/2, 1136 / 2)
    go_button:addTouchEventListener(handler(self,self.goClick))
    self.go_button = go_button
    self.layer:addChild(self.go_button)

    local function update(delta)
    	if os.time() >= s_CURRENT_USER.pkTime then
			self:unscheduleUpdate()
            local PKEndingLayer = require("view.summaryboss.PKEndingLayer")
            local pKEndingLayer = PKEndingLayer.create()
            s_SCENE:replaceGameLayer(pKEndingLayer) 
    	end
    end 
    self:scheduleUpdateWithPriorityLua(update, 0)
end

function WaitEndingLayer:goClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    self:stopAction()
    s_CorePlayManager.enterLevelLayer()
end

function WaitEndingLayer:stopAction()
    self:stopAllActions()
end

-- 显示对手姓名
function WaitEndingLayer:reOpname()
	local text = ""
    if s_CURRENT_USER.pkPlayer ~= "" then
		text = s_CURRENT_USER.pkPlayer
    end
	return text
end

-- 显示对手学校
function WaitEndingLayer:reOpschool()
	local text = ""
    if s_CURRENT_USER.schoolName ~= "" then
		text = s_CURRENT_USER.schoolName
    end
	return text
end

return WaitEndingLayer