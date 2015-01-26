require("cocos.init")
require("common.global")

local SaveDataInfo = class('SaveDataInfo',function ()
	return cc.Layer:create()
end)

function SaveDataInfo.create(target,index)
	local layer = SaveDataInfo.new()
	--layer.target = target
    local black = cc.LayerColor:create(cc.c4b(0,0,0,128),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    black:ignoreAnchorPointForPosition(false)
    black:setAnchorPoint(0.5,0)
    black:setPosition(s_DESIGN_WIDTH / 2,0)
    layer:addChild(black)

    local png = string.format("target_saved%d.png",index)
    target:saveToFile(png, cc.IMAGE_FORMAT_PNG)
    local pImage = target:newImage()
    local tex = cc.Director:getInstance():getTextureCache():addImage(pImage, png)
    pImage:release()
    local sprite = cc.Sprite:createWithTexture(tex)
    sprite:setScale(0.8)
    sprite:setPosition(black:getContentSize().width / 2,black:getContentSize().height / 2)
    black:addChild(sprite)

    local ShareBottom = require('view.share.ShareBottom')
    local shareBottomLayer = ShareBottom.create(target)
    layer:addChild(shareBottomLayer)

    local onTouchBegan = function(touch, event)
        return true
    end    
    
    local onTouchMoved = function(touch, event)
    end
    
    local onTouchEnded = function(touch, event)
    end
    
    layer.listener = cc.EventListenerTouchOneByOne:create()
    
    layer.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    layer.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    layer.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(layer.listener, layer)
    layer.listener:setSwallowTouches(true)
	return layer
end

function SaveDataInfo:shareEnd()
    local delay = cc.DelayTime:create(0.3)
    local remove = cc.CallFunc:create(function ()
        self:removeFromParent()
    end)
    self:runAction(cc.Sequence:create(delay,remove))
end

return SaveDataInfo