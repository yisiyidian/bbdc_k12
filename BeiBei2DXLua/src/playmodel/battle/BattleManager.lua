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
--初始化state
function BattleManager:initState(time,step,collect,wordList,stageType)
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
	print("33333333333333333333333333333")
	print_lua_table(self.wordList)
	--任务目标的收集数
	self.totalCollect = collect
	--当前收集数
	self.currentCollect = 0
	--关卡类型(限制时间或步数)
	self.stageType = stageType
	--各种资源数量
	self.petSource = {0,0,0,0,0}
	--是否获胜
	self.win = false
end
--进入战斗场景
function BattleManager:enterBattleView(unit)
	self:initState(100,10,20,unit.wrongWordList,'step')
	local battleView = require("playmodel.battle.BattleView").new()
	s_SCENE:replaceGameLayer(battleView)
	self.view = battleView
	self.unit = unit
end
--离开战斗场景
function BattleManager:leaveBattleView()
	self:unregister()
	self:sendNotification('UNREGISTER')
	s_CorePlayManager.leaveSummaryModel(self.win and self.unit.coolingDay == 0)
    s_CorePlayManager.enterLevelLayer() 
end
--重新挑战
function BattleManager:restartBattle()
	local unit = self.unit
	self:unregister()
	self:sendNotification('UNREGISTER')
	self:enterBattleView(unit)
end
--复活
function BattleManager:oneMoreChance()
	self.gameEnded = false
	if self.stageType == 'step' then
		self.currentStep = self.currentStep - 5
	else
		self.currentTime = self.currentTime - 30
	end
end
--战斗开始
function BattleManager:battleBegan()
	self:register()
	self:initInfo()
	self.gameBegan = true
end
--战斗结束
function BattleManager:battleEnded(win)
	-- self:unregister()
	-- self:initInfo()
	self.gameEnded = true
	self.win = win
	if win then
		print('win')
		-- self:leaveBattleView()
		-- return
		if self.unit.unitState == 0 then
            s_LocalDatabaseManager.addStudyWordsNum(#self.wordList)
            -- s_LocalDatabaseManager.addRightWord(self.rightWordList,self.unit.unitID)
            -- s_LocalDatabaseManager.addGraspWordsNum(self.maxCount - self.wrongWord)
         --   print(self.maxCount - self.wrongWord)
        elseif self.unit.unitState == 4 then
            -- local list = self.unit.wrongWordList[1]
            --  for i = 2,#self.unit.wrongWordList do
            --      list = list..'||'..self.unit.wrongWordList[i]
            --  end
            s_LocalDatabaseManager.addGraspWordsNum(#self.wordList)
            -- s_LocalDatabaseManager.addRightWord(list,self.unit.unitID)
        end
        local gameEndPopup = require('playmodel.popup.SuccessPopup').new(self.unit.unitID,self.stageType)
		s_SCENE:popup(gameEndPopup)
	else 
		print('lose')
		local gameEndPopup = require('playmodel.popup.FailPopup').new(self.unit.unitID,self.stageType)
		s_SCENE:popup(gameEndPopup)
	end
end
--更新时间
function BattleManager:updateTime(delta)
	--TODO
	if self.stageType == 'step' then
		return
	end
	if self.gameBegan and not self.gameEnded and not s_SCENE.popupLayer.layerpaused then
		self.currentTime = self.currentTime + delta
		if self.currentTime > self.totalTime then
			self:battleEnded(false)
		end
	end
end
--更新步数和收集数
function BattleManager:addStepWithCollect(collect)
	if self.stageType == 'step' then
		self.currentStep = self.currentStep + 1
		print(self.currentStep)
		if self.currentStep == self.totalStep then
			self:battleEnded(false)
		end
	end
	self.currentCollect = self.currentCollect + collect
	if self.currentCollect == self.totalCollect then
		if self.currentBossIndex > #self.bossList then
			self:battleEnded(true)
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
	self:changeNextBoss()
end

function BattleManager:releaseSkill(skill,count)

	local targets = skill.targets
	local source = skill.source
	for k,v in pairs(targets) do
		if skill.skillType == 'attack' then
			print('attack')
			--boss被攻击
			v:loseBlood(skill.attack * count)
		elseif skill.skillType == 'buff' then
			print('buff')
			--增加攻击
			v.buff = v.buff + skill.buff * count
		end
	end

end

function BattleManager:changeNextBoss()
	-- body
	if self.currentBossIndex > #self.bossList then
		if self.currentCollect >= self.totalCollect then
			self:battleEnded(true)
		end
		return
	end
	if self.bossList[self.currentBossIndex].blood <= 0 then
		if self.currentBossIndex == #self.bossList then
			if self.currentCollect >= self.totalCollect then
				self:battleEnded(true)
				return
			end
		end
	
		self.actionManager:changeBossAction(function()
			s_BattleManager.currentBossIndex = s_BattleManager.currentBossIndex + 1
			if self.currentBossIndex > #self.bossList then
				return
			end
			self.currentBoss = self.bossList[currentBossIndex]
		end)
	end
	
end
function BattleManager:createPausePopup()
    if s_SCENE.popupLayer.layerpaused then
        return
    end
    local pauseLayer = require("view.Pause").create()
    pauseLayer:setPosition(s_LEFT_X, 0)
    s_SCENE.popupLayer:addBackground()
    s_SCENE.popupLayer:addChild(pauseLayer)
    s_SCENE.popupLayer.listener:setSwallowTouches(true)
end

return BattleManager