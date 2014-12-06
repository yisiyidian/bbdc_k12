require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer     = require("view.newstudy.NewStudyLayer")

local  NewStudyRewardLayer = class("NewStudyRewardLayer", function ()
    return cc.Layer:create()
end)

function NewStudyRewardLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewStudyRewardLayer.new()

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

    JudgeColorAtTop(backGround)


    local familiar_label = cc.Label:createWithSystemFont("已完成"..maxWrongWordCount.."个生词","",40)
    familiar_label:setPosition(backGround:getContentSize().width *0.13,s_DESIGN_HEIGHT * 0.68)
    familiar_label:setColor(cc.c4b(124,157,208,255))
    familiar_label:ignoreAnchorPointForPosition(false)
    familiar_label:setAnchorPoint(0,0.5)
    backGround:addChild(familiar_label)

    local green_circle = cc.Sprite:create("image/newstudy/green_circle.png")
    green_circle:setPosition(backGround:getContentSize().width * 0.5,s_DESIGN_HEIGHT * 0.5)
    green_circle:ignoreAnchorPointForPosition(false)
    green_circle:setAnchorPoint(0.5,0.5)
    backGround:addChild(green_circle)

    local familiar_number_label = cc.Label:createWithSystemFont("+"..maxWrongWordCount,"",40)
    familiar_number_label:setColor(cc.c4b(74,219,55,255))
    familiar_number_label:setPosition(green_circle:getContentSize().width * 0.5,green_circle:getContentSize().height * 0.5)
    familiar_number_label:ignoreAnchorPointForPosition(false)
    familiar_number_label:setAnchorPoint(0.5,0.5)
    green_circle:addChild(familiar_number_label)

    local reward_text = cc.Label:createWithSystemFont("恭喜你完成了今天的学习任务\n获得任务奖励","",32)
    reward_text:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.3)
    reward_text:setColor(cc.c4b(255,255,255,255))
    reward_text:ignoreAnchorPointForPosition(false)
    reward_text:setAnchorPoint(0.5,0.5)
    backGround:addChild(reward_text)

    RewardAdd(backGround)

    local click_mission_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            print("congratulation")
        end
    end

    local choose_reward_button = ccui.Button:create("image/newstudy/brown_begin.png","image/newstudy/brown_end.png","")
    choose_reward_button:setPosition(backGround:getContentSize().width /2  , s_DESIGN_HEIGHT * 0.1)
    choose_reward_button:ignoreAnchorPointForPosition(false)
    choose_reward_button:setAnchorPoint(0.5,0.5)
    choose_reward_button:addTouchEventListener(click_mission_button)
    backGround:addChild(choose_reward_button)  

    local choose_reward_text = cc.Label:createWithSystemFont("完成任务","",32)
    choose_reward_text:setPosition(choose_reward_button:getContentSize().width * 0.5,choose_reward_button:getContentSize().height * 0.5)
    choose_reward_text:setColor(cc.c4b(255,255,255,255))
    choose_reward_text:ignoreAnchorPointForPosition(false)
    choose_reward_text:setAnchorPoint(0.5,0.5)
    choose_reward_button:addChild(choose_reward_text) 


    return layer
end

return NewStudyRewardLayer