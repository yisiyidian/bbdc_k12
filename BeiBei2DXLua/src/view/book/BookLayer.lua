require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local BigAlter = require("view.alter.BigAlter")
local SmallAlter = require("view.alter.SmallAlter")

local BookLayer = class("BookLayer", function ()
    return cc.Layer:create()
end)


function BookLayer.create()
    local layer = BookLayer.new()

    local backColor = cc.LayerColor:create(cc.c4b(253,252,234,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)


--    local button_middle_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            s_CorePlayManager.enterLevelLayer()
--        end
--    end
--
--    local button_middle = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
--    button_middle:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--    button_middle:setTitleText("进入关卡选择界面")
--    button_middle:setTitleFontSize(30)
--    button_middle:addTouchEventListener(button_middle_clicked)
--    layer:addChild(button_middle)
    
    
    local hint = cc.Label:createWithSystemFont("学英语就像翻越大山，开始挑战吧","",28)
    hint:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT-100)
    hint:setColor(cc.c4b(100,100,100,255))
    backColor:addChild(hint)
    
    
    local name_array = {'CEE', 'CET4', 'CET6', 'IELTF', 'TOEFL'}
    local func_array = {}
    for i = 1, 5 do
        local click = function(sender, eventType)
            if eventType == ccui.TouchEventType.began then                
                local smallAlter = SmallAlter.create("选择"..name_array[i].."课程")
                smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                layer:addChild(smallAlter)
                
                smallAlter.affirm = function()
                    if i == 1 then
                        s_CURRENT_USER.bookKey = s_BOOK_KEY_NCEE
                    elseif i == 2 then
                        s_CURRENT_USER.bookKey = s_BOOK_KEY_CET4
                    elseif i == 3 then
                        s_CURRENT_USER.bookKey = s_BOOK_KEY_CET6
                    elseif i == 4 then
                        s_CURRENT_USER.bookKey = s_BOOK_KEY_IELTS
                    elseif i == 5 then
                        s_CURRENT_USER.bookKey = s_BOOK_KEY_TOEFL
                    end
                end
            end
        end
        table.insert(func_array, click)
    
        local smallBack = ccui.Button:create("image/book/button_choose_book_"..name_array[i]..".png", "image/book/button_choose_book_"..name_array[i]..".png", "")
        smallBack:addTouchEventListener(func_array[i])
        smallBack:setAnchorPoint(0.5,0)
        if i%2 == 0 then
            smallBack:setPosition(s_DESIGN_WIDTH/2 + 150, s_DESIGN_HEIGHT-100 - 300*(math.ceil(i/2)))
        else
            smallBack:setPosition(s_DESIGN_WIDTH/2 - 150, s_DESIGN_HEIGHT-100 - 300*(math.ceil(i/2)))
        end
        if i == 5 then
            smallBack:setPositionX(s_DESIGN_WIDTH/2)
        end
        backColor:addChild(smallBack)
        
        local smallButton = ccui.Button:create("image/book/button_choose_book_"..name_array[i].."_click.png","image/book/button_choose_book_"..name_array[i].."_click.png","")
        smallButton:addTouchEventListener(func_array[i])
        smallButton:setPosition(smallBack:getContentSize().width/2,0)
        smallBack:addChild(smallButton)
        
        local name = cc.Label:createWithSystemFont(name_array[i],"",28)
        name:setPosition(smallButton:getContentSize().width/2,smallButton:getContentSize().height/2)
        smallButton:addChild(name)
    end
    


    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())

        return true
    end

    local onTouchMoved = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return BookLayer
