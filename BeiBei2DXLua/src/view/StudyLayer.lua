require("Cocos2d")
require("Cocos2dConstants")

local StudyLayer = class("StudyLayer", function ()
    return cc.Layer:create()
end)

function StudyLayer.create()
    local layer = StudyLayer.new()
    
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255), size.width, size.height)
    --backColor:setAnchorPoint(0.5,0.5)
    --backColor:setPosition(100,100)
    
    layer:addChild(backColor)
    
    print("add successfully")
    
    return layer
end

return StudyLayer