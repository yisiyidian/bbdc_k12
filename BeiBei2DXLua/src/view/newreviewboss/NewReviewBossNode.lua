require("cocos.init")

local NewReviewBossNode = class("NewReviewBossNode", function()
    return cc.Sprite:create()
end)


function NewReviewBossNode.create(character)
    local main = NewReviewBossNode.new()
    local text
    
    main.character = character

    main:setContentSize(189,141)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local mainSize = main:getContentSize()

    main.main_back = cc.Sprite:create("image/newreviewboss/reviewbossbig.png")
    main.main_back:setPosition(mainSize.width/2, mainSize.height / 2)
    main:addChild(main.main_back)
    
    main.main_character_label = cc.Label:createWithSystemFont(character,"",30)
    main.main_character_label:setColor(cc.c4b(0,0,0,255))
    main.main_character_label:setPosition(mainSize.width/2, mainSize.height* 0.3)
    main:addChild(main.main_character_label)
    
    
    local word_width =  string.len(character)
    if word_width > 15 then
        main.main_character_label:setSystemFontSize(20)
    end

   
    main.visible = function(bool)
        main.main_character_label:setVisible(bool)
    end

    main.right = function()
        main.main_back:setTexture("image/newreviewboss/reviewbossright.png")
    end

    main.wrong = function()
        main.main_back:setTexture("image/newreviewboss/reviewbosswrong.png")
    end

    return main
end

return NewReviewBossNode