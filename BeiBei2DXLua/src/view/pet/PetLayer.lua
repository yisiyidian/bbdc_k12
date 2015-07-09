
local PetLayer = class("PetLayer", function()
    return cc.Layer:create()
end)

function PetLayer.create()    
    local layer = PetLayer.new()

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

    return layer
end


return PetLayer







