

local MetaItem = class("MetaItem", function()
    return {}
end)

function MetaItem.create(key, type)

    local obj = MetaItem.new()

    obj.key = key
    obj.type = type
    obj.count = count
    obj.default_word = default_word
    
    return obj
end

return MetaItem
