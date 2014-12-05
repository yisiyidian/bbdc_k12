require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyMissionLayer = class("NewStudyMissionLayer", function ()
    return cc.Layer:create()
end)

function NewStudyMissionLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewStudyMissionLayer.new()

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


    local unfamiliar_label = cc.Label:createWithSystemFont("已完成20个生词","",40)
    unfamiliar_label:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
    unfamiliar_label:setColor(cc.c4b(124,157,208,255))
    unfamiliar_label:ignoreAnchorPointForPosition(false)
    unfamiliar_label:setAnchorPoint(0,0.5)
    backGround:addChild(unfamiliar_label)

    local yellow_circle = cc.Sprite:create("image/newstudy/yellow_circle.png")
    yellow_circle:setPosition(backGround:getContentSize().width * 0.5,s_DESIGN_HEIGHT * 0.5)
    yellow_circle:ignoreAnchorPointForPosition(false)
    yellow_circle:setAnchorPoint(0.5,0.5)
    backGround:addChild(yellow_circle)

    local unfamiliar_number_label = cc.Label:createWithSystemFont("+8","",40)
    unfamiliar_number_label:setPosition(yellow_circle:getContentSize().width * 0.5,yellow_circle:getContentSize().height * 0.5)
    unfamiliar_number_label:setColor(cc.c4b(233,228,80,255))
    unfamiliar_number_label:ignoreAnchorPointForPosition(false)
    unfamiliar_number_label:setAnchorPoint(0.5,0.5)
    yellow_circle:addChild(unfamiliar_number_label)

    local mission_text = cc.Label:createWithSystemFont("快速过一遍这些生词\n可以得到任务奖励:","",32)
    mission_text:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.3)
    mission_text:setColor(cc.c4b(255,255,255,255))
    mission_text:ignoreAnchorPointForPosition(false)
    mission_text:setAnchorPoint(0.5,0.5)
    backGround:addChild(mission_text)

    for i=1,3 do
        local diamond = cc.Sprite:create("image/newstudy/diamond.png")
        diamond:setPosition(backGround:getContentSize().width * 0.5 + diamond:getContentSize().width*1.1 * (i - 2),
            backGround:getContentSize().height * 0.2)
        diamond:ignoreAnchorPointForPosition(false)
        diamond:setAnchorPoint(0.5,0.5)
        backGround:addChild(diamond)  
    end

    local click_mission_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State_Reward)
            s_SCENE:replaceGameLayer(newStudyLayer)
        end
    end

    local choose_mission_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
    choose_mission_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
    choose_mission_button:ignoreAnchorPointForPosition(false)
    choose_mission_button:setAnchorPoint(0.5,0.5)
    choose_mission_button:addTouchEventListener(click_mission_button)
    backGround:addChild(choose_mission_button)  

    local choose_mission_text = cc.Label:createWithSystemFont("趁热打铁","",32)
    choose_mission_text:setPosition(choose_mission_button:getContentSize().width * 0.5,choose_mission_button:getContentSize().height * 0.5)
    choose_mission_text:setColor(cc.c4b(255,255,255,255))
    choose_mission_text:ignoreAnchorPointForPosition(false)
    choose_mission_text:setAnchorPoint(0.5,0.5)
    choose_mission_button:addChild(choose_mission_text) 


    return layer
end

return NewStudyMissionLayer