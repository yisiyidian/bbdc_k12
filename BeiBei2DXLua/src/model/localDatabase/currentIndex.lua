local DataCurrentIndex = require('model.user.DataCurrentIndex')
local Manager = s_LocalDatabaseManager

-- 代表当前书的进度

local M = {}

-- record word info
function M.printCurrentIndex()
    if RELEASE_APP ~= DEBUG_FOR_TEST then return end

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<currentIndex>")
    for row in Manager.database:nrows("SELECT * FROM DataCurrentIndex WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("current book word index: "..row.currentIndex.." time: "..row.lastUpdate)
    end
    print("</currentIndex>")
end

local function createDataCurrentIndex(lastUpdate, bookKey, currentIndex)
    local data = DataCurrentIndex.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.lastUpdate = lastUpdate
    data.bookKey = bookKey
    data.currentIndex = currentIndex

    return data
end

function M.getCurrentIndex()
    local currentIndex = nil

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataCurrentIndex WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            currentIndex = row.currentIndex
        end
    end
    
    if currentIndex == nil and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataCurrentIndex WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            currentIndex = row.currentIndex
        end
    end
    
    if currentIndex == nil then
        currentIndex = 1
        local data = createDataCurrentIndex(os.time(), bookKey, currentIndex)
        Manager.saveData(data, userId, username, 0)
    end
    
    return currentIndex
end

function M.setCurrentIndex(currentIndex)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    local data = createDataCurrentIndex(os.time(), bookKey, currentIndex)

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM " .. data.className .. " WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM " .. data.className .. " WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
        end
    end

    Manager.saveData(data, userId, username, num, " and bookKey = '" .. bookKey .. "';")
end

return M
