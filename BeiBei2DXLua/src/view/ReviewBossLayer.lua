require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local RBProgressBar = require("view.RBProgressBar")


local ReviewBossLayer = class("ReviewBossLayer", function ()
    return cc.Layer:create()
end)


function ReviewBossLayer.create()

    local layer = ReviewBossLayer.new()

    local back = cc.Sprite:create("image/reviewbossscene/background_fuxiboss_diyiguan.png")
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5, 0.5)
    back:setPosition(size.width/2, size.height/2)
    layer:addChild(back)

    local rbProgressBar = RBProgressBar.create(5)
    rbProgressBar:setPosition(size.width/2, 1040)
    layer:addChild(rbProgressBar)
    
    local onTouchBegan = function(touch, event)
        s_logd("touch began on block layer")
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
