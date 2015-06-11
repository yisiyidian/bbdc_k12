
function getSecondsFromString(srcDateTime)  
    -- Compute the difference in seconds between local time and UTC.
    local function get_timezone()
      local now = os.time()
      return os.difftime(now, os.time(os.date("!*t", now)))
    end
    local timezone = get_timezone()

    -- Return a timezone string in ISO 8601:2000 standard form (+hhmm or -hhmm)
    local function get_tzoffset(timezone)
      local h, m = math.modf(timezone / 3600)
      return h, m
    end
    local loh, lom = get_tzoffset(timezone)

    if string.find(srcDateTime, 'GMT') ~= nil or string.find(srcDateTime, 'CST') ~= nil or string.find(srcDateTime, '%(') ~= nil then
        -- Sun Mar 01 2015 07:56:45 GMT+0000 (CST)
        -- 123456789012345678901234567890
        local Y  = string.sub(srcDateTime,  12,  15)  
        local M  = string.sub(srcDateTime,  5,  7)  
        local D  = string.sub(srcDateTime,  9, 10)  
        local H  = string.sub(srcDateTime, 17, 18)  
        local MM = string.sub(srcDateTime, 20, 21)  
        local SS = string.sub(srcDateTime, 23, 24) 
        local months = { Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12 }
        local t = os.time{year=Y, month=months[M], day=D, hour=(H+loh), min=(MM+lom), sec=SS} 
        return t
    else
        -- iso8601
        -- 2014-09-12T14:10:12.495Z
        local Y  = string.sub(srcDateTime,  1,  4)  
        local M  = string.sub(srcDateTime,  6,  7)  
        local D  = string.sub(srcDateTime,  9, 10)  
        local H  = string.sub(srcDateTime, 12, 13)  
        local MM = string.sub(srcDateTime, 15, 16)  
        local SS = string.sub(srcDateTime, 18, 19)  
        local ms = string.sub(srcDateTime, 21, string.len(srcDateTime) - 1)
        
        local t = os.time{year=Y, month=M, day=D, hour=(H+loh), min=(MM+lom), sec=SS} 
        return t + ms / 1000.0
    end
end

function getLocalSeconds()
    return os.time()
end

function parseServerDataToClientData(serverdata, userdata)
    print("DataClassBase parseServerDataToClientData")
    dump(serverdata)
    if serverdata == nil or userdata == nil then return end
    
    for key, value in pairs(userdata) do
        if type(value) ~= 'function' 
            and type(value) ~= 'table' 
            and key ~= 'sessionToken' 
            and key ~= 'BEANSKEY'
            and key ~= 'password' 
            and key ~= 'appVersion' 
            and nil ~= serverdata[key] then
            if (key == 'createdAt' or key == 'updatedAt') and type(serverdata[key]) == 'string' then
                userdata[key] = getSecondsFromString(serverdata[key])
            else
                userdata[key] = serverdata[key]
            end
        end
    end

    if userdata['userId'] ~= nil and type(userdata['userId']) == 'string' and string.len(userdata['userId']) <= 0 then
        userdata['userId'] = s_CURRENT_USER.objectId
    end
    dump(userdata)
end

function parseLocalDBDataToClientData(localdb, userdata)
    for key, value in pairs(localdb) do
        userdata[key] = localdb[key]
    end
end

function dataToJSONString(dataObj)
    local str = '{'
    for key, value in pairs(dataObj) do  
        if (key == 'objectId'
            or key == 'sessionToken'
            or key == 'BEANSKEY'
            or key == 'password' 
            or key == 'createdAt' 
            or key == 'updatedAt' 
            or key == 'className' 
            or key == 'expires_in' 
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if (type(value) == 'string') then
                if string.len(str) > 1 then str = str .. ',' end
                str = str .. '"' .. key .. '":"' .. value .. '"'
            elseif (type(value) == 'boolean') then
                if string.len(str) > 1 then str = str .. ',' end
                -- local b = 0
                -- if value == true then b = 1 end
                -- str = str .. '"' .. key .. '":' .. b
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

function updateDataFromUser(data, user)
    data.userId = user.objectId
    data.username = user.username
end

------------------------------------------------------------------------------------------

local DataClassBase = class("DataClassBase", function()
    return {}
end)

function DataClassBase.create()
    local data = DataClassBase.new()
    return data
end

function DataClassBase:ctor()
    self.className = ''
    self.objectId = ''
    self.userId = ''
    self.username = ''
    self.createdAt = os.time()
    self.updatedAt = 0
end

return DataClassBase
