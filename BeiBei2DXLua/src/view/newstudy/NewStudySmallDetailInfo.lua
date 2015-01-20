

local SmallWordDetailInfo = class("SmallWordDetailInfo", function()
    return cc.Layer:create()
end)

function SmallWordDetailInfo.create(word)
    -- system variate

    local height = 750

    local main = SmallWordDetailInfo.new()
    main:setContentSize(s_DESIGN_WIDTH, height)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)


    local label_wordname
    local label_wordmeaning
    local sprite_split
    local label_sentenceen
    local label_sentencecn
    local label_sentenceen2
    local label_sentencecn2

    local index_y = height
    local text_length = 500
    local left = (s_DESIGN_WIDTH - text_length)/2

    local meanings = split(word.wordMeaning, "|||")
    for i = 1, #meanings do
        label_wordmeaning = cc.Label:createWithSystemFont(meanings[i],"",28)
        label_wordmeaning:setAnchorPoint(0,1)
        label_wordmeaning:setColor(cc.c4b(0,0,0,255))
        label_wordmeaning:setDimensions(text_length,0)
        label_wordmeaning:setAlignment(0)
        label_wordmeaning:setPosition(left, index_y)
        main:addChild(label_wordmeaning)
        index_y = index_y - label_wordmeaning:getContentSize().height - 10 
    end

    -- add sprite for split
    sprite_split = cc.Sprite:create("image/studyscene/studyscene_detailinfo_splitline.png")
    sprite_split:setAnchorPoint(0.5,1)
    sprite_split:setPosition(s_DESIGN_WIDTH/2, index_y)
    main:addChild(sprite_split)
    index_y = index_y - sprite_split:getContentSize().height - 10
    
    
    
--    label_hint = cc.Label:createWithSystemFont("这个词太熟悉了？如果希望放弃复习，点击下一个按钮将它收入你的熟词库吧。","",28)
--    label_hint:setAnchorPoint(0,1)
--    label_hint:setColor(cc.c4b(0,0,0,255))
--    label_hint:setDimensions(text_length,0)
--    label_hint:setAlignment(0)
--    label_hint:setPosition(left, index_y)
--    main:addChild(label_hint)
--    index_y = index_y - label_hint:getContentSize().height - 10 

    return main
end


return SmallWordDetailInfo







