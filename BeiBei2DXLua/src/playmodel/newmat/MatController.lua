-- 矩阵控制器
local ObserverController = require("playmodel.observer.ObserverController")
local Observer = require("playmodel.observer.Observer")
local MatController = class("MatController",Observer)

MatController.arr = {}
MatController.word = {}
MatController.index = 0
MatController.currentCoco = {}

function MatController:listNotify()
	return {}
end

-- 划的字母加入队列
function MatController:updateArr(p,coco)
	local exist = false
	for k,v in pairs(MatController.arr) do
		if MatController.arr[k] == p then
			print("已经存在该元素")
			exist = true
			if k == #MatController.arr - 1 then
				print("去掉最后的一个元素")
				table.remove(MatController.arr,#MatController.arr)
				table.remove(MatController.currentCoco,#MatController.currentCoco)
				MatController.currentCoco[#MatController.currentCoco].CocoSprite:setColor(cc.c4b(255,255,255,255))
			end
		end
	end

	if exist == false and p.x >= 1 and p.x <= 5 and p.y >= 1 and p.y <= 5 then
		MatController.arr[#MatController.arr + 1] = p
		MatController.currentCoco[#MatController.currentCoco + 1] = coco
		MatController.currentCoco[#MatController.currentCoco].CocoSprite:setColor(cc.c4b(0,0,0,255))
		print("加入队列")
	end
	print_lua_table(MatController.arr)
end

function MatController:judgeFunc()
	local temp = ""
	for k,v in pairs(MatController.currentCoco) do
		temp = temp + MatController.currentCoco[k].letter
	end
	if temp == MatController.word[MatController.index] then
		print("划词正确")
		print("这个词是"..temp)
		MatController.sendNotification(notify,data)
		return true
	else
		print("划错了")
		print("要划的词是"..MatController.word[MatController.index])
		print("你划的词是"..temp)
		return false
	end
end



return MatController