local DataClassBase = require('model.user.DataClassBase')

local DataUnknownWordTask = class("DataUnknownWordTask", function()
    return DataClassBase.new()
end)

function DataUnknownWordTask.create()
    local data = DataUnknownWordTask.new()
    return data
end

function DataUnknownWordTask:ctor()
    self.className = 'DataUnknownWordTask'
    
    self.bookKey = ''
    self.index = -1
    self.first = -1
    self.last = -1
    self.lastUpdate = 0
end

return DataUnknownWordTask
