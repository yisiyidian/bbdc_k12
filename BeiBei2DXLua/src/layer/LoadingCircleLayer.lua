require("Cocos2d")
require("Cocos2dConstants")

local LoadingCircleLayer = class("LoadingCircleLayer", function ()
    return cc.Layer:create()
end)

function LoadingCircleLayer.create()
    local layer = LoadingCircleLayer.new()
    return layer
end

function LoadingCircleLayer:ctor()
    self:setVisible(false)

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end
    
    local onTouchMoved = function(touch, event)
        --s_logd("touch moved on block layer")
    end
    
    local onTouchEnded = function(touch, event)
        --s_logd("touch ended on block layer")
    end
    
    self.listener = cc.EventListenerTouchOneByOne:create()
    
    self.listener:registerScriptHandler( onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler( onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler( onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)

    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    self.bg:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(self.bg)

    self.loadingIcon = cc.Sprite:create("image/icon_loading.png")
    self.loadingIcon:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    self.loadingIcon:setScale(2)
    self:addChild(self.loadingIcon)

    local degree = 0
    -- delta time : seconds
    local function update(dt)
        if self:isVisible() then 
            degree = degree + 10 * 30 * dt
            if degree >= 360 then degree = 0 end
            self.loadingIcon:setRotation(degree)
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0)
end

function LoadingCircleLayer:show()
    self.listener:setSwallowTouches(true)
    self:setVisible(true)
end

function LoadingCircleLayer:hide()
    self.listener:setSwallowTouches(false)
    self:setVisible(false)
end

return LoadingCircleLayer
