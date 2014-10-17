local DataDailyCheckIn = class("DataDailyCheckIn", function()
    return {}
end)

function DataDailyCheckIn.create()
    local data = DataDailyCheckIn.new()
    data.userId = ''
    data.dailyCheckInAwards = 0
    data.updatedAt = nil
    return data
end

return DataDailyCheckIn
