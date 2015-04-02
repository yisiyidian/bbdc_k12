local NewReviewBossPause = class("NewReviewBossPause", function()
    return ccui.Button:create()
end)

local EnlargeTouchAreaReturnButton = require("view.islandPopup.EnlargeTouchAreaReturnButton")

CreatePauseFromStudy   = 1
CreatePauseFromReview  = 2
CreatePauseFromSummary = 3

function NewReviewBossPause.create(FromWhere)
    local pauseBtn 
    
    if FromWhere == CreatePauseFromStudy then
        pauseBtn = EnlargeTouchAreaReturnButton.create("image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png")
    elseif FromWhere == CreatePauseFromReview then
        pauseBtn = EnlargeTouchAreaReturnButton.create("image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png")
    else
        pauseBtn = EnlargeTouchAreaReturnButton.create("image/button/pauseButtonWhite.png","image/button/pauseButtonWhite.png")
    end
    
    s_SCENE.popupLayer.pauseBtn = pauseBtn

    local function createPausePopup()
        local Pause = require('view.Pause')
        local pauseLayer = Pause.create()
        pauseLayer:setPosition(s_LEFT_X, 0)
        s_SCENE.popupLayer:addBackground()  
        s_SCENE.popupLayer:addChild(pauseLayer)
        s_SCENE.popupLayer.listener:setSwallowTouches(true)
    end

    local function pauseScene()
        playSound(s_sound_buttonEffect)
        createPausePopup()
    end

    pauseBtn.func = function ()
       pauseScene()
    end
    
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