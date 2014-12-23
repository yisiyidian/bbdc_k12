require("cocos.init")
require("common.global")
require("view.newstudy.NewStudyConfigure")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local ProgressBar       = require("view.newstudy.NewStudyProgressBar")
local FlipMat = require("view.mat.FlipMat")

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

    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local big_offset        =   97
    local middle_offset     =   45
    local small_offset      =   0

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT+big_offset)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)

    local progressBar
    if s_CorePlayManager.isStudyModel() then
        progressBar = ProgressBar.create(s_CorePlayManager.maxWrongWordCount, s_CorePlayManager.wrongWordNum, "yellow")
    else
        progressBar = ProgressBar.create(s_CorePlayManager.maxWrongWordCount, s_CorePlayManager.maxWrongWordCount-s_CorePlayManager.candidateNum, "yellow")
    end
    progressBar:setPosition(bigWidth/2, 1092)
    backColor:addChild(progressBar)

    local word_meaning_label = cc.Label:createWithSystemFont(wordMeaningSmall,"",50)
    word_meaning_label:setPosition(bigWidth/2, 1000)
    word_meaning_label:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(word_meaning_label)

    local success = function()   
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
                if s_CorePlayManager.wrongWordNum >= s_CorePlayManager.maxWrongWordCount then
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

    local size_big = backColor:getContentSize()

    mat = FlipMat.create(wordname,4,4,false,"coconut_light")
    mat:setPosition(size_big.width/2, 160)
    backColor:addChild(mat)

    mat.success = success
--    mat.fail = fail
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