local BattleManager = class('BattleManager')

function BattleManager:ctor()
	self:initBattle()
end
--初始化战斗信息
function BattleManager:initBattle()
	self.buff = 1.0
	self.attack = 0
	self.bossList = {}
	self.petList = {}
	self.currentBossIndex = 0
end
--战斗结束
function BattleManager:battleOver()
	self:initBattle()
end
--寻找技能目标
function BattleManager:getTargetBySkillType(skillType)
	if skillType == 'attack' then
		return {self.bossList[currentBossIndex]}
	elseif skillType == 'buff' then
		return self.petList
	end
end
--释放技能
function BattleManager:releaseSkill(skill)
	local targets = skill.targets
	local source = skill.source
	for k,v in pairs(targets) do
		if skill.skillType == 'attack' then
			--boss被攻击
		elseif skill.skillType == 'buff' then
			--增加攻击
			v.buff = v.buff + skill.buff
		end
	end

end


return BattleManager