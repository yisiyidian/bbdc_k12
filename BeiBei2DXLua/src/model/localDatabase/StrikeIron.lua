local DataStrikeIron = require('model.user.DataStrikeIron')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, wordList)
    local data = DataStrikeIron.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.wordList = wordList

    return data
end

function M.addWordList()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local list = nil
    for row in Manager.database:nrows("SELECT * FROM DataStrikeIron WHERE "..condition.." ;") do
        list        = row.wordList
    end

    if list == nil then
        local query = "INSERT INTO DataStrikeIron (userId, username, bookKey, wordList) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."','') ;"
        Manager.database:exec(query)
    end
end

function M.updateWordList(wordList)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataStrikeIron WHERE "..condition.." ;") do
        local newWordList = wordList

        local query = "UPDATE DataStrikeIron SET wordList = "..newWordList.." WHERE "..condition.." ;"
        Manager.database:exec(query)
    end    

    M.printBossWord()
end