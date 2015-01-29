local ProtocolBase = require('server.protocol.ProtocolBase')

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

    local data = {['objectId']=localDBUser.objectId}
    for key, value in pairs(localDBUser) do
        if type(value) ~= 'function' 
            and type(value) ~= 'table' 
            and key ~= 'sessionToken' 
            and key ~= 'password' 
            and key ~= 'createdAt' 
            and key ~= 'updatedAt' then
            if localDBUser[key] ~= serverUser[key] then data[key] = localDBUser[key] end
        end
    end

    local protocol = ProtocolBase.create(api, serverRequestType, data, cb)
    protocol:request()
end
-- DataStudyConfiguration -- User

-- 1 data/book
-- DataCurrentIndex 

function syn( ... )

end

-- 1 data
-- DataLevelInfo

-- 1 data/day
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

-- 1 data/day/book
-- DataDailyStudyInfo

-- 20 words, book
-- DataBossWord


-- XXX DataNewPlayState
-- XXX DataTodayReviewBossNum
-- XXX DataWrongWordBuffer

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
