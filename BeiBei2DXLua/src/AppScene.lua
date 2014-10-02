require "Cocos2d"
require "Cocos2dConstants"
require "AudioMgr"
local GameLayer = require "layer.GameLayer"

local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()
    -- playMusic("background.mp3", true)
    scene.gameLayer = GameLayer.create()
    scene:addChild(scene.gameLayer)
    return scene
end


function AppScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

function AppScene:test()
    require "model.randomMat"
    randomMat(4, 4)
    
    print(self.gameLayer)
    local main_back = sp.SkeletonAnimation:create("res/spine/coconut_light.json", "res/spine/coconut_light.atlas", 0.5)
    main_back:setPosition(50, 50)
    self.gameLayer:addChild(main_back)
end

return AppScene
