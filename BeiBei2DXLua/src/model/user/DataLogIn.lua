local DataLogIn = class("DataLogIn", function()
    return {}
end)

function DataLogIn.create()
    local data = DataLogIn.new()
    data.userId = ''
    data.Monday = nil
    data.Tuesday = nil
    data.Wednesday = nil
    data.Thursday = nil
    data.Friday = nil
    data.Saturday = nil
    data.Sunday = nil
    data.week = nil
    return data
end

return DataLogIn
