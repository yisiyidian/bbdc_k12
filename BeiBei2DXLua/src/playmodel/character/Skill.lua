local Skill = class("Skill")
local SkillConfig = require('playmodel.character.SkillConfig')

function Skill:initWithID(id,source)
	--技能ID
	self.id = id
	--技能来源
	self.source = source 
	--
	self.config = SkillConfig[id]
	--技能类型
	self.skillType = self.config.skillType
	--技能攻击
	self.attack = self.config.attack * self.source.buff
	--技能buff
	self.buff = self.config.buff
	--技能特效
	self.effect = nil
	--技能目标
	self.targets = s_BattleManager:getTargetBySkillType(self.skillType)
	

end

function Skill:release()
	s_BattleManager:releaseSkill(self)
end

return Skill