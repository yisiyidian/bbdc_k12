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

function M.getTodayReviewBoss()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local time      = os.time()
    local today     = os.date("%x", time)

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local bossList  = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID ;") do
        if row.typeIndex >= 4 and row.typeIndex <= 7 then
            local boss  = {}
            boss.bossID = row.bossID
            boss.typeIndex  = row.typeIndex
            boss.lastUpdate = row.lastUpdate
            table.insert(bossList, boss)
        end
    end

    local getGapDay = function(day1, day2)
        local t1 = split(day1, "/")
        local t2 = split(day2, "/")
        local d1 = {}
        local d2 = {}
        d1.year  = "20"..t1[3]
        d1.month = t1[1]
        d1.day   = t1[2]
        d2.year  = "20"..t2[3]
        d2.month = t2[1]
        d2.day   = t2[2]
        local numDay1 = os.time(d1)
        local numDay2 = os.time(d2)
        local gap = (numDay2-numDay1)/(3600*24)
        return gap
    end


    local todayReviewBoss = {}
    for i = 1, #bossList do
        local boss = bossList[i]
        
        local gap
        if     boss.typeIndex == 4 then
            gap = 1
        elseif boss.typeIndex == 5 then
            gap = 2
        elseif boss.typeIndex == 6 then
            gap = 3
        elseif boss.typeIndex == 7 then
            gap = 8
        end

        local lastUpdateDay = os.date("%x", boss.lastUpdate)
        local gapDayNum = getGapDay(lastUpdateDay, today)
        if gapDayNum >= gap then
            table.insert(todayReviewBoss, bossID)
        end
    end

    return todayReviewBoss
end

function M.getMaxBossID()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local maxBossID = 1
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        maxBossID   = row.bossID
    end

    return maxBossID
end

function M.getBossInfo(bossID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()
    
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local boss      = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." and bossID = "..bossID.." ;") do
        boss.bossID         = row.bossID
        boss.typeIndex      = row.typeIndex
        boss.wrongWordList  = row.wordList
        boss.lastWordIndex  = row.lastWordIndex
    end

    if boss.bossID == nil then
        boss.bossID         = bossID
        boss.typeIndex      = 0
        boss.wrongWordList  = {}
        boss.rightWordList  = {}
    else
        local startIndex
        if boss.bossID == 1 then
            startIndex = 1
        else
            for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." and bossID = "..(bossID-1).." ;") do
                startIndex  = row.lastWordIndex + 1
            end
        end

        local hash = {}
        if  boss.wrongWordList == '' then
            boss.wrongWordList = {}
        else
            boss.wrongWordList = split(boss.wrongWordList, "|")
            for i = 1, #boss.wrongWordList do
                local wordname = boss.wrongWordList[i]
                hash[wordname] = 1
            end
        end

        boss.rightWordList = {}
        for i = startIndex, boss.lastWordIndex do
            local wordname = s_BookWord[s_CURRENT_USER.bookKey][i]
            if hash[wordname] ~= 1 then
                table.insert(boss.rightWordList, wordname)
            end
        end
    end

    return boss
end

function M.getAllBossInfo()
    local bossList = {}

    local maxBossID = M.getMaxBossID()
    for i = 1, maxBossID do
        local boss = M.getBossInfo(i)
        table.insert(bossList, boss)
    end

    return bossList
end


function M.addRightWord(wordindex)
    local wordname = s_BookWord[s_CURRENT_USER.bookKey][wordindex]

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local bossID    = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        bossID      = row.bossID
    end

    if bossID == nil then
        local query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', 1, 0, '', "..wordindex..") ;"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
    end
end


function M.addWrongWord(wordindex)
    local wordname = s_BookWord[s_CURRENT_USER.bookKey][wordindex]

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

    if bossID == nil then
        local query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', 1, 0, '"..wordname.."', "..wordindex..") ;"
        Manager.database:exec(query)
        return false
    elseif wordList == '' then
        local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , wordList = '"..wordname.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
        return false
    else
        local newWordList = wordList.."|"..wordname
        local wordCount = #split(wordList, "|")

        if wordCount == s_max_wrong_num_everyday - 1 then
            local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , typeIndex = 1 , wordList = '"..newWordList.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)

            query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', "..(bossID+1)..", 0, '', "..wordindex..") ;"
            Manager.database:exec(query)
            return true
        else
            local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , wordList = '"..newWordList.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)
            return false
        end
    end
end


function M.printBossWord()
    if BUILD_TARGET ~= BUILD_TARGET_DEBUG then return end

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local query = "SELECT * FROM DataBossWord WHERE "..condition.." ;"
    print(query)
    print("<bossWord>")
    for row in Manager.database:nrows(query) do
        print("<item>")
        print("bossID: "..row.bossID)
        print("typeIndex: "..row.typeIndex)
        print("wordList: "..row.wordList)
        print("lastWordIndex: "..row.lastWordIndex)
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