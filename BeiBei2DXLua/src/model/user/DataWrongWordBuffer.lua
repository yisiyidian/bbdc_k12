local DataClassBase = require('model.user.DataClassBase')

-- record count == book count
-- 保存错词缓冲池

local DataWrongWordBuffer = class("DataWrongWordBuffer", function()
    return DataClassBase.new()
end)

function DataWrongWordBuffer.create()
    local data = DataWrongWordBuffer.new()
    return data
end

function DataWrongWordBuffer:ctor()
    self.className = 'DataWrongWordBuffer'
    
    self.bookKey = ''
    self.lastUpdate = 0

    self.wordNum = 0
    self.wordBuffer = ''
end

return DataWrongWordBuffer
