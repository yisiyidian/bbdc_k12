--Old wordlist, deprecated on version 1.8.0.1

require("cocos.init")
require("common.global")

local WordMenu = class('WordMenu', function()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH

function WordMenu.create()
    local layer = WordMenu.new()
    return layer
end

function WordMenu:ctor()
    local back = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,0.5 * s_DESIGN_HEIGHT)
    self:addChild(back)
--    local topline = cc.LayerColor:create(cc.c4b(98,113,121,255),s_RIGHT_X - s_LEFT_X,87)
--    topline:ignoreAnchorPointForPosition(false)
--    topline:setAnchorPoint(0.5,0.5)
--    topline:setPosition(0.5 * s_DESIGN_WIDTH,0.89 * s_DESIGN_HEIGHT + 87)
--    self:addChild(topline)

    local menu = cc.Menu:create()
    self:addChild(menu)
    menu:setPosition(s_LEFT_X ,  s_DESIGN_HEIGHT)
    
    self.backButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_select.png','')
    self.backButton:setScaleY(2)
    self.backButton:ignoreAnchorPointForPosition(false)
    self.backButton:setAnchorPoint(0,1)
    self.backButton:setPosition(0,0)
    self.backButton:setScaleX(scale)
    
    local title1 = cc.Sprite:create('image/word_list/button_wordbook_back.png')
    title1:setPosition(self.backButton:getContentSize().width / 2,self.backButton:getContentSize().height / 2)
    title1:setScaleX(1 / scale)
    title1:setScaleY(1 /  2)
    self.backButton:addChild(title1,1)
    menu:addChild(self.backButton)
    
    self.learnedListButton = cc.MenuItemImage:create('image/friend/fri_titleback_select.png','image/friend/fri_titleback_unselect.png','')
    self.learnedListButton:setPosition(bigWidth / 2,0)
    self.learnedListButton:ignoreAnchorPointForPosition(false)
    self.learnedListButton:setAnchorPoint(0.5,1)
    self.learnedListButton:setScaleX(scale)
    self.learnedListButton:setScaleY(2)
    
    local title2 = cc.Label:createWithSystemFont('已学习','',28)
    title2:setPosition(self.learnedListButton:getContentSize().width / 2,self.learnedListButton:getContentSize().height / 2)
    title2:setScaleX(1 / scale)
    title2:setScaleY(1 / 2)
    self.learnedListButton:addChild(title2,1)
    menu:addChild(self.learnedListButton)
    
    
    self.masteredListButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    self.masteredListButton:ignoreAnchorPointForPosition(false)
    self.masteredListButton:setPosition(bigWidth,0)
    self.masteredListButton:setAnchorPoint(1,1)
    self.masteredListButton:setScaleX(scale)
    self.masteredListButton:setScaleY(2)
        
    local title3 = cc.Label:createWithSystemFont('已掌握','',28)
    title3:setPosition(self.masteredListButton:getContentSize().width / 2,self.masteredListButton:getContentSize().height / 2)
    title3:setScaleX(1 / scale)
    title3:setScaleY(1 / 2)
    self.masteredListButton:addChild(title3,1)
    menu:addChild(self.masteredListButton)

    local list = require('view.wordlist.LearnedWordList')
    local layer = list.create()
    layer:setAnchorPoint(0.5,0)
    layer:setName('learned')
    self:addChild(layer,0)

    local function onBack(sender)
        --self.backButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.masteredListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.learnedListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self:removeChildByName('learned',true)
        self:removeChildByName('mastered',true)
        s_CorePlayManager.enterHomeLayer()
    end

    local function onLearnedList(sender)
        self.backButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.masteredListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.learnedListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self:removeChildByName('mastered',true)
        if not self:getChildByName('learned') then
            local list = require('view.wordlist.LearnedWordList')
            local layer = list.create()
            layer:setAnchorPoint(0.5,0)
            layer:setName('learned')
            self:addChild(layer,0)
        end
    end

    local function onMasteredList(sender)
        self.backButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.masteredListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.learnedListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self:removeChildByName('learned',true)
        if not self:getChildByName('mastered') then
            local request = require('view/wordlist/MasteredWordList')
            local layer = request.create()
            layer:setAnchorPoint(0.5,0)
            layer:setName('mastered')
            self:addChild(layer,0)
        end
    end

    self.backButton:registerScriptTapHandler(onBack)
    self.learnedListButton:registerScriptTapHandler(onLearnedList)
    self.masteredListButton:registerScriptTapHandler(onMasteredList)
end

return WordMenu
