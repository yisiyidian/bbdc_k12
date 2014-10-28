local DataClassBase = require('model/user/DataClassBase')

local DataWord = class("DataWord", function()
    return DataClassBase.new()
end)

function DataWord.create()
    local data = DataWord.new()
    return data
end

function DataWord:ctor()
    self.className = 'WMAV_UserWord'
    
    self.wordId = ''
    self.bookKey = ''
    self.status = 0
end

return DataWord
