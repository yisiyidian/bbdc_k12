require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local RBProgressBar = require("view.RBProgressBar")


local ReviewBossLayer = class("ReviewBossLayer", function ()
    return cc.Layer:create()
end)


function ReviewBossLayer.create()
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

    local layer = ReviewBossLayer.new()

    local back = cc.Sprite:create("image/reviewbossscene/background_fuxiboss_diyiguan.png")
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5, 0.5)
    back:setPosition(size.width/2, size.height/2)
    layer:addChild(back)

    local rbProgressBar = RBProgressBar.create(5)
    rbProgressBar:setPosition(size.width/2, 1040)
    layer:addChild(rbProgressBar)
    
    
    local sprite_array = {}
    for i = 1, 4 do 
        local tmp = {}
        for j = 1, 3 do
            local sprite = cc.Sprite:create("image/reviewbossscene/rb_boss.png")
            sprite:setPosition(200*j - 80, 936 - 260*i)
            sprite:setScale(0.8)
            layer:addChild(sprite)
            tmp[j] = sprite
        end
        sprite_array[i] = tmp
    end
    
    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        
        for i = 1, 4 do
            for j = 1, 3 do
                local action = cc.MoveBy:create(0.5, cc.p(0, 260))
                sprite_array[i][j]:runAction(action)
            end
        end
        
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer
end

return ReviewBossLayer
