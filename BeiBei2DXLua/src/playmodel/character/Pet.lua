require("playmodel.battle.Notification")
require('playmodel.battle.ActionManager')

local Observer = require("playmodel.observer.Observer")
local CharacterConfig = require('playmodel.character.CharacterConfig')

local Pet = class("Pet", Observer)

function Pet:listNotify()
    return {
        ATTACK
    }
end

function Pet:handleNotification(notify,data)
    if notify == ATTACK then
    	for k,v in pairs(data.id) do
    		if v == self.id then
				s_BattleManager:addPetToSkillList(self)
				break
			end
		end
    else

    end
end

function Pet:ctor(id)
	--self:register()
	self.id = id
	self.config = CharacterConfig[id]
	self.skillID = self.config.skillID
	self.blood = self.config.blood
	self.buff = 1.0
	self.ui = self:createUI(self.config.file)
	self.action = nil
	self.cb = function() end
end

function Pet:createUI(file)
	local sp = cc.Sprite:create(file)
	return sp
end


function Pet:releaseSkill()
	local skill = require("playmodel.character.Skill").new()
	skill:initWithID(''..self.skillID,self)
	skill:release()
	self.action = petActionToReleaseSkill()
	self.ui:runAction(cc.Sequence:create(self.action,cc.CallFunc:create(function (  )
		self.cb()
	end)))
end



-- function Pet:addBuff(buff)
-- 	self.buff = self.buff + buff
-- end

return Pet