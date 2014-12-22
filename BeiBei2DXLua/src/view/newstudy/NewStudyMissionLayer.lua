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
  





    return layer
end

return NewStudyMissionLayer