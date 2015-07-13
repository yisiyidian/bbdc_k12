    -- local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    -- beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    -- layer:addChild(beans)

    -- local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    -- been_number:setColor(cc.c4b(0,0,0,255))
    -- been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    -- beans:addChild(been_number)

    -- local scrollView = ccui.ScrollView:create()
    -- scrollView:setTouchEnabled(true)
    -- scrollView:setBounceEnabled(true)
    -- scrollView:setAnchorPoint(0.5,0.5)
    -- scrollView:ignoreAnchorPointForPosition(false)
    -- scrollView:setContentSize(cc.size(bigWidth, bigHeight)) 
    -- scrollView:setInnerContainerSize(cc.size(bigWidth, bigHeight*2))      
    -- scrollView:setPosition(cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    -- layer:addChild(scrollView)


local PetLayer = class("PetLayer", function()
    return cc.Layer:create()
end)

function PetLayer.create()    
    local layer = PetLayer.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local pageIndex = 1
    local attrList = {"blue","green","red","orange","yellow"}
    local attrCnt = {4,1,1,1,1}

    local colorList = {}
    table.insert(colorList, cc.c4b(151,220,239,255))
    table.insert(colorList, cc.c4b(190,246,175,255))
    table.insert(colorList, cc.c4b(245,175,175,255))
    table.insert(colorList, cc.c4b(246,215,175,255))
    table.insert(colorList, cc.c4b(246,242,175,255))

    pageList = {}
    for page = 0, 4 do
        local backColor = cc.LayerColor:create(colorList[page+1], bigWidth, s_DESIGN_HEIGHT)
        backColor:setAnchorPoint(0.5,0.5)
        backColor:ignoreAnchorPointForPosition(false)  
        backColor:setPosition(s_DESIGN_WIDTH/2+bigWidth*page, s_DESIGN_HEIGHT/2)
        layer:addChild(backColor)
        table.insert(pageList, backColor)
        for row = 0, 1 do
            for col = 0, 1 do
                local petIndex = row*2+col+1
                if petIndex <= attrCnt[page+1] then
                    local petBack = cc.Sprite:create("image/pet/pet_house/"..attrList[page+1].."card.png")
                    petBack:setPosition(bigWidth/2 - 120 + 240*row, s_DESIGN_HEIGHT/2 + 190 - 380*col)
                    backColor:addChild(petBack)

                    local attrBall = cc.Sprite:create("image/pet/pet_house/blueball_normal.png")
                    attrBall:setPosition(60, petBack:getContentSize().height-60)
                    petBack:addChild(attrBall)

                    local petStar = cc.Sprite:create("image/pet/pet_house/star.png")
                    petStar:setPosition(petBack:getContentSize().width-70, petBack:getContentSize().height-60)
                    petBack:addChild(petStar)

                    local pet = cc.Sprite:create("image/pet/pet_detail/"..attrList[page+1].."pet/"..attrList[page+1].."_"..petIndex.."_1.png")
                    pet:setPosition(petBack:getContentSize().width/2, petBack:getContentSize().height/2)
                    pet:setScale(0.6)
                    petBack:addChild(pet)

                    local petDesc = cc.Label:createWithSystemFont("Lv. 1 妙蛙种子","",28)
                    petDesc:setPosition(petBack:getContentSize().width/2,60)
                    petBack:addChild(petDesc)
                end
            end
        end
    end


    attrBallList = {}
    for i, v in pairs(attrList) do
        if i == pageIndex then
            local attrBall = cc.Sprite:create("image/pet/pet_house/"..v.."ball_selected.png")
            attrBall:setPosition(s_DESIGN_WIDTH/2-210+70*i, 60)
            layer:addChild(attrBall)
            table.insert(attrBallList, attrBall)
        else
            local attrBall = cc.Sprite:create("image/pet/pet_house/"..v.."ball_normal.png")
            attrBall:setPosition(s_DESIGN_WIDTH/2-210+70*i, 60)
            layer:addChild(attrBall)
            table.insert(attrBallList, attrBall)
        end
    end

    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if pageIndex - 1 >= 1 then
                for i = 0, 4 do
                    local action1 = cc.MoveBy:create(0.5, cc.p(bigWidth, 0))
                    local action2 = cc.EaseSineIn:create(action1)
                    pageList[i+1]:runAction(action2)
                end

                attrBallList[pageIndex]:setTexture("image/pet/pet_house/"..attrList[pageIndex].."ball_normal.png")
                pageIndex = pageIndex - 1
                attrBallList[pageIndex]:setTexture("image/pet/pet_house/"..attrList[pageIndex].."ball_selected.png")
            end
        end
    end

    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if pageIndex + 1 <= 5 then
                for i = 0, 4 do
                    local action1 = cc.MoveBy:create(0.5, cc.p(-bigWidth, 0))
                    local action2 = cc.EaseSineIn:create(action1)
                    pageList[i+1]:runAction(action2)
                end
                attrBallList[pageIndex]:setTexture("image/pet/pet_house/"..attrList[pageIndex].."ball_normal.png")
                pageIndex = pageIndex + 1
                attrBallList[pageIndex]:setTexture("image/pet/pet_house/"..attrList[pageIndex].."ball_selected.png")
            end
        end
    end

    local button_left = ccui.Button:create("image/pet/pet_house/turnleft.png","image/pet/pet_house/turnleft_buttondown.png","")
    button_left:setPosition(50, s_DESIGN_HEIGHT/2)
    button_left:addTouchEventListener(button_left_clicked)
    layer:addChild(button_left) 

    local button_right = ccui.Button:create("image/pet/pet_house/turnright.png","image/pet/pet_house/turnright_buttondown.png","")
    button_right:setPosition(s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT/2)
    button_right:addTouchEventListener(button_right_clicked)
    layer:addChild(button_right) 

    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local homeLayer = require("view.home.HomeLayer").create()
            s_SCENE:replaceGameLayer(homeLayer)
        end
    end

    local button_back = ccui.Button:create("image/pet/pet_house/homePageButton.png","","")
    button_back:setPosition(s_DESIGN_WIDTH-50, 50)
    button_back:addTouchEventListener(button_back_clicked)
    layer:addChild(button_back) 

    return layer
end


return PetLayer







