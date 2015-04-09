local DataUnit = require('model.user.DataUnit')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, unitID, unitState, wordList, currentWordIndex, savedToServer)
    local data = DataBossWord.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate

    data.unitID = unitID
    data.unitState = unitState
    data.wordList = wordList
    data.currentWordIndex = currentWordIndex
    data.savedToServer = savedToServer

    return data
end

local function saveDataToServer(skip_wordList, lastUpdate, unitID, unitState, wordList, currentWordIndex, savedToServer)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"
    local data = createData(bookKey, lastUpdate, unitID, unitState, wordList, currentWordIndex, savedToServer)
    saveWordBossToServer(data, skip_wordList, function (serverDatas, error)
        if serverDatas == nil then return end
        
        for i, v in ipairs(serverDatas) do

            local query = "UPDATE DataBossWord SET objectId = '"..v.objectId.."', savedToServer = " .. v.savedToServer .. " WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)

            break
        end
    end)
end

-- function M.getPrevWordState()
--     local preIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex() - 1
--     local currentUnit = M.getMaxUnitID()
--     local preWord  = s_BookWord[s_CURRENT_USER.bookKey][currentUnit][preIndex]

--     if preWord == nil then
--         return true
--     else
--         local maxUnitID = M.getMaxUnitID()
--         local unit = M.getUnitInfo(maxUnitID)
--         if #unit.wrongWordList == 0 then
--             if maxUnitID == 1 then
--                 return true
--             else
--                 local preUnit = M.getUnitInfo(maxUnitID - 1)
--                 local lastWrongWord = preUnit.wrongWordList[#preBoss.wrongWordList]
--                 if preWord == lastWrongWord then
--                     return false
--                 else
--                     return true
--                 end
--             end
--         else
--             local lastWrongWord = unit.wrongWordList[#unit.wrongWordList]
--             if preWord == lastWrongWord then
--                 return false
--             else
--                 return true
--             end
--         end
--     end
-- end

function M.getTodayReviewBoss()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local time      = os.time()
    local today     = os.date("%x", time)

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local unitList  = {}
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." ORDER BY unitID ;") do
        if row.unitState >= 4 and row.unitState <= 7 then
            local unit  = {}
            unit.unitID = row.unitID
            unit.unitState  = row.unitState
            unit.lastUpdate = row.lastUpdate
            table.insert(unitList, unit)
        end
    end

    local getGapDay = function(day1, day2)
        local t1 = split(day1, "/")
        local t2 = split(day2, "/")
        local d1 = {}
        local d2 = {}
        d1.year  = tonumber("20"..t1[3])
        d1.month = tonumber(t1[1])
        d1.day   = tonumber(t1[2])
        d2.year  = tonumber("20"..t2[3])
        d2.month = tonumber(t2[1])
        d2.day   = tonumber(t2[2])

        local y = tonumber(os.date('%Y', os.time()))
        if d1.year > y then d1.year = y end
        if d2.year > y then d2.year = y end

        local numDay1 = os.time(d1)
        local numDay2 = os.time(d2)
        local gap = (numDay2-numDay1)/(3600*24)
        return gap
    end


    local todayReviewBoss = {}
    for i = 1, #unitList do
        local unit = unitList[i]
        
        local gap
        if     unit.unitState == 4 then
            gap = 1
        elseif unit.unitState == 5 then
            gap = 2
        elseif unit.unitState == 6 then
            gap = 3
        elseif unit.unitState == 7 then
            gap = 8
        end

        local lastUpdateDay = os.date("%x", unit.lastUpdate)
        if unit.lastUpdate == nil or unit.lastUpdate == 0 then
            lastUpdateDay = os.date("%x", unit.updatedAt)
        end
        local gapDayNum = getGapDay(lastUpdateDay, today)
        if gapDayNum >= gap then
            table.insert(todayReviewBoss, unit.unitID)
        end
    end

    return todayReviewBoss
end

function M.getMaxUnit()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local maxUnit = nil
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." ORDER BY unitID DESC LIMIT 1 ;") do
        maxUnit = row
    end

    return maxUnit
end

function M.getMaxUnitByBookKey(bookKey)
    local userId    = s_CURRENT_USER.objectId
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local maxUnit = nil
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." ORDER BY unitID DESC LIMIT 1 ;") do
        maxUnit = row
    end

    return maxUnit
end

function M.getMaxUnitID()
    local unit = M.getMaxUnit()
    if unit ~= nil then return unit.unitID end
    return 1
end

function M.getUnitInfo(unitID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()
    
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local unit      = {}
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..unitID.." ;") do
        unit.unitID         = row.unitID
        unit.unitState      = row.unitState
        unit.wrongWordList  = row.wordList
        unit.currentWordIndex  = row.currentWordIndex
        unit.lastUpdate     = row.lastUpdate
    end

    if unit.unitID == nil then
        unit.unitID         = unitID
        unit.unitState      = 0
        unit.wrongWordList  = {}
        unit.rightWordList  = {}
        unit.coolingDay     = 0
    else
        local startIndex
        if unit.unitID == 1 then
            startIndex = 1
        else
            for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..(unitID-1).." ;") do
                startIndex  = row.lastWordIndex + 1
            end
        end

        -- local hash = {}
        if  unit.wrongWordList == '' then
            unit.wrongWordList = {}
        else
            unit.wrongWordList = split(unit.wrongWordList, "|")
            for i = 1, #unit.wrongWordList do
                local wordname = unit.wrongWordList[i]
                -- hash[wordname] = 1
            end
        end

        unit.rightWordList = {}
        -- for i = startIndex, unit.lastWordIndex do
        --     local wordname = s_BookWord[s_CURRENT_USER.bookKey][i]
        --     if hash[wordname] ~= 1 then
        --         table.insert(unit.rightWordList, wordname)
        --     end
        -- end

        -- get cooling day
        local getGapDay = function(day1, day2)
            print('local getGapDay = function(day1, day2)', day1, day2)
            local t1 = split(day1, "/")
            local t2 = split(day2, "/")
            local d1 = {}
            local d2 = {}
            d1.year  = tonumber("20"..t1[3])
            d1.month = tonumber(t1[1])
            d1.day   = tonumber(t1[2])
            d2.year  = tonumber("20"..t2[3])
            d2.month = tonumber(t2[1])
            d2.day   = tonumber(t2[2])

            local y = tonumber(os.date('%Y', os.time()))
            if d1.year > y then d1.year = y end
            if d2.year > y then d2.year = y end

            local numDay1 = os.time(d1)
            local numDay2 = os.time(d2)
            local gap = (numDay2-numDay1)/(3600*24)
            return gap
        end

        if unit.unitState < 4 or unit.unitState > 7 then
            -- other model
            unit.coolingDay = 0
        else
            -- review unit model
            local gap
            if     unit.unitState == 4 then
                gap = 1
            elseif unit.unitState == 5 then
                gap = 2
            elseif unit.unitState == 6 then
                gap = 3
            elseif unit.unitState == 7 then
                gap = 8
            end

            local today = os.date("%x", time)
            local lastUpdateDay = os.date("%x", unit.lastUpdate)
            if unit.lastUpdate == nil or unit.lastUpdate == 0 then
                lastUpdateDay = os.date("%x", unit.updatedAt)
            end
            local gapDayNum = getGapDay(lastUpdateDay, today)
            if gapDayNum >= gap then
                unit.coolingDay = 0
            else
                unit.coolingDay = gap - gapDayNum
            end
        end
    end

    if     unit.unitState == 0 then
        unit.proficiency = 0
    elseif unit.unitState >= 1 and unit.unitState <= 4 then
        unit.proficiency = 1
    elseif unit.unitState == 5 then
        unit.proficiency = 2
    elseif unit.unitState == 6 then
        unit.proficiency = 3
    elseif unit.unitState == 7 then
        unit.proficiency = 4
    elseif unit.unitState == 8 then
        unit.proficiency = 5
    else
        unit.proficiency = 0
    end

    return unit
end

function M.getAllUnitInfo()
    local unitList = {}

    local maxUnitID = M.getMaxUnitID()
    for i = 1, maxUnitID do
        local unit = M.getBossInfo(i)
        table.insert(unitList, unit)
    end

    return unitList
end


-- function M.addRightWord(wordindex)
--     local wordname = s_BookWord[s_CURRENT_USER.bookKey][wordindex]

--     local userId    = s_CURRENT_USER.objectId
--     local bookKey   = s_CURRENT_USER.bookKey
--     local username  = s_CURRENT_USER.username
--     local time      = os.time()

--     local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

--     local bossID    = nil
--     local record = nil
--     for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
--         bossID      = row.bossID
--         record      = row
--     end

--     if bossID == nil then
--         local query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, unitState, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', 1, 0, '', "..wordindex..", 0) ;"
--         Manager.database:exec(query)
--         saveDataToServer(true, time, 1, 0, '', wordindex, 0)
--     else
--         local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
--         Manager.database:exec(query)
--         saveDataToServer(true, time, record.bossID, record.unitState, record.wordList, wordindex, record.savedToServer)
--     end
-- end


-- function M.addWrongWord(wordindex)
--     local wordname = s_BookWord[s_CURRENT_USER.bookKey][wordindex]

--     local userId    = s_CURRENT_USER.objectId
--     local bookKey   = s_CURRENT_USER.bookKey
--     local username  = s_CURRENT_USER.username
--     local time      = os.time()

--     local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

--     local bossID    = nil
--     local unitState = nil
--     local wordList  = nil
--     local record = nil
--     for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
--         bossID      = row.bossID
--         unitState   = row.unitState
--         wordList    = row.wordList
--         record = row
--     end
    
--     if bossID == nil then
--         local query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, unitState, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', 1, 0, '"..wordname.."', "..wordindex..", 0) ;"
--         Manager.database:exec(query)
--         saveDataToServer(true, time, 1, 0, '', wordindex, 0)
--         return false
--     elseif wordList == '' then
--         local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , wordList = '"..wordname.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
--         Manager.database:exec(query)
--         saveDataToServer(true, time, record.bossID, record.unitState, wordname, wordindex, record.savedToServer)
--         return false
--     else
--         local newWordList = wordList.."|"..wordname
--         local wordCount = #split(wordList, "|")

--         local current_total_number = getMaxWrongNumEveryLevel()

--         if wordCount == current_total_number - 1 then
--             s_LocalDatabaseManager.minusTodayRemainTaskNum()

--             local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , unitState = 1 , wordList = '"..newWordList.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
--             Manager.database:exec(query)

--             print('saveDataToServer(false, time, bossID, 1, newWordList, wordindex, 1)')
--             saveDataToServer(false, time, bossID, 1, newWordList, wordindex, 0)
--             return true
--         else
--             local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , wordList = '"..newWordList.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
--             Manager.database:exec(query)
--             saveDataToServer(true, time, record.bossID, record.unitState, newWordList, wordindex, record.savedToServer)
--             return false
--         end
--     end
-- end

function M.updateUnitState(unitID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..unitID.." ;") do
        local newUnitState = row.unitState + 1
        local currentWordIndex = row.currentWordIndex

        local query = "UPDATE DataUnit SET lastUpdate = '"..time.."' , unitState = "..newUnitState.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, row.unitID, newUnitState, row.wordList, currentWordIndex, row.savedToServer)

        if newUnitState == 4 then
            query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, unitState, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', "..(bossID+1)..", 0, '', "..lastWordIndex..", 0) ;"
            Manager.database:exec(query)
            saveDataToServer(true, time, unitID + 1, 0, '', 0, 0)
        elseif newunitState == 8 then
            -- s_LocalDatabaseManager.addGraspWordsNum(getMaxWrongNumEveryLevel())
        end
    end    

    M.printUnitWord()
end

function M.printUnitWord()
    if BUILD_TARGET ~= BUILD_TARGET_DEBUG then return end

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local query = "SELECT * FROM DataUnit WHERE "..condition.." ;"
    print(query)
    print("<unitWord>")
    for row in Manager.database:nrows(query) do
        print("<item>")
        print("unitID: "..row.unitID)
        print("unitState: "..row.unitState)
        print("wordList: "..row.wordList)
        print("currentWordIndex: "..row.currentWordIndex)
        print("</item>")
    end
    print("</unitWord>")
end


function M.getAllWrongWordList()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local wordPool = {}
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." ORDER BY unitID ;") do
        if row.wordList ~= '' then
            local t = split(row.wordList, "|")
            for i = 1, #t do
                table.insert(wordPool, t[i])
            end
        end
    end
    return wordPool
end


return M