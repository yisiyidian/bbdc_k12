local DataClassBase = require('model.user.DataClassBase')

local DataWordProciency = class("DataWordProciency", function()
    return DataClassBase.new()
end)

function DataWordProciency.create()
    local data = DataWordProciency.new()
    return data
end

function DataWordProciency:ctor()
    self.className = 'DataWordProciency'
    
    self.wordName = ''
    self.bookKey = ''
    self.prociencyValue = 0
end

return DataWordProciency
