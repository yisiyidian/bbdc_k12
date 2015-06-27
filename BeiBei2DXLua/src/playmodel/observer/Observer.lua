-- 观察者
local ObserverController = require("playmodel.observer.ObserverController")
local Observer = class("Observer")

function Observer:ctor()
	
end

--override
function Observer:listNotify()
	return {}
end

function Observer:register()
	print("ObserverController.register(self)")
	ObserverController.register(self)
end

function Observer:unregister()
	ObserverController.unregister(self)
end

function Observer:sendNotification(notify,data)
	ObserverController.sendNotification(notify,data)
end

--override
function Observer:handleNotification(notify,data)
	-- if notify == XXXX then
	-- end
end


return Observer