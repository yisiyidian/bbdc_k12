

local WordDetailInfo = class("WordDetailInfo", function()
    return cc.Layer:create()
end)

function WordDetailInfo.create(word)
    -- system variate

    local height = 750

    local main = WordDetailInfo.new()
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

    label_wordname = cc.Label:createWithSystemFont(word.wordName,"",40)
    label_wordname:setAnchorPoint(0,1)
    label_wordname:setColor(cc.c4b(0,0,0,255))
    label_wordname:setDimensions(text_length,0)
    label_wordname:setAlignment(0)
    label_wordname:setPosition(left, index_y)
    main:addChild(label_wordname)
    index_y = index_y - label_wordname:getContentSize().height - 10

    -- add sprite for split
    sprite_split = cc.Sprite:create("image/studyscene/studyscene_detailinfo_splitline.png")
    sprite_split:setAnchorPoint(0.5,1)
    sprite_split:setPosition(s_DESIGN_WIDTH/2, index_y)
    main:addChild(sprite_split)
    index_y = index_y - sprite_split:getContentSize().height - 10

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

    label_sentenceen = cc.Label:createWithSystemFont(word.sentenceEn,"",28)
    label_sentenceen:setAnchorPoint(0,1)
    label_sentenceen:setColor(cc.c4b(0,0,0,255))
    label_sentenceen:setDimensions(text_length,0)
    label_sentenceen:setAlignment(0)
    label_sentenceen:setPosition(left, index_y)
    main:addChild(label_sentenceen)
    index_y = index_y - label_sentenceen:getContentSize().height - 10

    label_sentencecn = cc.Label:createWithSystemFont(word.sentenceCn,"",28)
    label_sentencecn:setAnchorPoint(0,1)
    label_sentencecn:setColor(cc.c4b(0,0,0,255))
    label_sentencecn:setDimensions(text_length,0)
    label_sentencecn:setAlignment(0)
    label_sentencecn:setPosition(left, index_y)
    main:addChild(label_sentencecn)
    index_y = index_y - label_sentencecn:getContentSize().height - 10
    
    label_sentenceen2 = cc.Label:createWithSystemFont(word.sentenceEn2,"",28)
    label_sentenceen2:setAnchorPoint(0,1)
    label_sentenceen2:setColor(cc.c4b(0,0,0,255))
    label_sentenceen2:setDimensions(text_length,0)
    label_sentenceen2:setAlignment(0)
    label_sentenceen2:setPosition(left, index_y)
    main:addChild(label_sentenceen2)
    index_y = index_y - label_sentenceen2:getContentSize().height - 10

    label_sentencecn2 = cc.Label:createWithSystemFont(word.sentenceCn2,"",28)
    label_sentencecn2:setAnchorPoint(0,1)
    label_sentencecn2:setColor(cc.c4b(0,0,0,255))
    label_sentencecn2:setDimensions(text_length,0)
    label_sentencecn2:setAlignment(0)
    label_sentencecn2:setPosition(left, index_y)
    main:addChild(label_sentencecn2)
    index_y = index_y - label_sentencecn2:getContentSize().height - 10
    
    print("detail info layer height: "..index_y)

    return main
end


return WordDetailInfo







