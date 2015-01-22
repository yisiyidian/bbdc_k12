local DataBossWord = require('model.user.DataBossWord')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, bossID, typeIndex, wordList)
    local data = DataBossWord.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate

    data.bossID = bossID
    data.typeIndex = typeIndex
    data.wordList = wordList

    return data
end

function M.printBossWord()
    if RELEASE_APP ~= DEBUG_FOR_TEST then return end

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<bossWord>")
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("<item>")
        print("bossID: "..row.bossID)
        print("typeIndex: "..row.typeIndex)
        print("wordList: "..row.wordList)
        print("lastUpdate: "..row.lastUpdate)
        print("</item>")
    end
    print("</bossWord>")
end

function M.addBossWord(bossWordList)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    
    local maxBossID = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            if row.bossID > maxBossID then
                maxBossID = row.bossID
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            if row.bossID > maxBossID then
                maxBossID = row.bossID
            end
        end
    end
    
    local bossID = maxBossID + 1
    local typeIndex = 0
    local data = createData(bookKey, time, maxBossID, typeIndex, bossWordList)
    Manager.saveData(data, userId, username, 0)
end

function M.getMaxBossID()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local maxBossID = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            if row.bossID > maxBossID then
                maxBossID = row.bossID
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."';") do
            num = num + 1
            if row.bossID > maxBossID then
                maxBossID = row.bossID
            end
        end
    end

    return maxBossID
end

function M.getBossWordNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    
    local bossWordNum = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            if row.typeIndex + 1 <= MAXTYPEINDEX then
                num = num + 1
                bossWordNum = bossWordNum + MAXWRONGWORDCOUNT
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            if row.typeIndex + 1 <= MAXTYPEINDEX then
                num = num + 1
                bossWordNum = bossWordNum + MAXWRONGWORDCOUNT
            end
        end
    end

    return bossWordNum
end

function M.getBossWordBeforeToday()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)
    
    local candidate = nil
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ORDER BY lastUpdate ;") do
            num = num + 1
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay ~= today and row.typeIndex + 1 <= MAXTYPEINDEX then
                candidate           = {}
                candidate.bossID    = row.bossID
                candidate.typeIndex = row.typeIndex
                candidate.wordList  = row.wordList
                break
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ORDER BY lastUpdate  ;") do
            num = num + 1
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay ~= today and row.typeIndex + 1 <= MAXTYPEINDEX then
                candidate           = {}
                candidate.bossID    = row.bossID
                candidate.typeIndex = row.typeIndex
                candidate.wordList  = row.wordList
                break
            end
        end
    end
    
    return candidate
end

function M.getTodayRemainBossNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay ~= today and row.typeIndex + 1 <= MAXTYPEINDEX then
                num = num + 1
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay ~= today and row.typeIndex + 1 <= MAXTYPEINDEX then
                num = num + 1
            end
        end
    end

    return num
end

function M.updateBossWord(bossID)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    
    local wordList = ''
    local typeIndex = nil
    local isId = false
    local isUsername = false
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;") do
            num = num + 1
            isId = true
            typeIndex = row.typeIndex
            wordList = row.wordList
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;") do
            num = num + 1
            isUsername = true
            typeIndex = row.typeIndex
            wordList = row.wordList
        end
    end

    if typeIndex + 1 >= MAXTYPEINDEX then
        Manager.addGraspWordsNum(MAXWRONGWORDCOUNT)
--        if isId and userId ~= '' then
--            local query = "DELETE FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;"
--            Manager.database:exec(query)
--        end
--        if isUsername and username ~= '' then
--            local query = "DELETE FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;"
--            Manager.database:exec(query)
--        end
    else
        local data = createData(bookKey, time, bossID, typeIndex + 1, wordList)
        Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;"    )
    end
end

return M