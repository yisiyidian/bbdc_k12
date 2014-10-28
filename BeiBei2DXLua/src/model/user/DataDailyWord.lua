local DataClassBase = require('model/user/DataClassBase')

local DataDailyWord = class("DataDailyWord", function()
    return DataClassBase.new()
end)

function DataDailyWord.create()
    local data = DataDailyWord.new()
    return data
end

function DataDailyWord:ctor()
    self.className = 'WMAV_ICDailyWordData'
    
    self.bookKey = ''
    self.learnedDate = nil
    self.learnedWordCount = 0
end

return DataDailyWord
