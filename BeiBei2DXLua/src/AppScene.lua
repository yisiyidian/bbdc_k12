require("Cocos2d")
require("Cocos2dConstants")
require("AudioMgr")
local BackgroundLayer = require("layer.BackgroundLayer")
local GameLayer = require("layer.GameLayer")
local HudLayer = require("layer.HudLayer")
local PopupLayer = require("layer.PopupLayer")
local TipsLayer = require("layer.TipsLayer")
local TouchEventBlockLayer = require("layer.TouchEventBlockLayer")
local DebugLayer = require("layer.DebugLayer")

local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()
    
    scene.bgLayer = BackgroundLayer.create()
    scene:addChild(scene.bgLayer)

    scene.gameLayer = GameLayer.create()
    scene:addChild(scene.gameLayer)

    scene.hudLayer = HudLayer.create()
    scene:addChild(scene.hudLayer)

    scene.popupLayer = PopupLayer.create()
    scene:addChild(scene.popupLayer)

    scene.tipsLayer = TipsLayer.create()
    scene:addChild(scene.tipsLayer)

    scene.touchEventBlockLayer = TouchEventBlockLayer.create()
    scene:addChild(scene.touchEventBlockLayer)

    scene.debugLayer = DebugLayer.create()
    scene:addChild(scene.debugLayer)
    
    return scene
end

function AppScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

return AppScene
