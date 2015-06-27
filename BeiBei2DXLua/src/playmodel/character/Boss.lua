local Pet = require("playmodel.character.Pet")

local Boss = class("Boss", Pet)

function Boss:listNotify()
    return {

    }
end

function Boss:handleNotification(notify,data)
    --data {xxx=xxx,xxxdd=xxxdd}
  --   if notify == ATTACK then
		-- self:releaseSkill()
  --   elseif notify == RUN then

  --   end
end

function Boss:loseBlood(blood)
	-- body
	self.blood = self.blood - blood
	if self.blood < 0 then
		self.blood = 0
	end
end

-- function Boss:addBuff(buff)
-- 	self.buff = self.buff + buff
-- end

return Boss