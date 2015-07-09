require("playmodel.battle.Notification")
require('playmodel.battle.ActionManager')

local Observer = require("playmodel.observer.Observer")
local CharacterConfig = require('playmodel.character.CharacterConfig')

local Pet = class("Pet", Observer)

function Pet:listNotify()
    return {
        ATTACK,
        RIGHT,
        UNREGISTER
    }
end

function Pet:handleNotification(notify,data)
    if notify == RIGHT then
		if data[self.colorIndex] > 0 then
			s_BattleManager.petSource[self.colorIndex] = s_BattleManager.petSource[self.colorIndex] + data[self.colorIndex] 
			self:releaseSkill(data[self.colorIndex])
		end
    elseif notify == UNREGISTER then
    	self:unregister()
    end
end

function Pet:ctor(id)
	--self:register()
	self.id = id
	self.config = CharacterConfig[id]
	self.colorIndex = self.config.colorIndex
	self.skillID = self.config.skillID
	self.blood = self.config.blood
	self.buff = 1.0
	self.skillFile = self.config.skillFile
	self.ui = self:createUI(self.config.file)
	self.action = nil
	self.cb = function() end
	--一轮攻击中总共要被攻击的次数
	self.totalAttackCount = 0
	--一轮攻击中已经被攻击的次数
	self.attackCount = 0
	if self.ui ~= nil then
		print(self.ui:getPositionY(),'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	end
end

function Pet:createUI(file)
	local sp = cc.Sprite:create(file)
	return sp
end


function Pet:releaseSkill(count)
	local skill = require("playmodel.character.Skill").new()
	skill:initWithID(''..self.skillID,self)
	skill:release(count)
	self.action = petActionToReleaseSkill()
	self.ui:runAction(cc.Sequence:create(self.action,cc.CallFunc:create(function (  )
		self.cb()
	end)))
end



-- function Pet:addBuff(buff)
-- 	self.buff = self.buff + buff
-- end

return Pet