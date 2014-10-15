
local MetaBook = class("MetaBook", function()
    return {}
end)

function MetaBook.create(key,
                        name,
                        words,
                        color_r,
                        color_g,
                        color_b,
                        figureName,
                        progressColor_r,
                        progressColor_g,
                        progressColor_b)

    local obj = MetaBook.new()

    obj.key = key
    obj.name = name
    obj.words = words
    obj.color_r = color_r
    obj.color_g = color_g
    obj.color_b = color_b
    obj.figureName = figureName
    obj.progressColor_r = progressColor_r
    obj.progressColor_g = progressColor_r
    obj.progressColor_b = progressColor_g
    
    return obj
end

return MetaBook
