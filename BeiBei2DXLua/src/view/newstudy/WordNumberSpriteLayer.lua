require("cocos.init")
require("common.global")

local SoundMark             = require("view.newstudy.NewStudySoundMark")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar     = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  WordNumberSpriteLayer = class("WordNumberSpriteLayer", function ()
    return cc.Layer:create()
end)

function WordNumberSpriteLayer.create()
    local layer = WordNumberSpriteLayer.new()
    return layer
end

function WordNumberSpriteLayer:getNumber()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local numRight = #bossList[#bossList].rightWordList 
    local numWrong = #bossList[#bossList].wrongWordList
    return numRight,numWrong
end

function WordNumberSpriteLayer:ctor()
    local wrongWordSprite = cc.Sprite:create("image/newstudy/unfamiliar_word_collection.png")
    wrongWordSprite:ignoreAnchorPointForPosition(false)
    wrongWordSprite:setAnchorPoint(cc.p(0.5,0.5))
    wrongWordSprite:setPosition(s_DESIGN_WIDTH /2 - 100,s_DESIGN_HEIGHT/2 - 50)
    self:addChild(wrongWordSprite)
    
    local rightWordSprite = cc.Sprite:create("image/newstudy/familiar_word_collection.png")
    rightWordSprite:ignoreAnchorPointForPosition(false)
    rightWordSprite:setAnchorPoint(cc.p(0.5,0.5))
    rightWordSprite:setPosition(s_DESIGN_WIDTH / 2 - 50,s_DESIGN_HEIGHT/2 - 50)
    self:addChild(rightWordSprite)

    local numRight,numWrong = self:getNumber()

    local labelWrong = cc.Label:createWithSystemFont(numWrong,"",20)
    labelWrong:setColor(cc.c4b(63,206,250,255))
    labelWrong:setPosition(wrongWordSprite:getContentSize().width * 0.5 + 2,wrongWordSprite:getContentSize().height * 0.5 - 4)
    labelWrong:enableOutline(cc.c4b(63,206,250,255),2)
    wrongWordSprite:addChild(labelWrong)

    local labelRight = cc.Label:createWithSystemFont(numRight,"",20)
    labelRight:setColor(cc.c4b(63,206,250,255))
    labelRight:setPosition(rightWordSprite:getContentSize().width * 0.5 + 2,rightWordSprite:getContentSize().height * 0.5 - 4)
    labelRight:enableOutline(cc.c4b(63,206,250,255),2)
    rightWordSprite:addChild(labelRight)
end

return WordNumberSpriteLayer