require("Cocos2d")
require("Cocos2dConstants")

local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4
local dir_init  = 0

local FlipNode = class("FlipNode", function()
    return cc.Sprite:create()
end)


function FlipNode.create(back, character, x, y)
    local main = FlipNode.new()
    main:setContentSize(120,120)
    main:setAnchorPoint(0.5,0.5)
    main:setColor(cc.c3b(1,1,1))
    
    local mainSize = main:getContentSize()

    main.logicX = x
    main.logicY = y
    main.main_character_content = character
    main.scroll_state = dir_init
    main.hasSelected = false
    
    --main.main_back = cc.Sprite:create(back)
    --main:addChild(main.main_back)
    
    main.main_back = sp.SkeletonAnimation:create("res/spine/"..back..".json", "res/spine/"..back..".atlas", 1)
    main.main_back:addAnimation(0, 'normal', false)
    --main.main_back = cc.Sprite:create("image/coconut_font.png")
    main.main_back:setPosition(mainSize.width/2, mainSize.height/2)
    main:addChild(main.main_back)
    
    main.main_character_label = cc.Label:createWithSystemFont(main.main_character_content,"",40)
    main.main_character_label:setColor(cc.c3b(0,0,0))
    main.main_character_label:setPosition(mainSize.width/2, mainSize.height/2)
    main:addChild(main.main_character_label)

    main.firstStyle = function()
        main.main_back:addAnimation(0, 'select', false)
    end

    main.addSelectStyle = function()
        main.hasSelected = true
        main.main_back:addAnimation(0, 'select', false)
    end

    main.removeSelectStyle = function()
        main.hasSelected = false
        if main.scroll_state == dir_up then
            main.up_back()
        elseif main.scroll_state == dir_down then
            main.down_back()
        elseif main.scroll_state == dir_left then
            main.left_back()
        elseif main.scroll_state == dir_right then
            main.right_back()
        else
            main.normal()
        end
    end

    main.bigSize = function()
        
    end

    main.middleSize = function()

    end

    main.smallSize = function()

    end
    
    main.normal = function()
        main.main_back:addAnimation(0, 'normal', false)
        main.main_character_label:setColor(cc.c3b(0,0,0))
        main.main_character_label:setVisible(true)
        main.hasSelected = false
    end
    
    main.win = function()
        main.main_back:addAnimation(0, 'win', false)
        main.main_character_label:setVisible(false)
    end

    main.up = function()
        main.scroll_state = dir_up
        main.main_back:addAnimation(0, 'up', false)
        main.main_character_label:setColor(cc.c3b(255,255,255))
    end

    main.down = function()
        main.scroll_state = dir_down
        main.main_back:addAnimation(0, 'down', false)
        main.main_character_label:setColor(cc.c3b(255,255,255))
    end

    main.left = function()
        main.scroll_state = dir_left
        main.main_back:addAnimation(0, 'left', false)
        main.main_character_label:setColor(cc.c3b(255,255,255))
    end

    main.right = function()
        main.scroll_state = dir_right
        main.main_back:addAnimation(0, 'right', false)
        main.main_character_label:setColor(cc.c3b(255,255,255))
    end

    main.up_back = function()
        main.scroll_state = dir_init
        main.main_back:addAnimation(0, 'up_back', false)
        main.main_character_label:setColor(cc.c3b(0,0,0))
    end

    main.down_back = function()
        main.scroll_state = dir_init
        main.main_back:addAnimation(0, 'down_back', false)
        main.main_character_label:setColor(cc.c3b(0,0,0))
    end

    main.left_back = function()
        main.scroll_state = dir_init
        main.main_back:addAnimation(0, 'left_back', false)
        main.main_character_label:setColor(cc.c3b(0,0,0))
    end

    main.right_back = function()
        main.scroll_state = dir_init
        main.main_back:addAnimation(0, 'right_back', false)
        main.main_character_label:setColor(cc.c3b(0,0,0))
    end


    return main
end

return FlipNode