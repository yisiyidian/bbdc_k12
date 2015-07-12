
local PetLayer = class("PetLayer", function()
    return cc.Layer:create()
end)

function PetLayer.create()    
    local layer = PetLayer.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local bigHeight = 1.0*s_DESIGN_HEIGHT

    local initColor = cc.LayerColor:create(cc.c4b(172,220,238,255), bigWidth, s_DESIGN_HEIGHT)
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

    local backColor = cc.LayerColor:create(cc.c4b(172,220,238,255), bigWidth, bigHeight)
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

    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           -- layer.backToHome()
            local homeLayer = require("view.home.HomeLayer").create()
            s_SCENE:replaceGameLayer(homeLayer)
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


    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then

        end
    end

    local button_left = ccui.Button:create("image/pet/pet_house/turnleft.png","image/pet/pet_house/turnleft_buttondown.png","")
    button_left:setPosition(50, s_DESIGN_HEIGHT/2)
    button_left:addTouchEventListener(button_left_clicked)
    layer:addChild(button_left) 

    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then

        end
    end

    local button_right = ccui.Button:create("image/pet/pet_house/turnright.png","image/pet/pet_house/turnright_buttondown.png","")
    button_right:setPosition(s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT/2)
    button_right:addTouchEventListener(button_right_clicked)
    layer:addChild(button_right) 


    for i = 0, 1 do
        for j = 0, 1 do
            local petBack = cc.Sprite:create("image/pet/pet_house/blueCard.png")
            petBack:setPosition(s_DESIGN_WIDTH/2 - 120 + 240*i, s_DESIGN_HEIGHT/2-190+380*j)
            layer:addChild(petBack)

            local attrBall = cc.Sprite:create("image/pet/pet_house/blueball_normal.png")
            attrBall:setPosition(60, petBack:getContentSize().height-60)
            petBack:addChild(attrBall)

            local petStar = cc.Sprite:create("image/pet/pet_house/star.png")
            petStar:setPosition(petBack:getContentSize().width-70, petBack:getContentSize().height-60)
            petBack:addChild(petStar)

            local pet = cc.Sprite:create("image/pet/pet_detail/bluepet/jienigui-1.png")
            pet:setPosition(petBack:getContentSize().width/2, petBack:getContentSize().height/2)
            pet:setScale(0.6)
            petBack:addChild(pet)

            local petDesc = cc.Label:createWithSystemFont("Lv. 1 妙蛙种子","",28)
            petDesc:setPosition(petBack:getContentSize().width/2,60)
            petBack:addChild(petDesc)
        end
    end


    return layer
end


return PetLayer







