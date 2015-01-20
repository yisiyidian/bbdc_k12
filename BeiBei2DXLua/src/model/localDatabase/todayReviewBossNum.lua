local DataTodayReviewBossNum = require('model.user.DataTodayReviewBossNum')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, bossNum, lastUpdate)
    local data = DataTodayReviewBossNum.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate
    data.bossNum = bossNum

    return data
end

function M.getDataTodayTotalBoss()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataTodayReviewBossNum WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
            local data = createData(bookKey, row.bossNum, row.lastUpdate)
            return data
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataTodayReviewBossNum WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
            local data = createData(bookKey, row.bossNum, row.lastUpdate)
            return data
        end
    end

    return nil 
end

function M.getTodayTotalBossNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    local bossNum = 0
    local lastUpdate = nil
    local data = M.getDataTodayTotalBoss()
    if data ~= nil then
        num = 1
        bossNum = data.bossNum
        lastUpdate = data.lastUpdate
    end
    
    if num == 0 then
        local reviewBossNum = Manager.getTodayRemainBossNum()
        local data = createData(bookKey, reviewBossNum, lastUpdate)
        Manager.saveData(data, userId, username, num)
        return reviewBossNum
    else
        local lastUpdateDay = os.date("%x", lastUpdate)
        if lastUpdateDay == today then
            return bossNum
        else
            local reviewBossNum = Manager.getTodayRemainBossNum()
            local data = createData(bookKey, reviewBossNum, lastUpdate)
            Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' ;")
            return reviewBossNum
        end
    end
end

-- lastUpdate : nil means now
function M.saveDataTodayReviewBossNum(bossNum, lastUpdate)
    lastUpdate = lastUpdate or os.time()

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataTodayReviewBossNum WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataTodayReviewBossNum WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
        end
    end

    local data = createData(bookKey, bossNum, lastUpdate)
    Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' ;")
end

return M