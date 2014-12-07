require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
local FlipMat = require("view.mat.FlipMat")

local  NewStudySlideLayer = class("NewStudySlideLayer", function ()
    return cc.Layer:create()
end)

function NewStudySlideLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local mat

    local layer = NewStudySlideLayer.new()
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    local pause_button = ccui.Button:create("image/newstudy/pause_button_begin.png","image/newstudy/pause_button_end.png","")
    pause_button:setPosition(s_LEFT_X + 150, s_DESIGN_HEIGHT - 50 )
    pause_button:ignoreAnchorPointForPosition(false)
    pause_button:setAnchorPoint(0,1)
    backGround:addChild(pause_button)    

    JudgeColorAtTop(backGround)  

    HugeWordUnderColorSquare(backGround)

    local slide_word_label = cc.Label:createWithSystemFont("回忆并划出刚才的单词","",32)
    slide_word_label:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
    slide_word_label:setColor(SilverFont)
    slide_word_label:ignoreAnchorPointForPosition(false)
    slide_word_label:setAnchorPoint(0,0.5)
    backGround:addChild(slide_word_label)

    local success = function()
        UpdateCurrentWordFromFalse()
    end

    local size_big = backGround:getContentSize()

    mat = FlipMat.create(NewStudyLayer_wordList_wordName,4,4,false,"coconut_light")
    mat:setPosition(size_big.width/2, 120)
    backGround:addChild(mat)

    mat.success = success
--    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = false

    local click_before_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Choose)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end

    local choose_before_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
    choose_before_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
    choose_before_button:ignoreAnchorPointForPosition(false)
    choose_before_button:setAnchorPoint(0.5,0.5)
    choose_before_button:addTouchEventListener(click_before_button)
    backGround:addChild(choose_before_button)  

    local choose_before_text = cc.Label:createWithSystemFont("偷偷看一眼","",32)
    choose_before_text:setPosition(choose_before_button:getContentSize().width * 0.5,choose_before_button:getContentSize().height * 0.5)
    choose_before_text:setColor(cc.c4b(255,255,255,255))
    choose_before_text:ignoreAnchorPointForPosition(false)
    choose_before_text:setAnchorPoint(0.5,0.5)
    choose_before_button:addChild(choose_before_text)


    return layer
end

return NewStudySlideLayer