require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local SmallDetailInfo   = require("view.newstudy.NewStudySmallDetailInfo")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")

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
    soundMark:setPosition(bigWidth/2, 960)  
    backColor:addChild(soundMark)

    local smallDetailInfo = SmallDetailInfo.create(currentWord)
    smallDetailInfo:setPosition(backColor:getContentSize().width *0.5, 0)  
    backColor:addChild(smallDetailInfo)
    
    local click_study_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsContinueReviewBtn()

            local normal = function()
                s_CorePlayManager.enterNewStudyWrongLayer()
            end
            if s_DATABASE_MGR.getIsAlterOn() == 1 then
                local guideAlter = GuideAlter.create(1, "依然复习？", "看来你对“"..wordname.."”还不熟，贝贝将把“"..wordname.."”放入生词库中，接下来的复习中，你们还会再见哦！")
                guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(guideAlter)
                
                guideAlter.sure = function()
                    print("guide alter tag: "..guideAlter.box_tag)
                    if guideAlter.box_tag == 1 then
                        s_DATABASE_MGR.setIsAlterOn(0)
                	end
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
        
            if s_DATABASE_MGR.getIsAlterOn() == 1 then
                local guideAlter = GuideAlter.create(1, "不再复习？", "看来你对“"..wordname.."”很熟悉，贝贝将把“"..wordname.."”放入熟词库中，该词以后不再出现！")
                guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(guideAlter)
                
                guideAlter.sure = function()
                    print("guide alter tag: "..guideAlter.box_tag)
                    if guideAlter.box_tag == 1 then
                        s_DATABASE_MGR.setIsAlterOn(0)
                    end
                    normal()
                end
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                normal()
            end
        end
    end

    local choose_next_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_next_button:setPosition(bigWidth/2+151, 153)
    choose_next_button:setTitleText("下一个")
    choose_next_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_next_button:setTitleFontSize(32)
    choose_next_button:addTouchEventListener(click_next_button)
    backColor:addChild(choose_next_button)
    
    
    
    return layer
end

return NewStudyRightLayer