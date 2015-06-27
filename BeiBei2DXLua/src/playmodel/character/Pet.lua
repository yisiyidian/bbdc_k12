local Observer = require("playmodel.observer.Observer")
local CharacterConfig = require('playmodel.character.CharacterConfig')

local Pet = class("Pet", Observer)

function Pet:listNotify()
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
	self:register()
	self.id = id
	self.config = CharacterConfig[id]
	self.skillID = self.config.skillID
	self.blood = self.config.blood
	self.buff = 1.0
	self.ui = self:createUI(self.config.file)
end

function Pet:createUI(file)
	local sp = cc.Sprite:create(file)
	return sp
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