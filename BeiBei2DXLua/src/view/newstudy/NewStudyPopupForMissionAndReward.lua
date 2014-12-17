require("view.newstudy.NewStudyFunction")
require("view.newstudy.NewStudyConfigure")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local NewStudyPopupForMissionAndReward = class ("NewStudyPopupForMissionAndReward",function ()
    return cc.Layer:create()
end)

function NewStudyPopupForMissionAndReward.create()
    local layer = NewStudyPopupForMissionAndReward.new()
    local firstparttitle
    local secondparttitle
    local thirdparttitle
    local circle
    local mission_text
    local choose_mission_text
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local  popup_window = cc.Sprite:create("image/newstudy/popupformission.png")
    popup_window:setPosition(s_LEFT_X + bigWidth / 2 ,s_DESIGN_HEIGHT / 2 * 3)
    popup_window:ignoreAnchorPointForPosition(false)
    popup_window:setAnchorPoint(0.5,0.5)
    layer:addChild(popup_window)
    
    if NewStudyLayer_State == NewStudyLayer_State_Reward then
       local head = cc.Sprite:create("image/newstudy/head.png")
       head:setPosition(popup_window:getContentSize().width *0.5, 
            popup_window:getContentSize().height *0.95 )
       popup_window:addChild(head)
    end
    
    local action1 = cc.MoveTo:create(0.3, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2))
    local action2 = cc.EaseBackOut:create(action1)
    popup_window:runAction(action2)
    
    local richtext = ccui.RichText:create()

    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(cc.p(0.5,0.5))
   
    if NewStudyLayer_State == NewStudyLayer_State_Mission then
        firstparttitle = cc.LabelTTF:create ("已完成","Helvetica",35)
        secondparttitle = cc.LabelTTF:create (maxWrongWordCount,"Helvetica",35)  
        thirdparttitle = cc.LabelTTF:create ("个生单词","Helvetica",35)
    elseif NewStudyLayer_State == NewStudyLayer_State_Reward then
        firstparttitle = cc.LabelTTF:create ("新学习单词：","Helvetica",35)
        secondparttitle = cc.LabelTTF:create (maxWrongWordCount,"Helvetica",35)  
        thirdparttitle = cc.LabelTTF:create ("个","Helvetica",35)
    end
    
    firstparttitle:setColor(LightBlueFont)
    secondparttitle:setColor(DeepRedFont)  
    thirdparttitle:setColor(LightBlueFont)
    
    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,firstparttitle)   
    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,secondparttitle)   
    local richElement3 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,thirdparttitle)  

    richtext:pushBackElement(richElement1)  
    richtext:pushBackElement(richElement2)
    richtext:pushBackElement(richElement3)  
        
    richtext:setContentSize(cc.size(popup_window:getContentSize().width *0.65, 
        popup_window:getContentSize().height *0.3))  

    richtext:setPosition(popup_window:getContentSize().width *0.55, 
        popup_window:getContentSize().height *0.7)
    richtext:setLocalZOrder(10)
    popup_window:addChild(richtext)
    
    
    if NewStudyLayer_State == NewStudyLayer_State_Mission then
        circle = cc.Sprite:create("image/newstudy/yellow_circle.png")
    elseif NewStudyLayer_State == NewStudyLayer_State_Reward then
        circle = cc.Sprite:create("image/newstudy/green_circle.png")
    end

    circle:setPosition(popup_window:getContentSize().width * 0.5,popup_window:getContentSize().height *0.63)
    circle:ignoreAnchorPointForPosition(false)
    circle:setAnchorPoint(0.5,0.5)
    popup_window:addChild(circle)

    local unfamiliar_number_label = cc.Label:createWithSystemFont("+"..maxWrongWordCount,"",55)
    unfamiliar_number_label:setPosition(circle:getContentSize().width * 0.5,circle:getContentSize().height * 0.5)
    unfamiliar_number_label:setColor(DeepRedFont)
    unfamiliar_number_label:ignoreAnchorPointForPosition(false)
    unfamiliar_number_label:setAnchorPoint(0.5,0.5)
    circle:addChild(unfamiliar_number_label)
    
    if NewStudyLayer_State == NewStudyLayer_State_Mission then
        circle = cc.Sprite:create("image/newstudy/yellow_circle.png")
        mission_text = cc.Label:createWithSystemFont("快速过一遍这些生词\n可以得到任务奖励:","",32)
    elseif NewStudyLayer_State == NewStudyLayer_State_Reward then
        circle = cc.Sprite:create("image/newstudy/green_circle.png")
        mission_text = cc.Label:createWithSystemFont("恭喜你完成了今天的学习任务\n获得任务奖励:","",32)
    end

    mission_text:setPosition(popup_window:getContentSize().width / 2,popup_window:getContentSize().height *0.4)
    mission_text:setColor(BlackFont)
    mission_text:ignoreAnchorPointForPosition(false)
    mission_text:setAnchorPoint(0.5,0.5)
    popup_window:addChild(mission_text)

    RewardAdd(popup_window)

    local click_mission_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            if NewStudyLayer_State == NewStudyLayer_State_Mission then
                current_state_judge = 0

--                NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]
--                NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
--                NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
--                NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
--                NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
--                NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
--                NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
--                NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn

                NewStudyLayer_State = NewStudyLayer_State_Choose
                local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
                s_SCENE:replaceGameLayer(newStudyLayer)

                local action1 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2 * 3))
                local action2 = cc.EaseBackOut:create(action1)
                popup_window:runAction(action2)

                s_SCENE:callFuncWithDelay(0.8,function()
                    s_SCENE:removeAllPopups()           
                end)
            elseif NewStudyLayer_State == NewStudyLayer_State_Reward then
                print("congratulation")
            end              
        end
    end

    local choose_mission_button = ccui.Button:create("image/newstudy/blue_begin.png","image/newstudy/blue_end.png","")
    choose_mission_button:setPosition(popup_window:getContentSize().width /2  , popup_window:getContentSize().height *0.15)
    choose_mission_button:ignoreAnchorPointForPosition(false)
    choose_mission_button:setAnchorPoint(0.5,0.5)
    choose_mission_button:addTouchEventListener(click_mission_button)
    popup_window:addChild(choose_mission_button)  
    
    if NewStudyLayer_State == NewStudyLayer_State_Mission then
        choose_mission_text = cc.Label:createWithSystemFont("趁热打铁","",32)
    elseif NewStudyLayer_State == NewStudyLayer_State_Reward then
        choose_mission_text = cc.Label:createWithSystemFont("完成任务","",32)
    end

    choose_mission_text:setPosition(choose_mission_button:getContentSize().width * 0.5,choose_mission_button:getContentSize().height * 0.5)
    choose_mission_text:setColor(YellowFont)
    choose_mission_text:ignoreAnchorPointForPosition(false)
    choose_mission_text:setAnchorPoint(0.5,0.5)
    choose_mission_button:addChild(choose_mission_text) 

    return layer
end

return NewStudyPopupForMissionAndReward