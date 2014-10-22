require("Cocos2d")
require("Cocos2dConstants")

local TapNode = class("TapNode", function()
    return cc.Sprite:create()
end)


function TapNode.create(back, character, x, y)
    
    local normalName = "image/studyscene/"..back.."_normal.png"
    local selectName = "image/studyscene/"..back.."_select.png"

    local main = TapNode.new()
    main:setContentSize(120,120)
    main:setAnchorPoint(0.5,0.5)

    local mainSize = main:getContentSize()

    main.logicX = x
    main.logicY = y
    main.main_character_content = character
    main.hasSelected = false

    print(normalName)
    print(selectName)
    main.main_back = cc.Sprite:create(normalName)
    main.main_back:setPosition(mainSize.width/2, mainSize.height/2)
    main:addChild(main.main_back)
    
    main.main_character_label = cc.Label:createWithSystemFont(main.main_character_content,"",40)
    main.main_character_label:setColor(cc.c3b(0,0,0))
    main.main_character_label:setPosition(mainSize.width/2, mainSize.height/2)
    main:addChild(main.main_character_label)

    main.firstStyle = function()
        
    end

    main.addSelectStyle = function()
        main.hasSelected = true
        
        local tmp = cc.Sprite:create(selectName)
        local w = tmp:getContentSize().width
        local h = tmp:getContentSize().height
        
        local a = cc.SpriteFrame:create(selectName,cc.rect(0,0,w,h))
        main.main_back:setSpriteFrame(a)
        
        --local texture = cc.Director:getInstance():getTextureCache():addImage(selectName)
        --cc.textureCache.addImage("HelloHTML5World.png");
        --main.main_back:loadTextures(texture)
        
    end

    main.removeSelectStyle = function()
        main.hasSelected = false
        
        local tmp = cc.Sprite:create(normalName)
        local w = tmp:getContentSize().width
        local h = tmp:getContentSize().height
        
        local a = cc.SpriteFrame:create(normalName,cc.rect(0,0,w,h))
        
        main.main_back:setSpriteFrame(a)
        --main.main_back:loadTextures(normalName)
    end

    main.bigSize = function()
        main:setScale(1.05)
    end

    main.middleSize = function()
        main:setScale(1)
    end

    main.smallSize = function()
        main:setScale(0.95)
    end

    main.win = function()
        
    end

    return main
end

return TapNode