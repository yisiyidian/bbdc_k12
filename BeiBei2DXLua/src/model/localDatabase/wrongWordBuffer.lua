local DataWrongWordBuffer = require('model.user.DataWrongWordBuffer')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, wordNum, wordBuffer)
    local data = DataWrongWordBuffer.create()

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate

    data.wordNum = wordNum
    data.wordBuffer = wordBuffer

    return data
end

function M.printWrongWordBuffer()
    if RELEASE_APP ~= DEBUG_FOR_TEST then return end

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<wrongWordBuffer>")
    for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("<item>")
        print("wordNum: "..row.wordNum)
        print("wordBuffer: "..row.wordBuffer)
        print("lastUpdate: "..row.lastUpdate)
        print("</item>")
    end
    print("</wrongWordBuffer>")
end

function M.getWrongWordBufferNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local wrongWordBufferNum = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            wrongWordBufferNum = wrongWordBufferNum + row.wordNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            wrongWordBufferNum = wrongWordBufferNum + row.wordNum
        end
    end
    
    return wrongWordBufferNum
end

function M.addWrongWordBuffer(wrongWord)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    
    local num = 0
    local oldWordBuffer = ""
    local oldWordNum = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            oldWordBuffer = row.wordBuffer
            oldWordNum = row.wordNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            oldWordBuffer = row.wordBuffer
            oldWordNum = row.wordNum
        end
    end
    
    if num == 0 then
        local wordNum = 1
        local data = createData(bookKey, time, wordNum, oldWordBuffer)
        Manager.saveData(data, userId, username, num)
    else
        local wordNum = nil
        local wordBuffer = nil
        if oldWordNum + 1 >= MAXWRONGWORDCOUNT then
            local bossWordListString = oldWordBuffer.."|"..wrongWord
            Manager.addBossWord(bossWordListString)
            
            wordNum = 0
            wordBuffer = ""
        else
            wordNum = oldWordNum + 1
            wordBuffer = oldWordBuffer.."|"..wrongWord
        end
        
        local data = createData(bookKey, time, wordNum, wordBuffer)
        Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."';")
    end
end

return M
