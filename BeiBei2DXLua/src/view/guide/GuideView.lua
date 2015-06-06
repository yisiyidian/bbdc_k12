
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
	self.pos = cc.p(0,0)
	self:initUI()
	-- 初始化UI
end

function GuideView:initUI()
	local back = cc.LayerColor:create(cc.c4b(255,255,255,255),s_DESIGN_WIDTH / 2,100)
    back:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT *1.2)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self.back = back
    self:addChild(self.back)
    -- 面板
	local label = cc.Label:createWithSystemFont("","",25)
    label:setPosition(cc.p(back:getContentSize().width/2,back:getContentSize().height /2))
    label:setColor(cc.c4b(0,0,0,255))
    self.label = label
    self.back:addChild(self.label)
	--渲染列表
	self:resetView()
end

function GuideView:resetView()
	local content = ""
	local pos = cc.p(0,0)
	table.foreach(GuideConfig.data, function(i, v)  if v.guide_id == self.index then print("当前引导是第"..i.."/"..#GuideConfig.data.."步") content = v.desc pos = v.pos end end)
	self.content = content
	self.pos = pos
	self.label:setString(content)

	local action1 = cc.MoveTo:create(0.5,self.pos)
    local action2 = cc.EaseBackOut:create(action1)
    self.back:runAction(action2)
end

return GuideView