require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local PersonalInfo = class("PersonalInfo", function()
    return cc.Layer:create()
end)

function PersonalInfo.create()
    local layer = PersonalInfo.new()
    return layer
end

function PersonalInfo:ctor()
    local currentIndex = 4
    local moved = false
    local start_y = nil
    local colorArray = {cc.c4b(56,182,236,255 ),cc.c4b(238,75,74,255 ),cc.c4b(251,166,24,255 ),cc.c4b(143,197,46,255 )}

    local intro_array = {}
    for i = 1,4 do
        
        local intro = cc.LayerColor:create(colorArray[5-i], s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        intro:ignoreAnchorPointForPosition(false)
        intro:setAnchorPoint(0.5,0.5)
        if i == 4 then
            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
        else
            intro:setPosition(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT*0.5)
        end     
               
        self:addChild(intro,0,string.format('back%d',i))
        if i > 1 then
            local scrollButton = cc.Sprite:create("image/PersonalInfo/scrollHintButton.png")
            scrollButton:setPosition(s_DESIGN_WIDTH/2  ,s_DESIGN_HEIGHT/2 - 400)
            scrollButton:setLocalZOrder(1)
            intro:addChild(scrollButton)
            local move = cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-30)),cc.MoveBy:create(0.5,cc.p(0,30)))
            scrollButton:runAction(cc.RepeatForever:create(move))
        
        end
        table.insert(intro_array, intro)
    end
        
        
    local girl = cc.Sprite:create("image/PersonalInfo/hj_personal_avatar.png")
    girl:setPosition(s_DESIGN_WIDTH/2 - 100,s_DESIGN_HEIGHT/2 + 400)
    girl:setLocalZOrder(2)
    self:addChild(girl)
   
    local label_hint = cc.Label:createWithSystemFont("tester","",36)
    label_hint:setColor(cc.c4b(255 , 255, 255 ,255))
    label_hint:setPosition(s_DESIGN_WIDTH/2 + 100, s_DESIGN_HEIGHT/2 + 420)
    label_hint:setLocalZOrder(2)
    self:addChild(label_hint)
    
    local label_study = cc.Label:createWithSystemFont("CET4","",36)
    label_study:setColor(cc.c4b(255 , 255, 255 ,255))
    label_study:setPosition(s_DESIGN_WIDTH/2 + 100, s_DESIGN_HEIGHT/2 + 380)
    label_study:setLocalZOrder(2)
    self:addChild(label_study)
        
    local back_color = cc.LayerColor:create(cc.c4b(255,255,255,128 ), s_RIGHT_X - s_LEFT_X, 400)
    back_color:ignoreAnchorPointForPosition(false)
    back_color:setAnchorPoint(0.5,0.5)
    back_color:setPosition(s_DESIGN_WIDTH/2 ,s_DESIGN_HEIGHT/2 + 450)
    back_color:setLocalZOrder(1)
    self:addChild(back_color) 
    
    --local node = self:getChildByName(string.format('back%d',1))
    
    local backButton = cc.Sprite:create("image/PersonalInfo/backButtonInPersonalInfo.png")
    backButton:setPosition(s_DESIGN_WIDTH/2 - 200 ,s_DESIGN_HEIGHT/2 + 400)
    backButton:setLocalZOrder(1)
    self:addChild(backButton)
    
--    local back_Button = cc.MenuItemImage("image/PersonalInfo/backButtonInPersonalInfo.png",
--        "image/PersonalInfo/backButtonInPersonalInfo.png","image/PersonalInfo/backButtonInPersonalInfo.png")
--    back_Button:setPosition(0,0)
--    back_Button:setLocalZOrder(1)
--    
--    local menu = cc.Menu:create()
--    menu:addChild(back_Button)
--    
--    local s = cc.Director:getInstance():getWinSize()
--    menu:setPosition(cc.p(s.width/2, s.height/2))
--
--    self.addChild(menu)

    
    
    
    
        
        
    local onTouchBegan = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        start_y = location.y
        moved = false
        return true
    end
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
        local location = self:convertToNodeSpace(touch:getLocation())
        local now_y = location.y
        if now_y - 200 > start_y then

            if currentIndex > 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT*1.5))
                intro_array[currentIndex]:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex-1]:runAction(cc.Sequence:create(action2, action3))

                currentIndex = currentIndex - 1 
                
           
            end
        elseif now_y + 200 < start_y then
            if currentIndex < 4 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                moved = true

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,-s_DESIGN_HEIGHT/2))
                intro_array[currentIndex]:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                intro_array[currentIndex+1]:runAction(cc.Sequence:create(action2, action3))

                currentIndex = currentIndex + 1
              
  
            end
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return PersonalInfo