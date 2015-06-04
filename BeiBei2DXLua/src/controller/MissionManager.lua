-- 玩家任务管理器 新的任务系统  在global.lua里初始化
-- Author: whe
-- Date: 2015-05-12 11:21:08
--	
-- 任务分为两大类 一、累计登陆  二、随机任务，又分为1、普通任务 2、特殊任务
--	一、累计登陆
-- 	第1个任务为累积登陆1天，第二个任务为累积登陆2天，第三个任务为5天，以后的任务都累加5
--	累计登陆一共有22个任务，区别只是累计的天数不同。
--	累积登陆100天后，一共22个任务完成后，显示“恭喜你获得称号：签到达人”
--	本书学习完成时，累积登陆任务未完成，仍然可以继续任务直到任务完成
--	累计登陆天数奖励的贝贝豆数量 等于 累计登陆的天数
-- 二、随机任务
--    	1、普通任务  可能会重复出现
-- 		神秘任务
-- 		打卡
-- 		趁热打铁连续答对3-8词
-- 		分享
-- 		完成一次总结BOSS

--		2、特殊任务
--		完善信息
-- 		拥有X个好友  x = 1、3、5、10、20
-- 		下载音频
-- 		解锁数据1 解锁数据2 解锁数据4
--		解锁VIP


local MissionManager = class("MissionManager")

local MissionConfig  = reloadModule("model.mission.MissionConfig") --任务配置文件
local DataMission    = require("model.user.DataMission")

function MissionManager:ctor()
	self.taskNum = 6 		--随机任务数量
	self.missionData = nil  --任务数据

end

--获取当前的任务列表 --View层调用
function MissionManager:getMissionList()
	--任务列表的str转成 table
	--返回当前的任务列表 包括累计登陆任务和随机任务,只有2个任务
	--任务ID_任务状态_任务条件_任务总条件_任务游标
	local loginTaskData = self:getLoginTask()
	--1:	任务序号
    --2:	当前连续的天数 
    --3:	当前任务总天数
    local status = "0"
    if loginTaskData[2] < loginTaskData[3] then
    	status = "0"
    else
    	status = "1"
    end

	local loginTask = {}
	loginTask[1] = MissionConfig.MISSION_LOGIN  --ID
	loginTask[2] = status 						--状态
	loginTask[3] = loginTaskData[2] 			--条件
	loginTask[4] = loginTaskData[3]				--总条件
	loginTask[5] = loginTaskData[1]				--任务游标
	--获取指定任务的状态
	local randomTask = self:getCurRandomTaskData()
	return {loginTask,randomTask}
end

-- 更新任务状态------------------------------------------------------------------外部调用-----------更新任务状态---
-- missionId 		任务ID
-- missionData 		任务数据 条件,修改条件
-- addData 			数据类型是 1增加的类型 true 还是 2 赋值的类型false 。所谓增加的类型,比如打败一次BOSS,增加一次。所谓赋值的类型,如好友数量,直接赋值,覆盖以前的值
-- callBack 		修改完成回调 cb(result, error)
function MissionManager:updateMission(missionId,missionsData,addData,callBack)
	missionsData = missionsData or 1
	if addData == nil then
		addData = true
	end
  
	print("更新任务:"..missionId.." 条件:"..missionsData.." 类型:"..tostring(addData))

	local tb = self:strToTable(self.missionData.taskList)
	local re = false
	local hit = false --命中 更新的任务在任务列表中存在,需要同步任务数据,如果不存在 则无需同步
	for k,v in pairs(tb) do
		if v[1] == missionId then
			hit = true
			if addData then
				v[3] = tostring(tonumber(v[3]) + missionsData) --默认条件+1
			else
				if v[3] ~= tostring(missionsData) then
					v[3] = tostring(missionsData) --当前完成度  直接赋值
				else
					hit = false	
				end
			end
			if v[3] >= v[4] then --如果当前任务条件和 任务总条件匹配,则标记为已完成
				v[2] = "1" --标记为已完成 未领取
				re = true
			end
		end
	end

	--如果有可以领取的任务 调用回调函数以更新箱子状态
	if re then
		if self.canCompleteCallBack ~= nil then
	   		self.canCompleteCallBack()
		end
	end
	if hit then
		self.missionData.taskList = self:tableToStr(tb)
		self:saveTaskToLocal()
		s_O2OController.syncMission(callBack)  --同步数据 到服务器
	end
	return re
end

-- 领取任务奖励-----------------------------------------------------------------外部调用-----------完成任务---
-- taskId 	任务ID
-- callBack	领取完成回调  cb(result, error)
function MissionManager:completeMission(taskId,index,callBack)
	--区分是累计登陆任务 还是随机任务
	local re = false
	local bean = 0
	if taskId == MissionConfig.MISSION_LOGIN then
		return self:getLoginReward(index,callBack)
	else
		local tb = self:strToTable(self.missionData.taskList) --取出来
		local curTaskData = nil
		for k,v in pairs(tb) do
			if v[1] == taskId then
				if v[2] == "1" then
					v[2] 	= "2"  	--修改状态为已领取
					curTaskData = v
					re 		= true
					break
				end 
			end
		end
		--领取成功
		if re then
			self.missionData.taskList = self:tableToStr(tb) --存回去
			local config = self:getRandomMissionConfig(taskId) ---数据多的话,这么写的效率很低
			local onceTaskComplete = false --特殊任务的完成标记
			--存储系列任务的ID
			--TODO 如果是系列任务全部完成状态 从系列任务进度列表里删除 移到完成任务列表里
			if #config.condition > 1 and curTaskData[5] ~= #config.condition then
				local seriesMissions = self:strToTable(self.missionData.taskSeriesList)
				local update = false
				for k,v in pairs(seriesMissions) do
					if v[1] == taskId then
						update = true
						v[2] = curTaskData[2] --状态
						v[3] = curTaskData[3] --条件
						v[4] = curTaskData[4] --总条件
						v[5] = curTaskData[5] --index
					end
				end

				if not update then
					local tb = {}
					tb[1] = curTaskData[1]
					tb[2] = curTaskData[2]
					tb[3] = curTaskData[3]
					tb[4] = curTaskData[4]
					tb[5] = curTaskData[5]
					seriesMissions[#seriesMissions + 1] = tb
				end
				--保存任务进度
				self.missionData.taskSeriesList = self:tableToStr(seriesMissions)
			elseif #config.condition > 1 and #config.condition == curTaskData[5] then
				onceTaskComplete = true
				--删除系列任务的进度
				local seriesMissions = self:strToTable(self.missionData.taskSeriesList)
				for k,v in pairs(seriesMissions) do
					if v[1] == taskId then
						seriesMissions[k] = nil
						break
					end
				end
				self.missionData.taskSeriesList = self:tableToStr(seriesMissions)
			elseif #config.condition == 1 and (string.sub(taskId,1,1) == "2" or string.sub(taskId,1,1) == "3") then
				onceTaskComplete = true
			end
			--特殊任务 要保存进度 确保不会重复出现
			if onceTaskComplete then
				-- local comTable = self:strToTable(self.missionData.taskCompleteList)
				local comTable = string.split(self.missionData.taskCompleteList,"|")
				comTable[#comTable + 1] = taskId
				local restr = ""
				for k,v in pairs(comTable) do
					if restr == "" then
						restr = v
					else
						restr = restr.."|"..v
					end
				end
				self.missionData.taskCompleteList = restr
			end

			self:updateRandomMissionId() --重新生成激活任务的ID
			self:saveTaskToLocal()
			s_O2OController.syncMission(callBack) --同步数据 到服务器
			
			bean = config.bean
			s_CURRENT_USER:addBeans(bean) --获取贝贝豆
        	saveUserToServer({[DataUser.BEANSKEY] = s_CURRENT_USER[DataUser.BEANSKEY]}) --同步到
		end
		return re,bean
	end
end

---设置完成任务状态的回调
function MissionManager:setCanCompleteCallBack(canCompleteCallBack)
	self.canCompleteCallBack = canCompleteCallBack   --宝箱回调
end



--------------------------------------------------------------------------------------------------------------------
--根据ID 获取指定任务的配置
--missionId 任务ID
function MissionManager:getRandomMissionConfig(missionId)
	for k,v in pairs(MissionConfig.randomMission) do
		if v.mission_id == missionId then
			return v
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------
--生成今日的任务数据
function MissionManager:generalTasks()
	local loginDay = 0 			--累计登陆天数
	local lastLoginDate = nil 	--上一次的登陆时间
	local taskGenDate = nil
	
	if self.missionData == nil then
		self.missionData = DataMission.create()
	end
	-- taskGenDate
	lastLoginDate   = self.missionData.lastLoginDate 	--取上一次的登陆时间
	loginDay 		= self.missionData.totalLoginDay	--累计登陆天数
	taskGenDate 	= self.missionData.taskGenDate 		--任务列表生成时间
	local tDate = os.date("%x", lastLoginDate)			--最后登陆日期
	local tNow  = os.date("%x", os.time())				--当前日期
	print("last Date:"..tDate)
	print("now  Date:"..tNow)
	--如果是今天第一次登陆 则重新生成任务列表
	if tNow ~= tDate or self.missionData.taskList == "" then
		print("重新生成任务列表")
		loginDay = loginDay + 1	--天数+1
		taskGenDate = os.time()
		--重新生成任务列表
		local result = {} 	 --生成结果
		local tasksConfig =  MissionConfig.randomMission
			
		-- ts_task 和 js_task 是任务生成的后备列表
		local ts_task = {} 		--特殊任务  配置  MissionConfig.randomMission 的项,例如 {["mission_id"] = "2-1",["type"] = 2,["condition"]= {1},["bean"]=0}, --完善信息
		local js_task = {} 		--解锁任务  配置
		--临时变量
		local id      = nil  	--任务ID
		local m_type  = nil 	--任务类型
		--分类任务
		for _,v in pairs(tasksConfig) do
			id = v.mission_id
			m_type = string.sub(id,1,1)
			if m_type == "1" then
				result[#result + 1] = v --普通任务 直接入选
			elseif m_type == "2" then
				ts_task[#ts_task + 1] = v
			elseif m_type == "3" then
				js_task[#js_task + 1] = v
			end
		end
		--获取table长度--------------------------------------
		local function tnum(t)
			local len = 0
			for k,v in pairs(t) do
				len = len + 1
			end
			return len
		end
		--从table中抽出指定的项---------------------------------
		local function tget(t,index)
			local len = 0
			for k,v in pairs(t) do
				len = len + 1
				if len == index then
					t[k] = nil
					return v
				end
			end
			return nil
		end
		--先精简任务列表 把已经领取奖励的特殊任务去掉  【领取奖励】= 已结束
		local temp_comp_missions = {} --系列任务进度的table,table中的每一项是table结构{{"1-1","1","0","1","1"},{"2-2","1","1","1","1"}}
		if self.missionData.taskCompleteList ~= "" then
			local temp_comp_missions = string.split(self.missionData.taskCompleteList,"|")
			--任务状态: 0未完成  1已完成 未领取 2已领取
			local mission_id = nil
			for k,v in pairs(temp_comp_missions) do
				mission_id = v
				--精简特殊任务
				for kk,vv in pairs(ts_task) do
					if mission_id == vv.mission_id then
						--如果 【1】任务ID匹配,【2】并且是任务最后一条(非系列任务只有1项),【4】并且状态是已领取奖励 则从任务列表里 移除这个任务
						ts_task[kk] = nil
						break
					end
				end
				--精简 解锁任务
				for kkk,vvv in pairs(js_task) do
					if mission_id == vvv.mission_id then
						js_task[kkk] = nil
					break
					end
				end
			end
		end

		--系列任务的完成记录 生成任务列表的时候会用到，比如加好友的任务已经进行到第二步了，再生成加好友的任务 游标就要从2
		local temp_series_missions = {} 
		local temp_mission = string.split(self.missionData.taskSeriesList,"|")
		for _,v in pairs(temp_mission) do
			temp_series_missions[#temp_series_missions + 1] = string.split(v,"_")
		end

		-- dump(ts_task,"ts_task")
		--从特殊任务和解锁任务里随机抽取	
		local tlen = 6 - #result  --可以抽取的任务数量
		local hasLockMission = false  --已经有解锁任务了  解锁任务只能领取一个
		
		for i=1,tlen do
			local temp_type = math.random(100) --先random 决定是特殊任务还是解锁任务
			if temp_type < 50 or hasLockMission then --特殊任务
				local ts_index = math.random(tnum(ts_task))
				if ts_index > 0 then
					result[#result + 1] = tget(ts_task,ts_index)
				end
			else
				hasLockMission = true --解锁任务  取价格最低的
				local minprice = 0
				local js_index = 0
				for k,v in pairs(js_task) do
					if v.cost < minprice or minprice == 0 then
						minprice = v.cost
						js_index = k
					end
				end
				if js_index > 0 then
					result[#result + 1] = tget(js_task,js_index)
				end
			end
		end
		--TEST 
		--result[#result + 1] = {["mission_id"] = "2-2",["type"] = 2,["condition"]= {1,3,5,10,20},["bean"]=0}
		--result 生成的任务列表
		local mission_str 			= "" --- 1-1_0_0_1_1|2-2_0_0_1_1|3-1_1_2_2_1 任务ID_任务状态_任务条件_任务总条件_任务游标
		local temp_mission_str  	= ""
		local condition 			= "" 
		for k,v in pairs(result) do
			temp_mission_str = v.mission_id
			condition = v.condition
			if #condition == 1 then
				temp_mission_str = temp_mission_str.."_0_0_"..condition[1].."_1"
			else
				local hit = false --命中
				for kk,vv in pairs(temp_series_missions) do --系列任务的列表
					if vv[1] == v.mission_id then
						hit = true
						--计算正确的游标
						--任务状态 如果是已领取,则把游标定位到下一个系列任务
						--TODO 如果是已完成，未领取状态，是不是要优先加入任务列表？？？TODO
						-- vv[5] 任务游标 -- vv[2] 任务状态 0未完成  1完成  2已领取
						if vv[2] == "0" and vv[2] == "1" then--游标不变
							temp_mission_str = temp_mission_str.."_0_0_"..condition[vv[4]].."_"..vv[5] --_0_0_ 是状态_当前完成度
						elseif vv[2] == "2" then--游标定位到下一个
							local nextIndex = 0
							------从系列任务的配置里,取下一条-----
							local vcon = condition[vv[5]+1]
							if vcon == nil then --取不到任务了
								temp_mission_str = ""
							else --定位到系列任务的下一项
								temp_mission_str = temp_mission_str.."_0_0_"..vcon.."_"..(vv[5] + 1)
							end
						end
						break --找到一个就退出  最多也就一个
					end
				end
				--未命中 从未接过此系列任务,就生成一个新的任务状态
				if not hit then
					temp_mission_str = temp_mission_str.."_0_0_"..condition[1].."_1"
				end
			end
			--用|分割每个任务
			if mission_str == "" then
				mission_str = temp_mission_str
			elseif temp_mission_str ~= "" then
				mission_str = mission_str.."|"..temp_mission_str
			end
		end
		self.missionData.taskList = mission_str

		self:updateRandomMissionId()   -- 重新生成激活任务的ID
	end
	
	self.missionData.lastLoginDate = os.time()  	--取当前的时间
	self.missionData.totalLoginDay = loginDay
	self.missionData.taskGenDate   = taskGenDate 	--任务列表生成时间
end

--获取任务数据
function MissionManager:getMissionData()
	-- self.missionData -对应--> DataMission.lua
	self.missionData = s_LocalDatabaseManager.getMissionData()
	--刷新任务数据
	self:generalTasks()
	--保存数据
	self:saveTaskToLocal()
	dump(self.missionData,"任务数据 ")
	return self.missionData
end

--获取任务的missionData
function MissionManager:getNornalMissionData()
	return self.missionData
end

--保存数据到本地数据库
function MissionManager:saveTaskToLocal()
	--保存到本地数据库
	self.missionData.userId = s_CURRENT_USER.userId
	self.missionData.username = s_CURRENT_USER.username
	s_LocalDatabaseManager.saveDataClassObject(self.missionData, s_CURRENT_USER.userId, s_CURRENT_USER.username)
end

--任务数据 str转换成table 结构,字段说明参见DataMission.lua
--“|”分任务   “_”分字段
--1 任务ID
--2 任务状态
--3 任务当前达到的条件数量
--4 任务总条件数量
function MissionManager:strToTable(str)
	local re = {}
	local missions = string.split(str,"|")
	for k,v in pairs(missions) do
		re[#re + 1] = string.split(v,"_")
	end
	return re
end
--任务数据  由 table 转到 string
function MissionManager:tableToStr(tb)
	local re = ""
	local tempStr = ""
	for k,v in pairs(tb) do
		tempStr = ""
		for kk,vv in pairs(v) do
			if tempStr == "" then
				tempStr = vv
			else
				tempStr = tempStr.."_"..vv
			end
		end
		if re == "" then
			re = tempStr
		else
			re = re.."|"..tempStr
		end
	end
	return re
end
--推送记录到服务器 处理返回数据
function MissionManager:handleMissionServerData(data)
	dump(data,"服务器返回任务数据")
	local change = false
	for k,v in pairs(data) do
		if self.missionData[k] ~= v then
			self.missionData[k] = v
			change = true
		end
	end
	dump(self.missionData,"服务器返回任务数据2")
	if change then
		self:saveTaskToLocal()--如果有改动 存到本地
	end
end
---------------累计登陆相关------------
--获取当前的累计登陆状态
--根据累计的登陆天数计算、如果前边的任务不领取完成奖励，一样可以继续往后边累计
--需要记录一个当前展示的任务ID 从1-22
--返回值 
--1:	任务序号
--2:	当前连续的天数
--3:	当前任务总天数
function MissionManager:getLoginTask()
	return self:calcLoginMission()
end

--领取累计登陆的奖励
--taskId 	任务ID
--callBack 	完成回调 cb(result, error)
function MissionManager:getLoginReward(taskId,callBack)
	local totalloginDay = self.missionData.totalLoginDay    --累计登陆的天数
	local rewardIndex = self.missionData.loginRewardIndex   --领取奖励的index 默认0
	local loginConfig = MissionConfig.loginMission 			--登陆任务的配置
	print("taskid:"..taskId)
	print("totalloginDay:"..totalloginDay)

	local remainDay = totalloginDay
	local re = false --领取成功与否
	local reward = 0 --奖励的贝贝豆数量等于累计登陆的天数
	for k,v in pairs(loginConfig) do  -- v 就是完成当前任务所需的天数
		if taskId == k then
			if remainDay >= v then
				self.missionData.loginRewardIndex = k --保存当前领取的任务的id
				re = true
				reward = v --奖励的贝贝豆
				break
			end
		end
	end
	--保存数据 到本地 到服务器
	if re then
		self:saveTaskToLocal()
		s_O2OController.syncMission(callBack) --同步数据 到服务器
		s_CURRENT_USER:addBeans(reward) --获取贝贝豆
	    saveUserToServer({[DataUser.BEANSKEY] = s_CURRENT_USER[DataUser.BEANSKEY]}) --同步到
	end
	
	return re,reward
end
-- 	计算当前的累计登陆的任务
--	如果有未领取的奖励 	返回最早的没有领取奖励的任务
--	如果没有未领取的奖励 	则返回当前的任务
function MissionManager:calcLoginMission()
	local totalloginDay = self.missionData.totalLoginDay    --累计登陆的天数
	local rewardIndex = self.missionData.loginRewardIndex   --领取奖励的index 默认0
	local loginConfig = MissionConfig.loginMission 			--登陆任务的配置
	--
	local index 	= 0
	local nowDay 	= self.missionData.totalLoginDay
	local totalDay 	= 0

	local remainDay = totalloginDay
	for k,v in pairs(loginConfig) do
		if k == (rewardIndex + 1) then
			--计算任务的状态 完成天数、总天数、什么的
			index = k
			totalDay  = v
			if remainDay >= v then
				remainDay = v
			else
				remainDay = remainDay - v				
			end
			break --找到当前对应的任务 退出
		else
			remainDay = remainDay - v
		end
	end
	--返回 任务索引,当前已经连续的天数,任务所需连续登陆天数
	return {index , nowDay, totalDay}
end

--更新随机任务的ID
function MissionManager:updateRandomMissionId()
	local curTaskId = self.missionData.curTaskId --完成某个随机任务、然后更新
	local taskList  = self:strToTable(self.missionData.taskList)
	local undoTask = {} --未完成的任务
	local needRecalc = true --是否需要重新计算 当前任务ID
	
	for k,v in pairs(taskList) do
		if v[2] == "0" then
			undoTask[#undoTask + 1] = v
		end
		--如果当前激活的任务 如果是已完成 未领取的情况,不会刷新任务
		if curTaskId == v[1] and (v[2] == "1") then
			needRecalc = false
			break
		end
	end
	if not needRecalc then
		return 
	end
	if #undoTask == 0 then
		self.missionData.curTaskId = "" --任务都做完了
		return
	end
	--重新指定激活任务的ID
	local randomTaskId = undoTask[math.random(#undoTask)][1]
	self.missionData.curTaskId = randomTaskId
	print("重新生成激活任务结束："..self.missionData.curTaskId)
end
--获取当前激活的随机任务的数据
function MissionManager:getCurRandomTaskData()
	print("self.missionData.curTaskId:"..self.missionData.curTaskId)
	local curTaskId = self.missionData.curTaskId --完成某个随机任务、然后更新
	local taskList  = self:strToTable(self.missionData.taskList)
	for k,v in pairs(taskList) do
		if v[1] == curTaskId then
			return v --返回要查询的任务数据
		end
	end
	return {0} --随机任务 明日再来
end
return MissionManager