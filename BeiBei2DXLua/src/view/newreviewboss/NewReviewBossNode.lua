require("cocos.init")

local NewReviewBossNode = class("NewReviewBossNode", function()
    return cc.Sprite:create()
end)


function NewReviewBossNode.create(character)
    local main = NewReviewBossNode.new()

    main.character = character

    main:setContentSize(194,192)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)

    local mainSize = main:getContentSize()

    --    main.main_back = cc.Sprite:create("image/reviewbossscene/rb_boss.png")
    --    main.main_back:setPosition(mainSize.width/2, mainSize.height/2)
    --    main:addChild(main.main_back)

    main.main_back = sp.SkeletonAnimation:create("res/spine/fuxiboss_diyiguan_boss_wrightwrong.json", "res/spine/fuxiboss_diyiguan_boss_wrightwrong.atlas", 1)
    main.main_back:setPosition(mainSize.width/2, 0)
    main:addChild(main.main_back)
    main.main_back:addAnimation(0, 'oudupus1', false)

    main.main_character_label = cc.Label:createWithSystemFont(character,"",40)
    main.main_character_label:setColor(cc.c4b(0,0,0,255))
    main.main_character_label:setPosition(mainSize.width/2, mainSize.height*0.6)
    main:addChild(main.main_character_label)

    main.right = function()
        --main.main_back:setTexture("image/reviewbossscene/rb_boss_right.png")
        main.main_back:addAnimation(0, 'oudupus2', false)
    end

    main.wrong = function()
        main.main_character_label:setVisible(false)
        --main.main_back:setTexture("image/reviewbossscene/rb_boss_wrong.png")
        main.main_back:addAnimation(0, 'oudupus3', false)
    end

    return main
end

return NewReviewBossNode