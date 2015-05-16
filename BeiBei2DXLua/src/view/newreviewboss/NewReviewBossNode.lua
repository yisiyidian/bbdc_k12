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

    local showWord = string.gsub(character,"|"," ")
    
    main.main_character_label = cc.Label:createWithSystemFont(showWord,"",24)
    main.main_character_label:setColor(cc.c4b(73,73,73,255))
    main.main_character_label:setPosition(mainSize.width/2, mainSize.height* 0.3)
    main:addChild(main.main_character_label)
    
    if string.len(showWord) >= 13  then
    	main.main_character_label:setSystemFontSize(20)
    end

    main.two_to_one = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.2, cc.p(80-40*j,200))
        local action3 = cc.ScaleTo:create(0.2, 0)
        local action4 = cc.Spawn:create(action1, action3)
        main:runAction(cc.Sequence:create(action0,action4))
        main:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()main.opacity(0.4,102)end)))
    end
   
    main.three_to_two = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.2, cc.p(100-50*j,200))
        local action2 = cc.ScaleTo:create(0.15,0.8,1.2)
        local action3 = cc.ScaleTo:create(0.05,0.8,0.8)
        main:runAction(cc.Sequence:create(action0,action1))
        main:runAction(cc.Sequence:create(action0,action2,action3,cc.CallFunc:create(function()main.animation(0.8)end)))
        main:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()main.opacity(0.4,102)end)))
    end
    
    main.two_to_three = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.2, cc.p(80-40*j,-200))
        local action3 = cc.ScaleTo:create(0.2, 0)
        local action4 = cc.Spawn:create(action1, action3)
        main:runAction(cc.Sequence:create(action0,action4))
        main:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()main.opacity(0.4,102)end)))
    end
    
    main.four_to_three = function (j)
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.2, cc.p(50*j-100,200))
        local action2 = cc.ScaleTo:create(0.15,1,1.5)
        local action3 = cc.ScaleTo:create(0.05,1,1)
        main:runAction(cc.Sequence:create(action0,action1))
        main:runAction(cc.Sequence:create(action0,action2,action3,cc.CallFunc:create(function()main.animation(1)end)))
        main:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()main.opacity(0.4,255)end)))
    end

    main.five_to_four = function ()
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.2, cc.p(0,200))
        local action2 = cc.ScaleTo:create(0.15,0.8,1.2)
        local action3 = cc.ScaleTo:create(0.05,0.8,0.8)
        main:runAction(cc.Sequence:create(action0,action1))
        main:runAction(cc.Sequence:create(action0,action2,action3,cc.CallFunc:create(function()main.animation(0.8)end)))
        main:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()main.opacity(0.4,102)end)))
    end

    main.more_to_five = function ()
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.MoveBy:create(0.2, cc.p(0,200))
        main:runAction(cc.Sequence:create(action0,action1))
        main:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()main.opacity(0.4,102)end)))
    end

   main.opacity = function (t,x)
        local action0 = cc.FadeTo:create(t,x)
        main.main_back:runAction(action0)
   end

    main.right = function()
        main.main_back:setTexture("image/newreviewboss/reviewbossright.png")
    end

    main.wrong = function()
        main.main_back:setTexture("image/newreviewboss/reviewbosswrong.png")
        local action0 = cc.DelayTime:create(0.1)
        local action1 = cc.RotateBy:create(0.05,15)
        local action2 = cc.RotateBy:create(0.1,-30)
        local action3 = cc.RotateBy:create(0.1,30)
        local action4 = cc.RotateBy:create(0.05,-15)
        main:runAction(cc.Sequence:create(action0,action1,action2,action3,action4))
    end
    
    main.animation = function (k1,k2)
        if k2 == nil then
            k2 = k1
        end   
        
        local action1 = cc.MoveBy:create(0.05, cc.p(-5,0))
        local action2 = cc.MoveBy:create(0.05, cc.p(10,0))
        local action3 = cc.MoveBy:create(0.05, cc.p(-10, 0))
        local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),3)
        local action5 = cc.MoveBy:create(0.05, cc.p(5,0)) 
        local action = cc.Sequence:create(action1, action4, action5, nil)
        main:runAction(action)

        local action7 = cc.ScaleTo:create(0.075,1.15 * k1,0.85 * k2)
        local action8 = cc.ScaleTo:create(0.075,0.85 * k1,1.15 * k2)
        local action9 = cc.ScaleTo:create(0.05, 1 * k1, 1 * k2)
        main:runAction(cc.Sequence:create(action7, action8, action9, nil))
    end

    return main
end

return NewReviewBossNode