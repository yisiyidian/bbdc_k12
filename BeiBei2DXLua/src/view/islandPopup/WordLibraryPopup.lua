local WordLibraryPopup = class ("WordLibraryPopup",function ()
    return cc.Layer:create()
end)

local Listview = require("view.islandPopup.WordLibraryListview")

function WordLibraryPopup.create()
    local layer = WordLibraryPopup.new()
    return layer
end

function WordLibraryPopup:ctor()

    local backPopup = cc.Sprite:create("image/islandPopup/backforlibrary.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backPopup)

    local top_sprite = cc.Sprite:create("image/islandPopup/top.png")
    top_sprite:setPosition(backPopup:getContentSize().width * 0.5,backPopup:getContentSize().height * 0.95)
    top_sprite:ignoreAnchorPointForPosition(false)
    top_sprite:setAnchorPoint(0.5,0.5)
    backPopup:addChild(top_sprite)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end

    local button_close = ccui.Button:create("image/friend/close.png","","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(top_sprite:getContentSize().width - 30 , top_sprite:getContentSize().height - 30 )
    button_close:addTouchEventListener(button_close_clicked)
    top_sprite:addChild(button_close)
    
    local line_sprite = cc.Sprite:create("image/islandPopup/line.png")
    line_sprite:setPosition(top_sprite:getContentSize().width * 0.5,top_sprite:getContentSize().height * 0.05)
    line_sprite:ignoreAnchorPointForPosition(false)
    line_sprite:setAnchorPoint(0.5,0.5)
    top_sprite:addChild(line_sprite)
    

    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end

    local button_back = ccui.Button:create("image/islandPopup/backtopocess.png","","")
    button_back:setScale9Enabled(true)
    button_back:setPosition(top_sprite:getContentSize().width *0.1 , top_sprite:getContentSize().height *0.5 )
    button_back:addTouchEventListener(button_back_clicked)
    top_sprite:addChild(button_back)
    
    local familiar_button = cc.Sprite:create("image/islandPopup/familiarwordend.png")
    familiar_button:setPosition(top_sprite:getContentSize().width * 0.5 + familiar_button:getContentSize().width * 0.5,top_sprite:getContentSize().height * 0.5)
    familiar_button:ignoreAnchorPointForPosition(false)
    familiar_button:setAnchorPoint(0.5,0.5)
    top_sprite:addChild(familiar_button) 
    
    local familiar_label = cc.Label:createWithSystemFont("熟词","",35)
    familiar_label:setPosition(familiar_button:getContentSize().width / 2,familiar_button:getContentSize().height / 2)
    familiar_button:addChild(familiar_label)
    
    local unfamiliar_button = cc.Sprite:create("image/islandPopup/unfamiliarwordbegin.png")
    unfamiliar_button:setPosition(top_sprite:getContentSize().width * 0.5 - unfamiliar_button:getContentSize().width * 0.5,top_sprite:getContentSize().height * 0.5)
    unfamiliar_button:ignoreAnchorPointForPosition(false)
    unfamiliar_button:setAnchorPoint(0.5,0.5)
    top_sprite:addChild(unfamiliar_button) 
    
    local unfamiliar_label = cc.Label:createWithSystemFont("生词","",35)
    unfamiliar_label:setPosition(unfamiliar_button:getContentSize().width / 2,unfamiliar_button:getContentSize().height / 2)
    unfamiliar_button:addChild(unfamiliar_label)
    
    local onTouchBegan = function(touch, event)
        return true  
    end
    
    local onTouchEnded = function(touch, event)
        local location = top_sprite:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(familiar_button:getBoundingBox(), location) then
            familiar_button:setTexture("image/islandPopup/familiarwordend.png")
            unfamiliar_button:setTexture("image/islandPopup/unfamiliarwordbegin.png")
            print("1")
        end
        if cc.rectContainsPoint(unfamiliar_button:getBoundingBox(), location) then
            familiar_button:setTexture("image/islandPopup/familiarwordbegin.png")
            unfamiliar_button:setTexture("image/islandPopup/unfamiliarwordend.png")
            print("2")
        end
    end
    
    local listview = Listview:create()
    listview:setPosition(2,50)
    backPopup:addChild(listview)
    
    local bottom_sprite = cc.Sprite:create("image/islandPopup/bottom.png")
    bottom_sprite:setPosition(backPopup:getContentSize().width * 0.5,backPopup:getContentSize().height * 0.05)
    bottom_sprite:ignoreAnchorPointForPosition(false)
    bottom_sprite:setAnchorPoint(0.5,0.5)
    backPopup:addChild(bottom_sprite)
    
    local review_button_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
    		print("review")
    	end
    end
    
    local review_button = ccui.Button:create("image/islandPopup/button.png","","")
    review_button:setScale9Enabled(true)
    review_button:setPosition(bottom_sprite:getContentSize().width * 0.7,bottom_sprite:getContentSize().height * 0.5)
    review_button:ignoreAnchorPointForPosition(false)
    review_button:setAnchorPoint(0.5,0.5)
    review_button:setTitleText("复习怪兽")
    review_button:setTitleFontSize(30)
    review_button:addTouchEventListener(review_button_click)
    bottom_sprite:addChild(review_button)
    
    
    
    local summary_button_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            print("summary")
        end
    end
    
    local summary_button = ccui.Button:create("image/islandPopup/button.png","","")
    summary_button:setScale9Enabled(true)
    summary_button:setPosition(bottom_sprite:getContentSize().width * 0.3,bottom_sprite:getContentSize().height * 0.5)
    summary_button:ignoreAnchorPointForPosition(false)
    summary_button:setAnchorPoint(0.5,0.5)
    summary_button:setTitleText("总结怪兽")
    summary_button:setTitleFontSize(30)
    summary_button:addTouchEventListener(summary_button_click)
    bottom_sprite:addChild(summary_button)
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = top_sprite:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, top_sprite)   

end

return WordLibraryPopup