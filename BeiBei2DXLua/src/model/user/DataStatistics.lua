local DataClassBase = require('model/user/DataClassBase')

local DataStatistics = class("DataStatistics", function()
    return DataClassBase.new()
end)

function DataStatistics.create()
    local data = DataStatistics.new()
    return data
end

function DataStatistics:ctor()
    self.className = 'DataStatistics'
    
    self.bookkey = ''
    self.bookWordNum = 0
    self.learnedWordCount = 0
    self.masteredWordCount = 0
    self.learnedDays = 0
end

return DataStatistics
