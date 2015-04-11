require("cocos.init")
require("common.global")

local SignUpLayer = class("SignUpLayer",function ()
	return cc.Layer:create()
end)

function SignUpLayer.create()
	local layer = SignUpLayer.new()
	return layer
end

function SignUpLayer:ctor()
	local backColor = cc.LayerColor:create(cc.c4b(35,167,227,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	backColor:ignoreAnchorPointForPosition(false)
	backColor:setAnchorPoint(0.5,0)
	backColor:setPosition(0.5 * s_DESIGN_WIDTH,0)
	self:addChild(backColor)

	local background = ccui.Scale9Sprite:create('image/signup/frontground_children_login.png',cc.rect(0,0,854,87),cc.rect(0, 43, 854, 1))
	background:setContentSize(cc.size(854,87+825))
	background:ignoreAnchorPointForPosition(false)
	background:setAnchorPoint(0.5,0)
	background:setPosition(0.5 * s_DESIGN_WIDTH,0)
	self:addChild(background)

	local girl = sp.SkeletonAnimation:create("res/spine/signup/bbchildren2.json", "res/spine/signup/bbchildren2.atlas", 1)
	--girl:setAnimation(0,'animation',true)
	self:addChild(girl)
	girl:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)

	local bubble = cc.Sprite:create('image/signup/dauglog_bbchildren_background.png')
	bubble:setAnchorPoint(0,0.15)
	bubble:setPosition(0.5 * s_DESIGN_WIDTH - 49,s_DESIGN_HEIGHT - 10 - 0.85 * bubble:getContentSize().height)
	self:addChild(bubble)

	local welcome = cc.Label:createWithSystemFont('欢迎来到\n贝贝单词','',40)
	welcome:setPosition(bubble:getContentSize().width / 2,bubble:getContentSize().height / 2)
	bubble:addChild(welcome)

	-- bubble:setScale(0)
	-- local appear = cc.ScaleTo:create(1.0,1)
	local shake = cc.RepeatForever:create(cc.Sequence:create(cc.RotateBy:create(0.5,3),cc.RotateBy:create(1,-6),cc.RotateBy:create(0.5,3)))
	bubble:runAction(shake)
end


return SignUpLayer