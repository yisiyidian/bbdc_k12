require("common.global")

local ShopErrorAlter = require("view.shop.ShopErrorAlter")

local ShopPanel = class("ShopPanel", function()
    return cc.Layer:create()
end)

local button_sure

function ShopPanel.create(itemId)    
    local maxWidth = s_DESIGN_WIDTH
    local maxHeight = 800

    local main = cc.LayerColor:create(cc.c4b(255,255,255,255), maxWidth, maxWidth)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)

    main.feedback = function()
    end

    main.sure = function()
        if s_CURRENT_USER:getBeans() >= s_DataManager.product[itemId].productValue then
            AnalyticsBuy(itemId)

            s_CURRENT_USER:subtractBeans(s_DataManager.product[itemId].productValue)
            s_CURRENT_USER:unlockFunctionState(itemId)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY], ['lockFunction']=s_CURRENT_USER.lockFunction})

            main.feedback()
            main:removeFromParent()
        else
            local shopErrorAlter = ShopErrorAlter.create()
            shopErrorAlter:setAnchorPoint(0.5, 0)
            shopErrorAlter:setPosition(maxWidth/2, 0)
            s_SCENE:popup(shopErrorAlter)
        end
    end

    local item = cc.Sprite:create("image/shop/item"..itemId..".png")
    item:setPosition(maxWidth/2, 470)
    main:addChild(item)

    local button_sure_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main.sure()
        end
    end

    button_sure = ccui.Button:create("image/shop/long_button.png","image/shop/long_button_clicked.png","")
    button_sure:setPosition(maxWidth/2,240)
    button_sure:addTouchEventListener(button_sure_clicked)
    main:addChild(button_sure)

    local item_name = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productValue.."贝贝豆购买",'',30)
    item_name:setColor(cc.c4b(255,255,255,255))
    item_name:setPosition(button_sure:getContentSize().width/2+10, button_sure:getContentSize().height/2)
    button_sure:addChild(item_name)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(50, button_sure:getContentSize().height/2)
    button_sure:addChild(been)

    local label_content = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productDescription,"",30)
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(84,107,144,255))
    label_content:setDimensions(370,0)
    label_content:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label_content:setPosition(maxWidth/2, 700)
    main:addChild(label_content)

    return main
end

return ShopPanel
