local DataWord = class("DataWord", function()
    return {}
end)

function DataWord.create()
    local data = DataWord.new()
    data.userId = ''
    data.wordId = ''
    data.bookKey = ''
    data.status = 0

    return data
end

return DataWord
