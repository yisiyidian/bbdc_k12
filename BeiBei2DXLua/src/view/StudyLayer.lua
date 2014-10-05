require("Cocos2d")
require("Cocos2dConstants")
require("model.ReadAllWord")

ProgressBar = require("view.ProgressBar")

local StudyLayer = class("StudyLayer", function ()
    return cc.Layer:create()
end)


function StudyLayer.create()
    local layer = StudyLayer.new()
    
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), size.width, size.height)    
    layer:addChild(backColor)
   
    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(size.width/2, size.height)
    layer:addChild(cloud_up)

    local cloud_down = cc.Sprite:create("image/studyscene/studyscene_cloud_white_down.png")
    cloud_down:setAnchorPoint(0.5, 0)
    cloud_down:setPosition(size.width/2, 0)
    layer:addChild(cloud_down)

    local beach = cc.Sprite:create("image/studyscene/studyscene_beach_down.png")
    beach:setAnchorPoint(0.5, 0)
    beach:setPosition(size.width/2, 0)
    layer:addChild(beach)

    local progressBar = ProgressBar.create(2,2)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)

    ReadAllWord()

    return layer
end

return StudyLayer