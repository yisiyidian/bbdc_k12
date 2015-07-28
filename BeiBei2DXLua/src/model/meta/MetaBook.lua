
local MetaBook = class("MetaBook", function()
    return {}
end)

function MetaBook.create(key,
                        name,
                        words,
                        music,
                        type)

    local obj = MetaBook.new()

    obj.key = key
    obj.name = name
    obj.words = words
    obj.music = music
    obj.type = type
    
    return obj
end

return MetaBook
