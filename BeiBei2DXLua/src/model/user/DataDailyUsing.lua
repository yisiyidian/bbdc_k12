local DataClassBase = require('model.user.DataClassBase')

local DataDailyUsing = class("DataDailyUsing", function()
    return DataClassBase.new()
end)

function DataDailyUsing.create()
    local data = DataDailyUsing.new()
    return data
end

function DataDailyUsing:ctor()
    self.className = 'DataDailyUsing'
    self.startTime = 0 -- seconds
    self.usingTime = 0 -- seconds
end

function DataDailyUsing:isInited()
    return self.startTime > 0
end

function DataDailyUsing:isToday()
    return is2TimeInSameDay(self.startTime, os.time())
end

function DataDailyUsing:update(dt)
    self.usingTime = self.usingTime + dt
end

function DataDailyUsing:reset()
    -- if
    -- get data from local db
    -- else
    updateDataFromUser(self, s_CURRENT_USER)
    self.startTime = os.time() -- seconds
    self.usingTime = 0 -- seconds
end

return DataDailyUsing
