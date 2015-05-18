-- 玩家任务管理器 新的任务系统
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

function MissionManager:ctor()
	self.taskNum = 6 		--随机任务数量
	self.missionData = nil  --任务数据	
	self:init()
end

--初始化任务数据
function MissionManager:init()
	-- self.missionData -对应--> DataMission.lua
	self.missionData = s_LocalDatabaseManager.getMissionData()
	--数据为空
	if self.missionData == nil then
		-- self.missionData.taskList = self:generalTasks()
		self:generalTasks()
		--保存数据到数据库
		-- s_LocalDatabaseManager.save()
		return
	end

	
end

--生成今日的任务数据
function MissionManager:generalTasks()
	local loginDay = 0 			--累计登陆天数
	local lastLoginDate = nil 	--上一次的登陆时间
	
	if self.missionData == nil then
		self.missionData = DataMission.create()
	end
	
	lastLoginDate   = self.missionData.lastLoginDate 	--取上一次的登陆时间
	loginDay 		= self.missionData.totalLoginDay	--累计登陆天数
	local tDate = os.date("%x", lastLoginDate)			--最后登陆日期
	local tNow  = os.date("%x", os.time())				--当前日期

	--如果是今天第一次登陆 则重新生成任务列表
	if tNow ~= tDate then		
		loginDay = loginDay + 1	--天数+1
		--重新生成任务列表
		local result = {} 	-- 生成结果
		local tasksConfig =  MissionConfig.randomMission
		
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
					t[v] = nil
					return v
				end
			end
			return nil
		end
		--先精简任务列表 把已经领取奖励的系列任务去掉  【领取奖励】= 已结束
		local temp_series_missions = {} --系列任务进度的table,table中的每一项是table结构{{"1-1","1","0"},{"2-2","1","1"}}
		if self.missionData.taskSeriesList ~= "" then
			local temp_mission = string.split(self.missionData.taskSeriesList,"|")
			for _,v in pairs(temp_mission) do
				temp_series_missions[#temp_series_missions + 1] = string.split(v,"_")
			end
			--处理特殊任务中 删除掉 已经完成的系列任务
			--任务状态:0未完成  1完成  2 已领取
			local mission_id = nil
			for k,v in pairs(temp_series_missions) do
				mission_id = v[1]
				for kk,vv in pairs(ts_task) do
					if mission_id == vv.mission_id and v[2] == vv.condition[#vv.condition] and v[3] == "2"  then
						--如果 【1】任务ID匹配,【2】并且是任务最后一条(非系列任务只有1项),【4】并且状态是已领取奖励 则从任务列表里 移除这个任务
						ts_task[kk] = nil
						break
					end
				end
			end
		end
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
			else --解锁任务
				hasLockMission = true
				local js_index = math.random(tnum(js_task))
				if js_index > 0 then
					result[#result + 1] = tget(js_task,js_index)
				end
			end
		end
		--result 生成的任务列表
		local mission_str 			= "" --- 1-1_0_1_1|2-2_0_1_1|3-1_1_2_1 任务ID_任务状态_任务条件_任务游标
		local temp_mission_str  	= ""
		local condition 			= "" 
		for k,v in pairs(result) do
			temp_mission_str = temp_mission_str..v.mission_id
			condition = v.condition
			if #condition == 1 then
				temp_mission_str = temp_mission_str.."_0_"..condition[1].."_1"
			else
				for kk,vv in pairs(temp_series_missions) do --系列任务的列表
					if vv[1] == v.mission_id then 
						--TODO 计算正确的游标
						--任务状态 如果是已领取,则把游标定位到下一个系列任务
						--TODO 如果是已完成，未领取状态，是不是要优先加入任务列表？？？TODO
						-- vv[2] 任务游标
						-- vv[3] 任务状态 0未完成  1完成  2已领取
						if vv[3] == "0" and vv[3] == "1" then--游标不变
							temp_mission_str = temp_mission_str.."_0_"..condition[vv[2]].."_"..vv[2]
						elseif vv[3] == "2" then--游标定位到下一个
							local nextIndex = 0
							------从系列任务的配置里,取下一条-----
							local vcon = condition[vv[2]+1]
							if vcon == nil then --取不到任务了
								temp_mission_str = ""
							else --定位到系列任务的下一项
								temp_mission_str = temp_mission_str.."_0_"..vcon.."_"..(vv[2] + 1)
							end
						end
						break
					end
				end
			end
			--用|分割每个任务
			if temp_mission_str == "" then
				mission_str = temp_mission_str
			else
				mission_str = mission_str.."|"..temp_mission_str
			end
		end


		---任务字符串生成完毕 mission_str
	end
		
	

	-- if self.missionData ~= nil then
	-- 	--上次登陆日期 跟现在的日期比较,如果不一样的话,就增加一天 一样的话就不动了
	-- 	local lastLoginDate = self.missionData.lastLoginDate
	-- 	local lastLoginDay = os.date("%x", lastLoginDate) 	--05/15/15   月/日/年		
	-- 	local nowDate = os.date("%x",os.time())				--05/15/15   月/日/年  	当前的时间
	-- 	--今天第一次登陆了  以前也登陆过
	-- 	if lastLoginDate ~= nowDate then
	-- 		self.missionData.totalLoginDay = self.missionData.totalLoginDay + 1
	-- 	end
	-- 	loginDay = self.missionData.totalLoginDay
	-- else

	-- end


	self.missionData.lastLoginDate = os.time()
	self.missionData.totalLoginDay = loginDay
end

--获取当前的任务列表
function MissionManager:getTaskList()
	
end

--保存数据到本地数据库
function MissionManager:saveTaskToLocal()
	
end

--从服务器拉取任务信息
function MissionManager:pullTaskFromServer()
	
end

--保存当前的任务到服务器
function MissionManager:pushTaskToServer()
	
end

--更新任务状态
--taskId 	任务ID
--taskData 	任务数据
function MissionManager:updateTask(taskId,taskData)
	
end

--完成任务
-- taskId 	任务ID
-- callBack	回调
function MissionManager:completeTask(taskId,callBack)
	
end

---------------累计登陆相关------------
--获取当前的累计登陆状态
--根据累计的登陆天数计算、如果前边的任务不领取完成奖励，一样可以继续往后边累计
--需要记录一个当前展示的任务ID 从1-22
--返回值 
--taskId	任务序号
--totaldays	任务总天数
--nowdays	当前总天数
function MissionManager:getTotalLoginTask()
	return 1,2,1
end
--获取随机任务状态
function MissionManager:getNormalTaskData(taskId)
	
end

return MissionManager