
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

    -- iso8601
    -- 2014-09-12T14:10:12.495Z
    local Y = string.sub(srcDateTime,1,4)  
    local M = string.sub(srcDateTime,6,7)  
    local D = string.sub(srcDateTime,9,10)  
    local H = string.sub(srcDateTime,12,13)  
    local MM = string.sub(srcDateTime,15,16)  
    local SS = string.sub(srcDateTime,18,19)  
    local ms = string.sub(srcDateTime, 21, string.len(srcDateTime) - 1)
    
    local t = os.time{year=Y, month=M, day=D, hour=(H+loh), min=(MM+lom), sec=SS} 
    return t + ms / 1000.0
end

function parseServerDataToUserData(serverdata, userdata)
    for key, value in pairs(userdata) do
        if nil ~= serverdata[key] then
            if (key == 'createdAt' or key == 'updatedAt') and type(serverdata[key]) == 'string' then
                userdata[key] = getSecondsFromString(serverdata[key])
            else
                userdata[key] = serverdata[key]
            end
        end
    end
end

local DataClassBase = class("DataClassBase", function()
    return {}
end)

function DataClassBase.create()
    local data = DataClassBase.new()
    return data
end

function DataClassBase:ctor()
    self.objectId = ''
    self.userId = ''
    self.createdAt = os.time()
    self.updatedAt = 0
end

return DataClassBase
