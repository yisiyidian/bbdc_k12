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

    main.two_to_one = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,200))
        local action2 = cc.ScaleTo:create(0.4, 0)
        local action3 = cc.Spawn:create(action1, action2)
        main:runAction(cc.Sequence:create(action0, action3))
    end
   
    main.three_to_two = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,200))
        local action2 = cc.ScaleTo:create(0.4, 0.8)
        local action3 = cc.Spawn:create(action1, action2)
        main:runAction(cc.Sequence:create(action0, action3))
    end
    
    main.two_to_three = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,-200))
        local action2 = cc.ScaleTo:create(0.4, 0)
        local action3 = cc.Spawn:create(action1, action2)
        main:runAction(cc.Sequence:create(action0, action3))
    end
    
    main.four_to_three = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,200))
        local action2 = cc.ScaleTo:create(0.4, 1)
        local action3 = cc.Spawn:create(action1, action2)
        main:runAction(cc.Sequence:create(action0, action3))
    end

    main.five_to_four = function ()
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.4, cc.p(0,200))
        local action2 = cc.ScaleTo:create(0.4, 0.8)
        local action3 = cc.Spawn:create(action1, action2)
        main:runAction(cc.Sequence:create(action0, action3))
    end

    main.more_to_five = function ()
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.4, cc.p(0,200))
        main:runAction(cc.Sequence:create(action0, action1))
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