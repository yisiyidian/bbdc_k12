local ProtocolBase = require('server.protocol.ProtocolBase')

---------------------------------------------------------------------------------------------------

local function dataTableToJSONString(dataTable)
    local str = '{'
    for key, value in pairs(dataTable) do  
        if (key == 'sessionToken'
            or key == 'password' 
            or key == 'className' 
            or key == 'createdAt' 
            or key == 'updatedAt' 
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

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

function syn( ... )

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
        for i, v in ipairs(unsavedDays) do
            table.insert(dataTable, dataTableToJSONString(v))
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, {['className']='DataDailyStudyInfo', ['us']=dataTable}, cb)
    protocol:request()
end

-- data : DataDailyStudyInfo
-- callback : function (data, error)
function saveDailyStudyInfoToServer(data, callback)
    sysDailyStudyInfo({['1']=data}, function (serverDatas, error)
        if error == nil then
            -- if serverDatas ~= nil then
            --     for i, v in ipairs(serverDatas) do
            --         parseServerDataToClientData(v, data)
            --         s_LocalDatabaseManager.saveDataClassObject(data, data.userId, data.username, " and dayString = " .. tostring(data.dayString))
            --     end
            -- end
            if callback then callback(data, nil) end
        else
            if callback then callback(nil, error) end
        end
    end)
end

---------------------------------------------------------------------------------------------------

-- 20 words, book
-- DataBossWord

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
