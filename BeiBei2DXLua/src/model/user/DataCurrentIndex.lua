local DataClassBase = require('model.user.DataClassBase')

-- record count == book count
-- 代表书中背单词的进度

local DataCurrentIndex = class("DataCurrentIndex", function()
    return DataClassBase.new()
end)

function DataCurrentIndex.create()
    local data = DataCurrentIndex.new()
    return data
end

function DataCurrentIndex:ctor()
    self.className = 'DataCurrentIndex'
    
    self.bookKey = ''
    self.lastUpdate = 0
    self.currentIndex = 0
end

return DataCurrentIndex
