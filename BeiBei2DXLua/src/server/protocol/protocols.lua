local ProtocolBase = require('server.protocol.ProtocolBase')
local DataEverydayInfo          = require('model.user.DataEverydayInfo')
local DataDailyStudyInfo        = require('model.user.DataDailyStudyInfo')
local DataBossWord              = require('model.user.DataBossWord')

---------------------------------------------------------------------------------------------------

SKIP_WORDLIST = '1'
-- wordList : only for DataBossWord
local function dataTableToJSONString(dataTable, wordList)
    local str = '{'
    for key, value in pairs(dataTable) do  
        if (key == 'sessionToken'
            or key == 'password' 
            or key == 'className' 
            or key == 'createdAt' 
            or key == 'updatedAt' 
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if wordList ~= nil and wordList == key then
                if string.len(str) > 1 then str = str .. ',' end
                str = str .. '"' .. key .. '":"' .. SKIP_WORDLIST .. '"'
            else

                if (type(value) == 'string') then
                    if string.len(str) > 1 then str = str .. ',' end
                    str = str .. '"' .. key .. '":"' .. value .. '"'
                elseif (type(value) == 'boolean') then
                    if string.len(str) > 1 then str = str .. ',' end
                    str = str .. '"' .. key .. '":' .. tostring(value)
                elseif (type(value) ~= 'function' and type(value) ~= 'table') then
                    if string.len(str) > 1 then str = str .. ',' end
                    str = str .. '"' .. key .. '":' .. tostring(value)
                end
            
            end
        end
    end
    str = str .. '}'
    return str
end

---------------------------------------------------------------------------------------------------

-- callback(isExist, error)
function isUsernameExist(username, callback)
    local api = 'searchusername'
    local serverRequestType = SERVER_REQUEST_TYPE_NORMAL
    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas.count > 0, nil) end
        else
            if callback then callback(nil, error) end
        end
    end
    local protocol = ProtocolBase.create(api, serverRequestType, {['username']=username}, cb)
    protocol:request()
end

-- localDBUser is newer than serverUser
-- callback(updatedAt, error)
function synUserAfterLogIn(localDBUser, serverUser, callback)
    local api = 'synuserafterlogin'
    local serverRequestType = SERVER_REQUEST_TYPE_CLIENT_ENCODE
    
    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas.updatedAt, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local data = {}
    for key, value in pairs(localDBUser) do
        if type(value) ~= 'function' 
            and type(value) ~= 'table' 
            and key ~= 'sessionToken'
            and key ~= 'objectId' 
            and key ~= 'password' 
            and key ~= 'createdAt' 
            and key ~= 'updatedAt' then
            if localDBUser[key] ~= serverUser[key] then data[key] = localDBUser[key] end
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, data, cb)
    protocol:request()
end

---------------------------------------------------------------------------------------------------

-- callback : function (serverDatas, error)
function getNotContainedInLocalDatasFromServer(className, sqlCondition, callback)
    if not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then 
        if callback then callback(nil, nil) end
        return
    end

    local api = 'getNotContainedInLocalDatas'
    local serverRequestType = math['or'](SERVER_REQUEST_TYPE_CLIENT_ENCODE, SERVER_REQUEST_TYPE_CLIENT_DECODE)

    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local objectIds = '['
    local i = 0
    local function handleDBData(row)
        if row.objectId ~= nil and row.objectId ~= '' then
            if i > 0 then objectIds = objectIds .. ',' end
            objectIds = objectIds .. '"' .. row.objectId .. '"'
        end
    end
    s_LocalDatabaseManager.getDatas(className, 
                                    s_CURRENT_USER.objectId, 
                                    s_CURRENT_USER.username, 
                                    handleDBData, 
                                    sqlCondition)
    objectIds = objectIds .. ']'

    local protocol = ProtocolBase.create(api, serverRequestType, {['className']=className, ['bookKey']=s_CURRENT_USER.bookKey, ['objectIds']=objectIds}, cb)
    protocol:request()
end

---------------------------------------------------------------------------------------------------

-- 1 data
-- DataLevelInfo
-- DataCurrentIndex 
function sysLevelInfo(clientData, callback)
    if not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then 
        if callback then callback(nil, nil) end
        return
    end

    local api = 'syslevelinfo'
    local serverRequestType = math['or'](SERVER_REQUEST_TYPE_CLIENT_ENCODE, SERVER_REQUEST_TYPE_CLIENT_DECODE)

    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, {['className']='DataLevelInfo', ['info']=dataTableToJSONString(clientData)}, cb)
    protocol:request()
end

---------------------------------------------------------------------------------------------------

-- 1 data/week
-- DataEverydayInfo
function sysEverydayInfo(unsavedWeeks, currentWeek, callback)
    local api = 'syseverydayinfo'
    local serverRequestType = math['or'](SERVER_REQUEST_TYPE_CLIENT_ENCODE, SERVER_REQUEST_TYPE_CLIENT_DECODE)

    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local dataTable = {}
    if unsavedWeeks ~= nil then
        for i, v in ipairs(unsavedWeeks) do
            table.insert(dataTable, dataTableToJSONString(v))
        end
    end
    local current = ''
    if currentWeek ~= nil then current = dataTableToJSONString(currentWeek) end
    
    local protocol = ProtocolBase.create(api, serverRequestType, {['className']='DataEverydayInfo', ['uw']=dataTable, ['crt']=current}, cb)
    protocol:request()
end

function checkInEverydayInfo()
    local currentWeek = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
    currentWeek:checkIn(os.time())

    local function cb (currentWeek)
        s_LocalDatabaseManager.saveDataClassObject(currentWeek, currentWeek.userId, currentWeek.username, " and week = " .. tostring(currentWeek.week))
        s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas] = currentWeek
    end

    if not (s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()) then    
        cb(currentWeek)
        return
    end

    sysEverydayInfo(nil, currentWeek, function (serverDatas, error) 
        if error == nil and serverDatas ~= nil then
            for i, v in ipairs(serverDatas) do
                parseServerDataToClientData(v, currentWeek)
            end
        end
        cb(currentWeek)
    end)
end

local function resetLocalEverydayInfos()
    s_CURRENT_USER.logInDatas = {}
    s_LocalDatabaseManager.getDatas('DataEverydayInfo', 
                        s_CURRENT_USER.objectId, 
                        s_CURRENT_USER.username, 
                        function (row)
                            local data = DataEverydayInfo.create()
                            parseLocalDBDataToClientData(row, data)
                            table.insert(s_CURRENT_USER.logInDatas, data)
                        end, 
                        'order by week')
    print('>>> resetLocalEverydayInfos')
    print_lua_table(s_CURRENT_USER.logInDatas)
    print('<<< resetLocalEverydayInfos')
end
function getNotContainedInLocalEverydayInfosFromServer(callback)
    getNotContainedInLocalDatasFromServer('DataEverydayInfo', nil, function (serverDatas, error)
        if error == nil then
            if serverDatas ~= nil then
                for i, v in ipairs(serverDatas) do 
                    local data = DataEverydayInfo.create()
                    parseServerDataToClientData(v, data)
                    s_LocalDatabaseManager.saveDataClassObject(data, s_CURRENT_USER.userId, s_CURRENT_USER.username, " and week = " .. tostring(data.week))
                end
            end
            resetLocalEverydayInfos()
            if callback then callback(serverDatas, nil) end
        else
            resetLocalEverydayInfos()
            if callback then callback(nil, error) end
        end
    end)
end

---------------------------------------------------------------------------------------------------

-- 1 data/day/book

-- unsavedDays: DataDailyStudyInfo table
-- callback : function (serverDatas, error)
function sysDailyStudyInfo(unsavedDays, callback)
    local api = 'sysdailystudyinfo'
    local serverRequestType = math['or'](SERVER_REQUEST_TYPE_CLIENT_ENCODE, SERVER_REQUEST_TYPE_CLIENT_DECODE)

    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local dataTable = {}
    if unsavedDays ~= nil then
        for k, v in pairs(unsavedDays) do
            table.insert(dataTable, dataTableToJSONString(v))
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, {['className']='DataDailyStudyInfo', ['bookKey']=s_CURRENT_USER.bookKey, ['us']=dataTable}, cb)
    protocol:request()
end

-- data : DataDailyStudyInfo
-- callback : function (data, error)
-- save data to server and update local database
function saveDailyStudyInfoToServer(data, callback)
    if not (s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()) then
        if callback then callback(data, nil) end
        return
    end

    sysDailyStudyInfo({['1']=data}, function (serverDatas, error)
        if error == nil then
            if serverDatas ~= nil then
                for i, v in ipairs(serverDatas) do
                    if data.dayString == v.dayString then
                        parseServerDataToClientData(v, data)
                        s_LocalDatabaseManager.saveDataClassObject(data, data.userId, data.username, " and bookKey = '".. s_CURRENT_USER.bookKey .."' and dayString = '".. data.dayString .."' ;")
                        break
                    end
                end
            end
            if callback then callback(data, nil) end
        else
            if callback then callback(nil, error) end
        end
    end)
end

function getNotContainedInLocalDailyStudyInfoFromServer(callback)
    getNotContainedInLocalDatasFromServer('DataDailyStudyInfo', " and bookKey = '".. s_CURRENT_USER.bookKey .. "' ", function (serverDatas, error)
        if error == nil then
            if serverDatas ~= nil then
                for i, v in ipairs(serverDatas) do 
                    local data = DataDailyStudyInfo.create()
                    parseServerDataToClientData(v, data)
                    s_LocalDatabaseManager.saveDataClassObject(data, s_CURRENT_USER.userId, s_CURRENT_USER.username, " and bookKey = '".. s_CURRENT_USER.bookKey .."' and dayString = '".. data.dayString .."' ;")
                end
            end
            if callback then callback(serverDatas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end)
end

---------------------------------------------------------------------------------------------------

-- 20 words, book
-- DataBossWord

-- bosses: DataDailyStudyInfo table
-- callback : function (serverDatas, error)
function sysBossWord(bosses, skipWordList, callback)
    if not (s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()) then
        if callback then callback(nil, nil) end
        return
    end

    local api = 'sysbossword'
    local serverRequestType = math['or'](SERVER_REQUEST_TYPE_CLIENT_ENCODE, SERVER_REQUEST_TYPE_CLIENT_DECODE)

    local skips = {}
    local function cb (result, error)
        if error == nil then
            if result.datas ~= nil then
                for i, v in ipairs(result.datas) do
                    if v.wordList == SKIP_WORDLIST and skips[v.bossID] ~= nil then
                        v.wordList = skips[v.bossID].wordList
                    end
                end
            end

            if callback then callback(result.datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local unsavedDataTable = {}
    if bosses ~= nil then
        for k, v in pairs(bosses) do
            if skipWordList then
                table.insert(unsavedDataTable, dataTableToJSONString(v, 'wordList'))
            else
                local wordCount = #split(v.wordList, "|")
                if wordCount == s_max_wrong_num_everyday and v.savedToServer == 0 then
                    table.insert(unsavedDataTable, dataTableToJSONString(v))
                else
                    table.insert(unsavedDataTable, dataTableToJSONString(v, 'wordList'))
                end
            end
            skips[v.bossID] = v
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, {['className']='DataBossWord', ['bookKey']=s_CURRENT_USER.bookKey, ['us']=unsavedDataTable}, cb)
    protocol:request()
end

-- callback : function (serverDatas, error)
function saveWordBossToServer(clientData, skipWordList, callback)
    sysBossWord({['1']=clientData}, skipWordList, callback)
end

function getNotContainedInLocalBossWordFromServer(callback)
    getNotContainedInLocalDatasFromServer('DataBossWord', " and bookKey = '".. s_CURRENT_USER.bookKey .. "' ", function (serverDatas, error)
        if error == nil then
            if serverDatas ~= nil then
                for i, v in ipairs(serverDatas) do 
                    local data = DataBossWord.create()
                    parseServerDataToClientData(v, data)
                    s_LocalDatabaseManager.saveDataClassObject(data, s_CURRENT_USER.userId, s_CURRENT_USER.username, " and bookKey = '".. s_CURRENT_USER.bookKey .."' and bossID = '".. data.bossID .."' ;")
                end
            end
            if callback then callback(serverDatas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end)
end

---------------------------------------------------------------------------------------------------

-- dataTable = {['className']=className, ['objectId']=objectId, ...}
-- callback(datas, error)
function saveToServer(dataTable, callback)
    if not (s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()) then
        if callback then callback(dataTable, nil) end
        return
    end

    local api = 'savetoserver'
    local serverRequestType = math['or'](SERVER_REQUEST_TYPE_CLIENT_ENCODE, SERVER_REQUEST_TYPE_CLIENT_DECODE)

    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, dataTable, cb)
    protocol:request()
end

-- callback(datas, error)
function saveUserToServer(dataTable, callback)
    local function cb (datas, error)
        s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER)
        if error == nil then
            if callback then callback(datas, nil) end
        else
            if callback then callback(nil, error) end
        end
    end

    local userdata = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId}
    for key, value in pairs(dataTable) do
        if (key == 'sessionToken'
            or key == 'password' 
            or key == 'className' 
            or key == 'createdAt' 
            or key == 'updatedAt' 
            or string.find(key, '__') ~= nil 
            or value == nil) == false 
            and (type(value) ~= 'function' and type(value) ~= 'table') then 

            userdata[key] = value

        end
    end
    saveToServer(userdata, cb)    
end


