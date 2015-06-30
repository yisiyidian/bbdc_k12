-- 矩阵控制器
local ObserverController = require("playmodel.observer.ObserverController")
local Observer = require("playmodel.observer.Observer")
local MatController = class("MatController",Observer)

-- 位置序列，cc.p(1,1)
MatController.arr = {}
-- 字母序列
MatController.word = {"a"}
-- 当前是第几个词
MatController.index = 1
-- 总共几个词
MatController.totalindex = 0
-- 砖块元素序列，cocoview
MatController.currentCoco = {}

-- 计算距离
function MatController:countDistance(p1,p2)
	return math.sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y))
end

-- 注册事件
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
			-- print("已经存在该元素")
			exist = true
			if k == #MatController.arr - 1 then	
				-- print("去掉最后的一个元素")
				-- 这个元素上方的所有单位下滑距离减一
				for i=1,10 do
					if i > MatController.arr[#MatController.arr].y then
						MatController.MatView.coco[MatController.arr[#MatController.arr].x][i].drop = MatController.MatView.coco[MatController.arr[#MatController.arr].x][i].drop - 1
					end
				end
				-- 改变这个元素的触摸状态及显示状态
				MatController.currentCoco[#MatController.currentCoco].touchState = 1
				MatController.currentCoco[#MatController.currentCoco]:resetView()
				-- 移除元素
				table.remove(MatController.arr,#MatController.arr)
				table.remove(MatController.currentCoco,#MatController.currentCoco)
			end
		end
	end

	if exist == false and p.x >= 1 and p.x <= 5 and p.y >= 1 and p.y <= 5 then
		-- print("在矩阵里")
		if #MatController.arr > 0 and self:countDistance(MatController.arr[#MatController.arr],p) ~= 1 then
			-- print("间隔不为1，不加入")
			return
		end
		MatController.arr[#MatController.arr + 1] = p
		MatController.currentCoco[#MatController.currentCoco + 1] = coco
		-- print("加入队列")

		-- 该元素上方所有的元素下滑距离加一
		for i=1,10 do
			if i > p.y then
				MatController.MatView.coco[p.x][i].drop = MatController.MatView.coco[p.x][i].drop + 1
			end
		end
	end

	-- 改变队列中所有的元素状态
	for k,v in pairs(MatController.arr) do
		if k == #MatController.arr then
			MatController.currentCoco[k].touchState = 2
		else
			MatController.currentCoco[k].touchState = 3
		end	
		MatController.currentCoco[k]:resetView()
	end
end

-- 判断事件
function MatController:judgeFunc()
	-- 没有划
	if #MatController.currentCoco == 0 then
		return 
	end
	local temp = ""	
	local attackList = {}
	for k,v in pairs(MatController.currentCoco) do
		-- 已经加入的所有字母
		temp = temp..MatController.currentCoco[k].letter
		-- 保存颜色
		table.insert(attackList,MatController.currentCoco[k].color%5)
	end



	-- if temp == MatController.word[MatController.index] then
		-- print("划词正确")
		print("这个词是"..temp)
		MatController:sendNotification("right",attackList)
		print_lua_table(attackList)
	-- 	print("congratulation!!!!!!!!!!!!!!!")
	-- else
	-- 	-- print("划错了")
	-- 	print("要划的词是"..MatController.word[MatController.index])
	-- 	print("你划的词是"..temp)
	-- end

	-- 下滑动作
	for k,v in pairs(MatController.currentCoco) do
		MatController.currentCoco[k]:runAction(cc.MoveBy:create(0.4,cc.p(0,-800)))
		MatController.currentCoco[k]:runAction(cc.RotateBy:create(0.4,math.random(360,720)))
	end

	-- 下滑动作
	MatController.MatView:dropFunc()
	-- 重置所有的序列
	MatController.arr = {}
	MatController.word = {"a"}
	MatController.index = 1
	MatController.totalindex = 0
	MatController.currentCoco = {}
end

function MatController:handleNotification(notify,data)
	if notify == "right" then
		print("处理消息right")
		-- MatController.MatView:resetUI()
	end
end



return MatController