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

local PetAlter = require("view.pet.PetAlter")
local PetCfg = require("view.pet.PetCfg")
local LocalPetCfg = require("view.pet.LocalPetCfg")

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

    local pageList = {}
    local petList = {}
    for page = 0, 4 do
        local backColor = cc.LayerColor:create(colorList[page+1], bigWidth, s_DESIGN_HEIGHT)
        backColor:setAnchorPoint(0.5,0.5)
        backColor:ignoreAnchorPointForPosition(false)  
        backColor:setPosition(s_DESIGN_WIDTH/2+bigWidth*page, s_DESIGN_HEIGHT/2)
        layer:addChild(backColor)
        table.insert(pageList, backColor)
        local oneAttrPetList = {}
        for row = 0, 1 do
            for col = 0, 1 do
                local petIndex = row*2+col+1
                if petIndex <= attrCnt[page+1] then
                    local petBack = cc.Sprite:create("image/pet/pet_house/"..attrList[page+1].."card.png")
                    petBack:setPosition(bigWidth/2 - 120 + 240*col, s_DESIGN_HEIGHT/2 + 190 - 380*row)
                    backColor:addChild(petBack)
                    table.insert(oneAttrPetList, petBack)

                    local attrBall = cc.Sprite:create("image/pet/pet_house/blueball_normal.png")
                    attrBall:setPosition(60, petBack:getContentSize().height-60)
                    petBack:addChild(attrBall)

                    local petStar = cc.Sprite:create("image/pet/pet_house/star.png")
                    petStar:setPosition(petBack:getContentSize().width-70, petBack:getContentSize().height-60)
                    petBack:addChild(petStar)

                    local pet = cc.Sprite:create("image/pet/pet_detail/"..attrList[page+1].."_"..petIndex.."_1.png")
                    pet:setPosition(petBack:getContentSize().width/2, petBack:getContentSize().height/2)
                    pet:setScale(0.6)
                    petBack:addChild(pet)

                    local petID = attrList[page+1].."_"..petIndex
                    local petDesc = cc.Label:createWithSystemFont("Lv"..LocalPetCfg[petID]["level"].." "..PetCfg[petID.."_1"]["name"],"",28)
                    petDesc:setPosition(petBack:getContentSize().width/2,60)
                    petBack:addChild(petDesc)
                end
            end
        end
        table.insert(petList, oneAttrPetList)
    end


    local attrBallList = {}
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


    local onTouchBegan = function(touch, event)        
        return true
    end

    local onTouchEnded = function(touch, event)
        for index1 = 1, #petList do
            for index2 = 1, #petList[index1] do 
                local location = petList[index1][index2]:convertToNodeSpace(touch:getLocation())
                local size = petList[index1][index2]:getBoundingBox()
                if cc.rectContainsPoint({x=0,y=0,width=size.width,height=size.height}, location) then
                    local petAlter = PetAlter.create(attrList[index1].."_"..index2)
                    layer:addChild(petAlter)
                end
            end
        end
        -- local location = main:convertToNodeSpace(touch:getLocation())
        -- if not cc.rectContainsPoint(back:getBoundingBox(),location) then
        --     local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
        --     local action2 = cc.EaseBackIn:create(action1)
        --     local remove = cc.CallFunc:create(function()
        --         main:removeFromParent()
        --     end)
        --     back:runAction(cc.Sequence:create(action2,remove))
        -- end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end


return PetLayer







