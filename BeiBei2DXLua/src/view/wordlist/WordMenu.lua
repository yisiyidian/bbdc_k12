require("Cocos2d")
require("Cocos2dConstants")
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
    self.backButton:ignoreAnchorPointForPosition(false)
    self.backButton:setAnchorPoint(0,1)
    self.backButton:setPosition(0,0)
    self.backButton:setScale(scale)
    
    local title1 = cc.Sprite:create('image/word_list/button_wordbook_back.png')
    title1:setPosition(self.backButton:getContentSize().width / 2,self.backButton:getContentSize().height / 2)
    title1:setScale(1 / scale)
    self.backButton:addChild(title1,1)
    menu:addChild(self.backButton)
    
    self.studyedListButton = cc.MenuItemImage:create('image/friend/fri_titleback_select.png','image/friend/fri_titleback_unselect.png','')
    self.studyedListButton:setPosition(bigWidth / 2,0)
    self.studyedListButton:ignoreAnchorPointForPosition(false)
    self.studyedListButton:setAnchorPoint(0.5,1)
    self.studyedListButton:setScale(scale)

    local title2 = cc.Label:createWithSystemFont('已学习','',28)
    title2:setPosition(self.studyedListButton:getContentSize().width / 2,self.studyedListButton:getContentSize().height / 2)
    title2:setScale(1 / scale)
    self.studyedListButton:addChild(title2,1)
    menu:addChild(self.studyedListButton)
    
    
    self.masteredListButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    self.masteredListButton:ignoreAnchorPointForPosition(false)
    self.masteredListButton:setPosition(bigWidth,0)
    self.masteredListButton:setAnchorPoint(1,1)
    self.masteredListButton:setScale(scale)
        
    local title3 = cc.Label:createWithSystemFont('已掌握','',28)
    title3:setPosition(self.masteredListButton:getContentSize().width / 2,self.masteredListButton:getContentSize().height / 2)
    title3:setScale(1 / scale)
    self.masteredListButton:addChild(title3,1)
    menu:addChild(self.masteredListButton)

    local list = require('view.wordlist.StudyedWordList')
    local layer = list.create()
    layer:setAnchorPoint(0.5,0)
    layer:setName('studyed')
    self:addChild(layer,0)

    local function onBack(sender)
        --self.backButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.masteredListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.studyedListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self:removeChildByName('studyed',true)
        self:removeChildByName('mastered',true)
        s_CorePlayManager.enterHomeLayer()
    end

    local function onStudyedList(sender)
        self.backButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.masteredListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.studyedListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self:removeChildByName('mastered',true)
        if not self:getChildByName('studyed') then
            local list = require('view.wordlist.StudyedWordList')
            local layer = list.create()
            layer:setAnchorPoint(0.5,0)
            layer:setName('studyed')
            self:addChild(layer,0)
        end
    end

    local function onMasteredList(sender)
        self.backButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.masteredListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.studyedListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self:removeChildByName('studyed',true)
        if not self:getChildByName('mastered') then
            local request = require('view/wordlist/MasteredWordList')
            local layer = request.create()
            layer:setAnchorPoint(0.5,0)
            layer:setName('mastered')
            self:addChild(layer,0)
        end
    end

    self.backButton:registerScriptTapHandler(onBack)
    self.studyedListButton:registerScriptTapHandler(onStudyedList)
    self.masteredListButton:registerScriptTapHandler(onMasteredList)
end

return WordMenu
