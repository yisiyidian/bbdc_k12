local NewReviewBossPause = class("NewReviewBossPause", function()
    return ccui.Button:create()
end)

CreatePauseFromStudy   = 1
CreatePauseFromReview  = 2
CreatePauseFromSummary = 3

function NewReviewBossPause.create(FromWhere)
    local pauseBtn = ccui.Button:create("image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png")
    
    if FromWhere == CreatePauseFromStudy then
       pauseBtn:loadTextures("image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png")
    elseif FromWhere == CreatePauseFromReview then
       pauseBtn:loadTextures("image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png")
    else
       pauseBtn:loadTextures("image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png")
    end
    
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT *0.99)
    s_SCENE.popupLayer.pauseBtn = pauseBtn

    local function createPausePopup()
        local Pause = require('view.Pause')
        local pauseLayer = Pause.create()
        pauseLayer:setPosition(s_LEFT_X, 0)
        s_SCENE.popupLayer:addBackground()  
        s_SCENE.popupLayer:addChild(pauseLayer)
        s_SCENE.popupLayer.listener:setSwallowTouches(true)
    end

    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            createPausePopup()
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    onAndroidKeyPressed(pauseBtn, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup == 0 then
            createPausePopup()
        end
    end, function ()

    end)

    return pauseBtn
end

return NewReviewBossPause