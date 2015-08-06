require("cocos.init")
require("common.global")

local Boss = class("Boss",function ()
	return cc.Node:create()
end)

function Boss.create()
	local node = Boss.new()
	return node
end

function Boss:ctor()
	local boss = sp.SkeletonAnimation:create("spine/summaryboss/klswangqianzou.json","spine/summaryboss/klswangqianzou.atlas",1)
    boss:setAnimation(0,'a2',true)
	self:addChild(boss)
    self.boss = boss
	--boss血条
	local bloodBack = cc.Sprite:create("image/summarybossscene/summaryboss_blood_back.png")
    bloodBack:setPosition(100,-10)
    boss:addChild(bloodBack)
    self.blood = cc.ProgressTimer:create(cc.Sprite:create("image/summarybossscene/jindutiao.png"))
    self.blood:setPosition(100,-10)
    self.blood:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.blood:setMidpoint(cc.p(0,0))
    self.blood:setBarChangeRate(cc.p(1,0))
    self.blood:setPercentage(100)
    boss:addChild(self.blood) 
	
	self.bossWin = function() end
    self.bossClose = function() end
    self.bossBack = function() end
end

function Boss:setBlood(currentBlood,totalBlood)
	self.blood:setPercentage(100 * currentBlood / totalBlood)
end

function Boss:goForward(time)
    print('----------------')
    print('boss time',time)
    print('----------------')    
	local bossAction = {}
    for i = 1, 10 do
        local stop = cc.DelayTime:create(time / 10 * 0.8)
        local stopAnimation = cc.CallFunc:create(function() 
            self.boss:setAnimation(0,'a2',true)
        end,{})
        local move = cc.MoveBy:create(time / 10 * 0.2,cc.p(- 0.45 * s_DESIGN_WIDTH / 10, 0))
        local moveAnimation = cc.CallFunc:create(function() 
            self.boss:setAnimation(0,'animation',false)
        end,{})
        bossAction[#bossAction + 1] = cc.Spawn:create(stop,stopAnimation)
        bossAction[#bossAction + 1] = cc.Spawn:create(move,moveAnimation)
        if i == 8 then
            bossAction[#bossAction + 1] = cc.CallFunc:create(function (  )
                self.bossClose()
            end)
        end
    end
    bossAction[#bossAction + 1] = cc.CallFunc:create(function() 
    	self.bossWin()
    end,{})
    self:runAction(cc.Sequence:create(bossAction))
end

function Boss:goBack(time)
    self:stopAllActions()
    self.bossBack()
    local back = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.75 + 20))
    local forward = cc.CallFunc:create(function ()
        self:goForward(time)
    end)
	self:runAction(cc.Sequence:create(back,forward))
end

function Boss:fly()
    local move = cc.MoveTo:create(0.5,cc.p(0.9 * s_DESIGN_WIDTH,1.1 * s_DESIGN_HEIGHT))
    local mini = cc.ScaleTo:create(0.5,0.5)
    local rotate = cc.RotateBy:create(0.5,360)
    --local fly = cc.Spawn:create(move,rotate)
    self.boss:runAction(cc.Spawn:create(move,rotate))
end

return Boss