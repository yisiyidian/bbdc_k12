local RBWORDNUM = 10
local MAXWRONGWORDCOUNT = 20

require("common.global")
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
    
    -- CREATE table Current Index
    Manager.database:exec[[
        create table if not exists DataCurrentIndex(
            userId TEXT,
            bookKey TEXT,
            currentIndex INTEGER,
            lastUpdate INTEGER
        );
    ]]
    
    -- CREATE table NewPlay State
    Manager.database:exec[[
        create table if not exists DataNewPlayState(
            userId TEXT,
            bookKey TEXT,
            playModel INTEGER,
            rightWordList TEXT,
            wrongWordList TEXT,
            wordCandidate TEXT,
            lastUpdate INTEGER
        );
    ]]
    
    -- CREATE table Wrong Word Buffer
    Manager.database:exec[[
        create table if not exists DataWrongWordBuffer(
            userId TEXT,
            bookKey TEXT,
            wordBuffer TEXT,
            lastUpdate INTEGER
        );
    ]]
    
    -- CREATE table Boss Word
    Manager.database:exec[[
        create table if not exists DataBossWord(
            userId TEXT,
            bookKey TEXT,
            bossID INTEGER,
            typeIndex INTEGER,
            wordList TEXT,
            lastUpdate INTEGER
        );
    ]]

    local userDataClasses = {
        require('model.user.DataDailyCheckIn'),
        require('model.user.DataDailyWord'),
        require('model.user.DataIAP'),
        require('model.user.DataLevel'),
        require('model.user.DataLogIn'),           -- IC_loginDate same as DataLogIn
        require('model.user.DataStatistics'),      -- IC_word_day same as DataStatistics
        require('model.user.DataUser')             -- db_userInfo same as DataUser
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

local function getUserDataFromLocalDB(objectOfDataClass, usertype)
    local lastLogIn = 0
    local data = nil
    for row in Manager.database:nrows("SELECT * FROM " .. objectOfDataClass.className) do
        print ('sql result:')
        print_lua_table(row)
        local rowTime = row.updatedAt
        if rowTime <= 0 then rowTime = row.createdAt end
        if rowTime > lastLogIn then
            s_logd(string.format('getUserDataFromLocalDB updatedAt: %s, %f, %f', row.objectId, row.updatedAt, lastLogIn))

            if usertype == USER_TYPE_GUEST then
                if (row.isGuest == 1 and row.usertype == nil) or row.usertype == USER_TYPE_GUEST then
                    lastLogIn = rowTime
                    data = row
                end
            elseif usertype == USER_TYPE_QQ then
                if row.usertype == USER_TYPE_QQ then
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
        if data.usertype == nil then
            if data.isGuest == 1 then 
                data.usertype = USER_TYPE_GUEST
            else
                data.usertype = USER_TYPE_MANUAL
            end
        end
        parseLocalDatabaseToUserData(data, objectOfDataClass)     
        return true
    end

    return false
end

function Manager.getLastLogInUser(objectOfDataClass, usertype)
    return getUserDataFromLocalDB(objectOfDataClass, usertype)
end


-- show word info
function Manager.getRandomWord()
    return "apple"
end

function Manager.getStudyWordsNum(bookKey, day) -- day must be a string like "11/16/14", as month + day + year
    return 0
end

function Manager.getGraspWordsNum(bookKey, day) -- day must be a string like "11/16/14", as month + day + year
    return 0
end

function Manager.getStudyWords(bookKey)
    return {}
end

function Manager.getGraspWords(bookKey)
    return {}
end

-- record word info
function Manager.printCurrentIndex()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<currentIndex>")
    for row in Manager.database:nrows("SELECT * FROM DataCurrentIndex WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("current book word index: "..row.currentIndex.." time: "..row.lastUpdate)
    end
    print("</currentIndex>")
end

function Manager.getCurrentIndex()
    local currentIndex = nil

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    
    for row in Manager.database:nrows("SELECT * FROM DataCurrentIndex WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        currentIndex = row.currentIndex
    end
    
    if currentIndex == nil then
        currentIndex = 1
        local time = os.time()
        local query = "INSERT INTO DataCurrentIndex VALUES ('"..userId.."', '"..bookKey.."', "..currentIndex..", "..time..");"
        Manager.database:exec(query)
    end
    
    return currentIndex
end

function Manager.setCurrentIndex(currentIndex)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataCurrentIndex WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        num = num + 1
    end

    if num == 0 then
        local query = "INSERT INTO DataCurrentIndex VALUES ('"..userId.."', '"..bookKey.."', "..currentIndex..", "..time..");"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataCurrentIndex SET currentIndex = "..currentIndex..", lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';"    
        Manager.database:exec(query)
    end
end

function Manager.printNewPlayState()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    print("<newPlayState>")
    for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        print("<item>")
        print("current playModel: "..row.playModel)
        print("current rightWordList: "..row.rightWordList)
        print("current wrongWordList: "..row.wrongWordList)
        print("current wordCandidate: "..row.wordCandidate)
        print("current lastUpdate: "..row.lastUpdate)
        print("</item>")
    end
    print("</newPlayState>")
end

function Manager.getNewPlayState()
    local newPlayState = {}
    newPlayState.lastUpdate = nil

    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        newPlayState.playModel     = row.playModel
        newPlayState.rightWordList = row.rightWordList
        newPlayState.wrongWordList = row.wrongWordList
        newPlayState.wordCandidate = row.wordCandidate
        newPlayState.lastUpdate    = row.lastUpdate
    end
    
    return newPlayState
end

function Manager.setNewPlayState(playModel, rightWordList, wrongWordList, wordCandidate)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataNewPlayState WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        num = num + 1
    end
    
    if num == 0 then
        local query = "INSERT INTO DataNewPlayState VALUES ('"..userId.."', '"..bookKey.."', "..playModel..", '"..rightWordList.."', '"..wrongWordList.."', '"..wordCandidate.."', "..time..");"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataNewPlayState SET playModel = "..playModel..", rightWordList = '"..rightWordList.."', wrongWordList = '"..wrongWordList.."', wordCandidate = '"..wordCandidate.."', lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';"    
        Manager.database:exec(query)
    end
end

---- CREATE table Wrong Word Buffer
--Manager.database:exec[[
--        create table if not exists DataWrongWordBuffer(
--            userId TEXT,
--            bookKey TEXT,
--            wordBuffer TEXT,
--            lastUpdate TEXT
--        );
--    ]]

function Manager.addWrongWordBuffer(newWordBuffer) -- newWordBuffer's format is like 'apple|pear|orange'
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    
    local num = 0
    local oldWordBuffer = ""
    for row in Manager.database:nrows("SELECT * FROM DataWrongWordBuffer WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        num = num + 1
        oldWordBuffer = row.wordBuffer
    end
    
    local wordList = {}
    if oldWordBuffer ~= "" then
        local oldWordList = split(oldWordBuffer, "|")
        for i = 1, #oldWordList do
            table.insert(wordList, oldWordList[i])
        end
    end
    if newWordBuffer ~= "" then
        local newWordList = split(newWordBuffer, "|")
        for i = 1, #newWordList do
            table.insert(wordList, newWordList[i])
        end
    end
    
    if #wordList >= MAXWRONGWORDCOUNT then
        local bossWordList = {}
        for i = 1, MAXWRONGWORDCOUNT do
            table.insert(bossWordList, wordList[1])
            table.remove(wordList, 1)
        end

        local bossWordListString = changeTableToString(bossWordList)
        Manager.addBossWord(bossWordListString)
    end
    
    local wordBufferString = changeTableToString(wordList)
    if num == 0 then
        local query = "INSERT INTO DataWrongWordBuffer VALUES ('"..userId.."', '"..bookKey.."', '"..wordBufferString.."', "..time..");"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataWrongWordBuffer SET wordBuffer = '"..wordBufferString.."', lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';"    
        Manager.database:exec(query)
    end
end


---- CREATE table Boss Word
--Manager.database:exec[[
--        create table if not exists DataBossWord(
--            userId TEXT,
--            bookKey TEXT,
--            bossID INTEGER,
--            typeIndex INTEGER,
--            wordList TEXT,
--            lastUpdate TEXT
--        );
--    ]]


function Manager.addBossWord(bossWordList)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    
    local maxBossID = 0
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if row.bossID > maxBossID then
            maxBossID = row.bossID
        end
    end
    
    local bossID = maxBossID + 1
    local typeIndex = 0
    
    local query = "INSERT INTO DataBossWord VALUES ('"..userId.."', '"..bookKey.."', "..bossID..", "..typeIndex..", '"..bossWordList.."', "..time..");"
    Manager.database:exec(query)
end


function Manager.getBossWord()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    
    local candidate = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';") do

    end
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


