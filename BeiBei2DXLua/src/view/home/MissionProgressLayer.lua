-- 进入游戏的按钮
require("cocos.init")
require("common.global")

local MissionProgressLayer = class("MissionProgressLayer", function ()
    return cc.Layer:create()
end)

MissionProgressLayer.hasGotNotContainedInLocalDatas = false
function MissionProgressLayer.getNotContainedInLocalDatas(callback)
    if MissionProgressLayer.hasGotNotContainedInLocalDatas or (not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken()) then
        if callback then callback() end
        return
    end

    showProgressHUD('', true)
    getNotContainedInLocalBossWordFromServer(function (serverDatas, error)
        MissionProgressLayer.hasGotNotContainedInLocalDatas = (error == nil)
        if callback then callback() end
        hideProgressHUD(true)
    end)
end


function MissionProgressLayer.create(share,homelayer)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = MissionProgressLayer.new()
    
    layer.stopListener = false
    
    local label = cc.Sprite:create("image/homescene/missionprogress/label.png")
    label:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 + 220)
    layer:addChild(label)

    --进入游戏
    local enterGame = function(sender, eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        sender:runAction(cc.FadeOut:create(0.5))
        playSound(s_sound_buttonEffect)
        MissionProgressLayer.getNotContainedInLocalDatas(function ()
            s_CURRENT_USER:generateSummaryBossList()
            s_CURRENT_USER:generateChestList()
            s_CURRENT_USER:updateDataToServer()

            AnalyticsEnterLevelLayerBtn()
            AnalyticsFirst(ANALYTICS_FIRST_LEVEL, 'TOUCH')

            if s_CURRENT_USER.k12SmallStep < s_K12_enterLevelLayer then
                s_CURRENT_USER:setK12SmallStep(s_K12_enterLevelLayer)
            end
            -- 打点
            s_CURRENT_USER:setSummaryStep(s_summary_enterLevelLayer) 
            playSound(s_sound_buttonEffect)
            if layer:getChildByTag(8888) ~=nil then
                local schedule = layer:getChildByTag(8888):getScheduler()
                schedule:unscheduleScriptEntry(schedule.schedulerEntry)
            end

            if s_CURRENT_USER.guideStep < s_guide_step_enterStory1 then
                s_CURRENT_USER:setGuideStep(s_guide_step_enterStory1)
                s_CorePlayManager.enterStoryLayer()
            else
                  s_CorePlayManager.enterLevelLayer()
            end
        end)
    end

    local backProgress = ccui.Button:create("image/homescene/missionprogress/button.png","image/homescene/missionprogress/button.png","image/homescene/missionprogress/button.png")
    backProgress:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 40)
    backProgress:addTouchEventListener(enterGame)
    layer:addChild(backProgress)
    
    local swelling = cc.ScaleTo:create(0.12,1.08)
    local swellingRevese = cc.ScaleTo:create(0.12,1)
    local delay = cc.DelayTime:create(1)

    local sequence = cc.Sequence:create(swelling,swellingRevese,swelling,swellingRevese,delay)
    local action = cc.RepeatForever:create(sequence)
    backProgress:runAction(action)

    return layer
end

return MissionProgressLayer
