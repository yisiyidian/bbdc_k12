
local RBWORDNUM = 10

require("lsqlite3")

-- define Manager
local Manager = {}

-- define Manager's variables
Manager.database = nil

-- connect local sqlite
function Manager.open()
    local sqlite3 = require("sqlite3")
    local databasePath = cc.FileUtils:getInstance():getWritablePath() .. "localDB.sqlite"
    Manager.database = sqlite3.open(databasePath)
    s_logd('databasePath:' .. databasePath)
    
    -- TODO
    -- check version update
    -- if s_APP_VERSION == 150000 then
    --     updateLocalDatabase()
    -- end
end

-- close local sqlite
function Manager.close()
    Manager.database:close()
end

-- add new column
-- ALTER TABLE table_name ADD column_name datatype
function Manager.alterLocalDatabase(objectOfDataClass)
    local function createData (col, type, isAlreadyInDB)
        local data = {}
        data.col = col
        data.type = type
        data.isAlreadyInDB = isAlreadyInDB
        return data
    end

    local dataCols = {}
    for key, value in pairs(objectOfDataClass) do  
        if (key == 'sessionToken'  
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            local data = nil
            if (type(value) == 'string') then
                data = createData(key, 'TEXT', false)
            elseif (type(value) == 'boolean') then
                data = createData(key, 'Boolean', false)
            elseif (type(value) == 'number') then
                data = createData(key, 'INTEGER', false)
            end 
            if data ~= nil then
                dataCols[ key ] = data
            end
        end
    end

    Manager.database:exec('PRAGMA table_info(' .. objectOfDataClass.className .. ')', 
        function (udata, cols, values, names)
            local n = nil
            local t = nil
            for i = 1, cols do 
                if names[i] == 'name' then
                    n = values[i]
                elseif names[i] == 'type' then
                    t = values[i]
                end
            end

            if n ~= nil and t ~= nil then
                dataCols[ n ] = nil
            end

            return 0
        end)

    for k, v in pairs(dataCols) do
        if v ~= nil then
            Manager.database:exec('ALTER TABLE ' .. objectOfDataClass.className .. ' ADD ' .. v.col .. ' ' .. v.type)
        end
    end
end

function Manager.createTable(objectOfDataClass)
    local sql = 'create table if not exists ' .. objectOfDataClass.className .. '(\n'

    local str = ''
    for key, value in pairs(objectOfDataClass) do  
        if (key == 'sessionToken'  
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if (type(value) == 'string') then
                if string.len(str) > 1 then str = str .. ',\n' end
                str = str .. key .. ' TEXT'
            elseif (type(value) == 'boolean') then
                if string.len(str) > 1 then str = str .. ',\n' end
                str = str .. key .. ' Boolean'
            elseif (type(value) == 'number') then
                if string.len(str) > 1 then str = str .. ',\n' end
                str = str .. key .. ' INTEGER'
            end     
        end
    end

    sql = sql .. str .. '\n);'
    -- print (sql)
    Manager.database:exec(sql)

    Manager.alterLocalDatabase(objectOfDataClass)
end

-- init data structure
function Manager.initTables()
   
    -- CREATE table Word Prociency
    Manager.database:exec[[
        create table if not exists DataWordProciency(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT,
            wordProciency INTEGER,
            lastUpdate TEXT
        );
    ]]
   
    -- CREATE table Review boss Control
    Manager.database:exec[[
        create table if not exists DataReviewBossControl(
            userId TEXT,
            bookKey TEXT,
            bossId INTEGER,
            wordCount INTEGER,
            appearCount INTEGER,
            lastUpdate TEXT
        ); 
    ]]

    -- create table Review boss Record
    Manager.database:exec[[
        create table if not exists DataReviewBossRecord(
            userId TEXT,
            bookKey TEXT,
            bossId INTEGER,
            wordId INTEGER,
            wordName TEXT,
            lastUpdate TEXT
        );
    ]]

    local userDataClasses = {
        require('model.user.DataDailyCheckIn'),
        require('model.user.DataDailyWord'),
        require('model.user.DataIAP'),
        require('model.user.DataLevel'),
        require('model.user.DataLogIn'),           -- IC_loginDate same as DataLogIn
        require('model.user.DataStatistics'),      -- IC_word_day same as DataStatistics
        require('model.user.DataUser'),            -- db_userInfo same as DataUser
        require('model.user.DataConfigs')
    }
    for i = 1, #userDataClasses do
        Manager.createTable(userDataClasses[i].create())
    end
end

-- if record exists then update record
-- else create record
--
-- ALTER TABLE table_name ADD column_name datatype
function Manager.saveDataClassObject(objectOfDataClass)
    Manager.alterLocalDatabase(objectOfDataClass)
    
    local num = 0
    for row in Manager.database:nrows("SELECT * FROM " .. objectOfDataClass.className .. " WHERE objectId = '".. objectOfDataClass.objectId .."'") do
        num = num + 1
        break
    end

    local insert = function ()
        local keys, values = '', ''
        for key, value in pairs(objectOfDataClass) do  
            if (key == 'sessionToken'  
                or string.find(key, '__') ~= nil 
                or value == nil) == false then 

                if (type(value) == 'string') then
                    if string.len(keys) > 0 then keys = keys .. ',' end
                    keys = keys .. "'" .. key .. "'"

                    if string.len(values) > 0 then values = values .. ',' end
                    values = values .. "'" .. value .. "'"
                elseif (type(value) == 'boolean') then
                    if string.len(keys) > 0 then keys = keys .. ',' end
                    if string.len(values) > 0 then values = values .. ',' end
                        keys = keys .. "'" .. key .. "'"
                        values = values .. tostring(value)
                    -- if value then
                    --     keys = keys .. "'" .. key .. "'"
                    --     values = values .. '1'
                    -- else
                    --     keys = keys .. "'" .. key .. "'"
                    --     values = values .. '0'
                    -- end
                elseif (type(value) == 'number') then
                    if string.len(keys) > 0 then keys = keys .. ',' end
                    keys = keys .. "'" .. key .. "'"

                    if string.len(values) > 0 then values = values .. ',' end
                    values = values .. value
                end
            end
        end
        return keys, values
    end

    local update = function ()
        local str = ''
        for key, value in pairs(objectOfDataClass) do  
            if (key == 'sessionToken'  
                or string.find(key, '__') ~= nil 
                or value == nil) == false then 

                if (type(value) == 'string') then
                    if string.len(str) > 0 then str = str .. ',' end
                    str = str .. "'" .. key .. "'" .. '=' .. "'" .. value .. "'"
                elseif (type(value) == 'boolean') then
                    if string.len(str) > 0 then str = str .. ',' end
                    str = str .. "'" .. key .. "'=" .. tostring(value)
                    -- if value then
                    --     str = str .. "'" .. key .. "'=1"
                    -- else
                    --     str = str .. "'" .. key .. "'=0"
                    -- end
                elseif (type(value) == 'number') then
                    if string.len(str) > 0 then str = str .. ',' end
                    str = str .. "'" .. key .. "'" .. '=' .. value
                end     
            end
        end
        return str
    end

    if num == 0 then
        local keys, values = insert()
        local query = "INSERT INTO " .. objectOfDataClass.className .. " (" .. keys .. ")" .. " VALUES (" .. values .. ");"
        local ret = Manager.database:exec(query)
        s_logd('[sql result:' .. tostring(ret) .. ']: ' .. query)
    else
        local query = "UPDATE " .. objectOfDataClass.className .. " SET " .. update() .. " WHERE objectId = '".. objectOfDataClass.objectId .."'"
        local ret = Manager.database:exec(query)
        s_logd('[sql result:' .. tostring(ret) .. ']: ' .. query)
    end
end

local function getUserDataFromLocalDB(objectOfDataClass, isJustNeedToFindGuest)
    local lastLogIn = 0
    local data = nil
    for row in Manager.database:nrows("SELECT * FROM " .. objectOfDataClass.className) do
        print ('sql result:')
        print_lua_table(row)
        local rowTime = row.updatedAt
        if rowTime <= 0 then rowTime = row.createdAt end
        if rowTime > lastLogIn then
            s_logd(string.format('getUserDataFromLocalDB updatedAt: %s, %f, %f', row.objectId, row.updatedAt, lastLogIn))

            if isJustNeedToFindGuest then
                if row.isGuest == 1 then
                    lastLogIn = rowTime
                    data = row
                end
            else
                lastLogIn = rowTime
                data = row
            end
        
        end
    end

    if data ~= nil then
        parseLocalDatabaseToUserData(data, objectOfDataClass)     
        return true
    end

    return false
end

function Manager.getLastLogInUser(objectOfDataClass)
    return getUserDataFromLocalDB(objectOfDataClass, false)
end

function Manager.getLastLogInGuest(objectOfDataClass)
    return getUserDataFromLocalDB(objectOfDataClass, true)
end

function Manager.getDataConfigsFromLocalDB(objectOfDataClass)
    local data = nil
    for row in Manager.database:nrows("SELECT * FROM " .. objectOfDataClass.className) do
        data = row
    end

    if data ~= nil then
        parseLocalDatabaseToUserData(data, objectOfDataClass)     
        return true
    end

    return false
end

function Manager.insertTable_DataWordProciency(wordName, wordProciency)
    local user = s_CURRENT_USER.objectId
    local book = s_CURRENT_USER.bookKey

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency WHERE userId = '"..user.."' and bookKey = '"..book.."' and wordName = '"..wordName.."'") do
        num = num + 1
    end
    
    if num == 0 then
        local time = os.time()
        local query = "INSERT INTO DataWordProciency VALUES ('"..user.."', '"..book.."', '"..wordName.."', "..wordProciency..", '"..time.."');"
        Manager.database:exec(query)
        
        if wordProciency == 0 then
            Manager.insertTable_DataReviewBossRecord(wordName)
        end
    else
        print("word exists")
    end
    Manager.showTable_DataWordProciency()

    s_UserBaseServer.saveWordProciencyOfCurrentUser(book, wordName, wordProciency, nil, nil)
end

function Manager.showTable_DataWordProciency()
    s_logd("DataWordProciency --------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency") do
        s_logd(row.wordName .. ',' .. row.wordProciency)
    end
    s_logd("DataWordProciency --------------------------- end")
end

function Manager.insertTable_DataReviewBossControl(bossID)
    local user = s_CURRENT_USER.objectId
    local book = s_CURRENT_USER.bookKey
    local time = os.time()
    local query = "INSERT INTO DataReviewBossControl VALUES ('"..user.."', '"..book.."', "..bossID..", "..RBWORDNUM..", 0, '"..time.."');"
    Manager.database:exec(query)
end

function Manager.showTable_DataReviewBossControl()
    s_logd("DataReviewBossControl ------------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataReviewBossControl") do
        s_logd("bossID:"..row.bossId..' appearCount:'..row.appearCount)
    end
    s_logd("DataReviewBossControl ------------------------------- end")
end

function Manager.insertTable_DataReviewBossRecord(wordName)
    local user = s_CURRENT_USER.objectId
    local book = s_CURRENT_USER.bookKey
    
    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataReviewBossRecord WHERE userId = '"..user.."' and bookKey = '"..book.."'") do
        num = num + 1
    end
    
    local wordID = num + 1
    local bossID = math.floor((wordID - 1) / RBWORDNUM) + 1
    
    local time = os.time()
    local query = "INSERT INTO DataReviewBossRecord VALUES ('"..user.."', '"..book.."', "..bossID..", "..wordID..", '"..wordName.."', '"..time.."');"
    print(query)
    Manager.database:exec(query)
    
    s_logd("insert word "..wordName.." into review boss")
    Manager.showTable_DataReviewBossRecord()
    
    if wordID % RBWORDNUM == 0 then
        Manager.insertTable_DataReviewBossControl(bossID)
        s_logd("generate a new review boss")
        Manager.showTable_DataReviewBossControl()
    end
end

function Manager.showTable_DataReviewBossRecord()
    s_logd("DataReviewBossRecord -------------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataReviewBossRecord") do
        s_logd("bossID:"..row.bossId..' wordID:' .. row.wordId .. ' wordName:' .. row.wordName)
    end
    s_logd("DataReviewBossRecord -------------------------------- end")
end

function Manager.getRBWordList(bossID)
    local user = s_CURRENT_USER.objectId
    local book = s_CURRENT_USER.bookKey
    local wordList = {}
    for row in Manager.database:nrows("SELECT * FROM DataReviewBossRecord WHERE userId = '"..user.."' and bookKey = '"..book.."' and bossId = '"..bossID.."'") do
        table.insert(wordList, row.wordName)
    end
    return wordList
end

function Manager.getRandomWord()
    local user = s_CURRENT_USER.objectId
    local book = s_CURRENT_USER.bookKey
    local wrongWords = {}
    local studyWords = {}
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency WHERE userId = '"..user.."' and bookKey = '"..book.."'") do
        if row.wordProciency < 5 then
            table.insert(wrongWords, row.wordName)
        end
        table.insert(studyWords, row.wordName)
    end
    
    math.randomseed(os.time())
    if #wrongWords ~= 0 then
        local randomIndex = math.random(1, #wrongWords)
        return wrongWords[randomIndex]
    end
    
    if #studyWords ~= 0 then
        local randomIndex = math.random(1, #studyWords)
        return studyWords[randomIndex]
    end
    
    local candidate = {"apple", "many", "tea"}
    local randomIndex = math.random(1, 3)
    return candidate[randomIndex]
end

function Manager.getStudyWordsNum(bookKey, day) -- day must be a string like "11/16/14", as month + day + year
    local user = s_CURRENT_USER.objectId
    local sum = 0
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency WHERE userId = '"..user.."' and bookKey = '"..bookKey.."'") do
        if day then
            local record_date = os.date("%x",row.lastUpdate)
            if record_date == day then
                sum = sum + 1
            end
        else
            sum = sum + 1
        end
    end
    return sum
end

function Manager.getGraspWordsNum(bookKey, day) -- day must be a string like "11/16/14", as month + day + year
    local user = s_CURRENT_USER.objectId
    local sum = 0
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency WHERE userId = '"..user.."' and bookKey = '"..bookKey.."' and wordProciency = 5") do
        if day then
            local record_date = os.date("%x",row.lastUpdate)
            if record_date == day then
                sum = sum + 1
            end
        else
            sum = sum + 1
        end
    end
    return sum
end

function Manager.getStudyWords(bookKey)
    local user = s_CURRENT_USER.objectId
    local wordList = {}
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency WHERE userId = '"..user.."' and bookKey = '"..bookKey.."'") do
        wordList[row.wordName] = row.wordProciency
    end
    return wordList
end

function Manager.getGraspWords(bookKey)
    local user = s_CURRENT_USER.objectId
    local wordList = {}
    for row in Manager.database:nrows("SELECT * FROM DataWordProciency WHERE userId = '"..user.."' and bookKey = '"..bookKey.."' and wordProciency = 5") do
        wordList[row.wordName] = row.wordProciency
    end
    return wordList
end

-- return current valid review bossId
function Manager:getCurrentReviewBossID()
    local bossId = -1
    for row in Manager.database:nrows('SELECT * FROM DataReviewBossControl') do
        if row.bookKey == s_CURRENT_USER.bookKey and row.userId == s_CURRENT_USER.objectId then
            -- TODO check the boss appear time
            local currentTime = os.time()
            local diffTime = os.time() - row.lastUpdate
            if row.appearCount == 0 then
                bossId = row.bossId
                break
            elseif row.appearCount == 1 then
                if diffTime >= 24 * 3600 then
                    bossId = row.bossId
                    break
                end
            elseif row.appearCount == 2 then
                if diffTime >= 24 * 3 * 3600 then
                    bossId = row.bossId
                    break
                end
            elseif row.appearCount == 3 then
                if diffTime >= 24 * 3 * 3600 then
                    bossId = row.bossId
                    break
                end
            elseif row.appearCount == 4 then
                if diffTime >= 24 * 7 * 3600 then
                    bossId = row.bossId
                    break
                end 
            end
        end
    end
    return bossId
end

-- update review boss after played
function Manager.updateReviewBossRecord(bossId)
    local user = s_CURRENT_USER.objectId
    local book = s_CURRENT_USER.bookKey

    for row in Manager.database:nrows('SELECT * FROM DataReviewBossControl where bossId = '..bossId) do
        if row.bookKey == s_CURRENT_USER.bookKey and row.userId == s_CURRENT_USER.objectId then
            -- update
            local command = 'UPDATE DataReviewBossControl SET appearCount = '..(row.appearCount+1)..' , lastUpdate = '..(os.time())
            Manager.database:exec(command)
        end
    end
    Manager.showTable_DataReviewBossControl()
    
    for row1 in Manager.database:nrows("SELECT * FROM DataReviewBossRecord where userId='"..user.."' and bookKey='"..book.."' and bossId = "..bossId) do
        local wordName = row1.wordName
        print("update word name:"..wordName)
        for row2 in Manager.database:nrows("SELECT * FROM DataWordProciency where userId='"..user.."' and bookKey='"..book.."' and wordName = '"..wordName.."'") do
--            local command = "UPDATE DataWordProciency SET wordProciency="..(row2.wordProciency+1)..", lastUpdate='"..(os.time()).."' WHERE userId='"..user.."' and bookKey='"..book.."' and wordName = '"..wordName.."'"
            local command = "UPDATE DataWordProciency SET wordProciency="..(row2.wordProciency+1).." WHERE userId='"..user.."' and bookKey='"..book.."' and wordName = '"..wordName.."'"
            Manager.database:exec(command)
            print(command)
        end
    end
    Manager.showTable_DataWordProciency()
end



---- UserDefault -----------------------------------------------------------

local is_log_out_key = 'log_out'
function Manager.isLogOut() return cc.UserDefault:getInstance():getBoolForKey(is_log_out_key, false) end
function Manager.setLogOut(b) cc.UserDefault:getInstance():setBoolForKey(is_log_out_key, b) end

local is_sound_on_key = 'sound'
function Manager.isSoundOn() return cc.UserDefault:getInstance():getBoolForKey(is_sound_on_key, true) end
function Manager.setSoundOn(b) cc.UserDefault:getInstance():setBoolForKey(is_sound_on_key, b) end

local is_music_on_key = 'music'
function Manager.isMusicOn() return cc.UserDefault:getInstance():getBoolForKey(is_music_on_key, true) end
function Manager.setMusicOn(b) cc.UserDefault:getInstance():setBoolForKey(is_music_on_key, b) end

return Manager
