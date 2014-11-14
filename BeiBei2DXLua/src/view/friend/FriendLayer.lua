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
    self.friendListButton = cc.MenuItemImage:create('image/friend/fri_titleback_select.png','image/friend/fri_titleback_select.png','')
    self.friendListButton:setAnchorPoint(0,0.5)
    self.friendListButton:setPosition(0,0)
    local title1 = cc.Label:createWithSystemFont('好友列表','',28)
    title1:setPosition(self.friendListButton:getContentSize().width / 2,self.friendListButton:getContentSize().height / 2)
    self.friendListButton:addChild(title1,1)
    menu:addChild(self.friendListButton)
    self.friendSearchButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    self.friendSearchButton:setPosition(s_DESIGN_WIDTH / 2,0)
    local title2 = cc.Label:createWithSystemFont('查找好友','',28)
    title2:setPosition(self.friendSearchButton:getContentSize().width / 2,self.friendSearchButton:getContentSize().height / 2)
    self.friendSearchButton:addChild(title2,1)
    menu:addChild(self.friendSearchButton)
    self.friendRequestButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    self.friendRequestButton:setAnchorPoint(1,0.5)
    self.friendRequestButton:setPosition(s_DESIGN_WIDTH,0)
    local title3 = cc.Label:createWithSystemFont('好友请求','',28)
    title3:setPosition(self.friendRequestButton:getContentSize().width / 2,self.friendRequestButton:getContentSize().height / 2)
    self.friendRequestButton:addChild(title3,1)
    menu:addChild(self.friendRequestButton)
    
    local list = require('view.friend.FriendList')
    local layer = list.create()
    layer:setAnchorPoint(0.5,0)
    self:addChild(layer,0,'list')
    
    local function onFriendList(sender)
        self.friendListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.friendRequestButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendSearchButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self:removeChildByName('search',true)
        self:removeChildByName('request',true)
        if not self:getChildByName('list') then
            local list = require('view.friend.FriendList')
            local layer = list.create()
            layer:setAnchorPoint(0.5,0)
            self:addChild(layer,0,'list')
        end
    end
    
    local function onFriendSearch(sender)
        self.friendListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendRequestButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendSearchButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self:removeChildByName('list',true)
        self:removeChildByName('request',true)
        if not self:getChildByName('list') then
            local search = require('view.friend.FriendSearch')
            local layer = search.create()
            layer:setAnchorPoint(0.5,0)
            self:addChild(layer,0,'search')
        end
    end
    
    local function onFriendRequest(sender)
        self.friendListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendRequestButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.friendSearchButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self:removeChildByName('search',true)
        self:removeChildByName('list',true)
        if not self:getChildByName('list') then
            local request = require('view.friend.FriendRequest')
            local layer = request.create()
            layer:setAnchorPoint(0.5,0)
            self:addChild(layer,0,'request')
        end
    end
        
    self.friendListButton:registerScriptTapHandler(onFriendList)
    self.friendSearchButton:registerScriptTapHandler(onFriendSearch)
    self.friendRequestButton:registerScriptTapHandler(onFriendRequest)
    
end

return FriendLayer