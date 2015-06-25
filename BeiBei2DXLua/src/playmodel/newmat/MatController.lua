-- 矩阵控制器
local ObserverController = require("playmodel.observer.ObserverController")
local MatController = class("MatController",function ()
	return require("playmodel.observer.Observer").create()
end)

MatController.arr = {}

function MatController:listNotify()
	return {}
end

-- 划的字母加入队列
function MatController.updateArr(p)
	local exist = false
	for k,v in pairs(MatController.arr) do
		if v == p then
			print("已经存在该元素")
			exist = true
			if k == #MatController.arr - 1 then
				print("去掉最后的一个元素")
				table.remove(MatController.arr,#MatController.arr)
			end
		end
	end

	if exist == false and p.x >= 1 and p.x <= 5 and p.y >= 1 and p.y <= 5 then
		MatController.arr[#MatController.arr + 1] = p
		print("加入队列")
	end
end



return MatController