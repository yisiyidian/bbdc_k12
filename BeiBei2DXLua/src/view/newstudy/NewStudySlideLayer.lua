require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")

local  NewStudySlideLayer = class("NewStudySlideLayer", function ()
    return cc.Layer:create()
end)

function NewStudySlideLayer.create()
    -- word info
    local currentWordName
    if s_CorePlayManager.isStudyModel() then
        currentWordName = s_CorePlayManager.NewStudyLayerWordList[s_CorePlayManager.currentIndex]
    else
        currentWordName = s_CorePlayManager.wordCandidate[1]
    end
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
    local layer = NewStudySlideLayer.new()

    local backColor = BackLayer.create(97) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local word_meaning_label = cc.Label:createWithSystemFont(wordMeaningSmall,"",50)
    word_meaning_label:setPosition(bigWidth/2, 1000)
    word_meaning_label:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(word_meaning_label)

    local success = function()
        local normal = function()  
            -- db
            s_DATABASE_MGR.updateSlideNum()
        
            playSound(s_sound_learn_true) 
        
            local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
            showAnswerStateBack:setPosition(backColor:getContentSize().width *1.5, 768)
            showAnswerStateBack:ignoreAnchorPointForPosition(false)
            showAnswerStateBack:setAnchorPoint(0.5,0.5)
            backColor:addChild(showAnswerStateBack)
    
            local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
            sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
            showAnswerStateBack:addChild(sign)
    
            local right_wordname = cc.Label:createWithSystemFont(wordname,"",60)
            right_wordname:setColor(cc.c4b(130,186,47,255))
            right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
            right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
            showAnswerStateBack:addChild(right_wordname)
    
            local action1 = cc.MoveTo:create(0.2,cc.p(backColor:getContentSize().width /2, 768))
            showAnswerStateBack:runAction(action1)
    
            s_SCENE:callFuncWithDelay(0.4,function()
                if s_CorePlayManager.isStudyModel() then
                    s_CorePlayManager.updateWrongWordList(wordname)
                    if s_CorePlayManager.wrongWordNum >= s_CorePlayManager.maxWrongWordCount then
                        s_CorePlayManager.updateCurrentIndex()
                        s_CorePlayManager.enterNewStudyMiddleLayer()
                    else
                        s_CorePlayManager.updateCurrentIndex()
                        s_CorePlayManager.enterNewStudyChooseLayer()
                    end
                else
                    s_CorePlayManager.updateWordCandidate(true)
                    s_CorePlayManager.enterNewStudyChooseLayer()
                end
            end)
        end
    
        if s_DATABASE_MGR.getSlideNum() == 1 then
            local guideAlter = GuideAlter.create(0, "划词加强记忆", "划词这一步是专门用来加强用户记忆的步骤，通过划词可以强化你对生词的印象。")
            guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
            backColor:addChild(guideAlter)
            
            guideAlter.know = function()
                normal()
            end
        else
            normal()
        end
    end

    local size_big = backColor:getContentSize()

    if s_DATABASE_MGR.getSlideNum() == 0 then
        mat = FlipMat.create(wordname,4,4,true,"coconut_light")
        mat.finger_action()
    else
        mat = FlipMat.create(wordname,4,4,false,"coconut_light")
    end
    
    mat:setPosition(size_big.width/2, 160)
    backColor:addChild(mat)

    mat.success = success
    mat.rightLock = true
    mat.wrongLock = false

    local click_before_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterNewStudyWrongLayer()
        end
    end

    local choose_before_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_before_button:setPosition(bigWidth/2, 153)
    choose_before_button:setTitleText("再看一眼")
    choose_before_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_before_button:setTitleFontSize(32)
    choose_before_button:addTouchEventListener(click_before_button)
    backColor:addChild(choose_before_button)  
    
    return layer
end

return NewStudySlideLayer