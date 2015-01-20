require("cocos.init")
require("common.global")

local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newstudy.NewStudyDetailInfo")

local  NewStudyRightLayer = class("NewStudyRightLayer", function ()
    return cc.Layer:create()
end)

function NewStudyRightLayer.create()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()

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

    -- ui 
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = NewStudyRightLayer.new()

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local soundMark = SoundMark.create(wordname, wordSoundMarkEn, wordSoundMarkAm)
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)

    local detailInfo = DetailInfo.create(currentWord)
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(bigWidth/2, 520)
    backColor:addChild(detailInfo)
    
    local click_study_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsContinueReviewBtn()

            local normal = function()
                s_CorePlayManager.updateWrongWordList(wordname)
                s_CorePlayManager.updateCurrentIndex()
                s_CorePlayManager.enterNewStudySlideLayer()
            end
            if s_LocalDatabaseManager.getIsAlterOn() == 1 then
                local guideAlter = GuideAlter.create(1, "依然复习？", "陛下，我在生词库中等你来哦～")
                guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(guideAlter)
                guideAlter.addbeibeiThrowHeart()
                guideAlter.sure = function()
                    print("guide alter tag: "..guideAlter.box_tag)
                    s_LocalDatabaseManager.setIsAlterOn(0)
                    normal()
                end
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                normal()
            end
        end
    end

    local choose_study_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_study_button:setPosition(bigWidth/2-151, 153)
    choose_study_button:setTitleText("依然复习")
    choose_study_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_study_button:setTitleFontSize(32)
    choose_study_button:addTouchEventListener(click_study_button)
    backColor:addChild(choose_study_button)
    
    local click_next_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsStudyNextBtn()
            
            local normal = function()
                s_CorePlayManager.updateRightWordList(wordname)
                s_CorePlayManager.updateCurrentIndex()
                if s_CorePlayManager.bookOver() then
                    if s_CorePlayManager.wrongWordNum == 0 then
                        s_CorePlayManager.enterNewStudyBookOverLayer()
                    else
                        s_CorePlayManager.initWordCandidate()
                        s_CorePlayManager.checkInReviewModel()
                        s_CorePlayManager.enterNewStudyMiddleLayer()
                    end
                else
                    s_CorePlayManager.enterNewStudyChooseLayer()
                end
            end
        
            if s_LocalDatabaseManager.getIsAlterOn() == 1 then
                local guideAlter = GuideAlter.create(1, "太简单了？", "陛下，您真的要把我打入冷宫吗？")
                guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(guideAlter)
                guideAlter.addbeibeiBreakHeart()
                guideAlter.sure = function()
                    print("guide alter tag: "..guideAlter.box_tag)
                    s_LocalDatabaseManager.setIsAlterOn(0)
                    normal()

                    if s_CorePlayManager.isStudyModel() then
                        AnalyticsFirst(ANALYTICS_FIRST_SKIP_REVIEW, 'sure')
                    else
                        AnalyticsFirst(ANALYTICS_FIRST_SKIP_REVIEW_STRIKEWHILEHOT, 'sure')
                    end
                end

                guideAlter.cancel = function()
                    if s_CorePlayManager.isStudyModel() then
                        AnalyticsFirst(ANALYTICS_FIRST_SKIP_REVIEW, 'cancel')
                    else
                        AnalyticsFirst(ANALYTICS_FIRST_SKIP_REVIEW_STRIKEWHILEHOT, 'cancel')
                    end
                end
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                normal()
            end
        end
    end

    local choose_next_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_next_button:setPosition(bigWidth/2+151, 153)
    choose_next_button:setTitleText("太简单了")
    choose_next_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_next_button:setTitleFontSize(32)
    choose_next_button:addTouchEventListener(click_next_button)
    backColor:addChild(choose_next_button)
    
    
    
    return layer
end

return NewStudyRightLayer