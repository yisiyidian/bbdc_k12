

local MetaDailyCheckIn = class("MetaDailyCheckIn", function()
    return {}
end)

function MetaDailyCheckIn.create(day,
                        itemKey,
                        count,
                        default_word)

    local obj = MetaDailyCheckIn.new()

    obj.day = day
    obj.itemKey = itemKey
    obj.count = count
    obj.default_word = default_word
    
    return obj
end

return MetaDailyCheckIn
