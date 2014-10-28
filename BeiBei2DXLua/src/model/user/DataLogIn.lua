local DataClassBase = require('model/user/DataClassBase')

local DataLogIn = class("DataLogIn", function()
    return DataClassBase.new()
end)

function DataLogIn.create()
    local data = DataLogIn.new()
    return data
end

function DataLogIn:ctor()
    self.className = 'WMAV_LogInDateData'
    
    self.Monday = nil
    self.Tuesday = nil
    self.Wednesday = nil
    self.Thursday = nil
    self.Friday = nil
    self.Saturday = nil
    self.Sunday = nil
    self.week = nil
end

return DataLogIn
