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
	self.currentBossIndex = 0
	self.currentBoss = nil
end
-- --清空state
-- function BattleManager:clearState()
-- 	--游戏是否暂停
-- 	self.gamePaused = false
-- 	--游戏是否开始
-- 	self.gameBegan = false
-- 	--游戏是否结束
-- 	self.gameEnded = false
-- 	--总步数
-- 	self.totalStep = 0
-- 	--当前步数
-- 	self.currentStep = 0
-- 	--总时间
-- 	self.totalTime = 0
-- 	--当前时间
-- 	self.currentTime = 0
-- end
--初始化state
function BattleManager:initState(time,step,collect,wordList)
	--游戏是否暂停
	self.gamePaused = false
	--游戏是否开始
	self.gameBegan = false
	--游戏是否结束
	self.gameEnded = false
	--限制步数
	self.totalStep = step
	--当前步数
	self.currentStep = 0
	--限制时间
	self.totalTime = time
	--当前时间
	self.currentTime = 0
	--单词列表
	self.wordList = wordList
	--任务目标的收集数
	self.totalCollect = collect
	--当前收集数
	self.currentCollect = 0
end
--进入战斗场景
function BattleManager:enterBattleView()
	local battleView = require("playmodel.battle.BattleView").new()
	s_SCENE:replaceGameLayer(battleView)
	self:initState(100,20,10,{'apple','apple'})
end
--战斗开始
function BattleManager:battleBegan()
	self:register()
	self:initInfo()
	self.gameBegan = true
end
--战斗结束
function BattleManager:battleEnded()
	self:unregister()
	self:initInfo()
	self.gameEnded = true
end
--更新时间
function BattleManager:updateTime(delta)
	if self.gameBegan and not self.gameEnded and not self.gameEnded then
		self.currentTime = self.currentTime + delta
		if self.currentTime > self.totalTime then
			self:battleEnded()
		end
	end
end
--更新步数和收集数
function BattleManager:addStepWithCollect(collect)
	self.currentStep = self.currentStep + 1
	if self.currentStep == self.totalStep then
		self:battleEnded()
	end
	self.currentCollect = self.currentCollect + collect
	if self.currentCollect == self.totalCollect then
		if self.currentBossIndex == -1 then
			self:battleEnded()
		else
			
		end
	end
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
	if #self.skillList == 0 then 
		self:releaseSkillEnded()
	end
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
		if self.currentCollect >= self.totalCollect then
			self:battleEnded()
		else  
			self.currentBossIndex = -1
		end
		return
	end
	self.actionManager:changeBossAction(function()
		s_BattleManager.currentBossIndex = s_BattleManager.currentBossIndex + 1
		self.currentBoss = self.bossList[currentBossIndex]
	end)
	
end

return BattleManager