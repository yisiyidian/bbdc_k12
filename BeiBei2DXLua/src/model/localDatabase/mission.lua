-- 新任务系统 对应的数据库操作类
-- Author: whe
-- Date: 2015-05-15 14:36:07
-- 
local DataMission = require("model.user.DataTask") --任务数据模型类
local Manager = s_LocalDatabaseManager
local M = {}

--创建一个数据模型
local function createData()
	local data = DataMission.create()
    updateDataFromUser(data,s_CURRENT_USER)
    return data
end

function M.getMissionData(userId)
    local userId    = userId or s_CURRENT_USER.userId
    local condition = "userId = '"..userId.."'"
    local sqlStr = "SELECT * FROM DataMission WHERE "..condition..";"
    for row in Manager.database:nrows(sqlStr) do
        return row
    end
end

return M