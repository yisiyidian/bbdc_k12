local DataLevel = class("DataLevel", function()
    return {}
end)

function DataLevel.create()
    local data = DataLevel.new()
    data.userId = ''
    data.chapterKey = ''
    data.chapterIndex = 0
    data.levelKey = ''
    data.levelIndex = 0
    data.isLevelUnlocked = false
    data.isPlayed = false
    data.isPassed = false
    data.hearts = 0
    data.bookKey = ''

    data.version = 0
    return data
end

return DataLevel
