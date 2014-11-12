
require("lsqlite3")

-- define Manager
local Manager = {}

-- define Manager's variables
Manager.database = nil

-- update local database when app version changes
function updateLocalDatabase()
    Manager.database:exec[[
        -- ALTER TABLE XXX ADD XXX DEFAULT XX;
    ]]
end

-- connect local sqlite
function Manager.open()
    local sqlite3 = require("sqlite3")
    local databasePath = cc.FileUtils:getInstance():getWritablePath() .. "localDB.sqlite"
    Manager.database = sqlite3.open(databasePath)
    s_logd('databasePath:' .. databasePath)
    
    -- TODO
    -- check version update
    if s_APP_VERSION == 151 then
        updateLocalDatabase()
    end
end

-- close local sqlite
function Manager.close()
    Manager.database:close()
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

    Manager.database:exec(sql)
end

-- init data structure
function Manager.initTables()
   
    -- CREATE table Review boss Control
    Manager.database:exec[[
        create table if not exists RB_control(
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
        create table if not exists RB_record(
            userId TEXT,
            bookKey TEXT,
            bossId INTEGER,
            insertDate TEXT,
            wordId INTEGER,
            wordName TEXT,
            lastUpdate TEXT
        );
    ]]

    -- create table database game design configuration
    Manager.database:exec[[
        create table if not exists DB_gameDesignConfiguration(
            books TEXT,
            booksV INTEGER,
            chapters TEXT,
            chaptersV INTEGER,
            dailyCheckIn TEXT,
            dailyCheckInV INTEGER,
            energy TEXT,
            energyV INTEGER,
            iaps TEXT,
            iapsV INTEGER,
            items TEXT,
            itemsV INTEGER,
            lv_cet4 TEXT,
            lv_cet4V INTEGER,
            lv_cet6 TEXT,
            lv_cet6V INTEGER,
            lv_ielts TEXT,
            lv_ieltsV INTEGER,
            lv_ncee TEXT,
            lv_nceeV INTEGER,
            lv_toefl TEXT,
            lv_toeflV INTEGER,
            review_boss TEXT,
            revew_bossV INTEGER,
            starRule TEXT
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
        require('model.user.DataWord')             -- Word_Prociency same as DataWord
    }
    for i = 1, #userDataClasses do
        Manager.createTable(userDataClasses[i].create())
    end
end

-- if record exists then update record
-- else create record
function Manager.saveDataClassObject(objectOfDataClass)
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
        s_logd(query)
        Manager.database:exec(query)
    else
        local query = "UPDATE " .. objectOfDataClass.className .. " SET " .. update() .. " WHERE objectId = '".. objectOfDataClass.objectId .."'"
        s_logd(query)
        Manager.database:exec(query)
    end
end

function Manager.getUserDataFromLocalDB(objectOfDataClass)
    local lastLogIn = 0
    local data = nil
    for row in Manager.database:nrows("SELECT * FROM " .. objectOfDataClass.className) do
        -- print_lua_table(row)
        if row.updatedAt > lastLogIn then
            s_logd(string.format('getUserDataFromLocalDB updatedAt: %s, %f, %f', row.objectId, row.updatedAt, lastLogIn))
            lastLogIn = row.updatedAt
            data = row
        end
    end

    if data ~= nil then
        parseLocalDatabaseToUserData(data, objectOfDataClass)     
        return true
    end

    return false
end

function Manager.insertTable_Word_Prociency(wordName, wordProciency)
    local num = 0
    for row in Manager.database:nrows("SELECT * FROM WMAV_UserWord WHERE wordName = '"..wordName.."'") do
        num = num + 1
    end
    
    if num == 0 then
        local query = "INSERT INTO WMAV_UserWord VALUES ('user1', 'book1', '"..wordName.."', "..wordProciency..", '2014-11-6');"
        Manager.database:exec(query)
        
        if wordProciency == 0 then
            Manager.insertTable_RB_record(wordName)
        end
    else
        print("word exists")
    end
end

function Manager.insertTable_RB_control()
    local query = "INSERT INTO RB_control VALUES ('user1', 'book1', 'boss1', '30', '2', '2014-11-6');"
    Manager.database:exec(query)
end

function Manager.insertTable_RB_record(wordName)
    local RBWORDNUM = 20

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM RB_record") do
        num = num + 1
    end
    
    local wordID = num + 1
    local bossID = ((wordID - 1) / RBWORDNUM) + 1
    
    local query = "INSERT INTO RB_control VALUES ('user1', 'book1', '"..bossID.."', '2014-10-6', '"..wordID.."', '"..wordName.."', '2014-11-6');"
    Manager.database:exec(query)
    
    if wordID % RBWORDNUM == 0 then
        Manager.insertTable_RB_control()
    end
end

function Manager.showTable_Word_Prociency()
    s_logd("WMAV_UserWord ---------------------------")
    for row in Manager.database:nrows("SELECT * FROM WMAV_UserWord") do
        s_logd(row.wordName .. ',' .. row.prociencyValue)
    end
end

-- return current valid review bossId
function Manager:getCurrentReviewBossID()
    local bossId = -1
    for row in Manager.database:nrows('SELECT * FROM RB_control') do
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
    for row in Manager.database:nrows('SELECT * FROM RB_control where bossId = '..bossId) do
        if row.bookKey == s_CURRENT_USER.bookKey and row.userId == s_CURRENT_USER.objectId then
            -- update
            local command = 'UPDATE RB_control SET appearCount = '..(row.appearCount+1)..' , lastUpdate = '..(os.time())
            Manager.database:exec(command)
        end
    end
end

function Manager.showTable_RB_control()
    s_logd("RB_control1 -------------------------------")
    for row in Manager.database:nrows("SELECT * FROM RB_control") do
        s_logd(row.bossId .. ',' .. row.appearCount..','..row.lastUpdate)
    end
end

function Manager.showTable_RB_record()
    s_logd("RB_record --------------------------------")
    for row in Manager.database:nrows("SELECT * FROM RB_record") do
        s_logd(row.bossId .. ',' .. row.wordId .. ',' .. row.wordName)
    end
end

---- UserDefault -----------------------------------------------------------

local is_sound_on_key = 'sound'
function Manager.isSoundOn() return cc.UserDefault:getInstance():getBoolForKey(is_sound_on_key, true) end
function Manager.setSoundOn(b) cc.UserDefault:getInstance():setBoolForKey(is_sound_on_key, b) end

local is_music_on_key = 'music'
function Manager.isMusicOn() return cc.UserDefault:getInstance():getBoolForKey(is_music_on_key, true) end
function Manager.setMusicOn(b) cc.UserDefault:getInstance():setBoolForKey(is_music_on_key, b) end

return Manager
