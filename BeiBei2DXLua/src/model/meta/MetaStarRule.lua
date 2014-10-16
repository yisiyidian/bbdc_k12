
local MetaStarRule = class("MetaStarRule", function()
    return {}
end)

function MetaStarRule.create(word_num,
                        star_1,
                        star_2,
                        star_3)

    local obj = MetaStarRule.new()

    obj.word_num = word_num
    obj.star_1 = star_1
    obj.star_2 = star_2
    obj.star_3 = star_3
    
    return obj
end

return MetaStarRule
