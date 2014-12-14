require("cocos.init")

require("common.global")
require("view.newstudy.NewStudyFunction")
require("view.newstudy.NewStudyConfigure")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
local FlipMat = require("view.mat.FlipMat")

local  NewStudySlideLayer = class("NewStudySlideLayer", function ()
    return cc.Layer:create()
end)

function NewStudySlideLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local mat

    local layer = NewStudySlideLayer.new()
    
    local backGround = cc.Sprite:create("image/newstudy/slidebackground.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    AddPauseButton(backGround)    

    JudgeColorAtTop(backGround)  

--    local richtext = ccui.RichText:create()
--
--    richtext:ignoreContentAdaptWithSize(false)
--    richtext:ignoreAnchorPointForPosition(false)
--    richtext:setAnchorPoint(cc.p(0.5,0.5))
--
--    richtext:setContentSize(cc.size(backGround:getContentSize().width *0.65, 
--        backGround:getContentSize().height *0.3))  
--
--    local current_word_wordMeaning = cc.LabelTTF:create (NewStudyLayer_wordList_wordMeaning,
--        "Helvetica",32, cc.size(550, 200), cc.TEXT_ALIGNMENT_LEFT)
--
--    current_word_wordMeaning:setColor(cc.c4b(255,255,255,255))
--
--    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
--    richtext:pushBackElement(richElement1)                   
--    richtext:setPosition(backGround:getContentSize().width *0.5, 
--        backGround:getContentSize().height *0.7)
--    richtext:setLocalZOrder(10)
--    
--    backGround:addChild(richtext) 

    local slide_word_label = cc.Label:createWithSystemFont("回忆并划出刚才的单词","",32)
    slide_word_label:setPosition(backGround:getContentSize().width *0.22,s_DESIGN_HEIGHT * 0.68)
    slide_word_label:setColor(WhiteFont)
    slide_word_label:ignoreAnchorPointForPosition(false)
    slide_word_label:setAnchorPoint(0,0.5)
    backGround:addChild(slide_word_label)

    local success = function()   
    
        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
        showAnswerStateBack:setPosition(backGround:getContentSize().width *1.5, 768)
        showAnswerStateBack:ignoreAnchorPointForPosition(false)
        showAnswerStateBack:setAnchorPoint(0.5,0.5)
        backGround:addChild(showAnswerStateBack)

        local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
        sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
        showAnswerStateBack:addChild(sign)

        local right_wordname = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",60)
        right_wordname:setColor(cc.c4b(130,186,47,255))
        right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
        right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
        showAnswerStateBack:addChild(right_wordname)

        local action1 = cc.MoveTo:create(0.5,cc.p(backGround:getContentSize().width /2, 768))
        showAnswerStateBack:runAction(action1)
                        
        s_SCENE:callFuncWithDelay(1,function()
           UpdateCurrentWordFromFalse()
        end)
    end

    local size_big = backGround:getContentSize()

    mat = FlipMat.create(NewStudyLayer_wordList_wordName,4,4,false,"coconut_light")
    mat:setPosition(size_big.width/2, 160)
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
            NewStudyLayer_State = NewStudyLayer_State_Choose
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end

    local choose_before_button = ccui.Button:create("image/newstudy/green_begin.png","image/newstudy/green_end.png","")
    choose_before_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
    choose_before_button:ignoreAnchorPointForPosition(false)
    choose_before_button:setAnchorPoint(0.5,0.5)
    choose_before_button:addTouchEventListener(click_before_button)
    backGround:addChild(choose_before_button)  

    local choose_before_text = cc.Label:createWithSystemFont("再看一眼","",32)
    choose_before_text:setPosition(choose_before_button:getContentSize().width * 0.5,choose_before_button:getContentSize().height * 0.5)
    choose_before_text:setColor(cc.c4b(255,255,255,255))
    choose_before_text:ignoreAnchorPointForPosition(false)
    choose_before_text:setAnchorPoint(0.5,0.5)
    choose_before_button:addChild(choose_before_text)


    return layer
end

return NewStudySlideLayer