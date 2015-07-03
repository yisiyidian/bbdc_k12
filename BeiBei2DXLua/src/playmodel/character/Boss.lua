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
    	if self.ui:getPositionY() < s_DESIGN_HEIGHT then
    	self:attackEnded()
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

function Boss:attackEnded()
	self.ui:runAction(cc.Sequence:create(bossAction(),cc.CallFunc:create(function (  )
		s_BattleManager:releaseSkillEnded()
	end)))
end


return Boss