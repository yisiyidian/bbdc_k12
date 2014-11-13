require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local FriendLayer = class("FriendLayer", function()
    return cc.Layer:create()
end)

function FriendLayer.create()
   local layer = FriendLayer.new()
   return layer 
end

function FriendLayer:ctor()
    local menu = cc.Menu:create()
    menu:setPosition(0,0.8 * s_DESIGN_HEIGHT)
    self:addChild(menu)
    local friendListButton = cc.MenuItemImage:create('','','')
    friendListButton:setPosition(0,0)
    menu:addChild(friendListButton)
    local friendSearchButton = cc.MenuItemImage:create('','','')
    
    local friendRequestButton = cc.MenuItemImage:create('','','')
end

return FriendLayer