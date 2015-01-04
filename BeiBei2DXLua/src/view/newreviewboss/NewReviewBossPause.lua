local NewReviewBossPause = class("NewReviewBossPause", function()
    return ccui.Button:create()
end)

function NewReviewBossPause.create()
    
    local pauseBtn = ccui.Button:create("image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT *0.99)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    local Pause = require('view.Pause')
    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer:addChild(pauseLayer)
            s_SCENE.popupLayer.listener:setSwallowTouches(true)
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    return pauseBtn
end

return NewReviewBossPause