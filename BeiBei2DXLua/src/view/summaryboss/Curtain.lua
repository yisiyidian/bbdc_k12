
local Curtain = class ("Curtain",function ()
    return cc.Layer:create()
end)

function Curtain.create()
    local layer = Curtain.new()
    return layer
end

function Curtain:ctor()
	local curtain = cc.LayerColor:create(cc.c4b(0,0,0,150),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    self:addChild(curtain)
    curtain:setPosition(s_LEFT_X,0)
    self.remove = function() end
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
    	self.remove()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end

return Curtain