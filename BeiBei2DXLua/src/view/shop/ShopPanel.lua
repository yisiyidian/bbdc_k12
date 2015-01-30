require("common.global")

local ShopErrorAlter = require("view.shop.ShopErrorAlter")

local ShopPanel = class("ShopPanel", function()
    return cc.Layer:create()
end)

local button_sure

function ShopPanel.create(itemId)    
    local maxWidth = s_DESIGN_WIDTH
    local maxHeight = 500

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100), maxWidth, maxWidth)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.sure = function()
        if s_CURRENT_USER.beans >= s_DataManager.product[itemId].productValue then
            s_CURRENT_USER.beans = s_CURRENT_USER.beans - s_DataManager.product[itemId].productValue
            s_CURRENT_USER:unlockFunctionState(itemId)
            s_CURRENT_USER:updateDataToServer()

            main:removeFromParent()
        else
            local shopErrorAlter = ShopErrorAlter.create()
            shopErrorAlter:setPosition(maxWidth/2, s_DESIGN_HEIGHT/2)
            main:addChild(shopErrorAlter)
        end
    end

    local item = cc.Sprite:create("image/shop/item"..itemId..".png")
    item:setPosition(maxWidth/2, maxHeight/2+150)
    back:addChild(item)

    local button_sure_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main.sure()
        end
    end

    button_sure = ccui.Button:create("image/shop/long_button.png","image/shop/long_button_clicked.png","")
    button_sure:setPosition(maxWidth/2,100)
    button_sure:addTouchEventListener(button_sure_clicked)
    back:addChild(button_sure)

    local item_name = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productValue.."贝贝豆购买",'',30)
    item_name:setColor(cc.c4b(255,255,255,255))
    item_name:setPosition(button_sure:getContentSize().width/2+10, button_sure:getContentSize().height/2)
    button_sure:addChild(item_name)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(50, button_sure:getContentSize().height/2)
    button_sure:addChild(been)

    local label_content = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productDescription,"",32)
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setDimensions(maxWidth-180,0)
    label_content:setAlignment(0)
    label_content:setPosition(maxWidth/2, maxHeight/2-60)
    back:addChild(label_content)

    -- touch lock
    local onTouchBegan = function(touch, event)        
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end

return ShopPanel
