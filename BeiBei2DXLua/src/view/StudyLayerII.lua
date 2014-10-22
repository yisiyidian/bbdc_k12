require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.ProgressBar")
local TapMat = require("view.TapMat")
local SoundMark = require("view.SoundMark")
local WordDetailInfo = require("view.WordDetailInfo")
local StudyAlter = require("view.StudyAlter")
local TestAlter = require("view.TestAlter")


local StudyLayerII = class("StudyLayerII", function ()
    return cc.Layer:create()
end)

function StudyLayerII.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

    local layer = StudyLayerII.new()

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local big_width = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), big_width, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local success = function()
    end

    local fail = function()
    end
    
    local mat = TapMat.create(wordName,4,4)
    mat:setPosition(big_width/2, 120)
    layer:addChild(mat)

    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false

    return layer
end

return StudyLayerII
