local EnlargeTouchAreaReturnButton = class ("EnlargeTouchAreaReturnButton",function ()
    return cc.Layer:create()
end) 

function EnlargeTouchAreaReturnButton.create(touch_begin_texture,touch_end_texture)
    local layer = EnlargeTouchAreaReturnButton.new(touch_begin_texture,touch_end_texture)
    return layer
end

function EnlargeTouchAreaReturnButton:ctor(touch_begin_texture,touch_end_texture)

    local sprite = cc.Sprite:create(touch_begin_texture)
    sprite:ignoreAnchorPointForPosition(false)
    sprite:setAnchorPoint(0.5,0.5)
    self:addChild(sprite)

    self.func = function ()

    end
  

    local width = sprite:getContentSize().width * 1.25
    local height = sprite:getContentSize().height * 1.25
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,0), width, height)
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(0.5,0.5)
    layer:setPosition(cc.p(sprite:getContentSize().width / 2,sprite:getContentSize().height / 2))
    sprite:addChild(layer)
    
    local onTouchBegan = function(touch, event)
        local location = sprite:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(layer:getBoundingBox(),location) then
            sprite:setTexture(touch_end_texture) 
        end
        return true  
    end

    local onTouchEnded = function(touch, event)
        sprite:setTexture(touch_begin_texture) 
        local location = sprite:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(layer:getBoundingBox(),location) then
            self.func()
        end
    end
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)   
end

return EnlargeTouchAreaReturnButton