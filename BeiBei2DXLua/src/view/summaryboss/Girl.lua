require("cocos.init")
require("common.global")

local Girl = class("Girl",function ()
	return cc.Node:create()
end)

function Girl.create()
	local node = Girl.new()
	return node
end

function Girl:ctor()
	local girl = sp.SkeletonAnimation:create("spine/summaryboss/girl-stand.json","spine/summaryboss/girl-stand.atlas",1)
	self:addChild(girl)
	self.girl = girl
	self.isAfraid = false
end
--girl 动画
function Girl:setAnimation(state)
	--state: win,lose,right,wrong,normal,afraid
	if state == "win" then
		self.girl:setAnimation(0,'girl_win',true)
	elseif state == "lose" then
		self.girl:setAnimation(0,'girl-fail',true)
	elseif state == "right" then
		self.girl:setAnimation(0,'girl_happy',false)
		self:setAnimation("normal")
	elseif state == "wrong" then
		self.girl:setAnimation(0,'girl-no',false)
		self:setAnimation("normal")
	elseif state == "afraid" then
		self.girl:setAnimation(0,'girl-afraid',true)
		self.isAfraid = true
	else 
		if self.isAfraid then
			self.girl:addAnimation(0,'girl-afraid',true)
		else
			self.girl:addAnimation(0,'girl-stand',true)
		end
	end
end

function Girl:setAfraid(isAfraid)
	self.isAfraid = isAfraid
end

return Girl