local DataDailyWord = class("DataDailyWord", function()
    return {}
end)

function DataDailyWord.create()
    local data = DataDailyWord.new()
    data.userId = ''
    data.bookKey = ''
    data.learnedDate = nil
    data.learnedWordCount = 0
    return data
end

return DataDailyWord
