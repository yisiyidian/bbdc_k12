require("common.global")

local ShopErrorAlter = require("view.shop.ShopErrorAlter")
local HomeLayer   = require("view.home.HomeLayer")
local Button                = require("view.button.longButtonInStudy")
local MissionConfig          = require("model.mission.MissionConfig") --任务的配置数据

local ShopAlter = class("ShopAlter", function()
    return cc.Layer:create()
end)

local button_sure

function ShopAlter.create(itemId, location)
    local state = s_CURRENT_USER:getLockFunctionState(itemId)

    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local main = cc.Layer:create()

    local back
    if location == 'out' then
        back = cc.Sprite:create("image/shop/alter_back_out.png")
    else
        back = cc.Sprite:create("image/shop/alter_back_in.png")
    end
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height

    local item
    local click_button = 0

    main.sure = function()
        if s_CURRENT_USER:getBeans() >= s_DataManager.product[itemId].productValue and click_button == 0 then
            click_button = 1
            s_CURRENT_USER:subtractBeans(s_DataManager.product[itemId].productValue)
            s_CURRENT_USER:unlockFunctionState(itemId)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY], ['lockFunction']=s_CURRENT_USER.lockFunction})

            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            item:setVisible(false)

            local bing = sp.SkeletonAnimation:create("res/spine/shop/bing"..itemId..".json", "res/spine/shop/bing"..itemId..".atlas", 1)
            bing:setPosition(maxWidth/2-100, maxHeight/2+60)
            bing:addAnimation(0, 'animation', false)
            back:addChild(bing) 

            for i=1,5 do
                if itemId == i then
                    s_LocalDatabaseManager.setBuy(math.pow(10,i-1))
                end
            end 

            local action0 = cc.DelayTime:create(4)
            local action1 = cc.CallFunc:create(function ()
                if itemId ~= 6 then
                    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                        s_SCENE:removeAllPopups()
                    end
                    local homeLayer = HomeLayer.create(true) 
                    s_SCENE:replaceGameLayer(homeLayer)
                else   
                    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                    local ShopAlter = require("view.shop.ShopAlter")
                    local shopAlter = ShopAlter.create(6, 'in')
                    s_SCENE:popup(shopAlter)
                end
            end)
            local action2 = cc.Sequence:create(action0,action1)
            main:runAction(action2)
            if itemId == 2 then 
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA1)
            elseif itemId == 3 then
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA2)
            elseif itemId == 5 then
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA3)
            elseif itemId == 6 then
                s_MissionManager:updateMission(MissionConfig.MISSION_VIP)
            end
            
        elseif s_CURRENT_USER:getBeans() < s_DataManager.product[itemId].productValue and click_button == 0 then
            click_button = 1
            local shopErrorAlter = ShopErrorAlter.create()
            s_SCENE:popup(shopErrorAlter)
        end
    end

    main.go = function ()
        if click_button == 0 then
            click_button = 1
            for i=1,5 do
                if itemId == i then
                    s_LocalDatabaseManager.setBuy(math.pow(10,i-1))
                end
            end 
            if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                   s_SCENE:removeAllPopups()
                end
            local homeLayer = HomeLayer.create(true) 
            s_SCENE:replaceGameLayer(homeLayer)
        end
    end
    
    if state == 0 then
        item = cc.Sprite:create("image/shop/item"..itemId..".png")
        item:setPosition(maxWidth/2, maxHeight/2+150)
        back:addChild(item)

        local button_func = function()
            main.sure()
        end

        button_sure = Button.create("image/button/middleblueback.png","image/button/middlebluefront.png",9,s_DataManager.product[itemId].productValue.."贝贝豆购买") 
        button_sure:setPosition(maxWidth/2,100)
        button_sure.func = function ()
            button_func()
        end
        back:addChild(button_sure)

        local been = cc.Sprite:create("image/shop/been.png")
        been:setPosition(50, button_sure.button_front:getContentSize().height/2)
        button_sure.button_front:addChild(been)
    else
        local title = cc.Sprite:create("image/shop/label"..itemId..".png")
        title:setPosition(maxWidth/2, maxHeight-80)
        back:addChild(title)

        item = cc.Sprite:create("image/shop/product"..itemId..".png")
        item:setPosition(maxWidth/2, maxHeight/2+150)
        back:addChild(item)
        
        local button_func = function()
            main.go()
        end

        button_sure = Button.create("image/button/middleblueback.png","image/button/middlebluefront.png",9,"去看一看") 
        button_sure:setPosition(maxWidth/2,100)
        button_sure.func = function ()
            button_func()
        end

        if itemId ~= 6 then
            back:addChild(button_sure)
        end
    end

    local label_content
    if itemId == 6 and state == 1 then -- vip
        local vip_content = "恭喜你！获得贝贝VIP门票一张！请加微信：beibeidanci001，距离VIP群，仅有一步之遥！"
        label_content = cc.Label:createWithSystemFont(vip_content,"",32)
    else
        label_content = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productDescription,"",32)
    end
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setDimensions(maxWidth-180,0)
    label_content:setAlignment(0)
    label_content:setPosition(maxWidth/2, maxHeight/2-60)
    back:addChild(label_content)

    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 1.5))
            local action2 = cc.EaseBackIn:create(action1)
            local remove = cc.CallFunc:create(function() 
                s_SCENE:removeAllPopups()
            end)
            back:runAction(cc.Sequence:create(action2,remove))
        end
    end

    button_close = ccui.Button:create("image/button/button_close.png","image/button/button_close.png","")
    button_close:setPosition(maxWidth-30,maxHeight-30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)



    -- touch lock
    local onTouchBegan = function(touch, event)        
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                s_SCENE:removeAllPopups()
            end)
            back:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    onAndroidKeyPressed(main, function ()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 1.5))
        local action2 = cc.EaseBackIn:create(action1)
        local remove = cc.CallFunc:create(function() 
            s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(action2,remove))
    end, function ()

    end)

    return main
end


return ShopAlter
