local Observer = require("playmodel.observer.Observer")
local BattleManager = class('BattleManager',Observer)
local Boss = require('playmodel.character.Boss')
local Pet = require('playmodel.character.Pet')

function BattleManager:listNotify()
	return {}
end

function BattleManager:sendNotification(notify,data)
	--ObserverController.sendNotification(notify,data)
end

--override
function BattleManager:handleNotification(notify,data)
	-- if notify == XXXX then
	-- end
end

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
	self.currentBoss = nil
end
--战斗结束
function BattleManager:battleOver()
	self:initBattle()
end
--创建boss
function BattleManager:createBoss(idList)
	-- body
	for i,v in ipairs(idList) do
		self.bossList[#self.bossList + 1] = Boss.createWithID(idList[i])
	end
	self.currentBossIndex = 1
	self.currentBoss = self.bossList[currentBossIndex]
end
--创建pet
function BattleManager:createPet(idList)
	-- body
	for i,v in ipairs(idList) do
		self.petList[#self.petList + 1] = Pet.createWithID(idList[i])
	end
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
			v:loseBlood(skill.attack)
		elseif skill.skillType == 'buff' then
			--增加攻击
			v.buff = v.buff + skill.buff
		end
	end

end


return BattleManager