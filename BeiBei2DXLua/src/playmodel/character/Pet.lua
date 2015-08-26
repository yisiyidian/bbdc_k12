require("playmodel.battle.Notification")
local ActionManager = require('playmodel.battle.ActionManager')

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
	-- print("self.colorIndex")
	-- print(self.colorIndex)
	-- print("data")
	-- print_lua_table(data)
    if notify == RIGHT then
		if data[self.colorIndex] > 0 then
			s_BattleManager.petSource[self.colorIndex] = s_BattleManager.petSource[self.colorIndex] + data[self.colorIndex] 
			self:releaseSkill(data[self.colorIndex])
			-- 给宠物汇集能量的音效
			-- ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
			-- 暂用
			playSound(s_sound_buttonEffect)
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
	self.action = ActionManager:petActionToReleaseSkill()
	self.ui:runAction(cc.Sequence:create(self.action,cc.CallFunc:create(function (  )
		self.cb()
		-- 攻击boss的音效
		playSound(s_sound_FightBoss)
	end)))
end



-- function Pet:addBuff(buff)
-- 	self.buff = self.buff + buff
-- end

return Pet