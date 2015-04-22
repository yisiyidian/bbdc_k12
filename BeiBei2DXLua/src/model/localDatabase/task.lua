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

function M.updateEveryDay()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local time      = os.time()
    local today     = os.date("%x", time)

    local lastUpdateDay = nil

    for row in Manager.database:nrows("SELECT * FROM DataTask WHERE "..condition.." ;") do
        lastUpdateDay = os.date("%x", row.lastUpdate)
    end

    if lastUpdateDay == nil or lastUpdateDay ~= today then
        local todayTotalBossNum = #s_LocalDatabaseManager.getTodayReviewBoss()

        local maxID = s_LocalDatabaseManager.getMaxUnitID()
        if maxID == 0 then -- empty
            s_LocalDatabaseManager.initUnitInfo(1)
            maxID = 1
        end
        local boss = s_LocalDatabaseManager.getAllUnitInfo()[1]

        local todayTotalTaskNum = nil
        if boss.unitState == 0 then
            todayTotalTaskNum = todayTotalBossNum + 3
        elseif boss.unitState >= 1 and boss.unitState <= 2 then
            todayTotalTaskNum = todayTotalBossNum + 6 - boss.unitState
        else
            todayTotalTaskNum = todayTotalBossNum
        end

        local todayRemainTaskNum = todayTotalTaskNum

        if lastUpdateDay == nil then
            local query = "INSERT INTO DataTask (userId, username, bookKey, lastUpdate, todayTotalTaskNum, todayRemainTaskNum, todayTotalBossNum) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', "..todayTotalTaskNum..", "..todayRemainTaskNum..", "..todayTotalBossNum..") ;"
            Manager.database:exec(query)
        else
            local query = "UPDATE DataTask SET lastUpdate = '"..time.."', todayTotalTaskNum = " .. todayTotalTaskNum .. ", todayRemainTaskNum = "..todayRemainTaskNum..", todayTotalBossNum = "..todayTotalBossNum.." WHERE "..condition.." ;"
            Manager.database:exec(query)
        end
    end
end

function M.getTodayTotalTaskNum()
    M.updateEveryDay()
    
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataTask WHERE "..condition.." ;") do
        return row.todayTotalTaskNum
    end
end

function M.getTodayRemainTaskNum()
    M.updateEveryDay()

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataTask WHERE "..condition.." ;") do
        return row.todayRemainTaskNum
    end
end

function M.getTodayTotalBossNum()
    M.updateEveryDay()
    
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataTask WHERE "..condition.." ;") do
        return row.todayTotalBossNum
    end
end

function M.setTodayRemainTaskNum(todayRemainTaskNum)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local query = "UPDATE DataTask SET todayRemainTaskNum = "..todayRemainTaskNum.." WHERE "..condition.." ;"
    print(query)
    Manager.database:exec(query)
end

return M