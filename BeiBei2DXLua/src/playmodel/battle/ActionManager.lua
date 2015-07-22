-- 动作管理器，继承观察者
-- 尽管没用到
local Observer = require("playmodel.observer.Observer")
local ActionManager = class('ActionManager',Observer)

function ActionManager:listNotify()
	return {}
end

--override
function ActionManager:handleNotification(notify,data)
	-- if notify == XXXX then
	-- end
end

function ActionManager:ctor()

end
-- callback 当前的boss序号加1
function ActionManager:changeBossAction(callback)
	--当前boss移出，下一个boss进入
	s_BattleManager.bossList[s_BattleManager.currentBossIndex].ui:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,400)),cc.CallFunc:create(function (  )
		if s_BattleManager.currentBossIndex < #s_BattleManager.bossList then
			s_BattleManager.bossList[s_BattleManager.currentBossIndex + 1].ui:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-400)),cc.CallFunc:create(callback)))
		else
			
		end
	end)))														  	
end

-- 宠物释放技能
function ActionManager:petActionToReleaseSkill()
	return cc.Sequence:create(cc.ScaleTo:create(0.5,1.2),cc.ScaleTo:create(0.5,1))
end

-- boss动作 
function ActionManager:bossAction()
	return nil
end

-- boss受到攻击，动画
function bossAttackedAnimation(target)
	target:setAnimation(0,'a3',false)
end

return ActionManager