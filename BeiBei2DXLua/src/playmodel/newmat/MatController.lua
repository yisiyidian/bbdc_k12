-- 矩阵控制器
require("playmodel.battle.Notification")
local ObserverController = require("playmodel.observer.ObserverController")
local Observer = require("playmodel.observer.Observer")
local MatController = class("MatController",Observer)

-- 位置序列，cc.p(1,1)
MatController.arr = {}
-- 字母序列
MatController.word = {}
-- 当前是第几个词
MatController.index = 1
-- 砖块元素序列，cocoview
MatController.currentCoco = {}

function MatController:reset()
	-- 位置序列，cc.p(1,1)
	MatController.arr = {}
	-- 字母序列
	MatController.word = {}
	-- 当前是第几个词
	MatController.index = 1
	-- 砖块元素序列，cocoview
	MatController.currentCoco = {}
end

-- 计算距离
function MatController:countDistance(p1,p2)
	return math.sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y))
end

-- 注册事件
function MatController:listNotify()
	return {RIGHT,
			UNREGISTER}
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

	local temp = ""	
	for k,v in pairs(MatController.currentCoco) do
		-- 已经加入的所有字母
		temp = temp..MatController.currentCoco[k].letter
	end
	MatController.MatView:resetWordLabel(temp)
end

-- 判断事件
function MatController:judgeFunc()
	-- 没有划
	if #MatController.currentCoco == 0 then
		return 
	end
	local temp = ""	
	local attackList = {0,0,0,0,0}
	for k,v in pairs(MatController.currentCoco) do
		-- 已经加入的所有字母
		temp = temp..MatController.currentCoco[k].letter
		-- 保存颜色
		attackList[MatController.currentCoco[k].color+1] = attackList[MatController.currentCoco[k].color+1] + 1
	end

	for i=1,5 do
		for j=1,10 do
			MatController.MatView.mat[i][j] = MatController.MatView.coco[i][j].color
		end
	end

	for i=1,5 do
		for j=1,10 do
			local drop = MatController.MatView.coco[i][j].drop
			if drop ~= 0 then
				MatController.MatView.mat[i][j - drop] = MatController.MatView.mat[i][j]
			end
		end
	end	



	if temp == MatController.word[MatController.index] then
		-- print("划词正确")
		-- print("这个词是"..temp)
		function MatController:callback()
			MatController:sendNotification("right",attackList)
		end

		-- print_lua_table(attackList)
		-- print("congratulation!!!!!!!!!!!!!!!")
		-- 下滑动作
		MatController.MatView:dropFunc(MatController.callback)
		MatController.index = MatController.index + 1
		-- 下滑动作
		for k,v in pairs(MatController.currentCoco) do
			MatController.currentCoco[k]:runAction(cc.MoveBy:create(0.4,cc.p(0,-800)))
			MatController.currentCoco[k]:runAction(cc.RotateBy:create(0.4,math.random(360,720)))
		end
	else
		s_BattleManager:addStepWithCollect(0)
		-- print("划错了")
		print("要划的词是"..MatController.word[MatController.index])
		print("你划的词是"..temp)
		-- 复原砖块状态
		for i = 1,5 do
			for j=1,10 do
				MatController.MatView.coco[i][j].drop = 0
				MatController.MatView.coco[i][j].touchState = 1
				MatController.MatView.coco[i][j]:resetView()	
			end
		end
	end

	-- 搞笑的代码
	if MatController.index == 99 then
        local SmallAlterWithOneButton = require("view.alter.SmallAlterWithOneButton")
        local smallAlter = SmallAlterWithOneButton.create("已经累了吧！稍微休息一下吧。")
        smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
        s_SCENE:popup(smallAlter)
        smallAlter.affirm = function ()
        	s_SCENE:removeAllPopups()
            s_CorePlayManager.enterLevelLayer()
        end
        return
	end

	-- 重置所有的序列
	MatController.arr = {}
	MatController.currentCoco = {}
end

-- 扩充一关的单词
function MatController:createWordGroup(list)
	local temp = {}
	for k,v in pairs(list) do
		temp[#temp + 1] = list[k]
	end
	math.randomseed(os.time())
	for i = 1,100 do
		temp[#temp + 1] = list[math.random(1,#list)]
	end 
	return temp
end

-- 处理观察者消息
function MatController:handleNotification(notify,data)
	if notify == "right" then
		print("处理消息right")
		-- MatController.MatView:resetUI()
	elseif notify == UNREGISTER then
    	self:unregister()
	end
end

-- 换词逻辑
function MatController:changeFunc()
	if #MatController.currentCoco ~= 0 then
		return 
	end
	s_BattleManager:addStepWithCollect(0)
	MatController.MatView:dropFunc()
	MatController.index = MatController.index + 1
end



return MatController