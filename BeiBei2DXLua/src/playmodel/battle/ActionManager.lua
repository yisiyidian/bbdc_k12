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

function ActionManager:changeBossAction(callback)
	--当前boss移出，下一个boss进入
	s_BattleManager.bossList[s_BattleManager.currentBossIndex].ui:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,400)),cc.CallFunc:create(function (  )
		if s_BattleManager.currentBossIndex < #s_BattleManager.bossList then
			s_BattleManager.bossList[s_BattleManager.currentBossIndex + 1].ui:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-400)),cc.CallFunc:create(callback)))
		else
			
		end
	end)))
																	  	
end

function petActionToReleaseSkill()
	return cc.Sequence:create(cc.ScaleTo:create(0.5,1.2),cc.ScaleTo:create(0.5,1))
end

function bossAction()
	return cc.Sequence:create(cc.ScaleTo:create(0.5,1.2),cc.ScaleTo:create(0.5,1))
end

function bossAttackedAnimation(target)
	target:setAnimation(0,'a3',false)
end

return ActionManager