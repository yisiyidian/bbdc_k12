local Observer = require("playmodel.observer.Observer")
local ActionManager = class('ActionManager',Observer)

function ActionManager:listNotify()
	return {}
end

function ActionManager:sendNotification(notify,data)
	--ObserverController.sendNotification(notify,data)
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
		s_BattleManager.bossList[s_BattleManager.currentBossIndex + 1].ui:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-400)),cc.CallFunc:create(callback)))
	end)))
																	  	
	
end

return ActionManager