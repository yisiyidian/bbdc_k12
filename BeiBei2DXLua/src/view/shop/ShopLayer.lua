require("cocos.init")
require("common.global")

local ShopAlter = require("view.shop.ShopAlter")

local ShopLayer = class("ShopLayer", function()
    return cc.Layer:create()
end)

function ShopLayer.create()
    local layer = ShopLayer.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local backColor = cc.LayerColor:create(cc.c4b(248,247,235,255), bigWidth, s_DESIGN_HEIGHT)
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local back_head = cc.Sprite:create("image/shop/headback.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT)
    backColor:addChild(back_head)


    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           s_CorePlayManager.enterHomeLayer()
        end
    end

    local button_back = ccui.Button:create("image/shop/button_back.png","image/shop/button_back.png","")
    button_back:setPosition(50, s_DESIGN_HEIGHT-50)
    button_back:addTouchEventListener(button_back_clicked)
    backColor:addChild(button_back) 

    local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    been_number_back:setPosition(s_DESIGN_WIDTH-100, s_DESIGN_HEIGHT-50)
    backColor:addChild(been_number_back)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(0, been_number_back:getContentSize().height/2)
    been_number_back:addChild(been)

    local been_number = cc.Label:createWithSystemFont('100','',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width/2 , been_number_back:getContentSize().height/2)
    been_number_back:addChild(been_number)




    local lock_state = {1,0,1,0,1,0,1,0}

    local height = 320
    for i = 1, 4 do
        local shelf = cc.Sprite:create("image/shop/shelf.png")
        shelf:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT-80-height*i)
        backColor:addChild(shelf) 
    end

    for i = 1, 8 do
        local x = s_DESIGN_WIDTH/2+150*(1-2*(i%2))
        local y = s_DESIGN_HEIGHT-height*(math.floor((i-1)/2))-435
        
        
        local item_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                print("item "..i.." clicked")
                local shopAlter = ShopAlter.create(i)
                shopAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(shopAlter)

                shopAlter.sure = function()
                    
                end
            end
        end
        
        local item = ccui.Button:create("image/shop/item"..i..".png","image/shop/item"..i..".png","")
        item:setPosition(x, y+150)
        item:addTouchEventListener(item_clicked)
        backColor:addChild(item) 
        
        local item_name_back = cc.Sprite:create("image/shop/item_name_back.png")
        item_name_back:setPosition(x+15, y)
        backColor:addChild(item_name_back) 

        if lock_state[i] == 0 then
            local item_name = cc.Label:createWithSystemFont('100','',28)
            item_name:setColor(cc.c4b(0,0,0,255))
            item_name:setPosition(item_name_back:getContentSize().width/2-10, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(item_name)

            local been_small = cc.Sprite:create("image/shop/been_small.png")
            been_small:setPosition(40, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(been_small)
        else
            local item_name = cc.Label:createWithSystemFont('已购','',28)
            item_name:setColor(cc.c4b(0,0,0,255))
            item_name:setPosition(item_name_back:getContentSize().width/2-20, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(item_name)
        end
    end



    return layer
end


return ShopLayer







