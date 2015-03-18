require("cocos.init")
require("common.global")

local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local GuideAlter            = require("view.newstudy.NewStudyGuideAlter")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")

local BackLayer = class("BackLayer", function()
    return cc.Layer:create()
end)

function BackLayer.create(offset)   -- offset is 97 or 45 or 0
    if offset == nil then
        offset = 45
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT)  
    
    backColor.forceFail =function ()

    end  

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT + offset)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)
    
    local pauseBtn = PauseButton.create(CreatePauseFromStudy)
    backColor:addChild(pauseBtn,100)
    
    return backColor
end


return BackLayer







