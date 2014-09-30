require "Cocos2d"
require "Cocos2dConstants"
require "AudioMgr"

local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()
    -- playMusic("background.mp3", true)
    return scene
end


function AppScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

function AppScene:test()
    require "model.mat"
    mat(4, 4)
end

return AppScene
