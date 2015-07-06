-- require("cocos.init")
-- require("common.global")
-- ##########################################################
-- 重构中
local  longButtonInStudy = class("longButtonInStudy", function ()
    return cc.Sprite:create()
end)

function longButtonInStudy:ctor(backTexture,front,moveLength,text)
    self.backTexture = backTexture
    self.frontTexture = frontTexture
    self.moveLength = moveLength
    self.text = text

    self:initUI()
end

function longButtonInStudy:initUI()
    local button_back = cc.Sprite:create()
    button_back:ignoreAnchorPointForPosition(false)
    button_back:setAnchorPoint(0.5,0.5)
    self.button_back = button_back

    self.func = function ()
        
    end
end



    button_back.func = function ()
    end

    button_back.button_front = cc.Sprite:create()
    button_back.button_front:ignoreAnchorPointForPosition(false)
    button_back.button_front:setAnchorPoint(0.5,0.5)
    button_back.button_front:setPosition(button_back:getContentSize().width / 2,button_back:getContentSize().height / 2 + 9)
    button_back:addChild(button_back.button_front)

    local label = cc.Label:createWithSystemFont(text,"",30)
    label:setPosition(button_back.button_front:getContentSize().width / 2, button_back.button_front:getContentSize().height / 2)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(255,255,255,255))
    button_back.label = label
    button_back.button_front:addChild(button_back.label)

    local function onTouchBegan(touch, event)
        local location = button_back:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(button_back.button_front:getBoundingBox(),location) then
            playSound(s_sound_buttonEffect)  
            button_back.button_front:setPosition(button_back:getContentSize().width / 2,button_back:getContentSize().height / 2)
        end
        return true
    end

    local function onTouchEnded(touch, event)            
        button_back.button_front:setPosition(button_back:getContentSize().width / 2,button_back:getContentSize().height / 2 + 9)
        local location = button_back:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(button_back.button_front:getBoundingBox(),location) then 
           button_back.func()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = button_back:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, button_back)

    return button_back
end

function longButtonInStudy:reset()
    setTexture
end

return longButtonInStudy