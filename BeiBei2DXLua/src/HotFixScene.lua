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

    -- local status = cx.CXNetworkStatus:getInstance():getStatus()
    -- if status == NETWORK_STATUS_WIFI then
    --     return true
    -- elseif status == NETWORK_STATUS_MOBILE then
    --     return true
    -- else
    --     return false
    -- end
    
    -- self:scheduleUpdateWithPriorityLua(update, 0)
    -- self:registerCustomEvent()

    -- go to O2OController.onAssetsManagerCompleted()

    -- if needUpdate == true then
    --     local updateInfoLabel = DynamicUpdate.initUpdateLabel()
    --     layer:addChild(updateInfoLabel,1000)
    --     DynamicUpdate.beginLoginUpdate(updateInfoLabel)
    -- else
    
    -- end
end

return HotFixScene