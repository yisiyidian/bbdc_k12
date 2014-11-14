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
    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,0.5 * s_DESIGN_HEIGHT)
    self:addChild(back)
    local topline = cc.LayerColor:create(cc.c4b(98,113,121,255),s_RIGHT_X - s_LEFT_X,87)
    topline:ignoreAnchorPointForPosition(false)
    topline:setAnchorPoint(0.5,0.5)
    topline:setPosition(0.5 * s_DESIGN_WIDTH,0.89 * s_DESIGN_HEIGHT + 87)
    self:addChild(topline)
    
    local menu = cc.Menu:create()
    menu:setPosition(0,0.89 * s_DESIGN_HEIGHT)
    self:addChild(menu)
    local friendListButton = cc.MenuItemImage:create('image/friend/fri_titleback_select.png','image/friend/fri_titleback_select.png','')
    friendListButton:setAnchorPoint(0,0.5)
    friendListButton:setPosition(0,0)
    menu:addChild(friendListButton)
    local friendSearchButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    friendSearchButton:setPosition(s_DESIGN_WIDTH / 2,0)
    menu:addChild(friendSearchButton)
    local friendRequestButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    friendRequestButton:setAnchorPoint(1,0.5)
    friendRequestButton:setPosition(s_DESIGN_WIDTH,0)
    menu:addChild(friendRequestButton)
    
    local function onFriendList(sender)
    
    end
    
    local function onFriendSearch(sender)
    
    end
    
    local function onFriendRequest(sender)
    
    end
        
    friendListButton:registerScriptTapHandler(onFriendList)
    friendSearchButton:registerScriptTapHandler(onFriendSearch)
    friendRequestButton:registerScriptTapHandler(onFriendRequest)
    
end

return FriendLayer