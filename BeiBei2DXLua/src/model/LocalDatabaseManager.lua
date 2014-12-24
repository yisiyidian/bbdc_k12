local RBWORDNUM = 10
local MAXWRONGWORDCOUNT = 20


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
            lastUpdate TEXT
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
            lastUpdate TEXT
        );
    ]]
   
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


----NewStudyLayer_suffer------
function Manager.initNewStudyLayerSufferTables()
--    Manager.database:exec[[
--                DROP TABLE DataNewStudyLayerSuffer
--            ]]
    Manager.database:exec[[
        create table if not exists DataNewStudyLayerSuffer(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT,
            lastUpdate TEXT
        );
    ]]    
    
--    print("initNewStudyLayerSufferTables over")
end

function Manager.insertNewStudyLayerSufferTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lastUpdate = os.time()

    local query = "INSERT INTO DataNewStudyLayerSuffer VALUES ('"..userId.."', '"..bookKey.."', '"..wordName.."' ,'"..lastUpdate.."');"
    Manager.database:exec(query)

    local minlastUpdate
    local i = 1

    s_logd("<<DataNewStudyLayerSuffer --------------------------- begin")

    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if i == 1 then
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            print ("i is "..i)
            i = i + 1
            minlastUpdate = row.lastUpdate
        else
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            print ("i is "..i)
            i = i + 1
            if minlastUpdate > row.lastUpdate then
                minlastUpdate = row.lastUpdate
            end
        end
    end

    s_logd("DataNewStudyLayerSuffer --------------------------- end>>")

    local unfamiliarWord = '' 
    local currentWord = ''
    local loop_judge_min = 0
    local loop_delete_min = 0
    if i > MAXWRONGWORDCOUNT then
        while loop_delete_min < MAXWRONGWORDCOUNT do
            loop_judge_min = 0
            for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
                if loop_judge_min == 0 then
                    minlastUpdate = row.lastUpdate
                else
                    if minlastUpdate > row.lastUpdate then
                        minlastUpdate = row.lastUpdate
                    end
                end
                loop_judge_min = loop_judge_min + 1
            end

            --insert unfamiliar
            for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  lastUpdate = " .. minlastUpdate..";") do
                --                Manager.insertNewStudyLayerUnfamiliarTables(row.wordName)
                Manager.insertNewStudyLayerTestTables(row.wordName)

--                currentWord = row.wordName
            end
            
--            if loop_delete_min + 1 < MAXWRONGWORDCOUNT then
--               unfamiliarWord = unfamiliarWord .. currentWord.."|"
--            else
--                unfamiliarWord = unfamiliarWord .. currentWord
--            end
            --delete suffer
            local delete = Manager.database:exec(" delete from  DataNewStudyLayerSuffer where lastUpdate = " .. minlastUpdate..";")
            Manager.database:exec(delete) 
            loop_delete_min = loop_delete_min +1

            --        s_logd("DataNewStudyLayerSuffer --------------------------- begin")
            --
            --        for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            --                s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            --        end
            --
            --        s_logd("DataNewStudyLayerSuffer --------------------------- end")
        end
        --insert 
--        Manager.insertNewStudyLayerUnfamiliarTables(unfamiliarWord)
    end    



    --    Manager.database:exec[[
    --                DROP TABLE DataNewStudyLayerSuffer
    --            ]]

end

function Manager.selectLastNewStudyLayerSufferTables()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lasttime
    local i = 1
    print("selectLastNewStudyLayerSufferTables")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if i == 1 then
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            lasttime = row.lastUpdate
        else
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            if lasttime < row.lastUpdate then
                lasttime = row.lastUpdate
            end
        end
    end

    if i == 1 then 
        return 0
    else
        for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  lastUpdate = " .. lasttime..";") do
            return row.wordName
        end
    end

    print("selectLastNewStudyLayerSufferTables over")
end

function Manager.countLastNewStudyLayerSufferTables()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lasttime
    local i = 0
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerSuffer where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        i = i + 1
    end
    return i
end
----NewStudyLayer_suffer_over------
----NewStudyLayer_familiar------
function Manager.initNewStudyLayerFamiliarTables()
--    Manager.database:exec[[
--                DROP TABLE DataNewStudyLayerFamiliar
--            ]]
    Manager.database:exec[[
        create table if not exists DataNewStudyLayerFamiliar(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT,
            lastUpdate TEXT
        );
    ]]    
    
--    print("initNewStudyLayerFamiliarTables over")
end

function Manager.insertNewStudyLayerFamiliarTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lastUpdate = os.time()

    local query = "INSERT INTO DataNewStudyLayerFamiliar VALUES ('"..userId.."', '"..bookKey.."', '"..wordName.."' ,'"..lastUpdate.."');"
    Manager.database:exec(query)

    local i = 1
    s_logd("<<DataNewStudyLayerFamiliar --------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerFamiliar") do
        s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName .. ',' ..row.lastUpdate)
        print ("i is "..i)
        i = i + 1
    end
    s_logd("DataNewStudyLayerFamiliar --------------------------- end>>")

    
end

function Manager.selectLastNewStudyLayerFamiliarTables()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lasttime
    local i = 1
    print("selectLastNewStudyLayerFamiliarTables")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerFamiliar where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if i == 1 then
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            lasttime = row.lastUpdate
        else
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            if lasttime < row.lastUpdate then
                lasttime = row.lastUpdate
            end
        end
    end
   
    if i == 1 then 
        return 0
    else
        for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerFamiliar where  lastUpdate = " .. lasttime..";") do
            return row.wordName
        end
    end
    print("selectLastNewStudyLayerFamiliarTables over")
end

----NewStudyLayer_familiar_over------
----NewStudyLayer_unfamiliar------

function Manager.initNewStudyLayerUnfamiliarTables()

--    Manager.database:exec[[
--                DROP TABLE DataNewStudyLayerUnfamiliar
--            ]]
    Manager.database:exec[[
        create table if not exists DataNewStudyLayerUnfamiliar(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT,
            wordType INTEGER,
            lastUpdate TEXT            
        );
    ]]    
--    print("initNewStudyLayerUnfamiliarTables over")
    
end

function Manager.insertNewStudyLayerUnfamiliarTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local wordType = 1
    local lastUpdate = os.time()

    local query = "INSERT INTO DataNewStudyLayerUnfamiliar VALUES ('"..userId.."', '"..bookKey.."', '"..wordName.."','"..wordType.."','"..lastUpdate.."');"
    Manager.database:exec(query)

    local i = 1
    s_logd("<<DataNewStudyLayerUnfamiliar --------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerUnfamiliar") do
        s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.wordType.. ',' ..row.lastUpdate)
        print ("i is "..i)
        i = i + 1
    end
    s_logd("DataNewStudyLayerUnfamiliar --------------------------- end>>")
	
end

function Manager.selectLastNewStudyLayerUnfamiliarTables()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lasttime
    local i = 1
    print("selectLastNewStudyLayerUnfamiliarTables")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerUnfamiliar where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if i == 1 then
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            lasttime = row.lastUpdate
        else
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            if lasttime < row.lastUpdate then
                lasttime = row.lastUpdate
            end
        end
    end

    if i == 1 then 
        return 0
    else
        for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerUnfamiliar where  lastUpdate = " .. lasttime..";") do
            return row.wordName
        end
    end
    
    print("selectLastNewStudyLayerUnfamiliarTables over")
end

--not finish test
function Manager.updateLastNewStudyLayerUnfamiliarTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lastUpdate = os.time()
    

    print("updateLastNewStudyLayerUnfamiliarTables")
    
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerUnfamiliar where wordName = '"..wordName.."'") do
        if row.bookKey == s_CURRENT_USER.bookKey and row.userId == s_CURRENT_USER.objectId then
            -- update
            if row.wordType > 3 then
                local command = "DELETE FROM DataNewStudyLayerUnfamiliar where wordName = '"..wordName.."'"
                Manager.database:exec(command)
                Manager.insertNewStudyLayerFamiliarTables(wordName)
            else
                local command = "UPDATE DataNewStudyLayerUnfamiliar SET wordType = "..(row.wordType+1)..", lastUpdate = "..(os.time()).." where wordName = '"..wordName.."'"
                Manager.database:exec(command)
            end

        end
    end

    print("updateLastNewStudyLayerUnfamiliarTables over")
end



----NewStudyLayer_unfamiliar_over------

----NewStudyLayer_test_from_suffer----

function Manager.initNewStudyLayerTestTables()

--    Manager.database:exec[[
--                DROP TABLE DataNewStudyLayerTest
--            ]]
    Manager.database:exec[[
        create table if not exists DataNewStudyLayerTestTables(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT,
            lastUpdate TEXT            
        );
    ]]   
    
--    print("initNewStudyLayerTestTables over") 
end


function Manager.insertNewStudyLayerTestTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lastUpdate = os.time()

    local query = "INSERT INTO DataNewStudyLayerTestTables VALUES ('"..userId.."', '"..bookKey.."', '"..wordName.."','"..lastUpdate.."');"
    Manager.database:exec(query)

    local i = 1
    s_logd("<<DataNewStudyLayerTest --------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerTestTables") do
        s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
        print ("i is "..i)
        i = i + 1
    end
    s_logd("DataNewStudyLayerTest --------------------------- end>>")

end

function Manager.updateNewStudyLayerTestTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lastUpdate = os.time()
    
    print("updateDataNewStudyLayerTests")

--    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerTest where wordName = '"..wordName.."'") do
--        if row.bookKey == s_CURRENT_USER.bookKey and row.userId == s_CURRENT_USER.objectId then
            -- update
    local command = "UPDATE DataNewStudyLayerTestTables SET lastUpdate = "..(os.time()).." where wordName = '"..wordName.."'"
            Manager.database:exec(command)
--        end
--    end

    print("updateDataNewStudyLayerTests over")

end

function Manager.deleteNewStudyLayerTestTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lastUpdate = os.time()

    print("deleteDataNewStudyLayerTests")
    local delete = Manager.database:exec("DELETE FROM DataNewStudyLayerTestTables where wordName = '"..wordName.."'")
    Manager.database:exec(delete) 
    
--    print("wordName is "..wordName )

    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerTestTables") do
        s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
    end


    print("deleteDataNewStudyLayerTests over")

end

function Manager.selectFormerNewStudyLayerTestTables()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lasttime
    local i = 1
    print("selectFormerNewStudyLayerTestTables")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerTestTables where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        if i == 1 then
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            lasttime = row.lastUpdate
        else
            s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName.. ',' ..row.lastUpdate)
            i = i + 1
            if lasttime > row.lastUpdate then
                lasttime = row.lastUpdate
            end
        end
    end

    if i == 1 then 
        return 0
    else
        for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerTestTables where  lastUpdate = " .. lasttime..";") do
            return row.wordName
        end
    end

    print("selectFormerNewStudyLayerTestTables over")
end
function Manager.countFormerNewStudyLayerTestTables()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local lasttime
    local i = 0
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerTestTables where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
        i = i + 1
    end
    return i
end
----NewStudyLayer_test_from_suffer_over----
----NewStudyLayer_group_word_table----
function Manager.initNewStudyLayerGroupTables()

    Manager.database:exec[[
        create table if not exists DataNewStudyLayerGroupTables(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT         
        );
    ]]    

end

function Manager.insertNewStudyLayerGroupTables(wordName)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    local query = "INSERT INTO DataNewStudyLayerGroupTables VALUES ('"..userId.."', '"..bookKey.."', '"..wordName.."');"
    Manager.database:exec(query)

    local i = 1

    s_logd("<<DataNewStudyLayerGroupTables --------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerGroupTables where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do

        s_logd(row.userId .. ','..row.bookKey .. ',' ..row.wordName)
        i = i + 1
    end

    s_logd("DataNewStudyLayerGroupTables --------------------------- end>>")

    local unfamiliarWord = '' 
    local currentWord = ''
    local loop_delete_min = 0
    if i > MAXWRONGWORDCOUNT then
        for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerGroupTables where  userId = '"..userId.."' and bookKey = '"..bookKey.."';") do
            currentWord = row.wordName
            if loop_delete_min + 1 < MAXWRONGWORDCOUNT then
                unfamiliarWord = unfamiliarWord .. currentWord.."|"
            else
                unfamiliarWord = unfamiliarWord .. currentWord
            end    
            loop_delete_min = loop_delete_min +1
        end
        --delete suffer
        local delete = Manager.database:exec(" delete from  DataNewStudyLayerGroupTables ;")
        Manager.database:exec(delete) 

        --insert 
        Manager.insertNewStudyLayerUnfamiliarTables(unfamiliarWord)
    end    



    --    Manager.database:exec[[
    --                DROP TABLE DataNewStudyLayerSuffer
    --            ]]

end 
----NewStudyLayer_group_word_table_over----
----NewStudyLayer_data_table----
function Manager.initNewStudyLayerDataTables()

    Manager.database:exec[[
        create table if not exists DataNewStudyLayerDataTables(
            userId TEXT,
            bookKey TEXT,
            numberKey INTEGER         
        );
    ]]    

end

function Manager.insertNewStudyLayerDataTables(numberKey)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    local query = "INSERT INTO DataNewStudyLayerDataTables VALUES ('"..userId.."', '"..bookKey.."', '"..numberKey.."');"
    Manager.database:exec(query)

    local i = 1
    s_logd("<<DataNewStudyLayerTest --------------------------- begin")
    for row in Manager.database:nrows("SELECT * FROM DataNewStudyLayerDataTables") do
        s_logd(row.userId .. ','..row.bookKey .. ',' ..row.numberKey)
        print ("i is "..i)
        i = i + 1
    end
    s_logd("DataNewStudyLayerTest --------------------------- end>>")

end
----NewStudyLayer_data_table_over----


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
        local query = "INSERT INTO DataCurrentIndex VALUES ('"..userId.."', '"..bookKey.."', "..currentIndex..", '"..time.."');"
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
        local query = "INSERT INTO DataCurrentIndex VALUES ('"..userId.."', '"..bookKey.."', "..currentIndex..", '"..time.."');"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataCurrentIndex SET currentIndex = "..currentIndex..", lastUpdate = '"..time.."' WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';"    
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
        local query = "INSERT INTO DataNewPlayState VALUES ('"..userId.."', '"..bookKey.."', "..playModel..", '"..rightWordList.."', '"..wrongWordList.."', '"..wordCandidate.."', '"..time.."');"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataNewPlayState SET playModel = "..playModel..", rightWordList = '"..rightWordList.."', wrongWordList = '"..wrongWordList.."', wordCandidate = '"..wordCandidate.."', lastUpdate = '"..time.."' WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."';"    
        Manager.database:exec(query)
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


