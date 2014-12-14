require("cocos.init")

require("common.global")
require("view.newstudy.NewStudyFunction")
require("view.newstudy.NewStudyConfigure")

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

    AddPauseButton(backGround)
       
    JudgeColorAtTop(backGround)
  
    HugeWordUnderColorSquare(backGround)
    
    local illustrate_word = cc.Label:createWithSystemFont("这个词太熟悉了，如果希望放弃复习\n点击单词将它收入你的词库吧","",32)
    illustrate_word:setPosition(backGround:getContentSize().width *0.2,s_DESIGN_HEIGHT * 0.65)
    illustrate_word:setColor(BlackFont)
    illustrate_word:ignoreAnchorPointForPosition(false)
    illustrate_word:setAnchorPoint(0,0.5)
    backGround:addChild(illustrate_word)
    
    local square = cc.Sprite:create("image/newstudy/square.png")
    square:setPosition(backGround:getContentSize().width *0.25,s_DESIGN_HEIGHT * 0.55)
    square:ignoreAnchorPointForPosition(false)
    square:setAnchorPoint(0.5,0.5)
    square:setScale(2)
    backGround:addChild(square)
    
    local right_sign = cc.Sprite:create("image/newstudy/right.png")
    right_sign:setPosition(square:getContentSize().width / 2, square:getContentSize().height / 2)
    right_sign:setScale(1/2)
    right_sign:ignoreAnchorPointForPosition(false)
    right_sign:setAnchorPoint(0.5,0.5)
    square:addChild(right_sign)
    
    if s_CURRENT_USER.newstudytruelayerMask == 1 then
        right_sign:setVisible(true)
    else
        right_sign:setVisible(false)
    end

    
    local tip_label = cc.Label:createWithSystemFont("以后不再提醒","",28)
    tip_label:setPosition(square:getContentSize().width + 10, square:getContentSize().height / 2)
    tip_label:setColor(BlackFont)
    tip_label:setScale(1/2)
    tip_label:ignoreAnchorPointForPosition(false)
    tip_label:setAnchorPoint(0,0.5)
    square:addChild(tip_label)
    
    local line = cc.Sprite:create("image/newstudy/line.png")
    line:setPosition(backGround:getContentSize().width *0.5,s_DESIGN_HEIGHT * 0.5)
    backGround:addChild(line)

    local current_word_name = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordName,"",35)
    current_word_name:setPosition(backGround:getContentSize().width *0.25 ,
        backGround:getContentSize().height *0.4)
    current_word_name:setColor(BlackFont)
    current_word_name:ignoreAnchorPointForPosition(false)
    current_word_name:setAnchorPoint(0,0.5)
    backGround:addChild(current_word_name)   

    local current_word_MarkUs = cc.Label:createWithSystemFont(NewStudyLayer_wordList_wordSoundMarkAm,"",35)
    current_word_MarkUs:setPosition(backGround:getContentSize().width *0.25 + current_word_name:getContentSize().width *1.1,
        backGround:getContentSize().height *0.4)
    current_word_MarkUs:setColor(BlackFont)
    current_word_MarkUs:ignoreAnchorPointForPosition(false)
    current_word_MarkUs:setAnchorPoint(0,0.5)
    backGround:addChild(current_word_MarkUs)    

    local richtext = ccui.RichText:create()
    
    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(cc.p(0.5,0.5))
    
    richtext:setContentSize(cc.size(backGround:getContentSize().width *0.65, 
        backGround:getContentSize().height *0.3))  
        
    local current_word_wordMeaning = cc.LabelTTF:create (NewStudyLayer_wordList_wordMeaning,
        "Helvetica",32, cc.size(550, 200), cc.TEXT_ALIGNMENT_LEFT)

    current_word_wordMeaning:setColor(BlackFont)
    
    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
    richtext:pushBackElement(richElement1)                   
    richtext:setPosition(backGround:getContentSize().width *0.52, 
        backGround:getContentSize().height *0.2)
    richtext:setLocalZOrder(10)


    backGround:addChild(richtext) 
    
      
    local click_study_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            s_DATABASE_MGR.insertNewStudyLayerSufferTables(NewStudyLayer_wordList_wordName)
            NewStudyLayer_State = NewStudyLayer_State_Wrong
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end

    local choose_study_button = ccui.Button:create("image/newstudy/orange_begin.png","image/newstudy/orange_end.png","")
    choose_study_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.12)
    choose_study_button:ignoreAnchorPointForPosition(false)
    choose_study_button:setAnchorPoint(0.5,0.5)
    choose_study_button:addTouchEventListener(click_study_button)
    backGround:addChild(choose_study_button)  

    local choose_study_text = cc.Label:createWithSystemFont("依然复习","",40)
    choose_study_text:setPosition(choose_study_button:getContentSize().width * 0.5,choose_study_button:getContentSize().height * 0.5)
    choose_study_text:setColor(DeepBlueFont)
    choose_study_text:ignoreAnchorPointForPosition(false)
    choose_study_text:setAnchorPoint(0.5,0.5)
    choose_study_button:addChild(choose_study_text)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = backGround:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(square:getBoundingBox(), location) then   
            if s_CURRENT_USER.newstudytruelayerMask == 1 then
                s_CURRENT_USER.newstudytruelayerMask = 0
               right_sign:setVisible(false)
            else
                s_CURRENT_USER.newstudytruelayerMask = 1
                right_sign:setVisible(true)
            end
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = backGround:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backGround)
    

    return layer
end

return NewStudyTrueLayer