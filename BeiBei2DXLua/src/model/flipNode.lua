require("Cocos2d")
require("Cocos2dConstants")


local flipNode = class("flipNode", function()
    return cc.Sprite:create()
end)


function flipNode.create(back, character, x, y)
    local main = flipNode.new()

    main.logic_x = x
    main.logic_y = y
    main.main_character_content = character
    main.scroll_state = 0
    main.hasSelected = false
    
    --main.main_back = cc.Sprite:create(back)
    --main:addChild(main.main_back)
    
    --main.main_back = sp.SkeletonAnimation:create("res/spine/"..back..".json", "res/spine/"..back..".atlas", 1)
    --main.main_back:addAnimation(0, 'normal', true)
    main.main_back = cc.Sprite:create("image/coconut_font.png")
    main:addChild(main.main_back)
    
    main.main_character_label = cc.Label:createWithSystemFont(main.main_character_content,"",40)
    main.main_character_label:setColor(cc.c3b(0,0,0))
    main:addChild(main.main_character_label)
    
    return main
end

function flipNode.select()
    main.main_back:addAnimation(0, 'select', false)
end

function flipNode.up()
    main.main_back:addAnimation(0, 'up', false)
end

function flipNode.down()
    main.main_back:addAnimation(0, 'down', false)
end

function flipNode.left()
    main.main_back:addAnimation(0, 'left', false)
end

function flipNode.right()
    main.main_back:addAnimation(0, 'right', false)
end

function flipNode.up_back()
    main.main_back:addAnimation(0, 'up_back', false)
end

function flipNode.down_back()
    main.main_back:addAnimation(0, 'down_back', false)
end

function flipNode.left_back()
    main.main_back:addAnimation(0, 'left_back', false)
end

function flipNode.right_back()
    main.main_back:addAnimation(0, 'right_back', false)
end

return flipNode