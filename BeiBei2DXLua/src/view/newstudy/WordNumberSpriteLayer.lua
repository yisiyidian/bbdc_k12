require("cocos.init")
require("common.global")

local BackLayer             = require("view.newstudy.NewStudyBackLayer")
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
end

return WordNumberSpriteLayer