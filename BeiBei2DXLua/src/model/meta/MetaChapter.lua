

local MetaChapter = class("MetaChapter", function()
    return {}
end)

function MetaChapter.create(book_key,
                        chapter_key,
--                        index,
                        ChapterImage,
                        BackImage,
                        NameImage,
                        Name)

    local obj = MetaChapter.new()

    obj.book_key = book_key
    obj.chapter_key = chapter_key
--    obj.index = index
    obj.ChapterImage = ChapterImage
    obj.BackImage = BackImage
    obj.NameImage = NameImage
    obj.Name = Name
    
    return obj
end

return MetaChapter
