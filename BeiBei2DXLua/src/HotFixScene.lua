require("cocos.init")

local HotFixScene = class("HotFixScene", function()
    return cc.Scene:create()
end)

function HotFixScene.create()
    local scene = HotFixScene.new()
    return scene
end

function HotFixScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
    
    -- self:scheduleUpdateWithPriorityLua(update, 0)
    -- self:registerCustomEvent()
end

return HotFixScene