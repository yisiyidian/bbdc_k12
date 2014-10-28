local DataClassBase = require('model/user/DataClassBase')

local DataLevel = class("DataLevel", function()
    return DataClassBase.new()
end)

function DataLevel.create()
    local data = DataLevel.new()
    return data
end

function DataLevel:ctor()
    self.className = 'WMAV_LevelData'
    
    self.chapterKey = ''
    self.chapterIndex = 0
    self.levelKey = ''
    self.levelIndex = 0
    self.isLevelUnlocked = false
    self.isPlayed = false
    self.isPassed = false
    self.hearts = 0
    self.bookKey = ''

    self.version = 0
end

return DataLevel
