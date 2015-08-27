-- 观察者控制器
local ObserverController = class("ObserverController")
-- 容器
ObserverController.observerArr = {}

function ObserverController.register(observer)
	--TODO
	local notifyArr = observer:listNotify()
	-- print("########")
	-- print(#notifyArr)
	local tempObsArr = nil
	for k,v in pairs(notifyArr) do
		-- (v,observer)
		tempObsArr = ObserverController.observerArr[v]
		if not tempObsArr then
			tempObsArr = {}
			ObserverController.observerArr[v] = tempObsArr
		end
		--TODO 校验是否有重复的 没有的话 就把observer 放到 tempObsArr里
		local exist = false
		for k,v in pairs(tempObsArr) do
			if tempObsArr[k] == observer then
				print("########")
				print("已经注册过")
				print("########")
				exist = true
			end
		end
		if exist == false then
			tempObsArr[#tempObsArr + 1] = observer
		end
	end	
end

function ObserverController.unregister(observer)
	--TODO
	local notifyArr = observer:listNotify()
	local tempObsArr = nil
	for k,v in pairs(notifyArr) do
		-- (v,observer)
		tempObsArr = ObserverController.observerArr[v]
		if not tempObsArr then
			tempObsArr = {}
			ObserverController.observerArr[v] = tempObsArr
		end
		--TODO 校验是否有重复的 没有的话 就把observer 放到 tempObsArr里
		for k,v in pairs(tempObsArr) do
			if tempObsArr[k] == observer then
				print("########")
				print("反注册")
				print("########")
				table.remove(tempObsArr,k)
			end
		end
	end	
end
function ObserverController.sendNotification(notify,data)

	local tempArr = ObserverController.observerArr[notify]
	if not tempArr then
		return
	end

	local tempObs = {}
	for k,v in pairs(tempArr) do
		tempObs[#tempObs + 1] = v
	end

	for key,obs in pairs(tempObs) do
		obs:handleNotification(notify,data)
	end

	tempObs = {}
end

return ObserverController

