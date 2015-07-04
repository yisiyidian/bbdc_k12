require("playmodel.battle.Notification")
require('playmodel.battle.ActionManager')
local Pet = require("playmodel.character.Pet")

local Boss = class("Boss", Pet)

function Boss:listNotify()
    return {
    	ATTACK,
    	RIGHT
    }
end

function Boss:handleNotification(notify,data)
	-- print(2)
 --    --data {xxx=xxx,xxxdd=xxxdd}
    if notify == RIGHT then
    	if self.ui:getPositionY() < s_DESIGN_HEIGHT and self.totalAttackCount == 0 then
    		self.totalAttackCount = data[1] + data[2] + data[3] + data[4] + data[5]
    		--没有形成攻击，直接进行结束判定
    		if self.totalAttackCount == 0 then
    			self:attackEnded()
    		end
    		--print('self.totalAttackCount',self.totalAttackCount)
    	end
    end


end

function Boss:loseBlood(blood)
	-- body
	self.blood = self.blood - blood
	print('boss blood',self.blood)
	if self.blood < 0 then
		self.blood = 0
	end
	
end

function Boss:createUI(file)
	local ui = sp.SkeletonAnimation:create(file..".json",file..".atlas",1)
    ui:setAnimation(0,'a2',true)
    return ui
end

function Boss:attackEnded()
	self.ui:runAction(cc.Sequence:create(bossAction(),cc.CallFunc:create(function (  )
		s_BattleManager:releaseSkillEnded()
	end)))
end

function Boss:addAttackCount(count)
	self.attackCount = self.attackCount + count
	--攻击结束
	if self.attackCount == self.totalAttackCount then
		self.attackCount = 0
		self.totalAttackCount = 0
		self:attackEnded()
	end
end

return Boss