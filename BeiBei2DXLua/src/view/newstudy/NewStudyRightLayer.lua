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
            local normal = function()
                s_CorePlayManager.enterNewStudyWrongLayer()
            end
            if s_DATABASE_MGR.getIsAlterOn() == 1 then
                local guideAlter = GuideAlter.create(1, "依然复习？", "看来你和"..wordname.."还需要加深一下了解，我们会将它放入你的生词库中，并安排它接下来的复习。")
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
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local normal = function()
                s_CorePlayManager.updateRightWordList(wordname)
                s_CorePlayManager.updateCurrentIndex()
                s_CorePlayManager.enterNewStudyChooseLayer()
            end
        
            if s_DATABASE_MGR.getIsAlterOn() == 1 then
                local guideAlter = GuideAlter.create(1, "不再复习？", "看来"..wordname.."对你来说太简单了，我们会将它放入你的熟词库中，该词以后不会在复习中出现。")
                --    local guideAlter = GuideAlter.create(0, "划词加强记忆", "划词这一步是专门用来加强用户记忆的步骤，通过划词可以强化你对生词的印象。")
                --    local guideAlter = GuideAlter.create(0, "生词进度条", "生词进度条代表的时你今天的生词积攒任务的完成进度")
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