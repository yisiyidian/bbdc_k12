require("cocos.init")
require("common.global")

local MissionCompleteCircle = class('MissionCompleteCircle',function ()
	return cc.Layer:create()
end)

function MissionCompleteCircle.create()
	local layer = MissionCompleteCircle.new()
	return layer
end

function MissionCompleteCircle:ctor()
	local background = cc.LayerColor:create(cc.c4b(126,239,255,255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
	background:ignoreAnchorPointForPosition(false)
	background:setAnchorPoint(0.5,0.5)
	background:setPosition(0.5 * s_DESIGN_WIDTH, 0.5 * s_DESIGN_HEIGHT)
	self:addChild(background)

	
end

return MissionCompleteCircle