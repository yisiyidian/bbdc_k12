require("playmodel.battle.Notification")

local Observer = require("playmodel.observer.Observer")
local BattleManager = class('BattleManager',Observer)
local Boss = require('playmodel.character.Boss')
local Pet = require('playmodel.character.Pet')
local ActionManager = require('playmodel.battle.ActionManager')

function BattleManager:listNotify()
	return {ATTACK}
end

--override
function BattleManager:handleNotification(notify,data)
	-- if notify == XXXX then
	-- end
end

function BattleManager:ctor()
	self.actionManager = ActionManager.new()
	self:initInfo()
end
--初始化战斗信息
function BattleManager:initInfo()
	self.buff = 1.0
	self.attack = 0
	self.bossList = {}
	self.petList = {}
	self.skillList = {}
	self.skillCount = 0
	self.currentBossIndex = 0
	self.currentBoss = nil
end
--进入战斗场景
function BattleManager:enterBattleView()
	local battleView = require("playmodel.battle.BattleView").new()
	s_SCENE:replaceGameLayer(battleView)
end
--战斗开始
function BattleManager:battleBegan()
	self:register()
	self:initInfo()
end
--战斗结束
function BattleManager:battleEnded()
	self:unregister()
	self:initInfo()
end
--创建boss
function BattleManager:createBoss(idList)
	-- body
	for i,v in ipairs(idList) do
		self.bossList[#self.bossList + 1] = Boss.new(idList[i])
		self.bossList[#self.bossList]:register()
	end
	self.currentBossIndex = 1
	self.currentBoss = self.bossList[currentBossIndex]
end
--创建pet
function BattleManager:createPet(idList)
	-- body
	for i,v in ipairs(idList) do
		self.petList[#self.petList + 1] = Pet.new(idList[i])
		self.petList[#self.petList]:register()
	end
end

--寻找技能目标
function BattleManager:getTargetBySkillType(skillType)
	if skillType == 'attack' then
		print('skilltype = attack')
		return {self.bossList[self.currentBossIndex]}
	elseif skillType == 'buff' then
		return self.petList
	end
end
--释放技能
function BattleManager:realseSkillInList()
	for i = #self.skillList,1,-1 do
		--self.skillList[i].action = self.actionManager:petActionToReleaseSkill()
		self.skillList[i].cb = function ()
			if i < #self.skillList then
				self.skillList[i + 1]:releaseSkill()
			else
				self:releaseSkillEnded()
			end
		end
	end
	self.skillList[1]:releaseSkill()
end

function BattleManager:releaseSkillEnded()
	self.skillList = {}
	self.skillCount = 0
	if self.bossList[self.currentBossIndex].blood <= 0 then
		self:changeNextBoss()
	end
end

function BattleManager:releaseSkill(skill)

	local targets = skill.targets
	local source = skill.source
	for k,v in pairs(targets) do
		if skill.skillType == 'attack' then
			print('attack')
			--boss被攻击
			v:loseBlood(skill.attack)
		elseif skill.skillType == 'buff' then
			print('buff')
			--增加攻击
			v.buff = v.buff + skill.buff
		end
	end

end

function BattleManager:changeNextBoss()
	-- body
	if s_BattleManager.currentBossIndex == #self.bossList then
		self:battleOver()
		return
	end
	self.actionManager:changeBossAction(function()
		s_BattleManager.currentBossIndex = s_BattleManager.currentBossIndex + 1
		self.currentBoss = self.bossList[currentBossIndex]
	end)
	
end
--将要发动技能的宠物加入列表，用于依次发动
function BattleManager:addPetToSkillList(pet)
	table.insert(self.skillList,pet)
	if #self.skillList == self.skillCount then
		self:realseSkillInList()
	end
end

function BattleManager:setPetCountToReleaseSkill(count)
	self.skillCount = count
end

return BattleManager