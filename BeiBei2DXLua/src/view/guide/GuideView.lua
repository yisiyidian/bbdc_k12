
-- 引导功能显示label
-- by 侯琪
-- 2015年06月05日11:27:18
local GuideConfig = require ("model/guide/GuideConfig.lua")
local GuideView = class("GuideView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function GuideView.create(index)
    local layer = GuideView.new(index)
    return layer
end

function GuideView:ctor(index)
	self.index = index
	self.content = ""
	self.color = ""
	self.bbName = "" 
	self.pos = cc.p(0,0)
	self:initUI()
	-- 初始化UI
end

function GuideView:initUI()
	local back = cc.Sprite:create()
    back:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT *1.2)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)
    -- 面板
	local label = cc.Label:createWithSystemFont("","",34)
	label:setColor(cc.c4b(36,63,79,255))
    label:setPosition(cc.p(self.back:getContentSize().width/2,self.back:getContentSize().height /2))
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self.back:addChild(self.label)
	--渲染列表
	self:resetView()
end

function GuideView:resetView()
	local content = ""
	local color = ""
	local bbName = ""
	local pos = cc.p(0,0)
	table.foreach(GuideConfig.data, function(i, v)  if v.guide_id == self.index then print("当前引导是第"..i.."/"..#GuideConfig.data.."步") content = v.desc pos = v.pos color = v.color bbName = v.bb end end)
	self.content = content
	self.pos = pos
	self.color = color
	self.bbName = bbName
	self.label:setString(content)

	if self.color == "white" then
		self.back:setTexture('image/guide/yindao_background_white.png')
	elseif self.color == "yellow" then
		self.back:setTexture('image/guide/yindao_background_yellow.png')
	elseif self.color == "blue1" then
		self.back:setTexture('image/guide/xiaoguan_tanchu_duihuakuang.png')
	elseif self.color == "blue2" then
		self.back:setTexture('image/guide/xiaoguan_tanchu_duihuakuang2.png')
	else
		return
	end

    self.label:setPosition(cc.p(self.back:getContentSize().width/2,self.back:getContentSize().height/2))
    if self.color == "white" or self.color == "yellow" then
		local action1 = cc.MoveTo:create(0.5,self.pos)
	    local action2 = cc.EaseBackOut:create(action1)
	    self.back:runAction(action2)
	else
		self.back:runAction(cc.Place:create(self.pos))
		self.back:setAnchorPoint(0,0)
		local action1 = cc.RotateBy:create(1,10)
		local action2 = cc.RotateBy:create(1,-10)
		self.back:runAction(cc.RepeatForever:create(cc.Sequence:create(action1,action2)))
	end

	if self.bbName ~= nil then
		local bb = cc.Sprite:create('image/guide/'..self.bbName..'.png')
		bb:setPosition(cc.p(self.back:getContentSize().width/4,self.back:getContentSize().height-20))
		bb:ignoreAnchorPointForPosition(false)
		bb:setAnchorPoint(0.5,0)
		self.bb = bb
		self.back:addChild(self.bb)
	end
end

return GuideView