require("view.newstudy.NewStudyFunction")
require("view.newstudy.NewStudyConfigure")

local  NewReviewBossSummaryLayer = class("NewReviewBossSummaryLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossSummaryLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewReviewBossSummaryLayer.new()

    local backGround = cc.Sprite:create("image/newreviewboss/newreviewboss_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    AddPauseButton(backGround)
    
    local summary_label = cc.Label:createWithSystemFont("小结（x/x）","",48)
    summary_label:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.9)
    summary_label:setColor(cc.c4b(0,0,0,255))
    summary_label:ignoreAnchorPointForPosition(false)
    summary_label:setAnchorPoint(0.5,0.5)
    backGround:addChild(summary_label)
    
    local array = {}
    for i = 1,20 do
        array[i] = string.format("ListView_item_%d",i - 1)
    end

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            print("SCROLL_TO_BOTTOM")
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            print("SCROLL_TO_TOP")
        end
    end

    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(bigWidth, s_DESIGN_HEIGHT * 0.6))
    listView:setPosition(bigWidth / 2 - listView:getContentSize().width / 2.0,
        s_DESIGN_HEIGHT *0.4 - listView:getContentSize().height / 2.0)
    listView:addScrollViewEventListener(scrollViewEvent)
    layer:addChild(listView,backGround:getLocalZOrder()+1)


    local count = table.getn(array)
    listView:removeAllChildren()

    --add custom item
    for i = 1,count do
        local custom_sprite = cc.Sprite:create("image/newreviewboss/firsttext.png")
        custom_sprite:setName("Title Button")
        custom_sprite:setContentSize(custom_sprite:getContentSize())
        
        local custom_label = cc.Label:createWithSystemFont(array[i],"",48)
        custom_label:setPosition(custom_sprite:getContentSize().width / 2,custom_sprite: getContentSize().height / 2)
        custom_label:setColor(cc.c4b(0,0,0,255))
        custom_label:ignoreAnchorPointForPosition(false)
        custom_label:setAnchorPoint(0.5,0.5)
        custom_sprite:addChild(custom_label)

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_sprite:getContentSize())
        custom_sprite:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_sprite)

        listView:addChild(custom_item) 
    end
    
    listView:setItemsMargin(2.0)
    
    return layer
end

return NewReviewBossSummaryLayer