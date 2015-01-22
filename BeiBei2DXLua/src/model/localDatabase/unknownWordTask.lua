local DataUnknownWordTask = require('model.user.DataUnknownWordTask')
local Manager = s_LocalDatabaseManager

local M = {}

function M.getRecords(taskindex)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local ret = {}

    if userId ~= '' then
        local sql = string.format("SELECT * FROM DataUnknownWordTask WHERE userId = '%s' and bookKey = '%s' and index = %d;", userId, bookKey, taskindex)
        for row in Manager.database:nrows(sql) do
            table.insert(ret, row)
        end
    end
    if #ret == 0 and username ~= '' then
        local sql = string.format("SELECT * FROM DataUnknownWordTask WHERE username = '%s' and bookKey = '%s' and index = %d;", username, bookKey, taskindex)
        for row in Manager.database:nrows(sql) do
            table.insert(ret, row)
        end
    end

    return ret
end

function M.getUnknownWordTask(taskindex)
    local records = M.getRecords(taskindex)
    for key, value in pairs(records) do 
        local data = DataUnknownWordTask.create()
        parseLocalDatabaseToUserData(value, data)
        return data
    end    
    return nil
end

function M.saveRecord(taskindex, firstWordId, lastWordId)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local data = M.getUnknownWordTask(taskindex)
    local hasRecord = 1
    if data == nil then
        data = DataUnknownWordTask.create()
        hasRecord = 0
    end
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.index = taskindex
    if data.first == -1 then 
        data.first = firstWordId 
    end
    data.last = lastWordId
    data.lastUpdate = os.time()

    Manager.saveData(data, userId, username, hasRecord, " and bookKey = '" .. bookKey .. "' and taskindex = " .. taskindex .. ";")
end

return M
