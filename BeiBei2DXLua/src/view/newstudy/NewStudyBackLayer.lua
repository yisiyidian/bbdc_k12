require("cocos.init")
require("common.global")

local ProgressBar       = require("view.newstudy.NewStudyProgressBar")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")

local BackLayer = class("BackLayer", function()
    return cc.Layer:create()
end)

function BackLayer.create(offset)   -- offset is 97 or 45 or 0
    if offset == nil then
        offset = 45
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT)  

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT + offset)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)

--    local button_pause_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            -- button sound
--            playSound(s_sound_buttonEffect)        
--        elseif eventType == ccui.TouchEventType.ended then            
--            s_CorePlayManager.enterLevelLayer()
--        end
--    end
    
    local pauseBtn = ccui.Button:create("image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    backColor:addChild(pauseBtn,100)
    local Pause = require('view.Pause')
    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then

            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer:addChild(pauseLayer)
            s_SCENE.popupLayer.listener:setSwallowTouches(true)

            --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    
    pauseBtn:addTouchEventListener(pauseScene)
--    local button_pause = ccui.Button:create("image/newstudy/zanting_chapter1.png","image/newstudy/zanting_chapter1.png","")
--    button_pause:setPosition(bigWidth/2-276, 1099)
--    button_pause:addTouchEventListener(button_pause_clicked)
--    backColor:addChild(button_pause)

    if s_CorePlayManager.isStudyModel() then
        backColor.progressBar = ProgressBar.create(s_CorePlayManager.maxWrongWordCount, s_CorePlayManager.wrongWordNum, "yellow")
    else
        backColor.progressBar = ProgressBar.create(s_CorePlayManager.wrongWordNum, s_CorePlayManager.wrongWordNum-s_CorePlayManager.candidateNum, "yellow")
    end
    backColor.progressBar:setPosition(bigWidth/2+44, 1099)
    backColor:addChild(backColor.progressBar)
    
    backColor.progressBar.hint = function()
        local guideAlter = GuideAlter.create(0, "生词进度条", "代表你今天生词积攒任务的完成进度")
        guideAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
        backColor:addChild(guideAlter)
    end
    
    return backColor
end


return BackLayer







