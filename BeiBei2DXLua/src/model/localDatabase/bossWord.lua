local DataBossWord = require('model.user.DataBossWord')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex)
    local data = DataBossWord.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate

    data.bossID = bossID
    data.typeIndex = typeIndex
    data.wordList = wordList
    data.lastWordIndex = lastWordIndex

    return data
end

function M.getBossInfo(bossID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."' and bossID = "..bossID

    local boss      = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ;") do
        boss.bossID         = row.bossID
        boss.typeIndex      = row.typeIndex
        boss.wrongWordList  = row.wordList
        boss.lastWordIndex  = row.lastWordIndex
    end


    if boss.bossID == nil then
        boss.bossID         = bossID
        boss.typeIndex      = 0
        boss.wrongWordList  = ''
        boss.rightWordList  = ''
    elseif boss.bossID == 1 then
        
    else

    end

    return boss
end

function M.addWrongWord(wordname, wordindex)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local bossID    = nil
    local typeIndex = nil
    local wordList  = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        bossID      = row.bossID
        typeIndex   = row.typeIndex
        wordList    = row.wordList
    end

    if wordList == nil then
        local query = "INSERT INTO DataBossWord (userId, username, bookKey, bossID, typeIndex, wordList, lastWordIndex) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', 1, 0, '"..wordname.."', "..wordindex..") ;"
        Manager.database:exec(query)
        return false
    elseif wordList == '' then
        local query = "UPDATE DataBossWord SET wordList = '"..wordname.."' and lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
        return false
    else
        local wordCount = split(wordList, "|")
        local newWordList = wordList.."|"..wordname

        if wordCount == 9 then
            local query = "UPDATE DataBossWord SET typeIndex = 1 and wordList = '"..newWordList.."' and lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)

            query = "INSERT INTO DataBossWord (userId, username, bookKey, bossID, typeIndex, wordList, lastWordIndex) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', "..(bossID+1)..", 0, '', "..wordindex..") ;"
            Manager.database:exec(query)
            return true
        else
            local query = "UPDATE DataBossWord SET wordList = '"..newWordList.."' and lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)
            return false
        end
    end
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
    local lastWordIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex()

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
    local data = createData(bookKey, time, maxBossID, typeIndex, bossWordList, lastWordIndex)
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
            if row.typeIndex < MAXTYPEINDEX then
                num = num + 1
                bossWordNum = bossWordNum + MAXWRONGWORDCOUNT
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            if row.typeIndex < MAXTYPEINDEX then
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
            if lastUpdateDay ~= today and row.typeIndex < MAXTYPEINDEX then
                candidate           = {}
                candidate.bossID    = row.bossID
                candidate.typeIndex = row.typeIndex
                candidate.wordList  = row.wordList
                candidate.lastWordIndex = row.lastWordIndex
                break
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ORDER BY lastUpdate  ;") do
            num = num + 1
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay ~= today and row.typeIndex < MAXTYPEINDEX then
                candidate           = {}
                candidate.bossID    = row.bossID
                candidate.typeIndex = row.typeIndex
                candidate.wordList  = row.wordList
                candidate.lastWordIndex = row.lastWordIndex
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
            if lastUpdateDay ~= today and row.typeIndex < MAXTYPEINDEX then
                num = num + 1
            end
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            local lastUpdate = tostring(row.lastUpdate)
            local lastUpdateDay = os.date("%x", lastUpdate)
            if lastUpdateDay ~= today and row.typeIndex < MAXTYPEINDEX then
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
    local typeIndex = 0
    local lastWordIndex = 0
    local isId = false
    local isUsername = false
    local num = 0
    
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;") do
            if row.typeIndex < MAXTYPEINDEX then
                num = num + 1
                isId = true
                typeIndex = row.typeIndex
                wordList = row.wordList
                lastWordIndex = row.lastWordIndex
            end
        end
    end
    
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;") do
            if row.typeIndex < MAXTYPEINDEX then
                num = num + 1
                isUsername = true
                typeIndex = row.typeIndex
                wordList = row.wordList
                lastWordIndex = row.lastWordIndex
            end
        end
    end

    if typeIndex + 1 >= MAXTYPEINDEX then Manager.addGraspWordsNum(MAXWRONGWORDCOUNT) end

    if typeIndex < MAXTYPEINDEX then
        local data = createData(bookKey, time, bossID, typeIndex + 1, wordList, lastWordIndex)
        Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' and bossID = "..bossID.." ;"    )
    end
end

return M