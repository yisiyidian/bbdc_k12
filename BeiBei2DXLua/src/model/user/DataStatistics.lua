local DataStatistics = class("DataStatistics", function()
    return {}
end)

function DataStatistics.create()
    local data = DataStatistics.new()
    data.userId = ''
    data.bookkey = ''
    data.bookWordNum = 0
    data.learnedWordCount = 0
    data.masteredWordCount = 0
    data.learnedDays = 0
    return data
end

return DataStatistics
