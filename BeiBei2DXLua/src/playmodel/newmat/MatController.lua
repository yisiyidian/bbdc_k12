-- 矩阵控制器
local ObserverController = require("playmodel.observer.ObserverController")
local Observer = require("playmodel.observer.Observer")
local MatController = class("MatController",Observer)

MatController.arr = {}
MatController.word = {"a"}
MatController.index = 1
MatController.totalindex = 0
MatController.currentCoco = {}

function MatController:countDistance(p1,p2)
	return math.sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y))
end

function MatController:listNotify()
	return {"right"}
end

-- 重置当前序号
function MatController:resetIndex()
	if MatController.index < MatController.totalindex then
		MatController.index = MatController.index + 1
		return false
	elseif MatController.index == MatController.totalindex then 
		return true
	end
end

-- 划的字母加入队列
function MatController:updateArr(p,coco)
	local exist = false
	-- 优化：如果位置与上一个位置相同，return
	if #MatController.arr > 0 and MatController.arr[#MatController.arr].x == p.x and MatController.arr[#MatController.arr].y == p.y then
		return
	end
	for k,v in pairs(MatController.arr) do
		if MatController.arr[k].x == p.x and MatController.arr[k].y == p.y then
			print("已经存在该元素")
			exist = true
			if k == #MatController.arr - 1 then	
				MatController.currentCoco[#MatController.currentCoco].CocoSprite:setColor(cc.c4b(255,255,255,255))
				print("去掉最后的一个元素")
				table.remove(MatController.arr,#MatController.arr)
				table.remove(MatController.currentCoco,#MatController.currentCoco)
			end
		end
	end

	if exist == false and p.x >= 1 and p.x <= 5 and p.y >= 1 and p.y <= 5 then
		print("在矩阵里")
		if #MatController.arr > 0 and self:countDistance(MatController.arr[#MatController.arr],p) ~= 1 then
			print("间隔不为1，不加入")
			return
		end
		MatController.arr[#MatController.arr + 1] = p
		MatController.currentCoco[#MatController.currentCoco + 1] = coco
		MatController.currentCoco[#MatController.currentCoco].CocoSprite:setColor(cc.c4b(0,0,0,255))
		print("加入队列")
	end
end

function MatController:judgeFunc()
	local temp = ""
	for k,v in pairs(MatController.currentCoco) do
		temp = temp..MatController.currentCoco[k].letter
	end
	if temp == MatController.word[MatController.index] then
		print("划词正确")
		print("这个词是"..temp)
		MatController:sendNotification("right",{})

		print("congratulation!!!!!!!!!!!!!!!")
		return true
	else
		print("划错了")
		print("要划的词是"..MatController.word[MatController.index])
		print("你划的词是"..temp)
		for k,v in pairs(MatController.currentCoco) do
			MatController.currentCoco[k].CocoSprite:setColor(cc.c4b(255,255,255,255))
		end
		MatController.currentCoco = {}
		MatController.arr = {}
		return false
	end
end

function MatController:handleNotification(notify,data)
	if notify == "right" then
		print("处理消息right")
		MatController.MatView:resetUI()
	end
end



return MatController