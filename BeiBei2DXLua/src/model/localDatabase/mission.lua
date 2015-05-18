-- 新任务系统 对应的数据库操作类
-- Author: whe
-- Date: 2015-05-15 14:36:07
-- 


local DataMission = require("model.user.DataTask") --任务数据模型类

local M = {}

--创建一个数据模型
local function createData()
	local data = DataMission.create()

    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate
    
    data.todayTotalTaskNum   = todayTotalTaskNum
    data.todayRemainTaskNum  = todayRemainTaskNum
    data.todayTotalBossNum   = todayTotalBossNum

    return data
end

--
local function saveDataToServer()
	
end


-- 更新任务状态
-- userId 用户 username 
-- content 	任务记录内容
-- genDate 	生成任务的时间 可为nil,为nil就不更新进去
function M.updateMissionContent(content,genDate)
	
end

--更新累计登陆天数
function M.updateTotalLoginDay(userId,day)
	
end

-- --从服务器上获取任务的数据
-- function M.getMissionDataFromServer()
	
-- end



return M