require("cocos.init")
require("common.global")

local DramaLayer = class("DramaLayer", function()
	return cc.Layer:create()
end)

function DramaLayer.create()
	return DramaLayer.new()
end

function DramaLayer:ctor()
	--drama 1
	-- local drama1 = sp.SkeletonAnimation:create("spine/tutorial/jieshao1.json","spine/tutorial/jieshao1.atlas",1)
	-- drama1:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	-- drama1:setAnchorPoint(0.5, 0.5)
	-- drama1:addAnimation(0, 'animation', false)
	-- self:addChild(drama1)

	-- local drama2 = sp.SkeletonAnimation:create("spine/tutorial/jieshao2.json","spine/tutorial/jieshao2.atlas",1)
	-- drama2:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	-- drama2:setAnchorPoint(0.5, 0.5)
	-- drama2:addAnimation(0, 'animation', false)
	-- self:addChild(drama2)

	local drama3 = sp.SkeletonAnimation:create("spine/tutorial/jieshao_3.json","spine/tutorial/jieshao_3.atlas",1)
	drama3:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama3:setAnchorPoint(0.5, 0.5)
	drama3:addAnimation(0, 'animation', true)
	self:addChild(drama3)

	-- local drama4 = sp.SkeletonAnimation:create("spine/tutorial/jieshao_4.json","spine/tutorial/jieshao_4.atlas",1)
	-- drama4:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	-- drama4:setAnchorPoint(0.5, 0.5)
	-- drama4:addAnimation(0, 'animation', true)
	-- self:addChild(drama4)
end

return DramaLayer
