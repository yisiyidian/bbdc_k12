local DataUnit = require('model.user.DataUnit')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, unitID, unitState, wordList, currentWordIndex, savedToServer)
    local data = DataUnit.create()
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

            local query = "UPDATE DataUnit SET objectId = '"..v.objectId.."', savedToServer = " .. v.savedToServer .. " WHERE "..condition.." and unitID = "..unitID.." ;"
            Manager.database:exec(query)

            break
        end
    end)
end

-- function M.getPrevWordState()
--     local preIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex() - 1
--     local currentUnit = M.getMaxUnitID()
--     local preWord  = s_BookUnitWord[s_CURRENT_USER.bookKey][currentUnit][preIndex]

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
        if row.unitState >= 1 and row.unitState <= 4 then
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
        if     unit.unitState == 1 then
            gap = 1
        elseif unit.unitState == 2 then
            gap = 2
        elseif unit.unitState == 3 then
            gap = 3
        elseif unit.unitState == 4 then
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
    --print('MAXUNIT:')
    --print_lua_table(maxUnit)

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
    return 0
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
        unit.rightWordList  = row.wordList
        unit.currentWordIndex  = row.currentWordIndex
        unit.lastUpdate     = row.lastUpdate
    end

    if unit.unitID == nil then
        unit.unitID         = unitID
        unit.unitState      = 0
        unit.wrongWordList  = {}
        unit.rightWordList  = {}
        unit.coolingDay     = 0
        --print('unit.unitID == nil')
    else
        -- local startIndex
        -- if unit.unitID == 1 then
        --     startIndex = 1
        -- else
        --     for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..(unitID-1).." ;") do
        --         startIndex  = row.lastWordIndex + 1
        --     end
        -- end
        -- print(debug.traceback())
        local hash = {}
        print('UNItID:'..unitID)
        print('BookKEy:'..bookKey)
        print_lua_table(s_BookUnitWord[bookKey])
        unit.wrongWordList  = s_BookUnitWord[bookKey][''..unitID]
        print('rightWordList',unit.rightWordList)
         print('wrongWordList',unit.wrongWordList)
        unit.wrongWordList = split(unit.wrongWordList, "||")
         
        if  unit.rightWordList == '' then
            unit.rightWordList = {}
        else
            unit.rightWordList = split(unit.rightWordList, "||")
            -- for i = 1, #unit.rightWordList do
            --     local wordname = unit.rightWordList[i]
            --     hash[wordname] = 1
            -- end
        end

        -- unit.rightWordList = {}
        -- for i = startIndex, unit.lastWordIndex do
        --     local wordname = s_BookUnitWord[s_CURRENT_USER.bookKey][i]
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

        if unit.unitState < 1 or unit.unitState > 4 then
            -- other model
            unit.coolingDay = 0
        else
            -- review unit model
            local gap
            if     unit.unitState == 1 then
                gap = 1
            elseif unit.unitState == 2 then
                gap = 2
            elseif unit.unitState == 3 then
                gap = 3
            elseif unit.unitState == 4 then
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
    if unit.unitState >= 0 and unit.unitState <= 5 then
        unit.proficiency = unit.unitState
    else
        unit.proficiency = 0
    end
    -- if     unit.unitState == 0 then
    --     unit.proficiency = 0
    -- elseif unit.unitState >= 1 and unit.unitState <= 2 then
    --     unit.proficiency = 1
    -- elseif unit.unitState == 1 then
    --     unit.proficiency = 2
    -- elseif unit.unitState == 2 then
    --     unit.proficiency = 3
    -- elseif unit.unitState == 4 then
    --     unit.proficiency = 4
    -- elseif unit.unitState == 5 then
    --     unit.proficiency = 5
    -- else
    --     unit.proficiency = 0
    -- end

    -- test
    -- unit.coolingDay = 0

    return unit
end

function M.getUnitCoolingSeconds(unitID)
    print('------ in get cooling seconds function ----')
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()
    
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local unit      = {}
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..unitID.." ;") do
        unit.unitID         = row.unitID
        unit.unitState      = row.unitState
        unit.lastUpdate     = row.lastUpdate
    end
    print('unit:'..unitID)
    if unit.unitID == nil then
        return -1
    else
        -- get cooling seconds
        local getGapSeconds = function(day1, day2)
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
            local gap = (numDay2-numDay1)
            return gap
        end

        if unit.unitState < 1 or unit.unitState > 4 then
            return -1
        else
            -- review unit model
            local gap
            if     unit.unitState == 1 then
                gap = 1
            elseif unit.unitState == 2 then
                gap = 2
            elseif unit.unitState == 3 then
                gap = 3
            elseif unit.unitState == 4 then
                gap = 8
            end
            gap = gap * 3600 * 24

            local today = os.date("%x", time)
            local lastUpdateDay = os.date("%x", unit.lastUpdate)
            if unit.lastUpdate == nil or unit.lastUpdate == 0 then
                lastUpdateDay = os.date("%x", unit.updatedAt)
            end
            local gapSecondNum = getGapSeconds(lastUpdateDay, today)
            if gapSecondNum >= gap then
                return 0
            else
                return  (gap - gapSecondNum)
            end
        end
    end
end

function M.getAllUnitInfo()
    local unitList = {}


    -- local bookMaxID = M.getBookMaxUnitID(s_CURRENT_USER.bookKey)
    -- print('test book max ID:'..bookMaxID)
    -- local unitID = 1
    -- local bookMaxID = M.getBookMaxUnitID(s_CURRENT_USER.bookKey)
    -- print('test book max ID ##:'..bookMaxID)
    -- if unitID - bookMaxID < 0 then
    --     M.initUnitInfo(unitID+1)
    -- end
    -- print_lua_table(s_BookUnitWord)

    local maxUnitID = M.getMaxUnitID()
    for i = 1, maxUnitID do
        local unit = M.getUnitInfo(i)
        table.insert(unitList, unit)
    end

    return unitList
end

function M.initUnitInfo(unitID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()
    local wordlist = ''
    local currentWordIndex = 1
    local unitState = 0
    --print('wordlist:'..wordlist)

    query = "INSERT INTO DataUnit (userId, username, bookKey, lastUpdate, unitID, unitState, wordList, currentWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', "..unitID..", 0, '"..wordlist.."', "..currentWordIndex..", 0) ;"
    --print('sql:'..query)
    Manager.database:exec(query)
    -- print("initUnitInfo",wordlist)

    -- local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"
    -- print('row:')
    -- for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition..";") do
    --     print(row.unitID)
    -- end
    saveDataToServer(true, time, unitID, unitState, wordList, currentWordIndex, 0)
end

function M.updateUnitState(unitID)
    if unitID == nil then
        return 
    end
    
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    --TODO 处理bookKey标记的书不存在的情况
    --用户用同一帐号,登陆不同的版本,会出现这种情况

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..unitID.." ;") do
        local newUnitState = row.unitState + 1
        local currentWordIndex = row.currentWordIndex

        local query = "UPDATE DataUnit SET lastUpdate = '"..time.."' , unitState = "..newUnitState.." WHERE "..condition.." and unitID = "..unitID.." ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, row.unitID, newUnitState, row.wordList, currentWordIndex, row.savedToServer)

        if newUnitState == 1 then
        -- if true then
            -- query = "INSERT INTO DataUnit (userId, username, bookKey, lastUpdate, unitID, unitState, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', "..(bossID+1)..", 0, '', "..lastWordIndex..", 0) ;"
            -- Manager.database:exec(query)
            -- saveDataToServer(true, time, unitID + 1, 0, '', 0, 0)
            local bookMaxID = M.getBookMaxUnitID(bookKey)
            -- print('test book max ID ##:'..bookMaxID)
            if unitID - bookMaxID < 0 then
                M.initUnitInfo(unitID+1)
            end
        elseif newunitState == 5 then -- grasp word
            s_LocalDatabaseManager.addGraspWordsNum(#row.wordList)
        end
    end    

    M.printUnitWord()
end

function M.addRightWord(wordlist,unitID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"
    
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." and unitID = "..unitID.." ;") do
        local rightWordList = row.wordList

        local query = "UPDATE DataUnit SET lastUpdate = '"..time.."' , wordList = '"..wordlist.."' WHERE "..condition.." and unitID = "..unitID.." ;"
        Manager.database:exec(query)
        --print("addRightWord",row.wordList)
        saveDataToServer(true, time, row.unitID, row.unitState, wordlist, row.currentWordIndex, row.savedToServer)
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

function M.getBookMaxUnitID(bookKey)
    -- print('getBookmaxunit')
    -- print('bookKey:'..bookKey)
    -- print_lua_table(s_BookUnitWord[bookKey])
    local maxID = 1
    for unitID, unitWord in pairs(s_BookUnitWord[bookKey]) do
        if unitID - maxID > 0 then
            maxID = unitID + 0
        end
    end
    print('maxID:'..maxID)
    return maxID
end


function M.getAllWrongWordList()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local wordPool = {}
    for row in Manager.database:nrows("SELECT * FROM DataUnit WHERE "..condition.." ORDER BY unitID ;") do
        if row.wordList ~= '' then
            local t = split(row.wordList, "||")
            for i = 1, #t do
                table.insert(wordPool, t[i])
            end
        end
    end
    return wordPool
end


return M