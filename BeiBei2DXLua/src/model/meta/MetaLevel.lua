

local MetaLevel = class("MetaLevel", function()
    return {}
end)

function MetaLevel.create(index, 
                        word_content,
                        summary_boss_drop, 
                        chapter_key, 
                        book_key, 
                        summary_boss_time, 
                        summary_boss_word,
                        summary_boss_hp, 
                        summary_boss_stars, 
                        type, 
                        level_key)

    local obj = MetaLevel.new()

    obj.index = index
    obj.word_content = word_content
    obj.summary_boss_drop = summary_boss_drop
    obj.chapter_key = chapter_key
    obj.book_key = book_key
    obj.summary_boss_time = summary_boss_time
    obj.summary_boss_word = summary_boss_word
    obj.summary_boss_hp = summary_boss_hp
    obj.summary_boss_stars = summary_boss_stars
    obj.type = type
    obj.level_key = level_key
    
    return obj
end

return MetaLevel
