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

-- local function saveDataTodayReviewBossNum(userId, bookKey, today, reviewBossNum) -- TODO
--     local data = {}
--     data.userId = userId
--     data.bookKey = bookKey
--     data.today = today
--     data.reviewBossNum = reviewBossNum
--     data.className = 'DataTodayReviewBossNum'
--     if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
--         s_SERVER.createData(data)
--     end
-- end
function M.getTodayTotalBossNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    local bossNum = 0
    local lastUpdate = nil
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataTodayReviewBossNum WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
            bossNum = row.bossNum 
            lastUpdate = row.lastUpdate
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataTodayReviewBossNum WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
            bossNum = row.bossNum 
            lastUpdate = row.lastUpdate
        end
    end
    
    if num == 0 then
        local reviewBossNum = Manager.getTodayRemainBossNum()
        local data = createData(bookKey, reviewBossNum, lastUpdate)
        Manager.saveData(data, userId, username, num)
        -- saveDataTodayReviewBossNum(userId, bookKey, today, reviewBossNum)
        return reviewBossNum
    else
        local lastUpdateDay = os.date("%x", lastUpdate)
        if lastUpdateDay == today then
            return bossNum
        else
            local reviewBossNum = Manager.getTodayRemainBossNum()
            local data = createData(bookKey, reviewBossNum, lastUpdate)
            Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' ;")
            -- saveDataTodayReviewBossNum(userId, bookKey, today, reviewBossNum)
            return reviewBossNum
        end
    end
end

return M