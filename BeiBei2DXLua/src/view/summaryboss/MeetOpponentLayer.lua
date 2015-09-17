local PKConfig = require("model.pk.PKConfig")

local MeetOpponentLayer = class("MeetOpponentLayer", function ()
    return cc.Layer:create()
end)

function MeetOpponentLayer.create(unit)
    local layer = MeetOpponentLayer.new(unit)
    return layer
end

function MeetOpponentLayer:ctor(unit)
	self.unit = unit
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
    local name = cc.Label:createWithSystemFont("",'',50)
    name:setColor(cc.c4b(255,255,255,255))
    name:setPosition(self.blue:getContentSize().width/2,330)
    self.name = name
    self.blue:addChild(self.name)
    self.name:setString(self:rename())

    -- 学校标签
    local school = cc.Label:createWithSystemFont("",'',27)
    school:setColor(cc.c4b(255,255,255,255))
    school:setPosition(self.blue:getContentSize().width/2,230)
    self.school = school
    self.blue:addChild(self.school)
    self.school:setString(self:reschool())

    -- 红底
    local red = cc.Sprite:create("image/islandPopup/red.png")
	red:ignoreAnchorPointForPosition(false)
	red:setAnchorPoint(0.5,1)
	red:setPosition((s_RIGHT_X - s_LEFT_X)/2,s_DESIGN_HEIGHT + red:getContentSize().height)
	self.red = red
	self.layer:addChild(self.red)

    math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
    local rand = math.random(1,#PKConfig.data * 2)
    self.rand = rand

	-- 对手名字
	local Opname = cc.Label:createWithSystemFont("",'',50)
    Opname:setColor(cc.c4b(255,255,255,255))
    Opname:setPosition(self.red:getContentSize().width/2,330)
    self.Opname = Opname
    self.red:addChild(self.Opname)
    self.Opname:setString(self:reOpname())

    -- 对手学校
    local Opschool = cc.Label:createWithSystemFont("",'',27)
    Opschool:setColor(cc.c4b(255,255,255,255))
    Opschool:setPosition(self.red:getContentSize().width/2,230)
    self.Opschool = Opschool
    self.red:addChild(self.Opschool)
	self.Opschool:setString(self:reOpschool())

    -- vs
    local vs = cc.Sprite:create()
    vs:setPosition(self.layer:getContentSize().width / 2,self.layer:getContentSize().height / 2 + 10)
    self.layer:addChild(vs)
    local animation = cc.Animation:create()
    local number, name
    for i = 1, 8 do
        number = i
        name = "image/pk/vs/vs_00"..number..".png"
        animation:addSpriteFrameWithFile(name)
    end
    animation:setDelayPerUnit(0.05)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Animate:create(animation)
    vs:runAction(cc.RepeatForever:create(action))


 --    local v = cc.Sprite:create("image/islandPopup/v.png")
	-- v:setPosition((s_RIGHT_X - s_LEFT_X)/2 - 25,s_DESIGN_HEIGHT / 2 + 18)
	-- self.v = v
	-- self.layer:addChild(self.v)

	-- local s = cc.Sprite:create("image/islandPopup/s.png")
	-- s:setPosition((s_RIGHT_X - s_LEFT_X)/2 + 25,s_DESIGN_HEIGHT / 2 - 21)
	-- self.s = s
	-- self.layer:addChild(self.s)

	callWithDelay(self,2.5,self.enterPKScene)
    callWithDelay(self,2,self.runAnimation2)
    self:runAnimation1()
end

function MeetOpponentLayer:runAnimation1()
    local move = cc.JumpTo:create(0.5,cc.p((s_RIGHT_X - s_LEFT_X)/2,s_DESIGN_HEIGHT),s_DESIGN_HEIGHT-10,1)
    -- local easeBounceOut = cc.EaseBounceOut:create(move)
    self.red:runAction(move)

    local delay = cc.DelayTime:create(0.45)
    local move = cc.MoveTo:create(0.1,cc.p((s_RIGHT_X - s_LEFT_X)/2,-10))
    local move2 = cc.MoveTo:create(0.05,cc.p((s_RIGHT_X - s_LEFT_X)/2,0))
    local se = cc.Sequence:create(delay,move,move2)
    self.blue:runAction(se)
end

function MeetOpponentLayer:runAnimation2()
    local move = cc.MoveTo:create(0.5,cc.p((s_RIGHT_X - s_LEFT_X)/2,s_DESIGN_HEIGHT +600))
    local easeBounceIn = cc.EaseBounceIn:create(move)
    self.red:runAction(easeBounceIn)

    local move = cc.MoveTo:create(0.5,cc.p((s_RIGHT_X - s_LEFT_X)/2,0 -600))
    local easeBounceIn = cc.EaseBounceIn:create(move)
    self.blue:runAction(easeBounceIn)
end

function MeetOpponentLayer:enterPKScene()
	local player = self.Opname:getString()
	local school = self.Opschool:getString()
	local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    local maxID = s_LocalDatabaseManager.getMaxUnitID()
    showProgressHUD('', true)
    local PKLayer = require('view.summaryboss.PKLayer')
    local pKLayer = PKLayer.create(self.unit,player,school)
    s_SCENE:replaceGameLayer(pKLayer) 
end

-- 显示名字
function MeetOpponentLayer:rename()
	local text = ""
    if s_CURRENT_USER.usertype == USER_TYPE_QQ then 
        text = s_CURRENT_USER.nickName
    end
    if s_CURRENT_USER.usertype == USER_TYPE_GUEST then 
        text = '游客' 
    end
    if s_CURRENT_USER.nickName ~= "" then
        text = s_CURRENT_USER.nickName
    end
    return text
end

-- 显示学校
function MeetOpponentLayer:reschool()
	local text = "未知学校"
    if s_CURRENT_USER.school ~= "" then
        text = s_CURRENT_USER.school
    end
    return text
end

-- 显示对手姓名
function MeetOpponentLayer:reOpname()
	local text = "游客"
	if self.rand <= #PKConfig.data then
		text = PKConfig.data[self.rand].name
	end
	return text
end

-- 显示对手学校
function MeetOpponentLayer:reOpschool()
	local text = "未知学校"
	if self.rand <= #PKConfig.data then
		text = PKConfig.data[self.rand].school
	end
	return text
end

return MeetOpponentLayer