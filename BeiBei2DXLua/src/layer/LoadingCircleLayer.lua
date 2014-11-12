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

    self.label_info = cc.Label:createWithSystemFont("", "", 28)
    self.label_info:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.label_info:setColor(cc.c4b(255,255,255,255))
    self.label_info:setAnchorPoint(0.5, 1)
    self.label_info:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2 - self.loadingIcon:getContentSize().height - 10)
    self:addChild(self.label_info)

    local degree = 0
    local layer = self
    -- delta time : seconds
    local function update(dt)
        if layer:isVisible() then 
            degree = degree + 10 * 30 * dt
            if degree >= 360 then degree = 0 end
            layer.loadingIcon:setRotation(degree)
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0)
end

function LoadingCircleLayer:show(info)
    if info == nil then 
        self.label_info:setString(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING)) 
    else
        self.label_info:setString(info)
    end
    self.listener:setSwallowTouches(true)
    self:setVisible(true)
end

function LoadingCircleLayer:hide()
    self.listener:setSwallowTouches(false)
    self:setVisible(false)
end

return LoadingCircleLayer
