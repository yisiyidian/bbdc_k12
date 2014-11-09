require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local ScrollViewTest = class("ScrollViewTest", function()
    return cc.Layer:create()
end)

function ScrollViewTest.create()
    local layer = ScrollViewTest.new()
    return layer
end

function ScrollViewTest:ctor()

    local scrollView1 = ccui.ScrollView:create()
    
    if nil ~= scrollView1 then
    
        scrollView1:setPosition(cc.p(0,0))
        scrollView1:setContentSize(cc.size(s_DESIGN_WIDTH  ,s_DESIGN_HEIGHT))
        scrollView1:setInnerContainerSize(cc.size(s_DESIGN_WIDTH  ,s_DESIGN_HEIGHT * 4))
        
        local colorArray = {cc.c4b(56,182,236,255 ),cc.c4b(238,75,74,255 ),cc.c4b(251,166,24,255 ),cc.c4b(143,197,46,255 )}
        local titleArray = {'单词掌握统计','单词学习增长','登陆贝贝天数','学习效率统计'}
        local intro_array = {}
        for i = 1,4 do

            local intro = cc.LayerColor:create(colorArray[5-i], s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
            intro:ignoreAnchorPointForPosition(false)
            intro:setAnchorPoint(0.5,0.5)
            intro:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT*(i-0.5)) 

            scrollView1:addChild(intro,0,string.format('back%d',i))
            if i > 1 then
                local scrollButton = cc.Sprite:create("image/PersonalInfo/scrollHintButton.png")
                scrollButton:setPosition(s_DESIGN_WIDTH/2  ,s_DESIGN_HEIGHT * 0.08)
                scrollButton:setLocalZOrder(1)
                intro:addChild(scrollButton)
                local move = cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-30)),cc.MoveBy:create(0.5,cc.p(0,30)))
                scrollButton:runAction(cc.RepeatForever:create(move))

            end
            local title = cc.Label:createWithSystemFont(titleArray[5-i],'',36)
            title:setPosition(0.5 * s_DESIGN_WIDTH,0.75 * s_DESIGN_HEIGHT)
            title:setColor(cc.c3b(255,255,255))
            intro:addChild(title)
            table.insert(intro_array, intro)
        end 
    end
    self:addChild(scrollView1)
    
    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            print("SCROLL_TO_BOTTOM")
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            print("SCROLL_TO_TOP")
        end
    end
    scrollView1:addScrollViewEventListener(scrollViewEvent)
end

return ScrollViewTest