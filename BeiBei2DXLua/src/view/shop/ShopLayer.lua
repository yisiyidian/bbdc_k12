--商店界面 商品列表部分 可滚动

local ShopAlter     = require("view.shop.ShopAlter")
local MissionConfig = require("model.mission.MissionConfig") --任务的配置数据

local ShopLayer = class("ShopLayer", function()
    return cc.Layer:create()
end)

function ShopLayer.create()    
    local layer = ShopLayer.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local bigHeight = 1.0*s_DESIGN_HEIGHT

    local initColor = cc.LayerColor:create(cc.c4b(248,247,235,255), bigWidth, s_DESIGN_HEIGHT)
    initColor:setAnchorPoint(0.5,0.5)
    initColor:ignoreAnchorPointForPosition(false)  
    initColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(initColor)

    local scrollView = ccui.ScrollView:create()
    scrollView:setTouchEnabled(true)
    scrollView:setBounceEnabled(true)
    scrollView:setAnchorPoint(0.5,0.5)
    scrollView:ignoreAnchorPointForPosition(false)
    scrollView:setContentSize(cc.size(bigWidth, s_DESIGN_HEIGHT))  
    scrollView:setInnerContainerSize(cc.size(bigWidth, bigHeight))      
    scrollView:setPosition(cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    layer:addChild(scrollView)

    local backColor = cc.LayerColor:create(cc.c4b(248,247,235,255), bigWidth, bigHeight)
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(bigWidth/2, bigHeight/2)
    scrollView:addChild(backColor)

    local back_head = cc.ProgressTimer:create(cc.Sprite:create("image/shop/headback.png"))
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT)
    back_head:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    back_head:setMidpoint(cc.p(0.5, 0))
    back_head:setBarChangeRate(cc.p(1, 0))
    back_head:setPercentage((s_RIGHT_X - s_LEFT_X) / back_head:getContentSize().width * 100)
    layer:addChild(back_head)

    layer.backToHome = function ()

    end

    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           layer.backToHome()
        end
    end

    local button_back = ccui.Button:create("image/shop/button_back.png","image/shop/button_back.png","")
    button_back:setPosition(50, s_DESIGN_HEIGHT-50)
    button_back:addTouchEventListener(button_back_clicked)
    layer:addChild(button_back) 

    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    layer:addChild(beans)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)

    local height = 320
    local productNum = #s_DataManager.product
    for i = 1, math.ceil(productNum/2) do
        local shelf = cc.Sprite:create("image/shop/shelf.png")
        shelf:setPosition(s_DESIGN_WIDTH/2, bigHeight-80-height*i)
        backColor:addChild(shelf) 
    end

    layer.vip1 = nil
    layer.vip2 = nil
    layer.vip3 = nil

    for i = 2, productNum do
        local x = s_DESIGN_WIDTH/2+150*(1-2*((i-1)%2))
        local y = bigHeight - height*(math.floor((i-2)/2))-435
        
        local item_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                local shopAlter = ShopAlter.create(i, 'in')
                shopAlter.vip = function()
                    if layer.vip1 ~= nil and layer.vip2 ~= nil and layer.vip3 ~= nil then
                        layer.vip1:loadTextureNormal("image/shop/product6.png")
                        layer.vip1:loadTexturePressed("image/shop/product6.png")
                        layer.vip2:setVisible(false)
                        layer.vip3:setVisible(false)
                        
                        local w = layer.vip1:getContentSize().width
                        local h = layer.vip1:getContentSize().height

                        local label = cc.Sprite:create("image/shop/label6.png")
                        label:setPosition(w/2-10, h/2-40)
                        layer.vip1:addChild(label)
                    
                        local item_name = cc.Label:createWithSystemFont('已购','',28)
                        item_name:setColor(cc.c4b(0,0,0,255))
                        item_name:setPosition(w/2-5, h/2-155)
                        layer.vip1:addChild(item_name)
                    end
                end
                s_SCENE:popup(shopAlter)
            end
        end
        
        local item_name_back = cc.Sprite:create("image/shop/item_name_back.png")
        item_name_back:setPosition(x+15, y)
        backColor:addChild(item_name_back) 

        --获取商品解锁状态
        if s_CURRENT_USER:getLockFunctionState(i) == 0 then
            local item = ccui.Button:create("image/shop/item"..i..".png","image/shop/item"..i..".png","")
            item:setPosition(x, y+150)
            item:addTouchEventListener(item_clicked)
            backColor:addChild(item)
        
            local item_name = cc.Label:createWithSystemFont(s_DataManager.product[i].productValue,'',28)
            item_name:setColor(cc.c4b(0,0,0,255))
            item_name:setPosition(item_name_back:getContentSize().width/2-10, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(item_name)

            local been_small = cc.Sprite:create("image/shop/been_small.png")
            been_small:setPosition(40, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(been_small)

            if i == 6 then
                layer.vip1 = item
                layer.vip2 = item_name
                layer.vip3 = been_small
            end

        else
            local item = ccui.Button:create("image/shop/product"..i..".png","image/shop/product"..i..".png","")
            item:setPosition(x, y+150)
            item:addTouchEventListener(item_clicked)
            backColor:addChild(item)
            
            local label = cc.Sprite:create("image/shop/label"..i..".png")
            label:setPosition(x-10, y+110)
            backColor:addChild(label) 
        
            local item_name = cc.Label:createWithSystemFont('已购','',28)
            item_name:setColor(cc.c4b(0,0,0,255))
            item_name:setPosition(item_name_back:getContentSize().width/2-20, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(item_name)
            --触发任务
            if i == 2 then 
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA1,1,false)
            elseif i == 3 then
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA2,1,false)
            elseif i == 5 then
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA3,1,false)
            elseif i == 6 then
                s_MissionManager:updateMission(MissionConfig.MISSION_VIP,1,false)
            end
        end
    end

    local view = 'shop'
    local delay = cc.DelayTime:create(1)
    local func = cc.CallFunc:create(function ()
        onAndroidKeyPressed(layer, function ()
            local isPopup = s_SCENE.popupLayer:getChildren()
            if #isPopup == 0 then
                if view == 'shop' then
                    layer.backToHome()
                    view = 'home'
                end
            end
        end, function ()

        end)
    end)


    layer:runAction(cc.Sequence:create(delay,func))

    
    return layer
end


return ShopLayer







