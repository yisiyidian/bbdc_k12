
local MetaBook = class("MetaBook", function()
    return {}
end)

function MetaBook.create(key,
                        name,
                        words,
                        music)

    local obj = MetaBook.new()

    obj.key = key
    obj.name = name
    obj.words = words
    obj.music = music
    
    return obj
end

return MetaBook
