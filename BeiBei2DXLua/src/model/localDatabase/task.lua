local DataTask = require('model.user.DataTask')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(todayTotalTaskNum, todayRemainTaskNum, todayTotalBossNum)
    local data = DataTask.create()

    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate
    
    data.todayTotalTaskNum   = todayTotalTaskNum
    data.todayRemainTaskNum  = todayRemainTaskNum
    data.todayTotalBossNum   = todayTotalBossNum

    return data
end


function M.getTodayTotalTaskNum()

    for row in Manager.database:nrows("SELECT * FROM DataTask ;") do
    
    end
    
    return 0
end

function M.getTodayRemainTaskNum()

    for row in Manager.database:nrows("SELECT * FROM DataTask ;") do

    end

    return 0
end

function M.setTodayRemainTaskNum(todayRemainTaskNum)

    for row in Manager.database:nrows("SELECT * FROM DataTask ;") do

    end
end

function M.getTodayTotalBossNum()

    for row in Manager.database:nrows("SELECT * FROM DataTask ;") do

    end

    return 0
end










return M