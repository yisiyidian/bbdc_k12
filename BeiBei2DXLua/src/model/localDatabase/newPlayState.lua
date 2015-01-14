local DataNewPlayState = require('model.user.DataNewPlayState')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, playModel, rightWordList, wrongWordList, wordCandidate)
    local data = DataNewPlayState.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate
    data.playModel = playModel
    data.rightWordList = rightWordList
    data.wrongWordList = wrongWordList
    data.wordCandidate = wordCandidate

    return data
end

function M.printNewPlayState()
    if RELEASE_APP ~= DEBUG_FOR_TEST then return end

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<newPlayState>")
    for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("<item>")
        print("current playModel: "..row.playModel)
        print("current rightWordList: "..row.rightWordList)
        print("current wrongWordList: "..row.wrongWordList)
        print("current wordCandidate: "..row.wordCandidate)
        print("current lastUpdate: "..row.lastUpdate)
        print("</item>")
    end
    print("</newPlayState>")
end

function M.getTodayPlayModel()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)

    local playModel = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay == today then
                playModel = row.playModel
            end
        end
    end
    
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay == today then
                playModel = row.playModel
            end
        end
    end

    return playModel
end

function M.getwrongWordListSize()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local size = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            local wrongWordList =  row.wrongWordList
            if wrongWordList ~= "" then
                local tmp = split(wrongWordList, "|")
                size = #tmp
            end
        end
    end

    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            local wrongWordList =  row.wrongWordList
            if wrongWordList ~= "" then
                local tmp = split(wrongWordList, "|")
                size = #tmp
            end
        end
    end

    return size
end

function M.getNewPlayState()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local newPlayState = createData(bookKey, 0, 0, '', '', '')

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            newPlayState.playModel     = row.playModel
            newPlayState.rightWordList = row.rightWordList
            newPlayState.wrongWordList = row.wrongWordList
            newPlayState.wordCandidate = row.wordCandidate
            newPlayState.lastUpdate    = row.lastUpdate
        end
    end

    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            newPlayState.playModel     = row.playModel
            newPlayState.rightWordList = row.rightWordList
            newPlayState.wrongWordList = row.wrongWordList
            newPlayState.wordCandidate = row.wordCandidate
            newPlayState.lastUpdate    = row.lastUpdate
        end
    end
    
    return newPlayState
end

function M.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
        end
    end

    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
        end
    end

    local data = createData(bookKey, time, playModel, rightWordList, wrongWordList, wordCandidate)
    Manager.saveData(data, userId, username, num)
end

return M