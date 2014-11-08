require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local PersonalInfo = class("PersonalInfo", function()
    return cc.Layer:create()
end)

function PersonalInfo.create()
    local layer = PersonalInfo.new()
    return layer
end

function PersonalInfo:ctor()
    self:initPage()
end

function PersonalInfo:initPage()
    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT * 3))
    pageView:setPosition(s_LEFT_X,0)
    self:addChild(pageView)
    for i = 1 , 3 do
        local back = cc.LayerColor:create(cc.c3b(255,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT * i)
        back:setPosition(s_LEFT_X, 0)
        pageView:addPage(back)

    end 

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local pageView = sender
        end
    end 

    pageView:addEventListener(pageViewEvent)

    
end

return PersonalInfo