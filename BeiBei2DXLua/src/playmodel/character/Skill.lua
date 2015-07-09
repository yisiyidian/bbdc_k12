local Skill = class("Skill")
local SkillConfig = require('playmodel.character.SkillConfig')
require('playmodel.battle.ActionManager')

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
	self.effectFile = self.config.effectFile
	--技能目标
	self.targets = s_BattleManager:getTargetBySkillType(self.skillType)
	

end

function Skill:release(count)
	s_BattleManager:releaseSkill(self,count)
	self:setTrack(count)
end

function Skill:setTrack(count)
	if self.attack == 0 then
		return
	end
	for i = 1, #self.targets do
		for j = 1,count do
			local effect = cc.Sprite:create(self.source.skillFile)
			effect:setScale(0.3)
			effect:setPosition(self.source.ui:getContentSize().width / 2,self.source.ui:getContentSize().height / 2)
			self.source.ui:addChild(effect,-1)
			local pos = cc.p(s_DESIGN_WIDTH / 2 - self.source.ui:getPositionX(),s_DESIGN_HEIGHT * 0.9 - self.source.ui:getPositionY())
			effect:runAction(cc.Sequence:create(cc.DelayTime:create(0.2 * (j - 1)),cc.MoveBy:create(0.5,pos),cc.CallFunc:create(function (  )
				if self.attack > 0 then
					bossAttackedAnimation(self.targets[i].ui)
					self.targets[i]:addAttackCount(1)
				end
				effect:removeFromParent()
			end)))
		end
	end
end

return Skill