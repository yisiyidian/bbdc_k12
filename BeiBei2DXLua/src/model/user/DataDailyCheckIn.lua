local DataClassBase = require('model.user.DataClassBase')

local DataDailyCheckIn = class("DataDailyCheckIn", function()
    return DataClassBase.new()
end)

function DataDailyCheckIn.create()
    local data = DataDailyCheckIn.new()
    return data
end

function DataDailyCheckIn:ctor()
    self.className = 'DataDailyCheckIn'
    
    self.dailyCheckInAwards = 0
end

return DataDailyCheckIn
