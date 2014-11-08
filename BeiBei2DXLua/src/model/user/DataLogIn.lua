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
    
    self.Monday = 0
    self.Tuesday = 0
    self.Wednesday = 0
    self.Thursday = 0
    self.Friday = 0
    self.Saturday = 0
    self.Sunday = 0
    self.week = 0
end

return DataLogIn
