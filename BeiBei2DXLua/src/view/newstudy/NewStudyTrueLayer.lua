require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyTrueLayer = class("NewStudyTrueLayer", function ()
    return cc.Layer:create()
end)

function NewStudyTrueLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local layer = NewStudyTrueLayer.new()
    
    local font_number

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

    local word_mark 

    for i = 1,8 do
        if i >= currentIndex_unfamiliar then
            if i == 1 then 
                word_mark = cc.Sprite:create("image/newstudy/blue_begin.png")
            elseif i == 8 then 
                word_mark = cc.Sprite:create("image/newstudy/blue_end.png")
            else
                word_mark = cc.Sprite:create("image/newstudy/blue_mid.png")
            end
        else
            if i == 1 then 
                word_mark = cc.Sprite:create("image/newstudy/green_begin.png")
            elseif i == 8 then 
                word_mark = cc.Sprite:create("image/newstudy/green_end.png")
            else
                word_mark = cc.Sprite:create("image/newstudy/green_mid.png")
            end
        end

        if word_mark ~= nil then
            word_mark:setPosition(backGround:getContentSize().width * 0.5 + word_mark:getContentSize().width*1.1 * (i - 5),s_DESIGN_HEIGHT * 0.95)
            word_mark:ignoreAnchorPointForPosition(false)
            word_mark:setAnchorPoint(0,0.5)
            backGround:addChild(word_mark)
        end
    end

    
    local huge_word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",100)
    huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.8)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    backGround:addChild(huge_word)
    
    if string.len(huge_word:getString()) > 5  then
    huge_word:setSystemFontSize(24 * backGround:getContentSize().width / huge_word:getContentSize().width)
    end


    local word = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",40)
    word:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.50)
    word:setColor(cc.c4b(191,181,46,255))
    word:ignoreAnchorPointForPosition(false)
    word:setAnchorPoint(0,0.5)
    backGround:addChild(word)

    local illustrate_word = cc.Label:createWithSystemFont("这个单词对你而言太熟悉了，所以你希\n望放弃对他的复习，如果确实如此，\n请点击单词将它收入你的词库吧","",36)
    illustrate_word:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.40)
    illustrate_word:setColor(cc.c4b(255,255,255,255))
    illustrate_word:ignoreAnchorPointForPosition(false)
    illustrate_word:setAnchorPoint(0,0.5)
    backGround:addChild(illustrate_word)

    local backColor_second = cc.LayerColor:create(cc.c4b(131,162,206,255), backGround:getContentSize().width *0.7,200)  
    backColor_second:setAnchorPoint(0.5,0.5)
    backColor_second:ignoreAnchorPointForPosition(false)
    backColor_second:setPosition(backGround:getContentSize().width *0.5,s_DESIGN_HEIGHT*0.25)
    backGround:addChild(backColor_second) 

    local current_word_text = cc.Label:createWithSystemFont("当前单词","",30)
    current_word_text:setPosition(backColor_second:getContentSize().width *0.05,backColor_second:getContentSize().height *0.9)
    current_word_text:setColor(cc.c4b(255,255,255,255))
    current_word_text:ignoreAnchorPointForPosition(false)
    current_word_text:setAnchorPoint(0,0.5)
    backColor_second:addChild(current_word_text) 

    local current_word_name = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",30)
    current_word_name:setPosition(backColor_second:getContentSize().width *0.05 + current_word_text:getContentSize().width * 1.1,
        backColor_second:getContentSize().height *0.9)
    current_word_name:setColor(cc.c4b(191,181,46,255))
    current_word_name:ignoreAnchorPointForPosition(false)
    current_word_name:setAnchorPoint(0,0.5)
    backColor_second:addChild(current_word_name)   

    local current_word_MarkUs = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordSoundMarkAm,"",30)
    current_word_MarkUs:setPosition(backColor_second:getContentSize().width *0.05 + current_word_text:getContentSize().width *1.1+ current_word_name:getContentSize().width *1.1,
        backColor_second:getContentSize().height *0.9)
    current_word_MarkUs:setColor(cc.c4b(255,255,255,255))
    current_word_MarkUs:ignoreAnchorPointForPosition(false)
    current_word_MarkUs:setAnchorPoint(0,0.5)
    backColor_second:addChild(current_word_MarkUs)    

    local richtext = ccui.RichText:create()
    
    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(0.5,0.5)
    
    richtext:setContentSize(cc.size(backColor_second:getContentSize().width *0.95, 
        backColor_second:getContentSize().height *0.5))  
        
    local current_word_wordMeaning = CCLabelTTF:create (NewStudyLayer_wordList_wordMeaning,
        "Helvetica",32, cc.size(600, 300), cc.TEXT_ALIGNMENT_LEFT)

    current_word_wordMeaning:setColor(cc.c4b(152,183,227,255))
    
    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
    richtext:pushBackElement(richElement1)                   
    richtext:setPosition(backColor_second:getContentSize().width *0.5, 
        backColor_second:getContentSize().height *0.5)
    richtext:setLocalZOrder(10)


    backColor_second:addChild(richtext) 
    
      
    local click_study_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Wrong)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end

    local choose_study_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
    choose_study_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
    choose_study_button:ignoreAnchorPointForPosition(false)
    choose_study_button:setAnchorPoint(0.5,0.5)
    choose_study_button:addTouchEventListener(click_study_button)
    backGround:addChild(choose_study_button)  

    local choose_study_text = cc.Label:createWithSystemFont("我依然想复习该单词","",32)
    choose_study_text:setPosition(choose_study_button:getContentSize().width * 0.5,choose_study_button:getContentSize().height * 0.5)
    choose_study_text:setColor(cc.c4b(255,255,255,255))
    choose_study_text:ignoreAnchorPointForPosition(false)
    choose_study_text:setAnchorPoint(0.5,0.5)
    choose_study_button:addChild(choose_study_text)

    return layer
end

return NewStudyTrueLayer