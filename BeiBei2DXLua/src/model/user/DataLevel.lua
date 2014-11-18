local DataClassBase = require('model/user/DataClassBase')

local DataLevel = class("DataLevel", function()
    return DataClassBase.new()
end)

function DataLevel.create()
    local data = DataLevel.new()
    return data
end

function DataLevel:ctor()
    self.className = 'DataLevel'
    
    self.chapterKey = ''
--    self.chapterIndex = 0
    self.levelKey = ''
--    self.levelIndex = 0
    self.isLevelUnlocked = 0
    self.isPlayed = 0
    self.isPassed = 0
    self.stars = 0
--    self.hearts = 0
    self.bookKey = ''

    self.version = 0
end

return DataLevel
