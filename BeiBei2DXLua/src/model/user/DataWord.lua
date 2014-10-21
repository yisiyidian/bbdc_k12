local DataClassBase = require('model/user/DataClassBase')

local DataWord = class("DataWord", function()
    return DataClassBase.new()
end)

function DataWord.create()
    local data = DataWord.new()
    data.userId = ''
    data.wordId = ''
    data.bookKey = ''
    data.status = 0

    return data
end

function DataWord:ctor()
    self.wordId = ''
    self.bookKey = ''
    self.status = 0
end

return DataWord
