-- 任务纸张渲染
local GuideToTaskRender = class("GuideToTaskRender", function()
	local layer = cc.Layer:create()
	return layer
end)

function GuideToTaskRender.create(parent)
    local layer = GuideToTaskRender.new(parent)
    return layer
end

function GuideToTaskRender:ctor(parent)
    self.parent = parent
	self:init()
end
--初始化UI
function GuideToTaskRender:init()
    local width = self.parent:getContentSize().width
    local height = self.parent:getContentSize().height

    local label = cc.Label:createWithSystemFont("完成任务获得奖励","",30)
    label:setPosition(cc.p(width / 2,height * 0.85))
    label:setColor(cc.c4b(120,159,0,255))
    label:enableOutline(cc.c4b(120,159,0,255),1)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    self.label = label
    self.parent:addChild(self.label)

    local line = cc.LayerColor:create(cc.c4b(0,0,0,255), width * 0.8, 3)
    line:setPosition(width /2,height *0.8)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0.5,0.5)
    self.line = line
    self.parent:addChild(self.line)

	local sprite = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
    sprite:setAnimation(0,'animation',false)
    sprite:setPosition(width / 4,height / 3)
    self.sprite = sprite
    self.parent:addChild(self.sprite)

    local tar = cc.Label:createWithSystemFont("任务目标：赶走我身上的胖子","",25)
    tar:setPosition(cc.p(width / 2,height * 0.3))
    tar:setColor(cc.c4b(120,159,0,255))
    tar:enableOutline(cc.c4b(120,159,0,255),1)
    tar:ignoreAnchorPointForPosition(false)
    tar:setAnchorPoint(0.5,0.5)
    self.tar = tar
    self.parent:addChild(self.tar)

    local rew = cc.Label:createWithSystemFont("任务奖励：超级多的钱","",25)
    rew:setPosition(cc.p(width / 2,height * 0.25))
    rew:setColor(cc.c4b(120,159,0,255))
    rew:enableOutline(cc.c4b(120,159,0,255),1)
    rew:ignoreAnchorPointForPosition(false)
    rew:setAnchorPoint(0.5,0.5)
    self.rew = rew
    self.parent:addChild(self.rew)

    local Button = require("view.button.longButtonInStudy")
    local button = Button.create("long","blue","领取奖励") 
    button:setPosition(width * 0.5, height * 0.15)
    button.func = function () handler(self,self.buttonFunc) end
    self.button = button
    self.parent:addChild(self.button)
end

function GuideToTaskRender:buttonFunc()
    print("领取奖励")
end

return GuideToTaskRender