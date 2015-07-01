local Observer = require("playmodel.observer.Observer")
local BattleStateManager = class('BattleStateManager',Observer)

function BattleStateManager:listNotify()
	return {}
end

function BattleStateManager:sendNotification(notify,data)
	--ObserverController.sendNotification(notify,data)
end

--override
function BattleStateManager:handleNotification(notify,data)
	-- if notify == XXXX then
	-- end
end

function BattleStateManager:ctor()

end


return BattleStateManager