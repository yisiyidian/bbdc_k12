

local PetCfg = require("view.pet.PetCfg")
local LocalPetCfg = require("view.pet.LocalPetCfg")

local PetAlter = class("PetAlter", function()
    return cc.Layer:create()
end)

function PetAlter.create(petID)
    local main = cc.Layer:create()

    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/pet/pet_alter/board.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 1.5))
            local action2 = cc.EaseBackIn:create(action1)
            local remove = cc.CallFunc:create(function() 
                main:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,remove))
        end
    end

    local button_close = ccui.Button:create("image/pet/pet_alter/closeButton_1.png","image/pet/pet_alter/closeButton_2.png","")
    button_close:setPosition(maxWidth-80,maxHeight-80)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)

    local petDesc = cc.Label:createWithSystemFont("Lv"..LocalPetCfg[petID]["level"].." "..PetCfg[petID.."_1"]["name"],"",28)
    petDesc:setColor(cc.c4b(0,0,0,255))
    petDesc:setPosition(maxWidth/2,maxHeight-80)
    back:addChild(petDesc)

    local pet = cc.Sprite:create("image/pet/pet_detail/"..petID.."_1.png")
    pet:setPosition(maxWidth/2, maxHeight/2+200)
    back:addChild(pet)

    local lineUp = cc.Sprite:create("image/pet/pet_alter/line.png")
    lineUp:setPosition(maxWidth/2, maxHeight/2-100)
    back:addChild(lineUp)

    
        local info11 = cc.Label:createWithSystemFont("当前","",30)
        info11:setColor(cc.c4b(0,0,0,255))
        info11:setPosition(maxWidth/2-80,maxHeight/2-120)
        back:addChild(info11)

        local info12 = cc.Label:createWithSystemFont("攻击力:200","",28)
        info12:setColor(cc.c4b(0,0,0,255))
        info12:setPosition(maxWidth/2-80,maxHeight/2-160)
        back:addChild(info12)

        local info13 = cc.Label:createWithSystemFont("特殊技能:无","",28)
        info13:setColor(cc.c4b(0,0,0,255))
        info13:setPosition(maxWidth/2-80,maxHeight/2-200)
        back:addChild(info13)

        local info21 = cc.Label:createWithSystemFont("当前","",30)
        info21:setColor(cc.c4b(0,0,0,255))
        info21:setPosition(maxWidth/2+80,maxHeight/2-120)
        back:addChild(info21)

        local info22 = cc.Label:createWithSystemFont("攻击力:200","",28)
        info22:setColor(cc.c4b(0,0,0,255))
        info22:setPosition(maxWidth/2+80,maxHeight/2-160)
        back:addChild(info22)

        local info23 = cc.Label:createWithSystemFont("特殊技能:无","",28)
        info23:setColor(cc.c4b(0,0,0,255))
        info23:setPosition(maxWidth/2+80,maxHeight/2-200)
        back:addChild(info23)

    local lineDown = cc.Sprite:create("image/pet/pet_alter/line.png")
    lineDown:setPosition(maxWidth/2, maxHeight/2-300)
    back:addChild(lineDown)

    local board = cc.Sprite:create("image/pet/pet_alter/sourceboard.png")
    board:setPosition(maxWidth/2, 100)
    back:addChild(board)

    local button_levelup_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then

        end
    end

    local button_levelup = ccui.Button:create("image/pet/pet_alter/blueButton_1.png","image/pet/pet_alter/blueButton_2.png","")
    button_levelup:setPosition(maxWidth/2,80)
    button_levelup:addTouchEventListener(button_levelup_clicked)
    back:addChild(button_levelup)

    -- touch lock
    local onTouchBegan = function(touch, event)        
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local remove = cc.CallFunc:create(function()
                main:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,remove))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end


return PetAlter
