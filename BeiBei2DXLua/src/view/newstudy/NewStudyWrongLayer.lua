require("cocos.init")
require("common.global")
require("view.newstudy.NewStudyConfigure")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")

local  NewStudyWrongLayer = class("NewStudyWrongLayer", function ()
    return cc.Layer:create()
end)

function NewStudyWrongLayer.create()
    -- word info
    local currentWordName   = s_CorePlayManager.NewStudyLayerWordList[s_CorePlayManager.currentIndex]
    local currentWord       = s_WordPool[currentWordName]
    local wordname          = currentWord.wordName
    local wordSoundMarkEn   = currentWord.wordSoundMarkEn
    local wordSoundMarkAm   = currentWord.wordSoundMarkAm
    local wordMeaningSmall  = currentWord.wordMeaningSmall
    local wordMeaning       = currentWord.wordMeaning
    local sentenceEn        = currentWord.sentenceEn
    local sentenceCn        = currentWord.sentenceCn
    local sentenceEn2       = currentWord.sentenceEn2
    local sentenceCn2       = currentWord.sentenceCn2

    local totalWordNum      = #s_CorePlayManager.NewStudyLayerWordList

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewStudyWrongLayer.new()
    
    local current_word_sentence_before_wordName 
    local current_word_sentence_after_wordName
    
    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    local soundMark = SoundMark.create(wordname, wordSoundMarkEn, wordSoundMarkAm)
    soundMark:setPosition(backGround:getContentSize().width *0.5, s_DESIGN_HEIGHT * 0.8)  
    backGround:addChild(soundMark)
    
    local detailInfo = DetailInfo.create(currentWord)
    detailInfo:setPosition(backGround:getContentSize().width *0.5, 0)  
    backGround:addChild(detailInfo)

    local spell_drill = cc.Label:createWithSystemFont("拼写强化训练>","",32)
    spell_drill:setPosition(backGround:getContentSize().width *0.18  , s_DESIGN_HEIGHT * 0.25)
    spell_drill:setColor(cc.c4b(243,27,26,255))
    spell_drill:ignoreAnchorPointForPosition(false)
    spell_drill:setAnchorPoint(0,0.5)
    backGround:addChild(spell_drill)
    
    local spell_position = cc.p(spell_drill:getPosition())
    local spell_size = spell_drill:getContentSize()
    
    local onTouchBegan = function(touch, event)
        playSound(s_sound_buttonEffect) 
        return true
    end
    
    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(spell_drill:getBoundingBox(), location) then
            s_CorePlayManager.enterNewStudySlideLayer()
        end
    end

    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.updateCurrentIndex()
            s_CorePlayManager.enterNewStudyChooseLayer()
        end
    end

    local choose_next_button = ccui.Button:create("image/newstudy/orange_begin.png","image/newstudy/orange_end.png","")
    choose_next_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.12)
    choose_next_button:ignoreAnchorPointForPosition(false)
    choose_next_button:setAnchorPoint(0.5,0.5)
    choose_next_button:addTouchEventListener(click_next_button)
    backGround:addChild(choose_next_button)  

    local choose_next_text = cc.Label:createWithSystemFont("下一个","",32)
    choose_next_text:setPosition(choose_next_button:getContentSize().width * 0.5,choose_next_button:getContentSize().height * 0.5)
    choose_next_text:setColor(cc.c4b(31,70,102,255))
    choose_next_text:ignoreAnchorPointForPosition(false)
    choose_next_text:setAnchorPoint(0.5,0.5)
    choose_next_button:addChild(choose_next_text)
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return NewStudyWrongLayer
