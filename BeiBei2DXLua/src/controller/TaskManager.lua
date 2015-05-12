-- 玩家任务管理器
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

local TaskManager = class("TaskManager")

function TaskManager:ctor()
	self:init()
end

--初始化任务数据
function TaskManager:init()
	
end

--加载配置数据
function TaskManager:loadTaskData()
	
end

--生成今日的任务数据
function TaskManager:generalTasks()
	
end

--获取当前的任务列表
function TaskManager:getTaskList()
	-- body
end

--保存数据到本地数据库
function TaskManager:saveTaskToLocal()
	
end

--从服务器拉取任务信息
function TaskManager:pullTaskFromServer()
	
end

--保存当前的任务到服务器
function TaskManager:pushTaskToServer()
	
end

--更新任务状态
--taskId 	任务ID
--taskData 	任务数据
function TaskManager:updateTask(taskId,taskData)
	
end

--完成任务
-- taskId 	任务ID
-- callBack	回调
function TaskManager:completeTask(taskId,callBack)
	
end

---------------累计登陆相关------------
--获取当前的累计登陆状态
--根据累计的登陆天数计算、如果前边的任务不领取完成奖励，一样可以继续往后边累计
--需要记录一个当前展示的任务ID 从1-22
--返回值 
--taskId	任务序号
--totaldays	任务总天数
--nowdays	当前总天数
function TaskManager:getTotalLoginTask()
	return 1,2,1
end

--获取随机任务状态
function TaskManager:getNormalTaskData(taskId)
	
end



return TaskManager