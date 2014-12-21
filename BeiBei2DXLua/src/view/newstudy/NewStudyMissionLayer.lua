require("cocos.init")
require("common.global")
require("view.newstudy.NewStudyConfigure")

local  NewStudyMissionLayer = class("NewStudyMissionLayer", function ()
    return cc.Layer:create()
end)

function NewStudyMissionLayer.create()

    local New_study_popup = require("view.newstudy.NewStudyPopupForMissionAndReward")
    local new_study_popup = New_study_popup.create()  
    s_SCENE:popup(new_study_popup)

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewStudyMissionLayer.new()

    local backGround = cc.Sprite:create("image/newstudy/new_study_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)
  


--    local unfamiliar_label = cc.Label:createWithSystemFont("已完成"..maxWrongWordCount.."个生词","",40)
--    unfamiliar_label:setPosition(backGround:getContentSize().width *0.18,s_DESIGN_HEIGHT * 0.68)
--    unfamiliar_label:setColor(SilverFont)
--    unfamiliar_label:ignoreAnchorPointForPosition(false)
--    unfamiliar_label:setAnchorPoint(0,0.5)
--    backGround:addChild(unfamiliar_label)
--
--    local yellow_circle = cc.Sprite:create("image/newstudy/yellow_circle.png")
--    yellow_circle:setPosition(backGround:getContentSize().width * 0.5,s_DESIGN_HEIGHT * 0.5)
--    yellow_circle:ignoreAnchorPointForPosition(false)
--    yellow_circle:setAnchorPoint(0.5,0.5)
--    backGround:addChild(yellow_circle)
--
--    local unfamiliar_number_label = cc.Label:createWithSystemFont("+"..maxWrongWordCount,"",40)
--    unfamiliar_number_label:setPosition(yellow_circle:getContentSize().width * 0.5,yellow_circle:getContentSize().height * 0.5)
--    unfamiliar_number_label:setColor(cc.c4b(233,228,80,255))
--    unfamiliar_number_label:ignoreAnchorPointForPosition(false)
--    unfamiliar_number_label:setAnchorPoint(0.5,0.5)
--    yellow_circle:addChild(unfamiliar_number_label)
--
--    local mission_text = cc.Label:createWithSystemFont("快速过一遍这些生词\n可以得到任务奖励:","",32)
--    mission_text:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.3)
--    mission_text:setColor(cc.c4b(255,255,255,255))
--    mission_text:ignoreAnchorPointForPosition(false)
--    mission_text:setAnchorPoint(0.5,0.5)
--    backGround:addChild(mission_text)
--
--    RewardAdd(backGround)
--
--    local click_mission_button = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            -- button sound
--            playSound(s_sound_buttonEffect)        
--        elseif eventType == ccui.TouchEventType.ended then
--            
--            current_state_judge = 0
--            
--            NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]
--            NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
--            NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
--            NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
--            NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
--            NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
--            NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
--            NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn
--            
--            NewStudyLayer_State = NewStudyLayer_State_Choose
--            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
--            s_SCENE:replaceGameLayer(newStudyLayer)
--        end
--    end
--
--    local choose_mission_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
--    choose_mission_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
--    choose_mission_button:ignoreAnchorPointForPosition(false)
--    choose_mission_button:setAnchorPoint(0.5,0.5)
--    choose_mission_button:addTouchEventListener(click_mission_button)
--    backGround:addChild(choose_mission_button)  
--
--    local choose_mission_text = cc.Label:createWithSystemFont("趁热打铁","",32)
--    choose_mission_text:setPosition(choose_mission_button:getContentSize().width * 0.5,choose_mission_button:getContentSize().height * 0.5)
--    choose_mission_text:setColor(cc.c4b(255,255,255,255))
--    choose_mission_text:ignoreAnchorPointForPosition(false)
--    choose_mission_text:setAnchorPoint(0.5,0.5)
--    choose_mission_button:addChild(choose_mission_text) 


    return layer
end

return NewStudyMissionLayer