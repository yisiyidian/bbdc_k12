require "Cocos2d"
require "Cocos2dConstants"

local GameLayer = class("GameLayer", function ()
    return cc.Layer:create()
end)



return GameLayer