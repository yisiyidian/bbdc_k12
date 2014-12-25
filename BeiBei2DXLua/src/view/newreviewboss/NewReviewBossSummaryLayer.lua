

local  NewReviewBossSummaryLayer = class("NewReviewBossSummaryLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossSummaryLayer.create()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local custom_sprite_site = {}
    custom_sprite_site[1] = "image/newreviewboss/firsttext.png"
    custom_sprite_site[2] = "image/newreviewboss/middletext.png"
    custom_sprite_site[3] = "image/newreviewboss/endtext.png"

    local layer = NewReviewBossSummaryLayer.new()

    local backGround = cc.Sprite:create("image/newreviewboss/newreviewboss_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)
    
    local summary_label = cc.Label:createWithSystemFont("小结（4/4）","",48)
    summary_label:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.95)
    summary_label:setColor(cc.c4b(0,0,0,255))
    summary_label:ignoreAnchorPointForPosition(false)
    summary_label:setAnchorPoint(0.5,0.5)
    backGround:addChild(summary_label)
    
    local word = {}
    local meaning = {}
    for i = 1,20 do
        word[i] = s_WordPool[s_CorePlayManager.ReviewWordList[i]].wordName
        meaning[i] = s_WordPool[s_CorePlayManager.ReviewWordList[i]].wordMeaning
    end

    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(bigWidth, s_DESIGN_HEIGHT * 0.7))
    listView:setPosition(bigWidth / 2 - listView:getContentSize().width / 2.0,
        s_DESIGN_HEIGHT *0.5 - listView:getContentSize().height / 2.0)
    layer:addChild(listView,backGround:getLocalZOrder()+1)


    local count = table.getn(word)
    listView:removeAllChildren()

    --add custom item
    for i = 1,count do
        local custom_sprite
        if i == 1 then
           custom_sprite = cc.Sprite:create(custom_sprite_site[1])
        elseif i == 20 then
            custom_sprite = cc.Sprite:create(custom_sprite_site[3])
        else 
            custom_sprite = cc.Sprite:create(custom_sprite_site[2])
        end

        custom_sprite:setContentSize(custom_sprite:getContentSize())
        
        local custom_label = cc.Label:createWithSystemFont(word[i],"",30)
        custom_label:setPosition(custom_sprite:getContentSize().width *0.1,custom_sprite: getContentSize().height*0.9)
        custom_label:setColor(cc.c4b(0,0,0,255))
        custom_label:ignoreAnchorPointForPosition(false)
        custom_label:setAnchorPoint(0,1)
        custom_sprite:addChild(custom_label)
        
        local richtext = ccui.RichText:create()

        local current_word_wordMeaning = cc.LabelTTF:create (meaning[i],
            "Helvetica",24, cc.size(custom_sprite:getContentSize().width *0.8, 200), cc.TEXT_ALIGNMENT_LEFT)

        current_word_wordMeaning:setColor(cc.c4b(0,0,0,255))

        local richElement = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           

        richtext:pushBackElement(richElement) 

        richtext:setContentSize(cc.size(custom_sprite:getContentSize().width *0.8, 
            custom_sprite:getContentSize().height *0.3)) 
        richtext:ignoreContentAdaptWithSize(false)
        richtext:ignoreAnchorPointForPosition(false)
        richtext:setAnchorPoint(cc.p(0.5,0.5))
        richtext:setPosition(custom_sprite:getContentSize().width *0.5, 
            custom_sprite:getContentSize().height *0.4)
        richtext:setLocalZOrder(10)                    

        custom_sprite:addChild(richtext) 

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_sprite:getContentSize())
        custom_sprite:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_sprite)

        listView:addChild(custom_item) 
    end
    
    listView:setItemsMargin(2.0)
    
    local bottomColor = cc.LayerColor:create(cc.c4b(118,218,240,100), backGround:getContentSize().width ,s_DESIGN_HEIGHT * 0.2)  
    bottomColor:setAnchorPoint(0.5,0)
    bottomColor:ignoreAnchorPointForPosition(false)
    bottomColor:setPosition(s_DESIGN_WIDTH/2,0)
    backGround:addChild(bottomColor) 
    
    local next_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossSuccessPopup")
            local newReviewBossLayerChange = NewReviewBossLayerChange.create()
            s_SCENE:popup(newReviewBossLayerChange)
        end
    end
    
    local nextButton = ccui.Button:create("image/newreviewboss/nextgroupbegin.png","image/newreviewboss/nextgroupend.png","")
    nextButton:setPosition(backGround:getContentSize().width /2 , bottomColor:getContentSize().height *0.4 )
    nextButton:ignoreAnchorPointForPosition(false)
    nextButton:setAnchorPoint(0.5,0.5)
    nextButton:addTouchEventListener(next_click)
    backGround:addChild(nextButton) 
    
    local nextButton_label = cc.Label:createWithSystemFont("下一组","",30)
    nextButton_label:setPosition(nextButton:getContentSize().width / 2,nextButton: getContentSize().height / 2)
    nextButton_label:setColor(cc.c4b(255,255,255,255))
    nextButton_label:ignoreAnchorPointForPosition(false)
    nextButton_label:setAnchorPoint(0.5,0.5)
    nextButton:addChild(nextButton_label)
    
    
    return layer
end

return NewReviewBossSummaryLayer