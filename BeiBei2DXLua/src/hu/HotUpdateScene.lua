require("cocos.init")

local HotUpdateScene = class("HotUpdateScene", function()
    return cc.Scene:create()
end)

function HotUpdateScene.create()
    local scene = HotUpdateScene.new()
    return scene
end

function HotUpdateScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
    
    local layer = cc.Layer:create()
    layer:setPosition(s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(layer)

    self.rootLayer = layer
end

return HotUpdateScene