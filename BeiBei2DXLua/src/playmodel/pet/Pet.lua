local Observer = require("playmodel.observer.Observer")

local Pet = class("Pet", Observer)

function Pet:listNotification()
    return {
        ATTACK,
        RUN
    }
end

function Pet:handleNotification(notify,data)
    --data {xxx=xxx,xxxdd=xxxdd}
    if notify == ATTACK then
		self:releaseSkill()
    elseif notify == RUN then

    end
end

function Pet.createWithID(id)
	return Pet.new(id)
end

function Pet:ctor(id)
	self.id = id
	self.skillID = 1000
	self.buff = 1.0
end

function Pet:releaseSkill()
	local skill = require("playmodel.pet.Skill").new()
	skill:initWithID(self.skillID,self)
	skill:release()
end

-- function Pet:addBuff(buff)
-- 	self.buff = self.buff + buff
-- end

return Pet