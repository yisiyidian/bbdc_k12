require("Cocos2d")
require("Cocos2dConstants")

local ReviewBossNode = class("ReviewBossNode", function()
    return cc.Sprite:create()
end)


function ReviewBossNode.create(character)
    local main = ReviewBossNode.new()
    
    main:setContentSize(194,192)
    main:setAnchorPoint(0.5,0.5)

    local mainSize = main:getContentSize()

    main.main_back = cc.Sprite:create("image/reviewbossscene/rb_boss.png")
    main.main_back:setPosition(mainSize.width/2, mainSize.height/2)
    main:addChild(main.main_back)

    main.main_character_label = cc.Label:createWithSystemFont(character,"",40)
    main.main_character_label:setColor(cc.c4b(0,0,0,255))
    main.main_character_label:setPosition(mainSize.width/2, mainSize.height*0.6)
    main:addChild(main.main_character_label)

    main.right = function()
        main.main_back:setTexture("image/reviewbossscene/rb_boss_right.png")
    end
    
    main.wrong = function()
        main.main_character_label:setVisible(false)
        main.main_back:setTexture("image/reviewbossscene/rb_boss_wrong.png")
    end
    
    return main
end

return ReviewBossNode