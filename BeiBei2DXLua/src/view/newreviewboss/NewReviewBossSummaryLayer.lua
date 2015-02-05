local Pause             = require("view.newreviewboss.NewReviewBossPause")
local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")

local  NewReviewBossSummaryLayer = class("NewReviewBossSummaryLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossSummaryLayer.create(reviewWordList)

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local custom_sprite_site = {}
    custom_sprite_site[1] = "image/newreviewboss/firsttext.png"
    custom_sprite_site[2] = "image/newreviewboss/middletext.png"
    custom_sprite_site[3] = "image/newreviewboss/endtext.png"

    local layer = NewReviewBossSummaryLayer.new()
   
    
    local type = 1
    local custom_sprite = {}
    local percentBar 
    local listView
    
    local pauseButton = Pause.create()
    layer:addChild(pauseButton,100)


    local fillColor1 = cc.LayerColor:create(cc.c4b(10,152,210,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 263)
    fillColor1:setAnchorPoint(0.5,0)
    fillColor1:ignoreAnchorPointForPosition(false)
    fillColor1:setPosition(s_DESIGN_WIDTH/2,0)
    layer:addChild(fillColor1)

    local fillColor2 = cc.LayerColor:create(cc.c4b(26,169,227,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 542-263)
    fillColor2:setAnchorPoint(0.5,0)
    fillColor2:ignoreAnchorPointForPosition(false)
    fillColor2:setPosition(s_DESIGN_WIDTH/2,263)
    layer:addChild(fillColor2)

    local fillColor3 = cc.LayerColor:create(cc.c4b(36,186,248,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 776-542)
    fillColor3:setAnchorPoint(0.5,0)
    fillColor3:ignoreAnchorPointForPosition(false)
    fillColor3:setPosition(s_DESIGN_WIDTH/2,542)
    layer:addChild(fillColor3)

    local fillColor4 = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-776)
    fillColor4:setAnchorPoint(0.5,0)
    fillColor4:ignoreAnchorPointForPosition(false)
    fillColor4:setPosition(s_DESIGN_WIDTH/2,776)
    layer:addChild(fillColor4)
    
    local backGround = cc.Sprite:create("image/newreviewboss/weavebackgroundblue.png")
    backGround:setPosition(s_DESIGN_WIDTH / 2,-200)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0)
    layer:addChild(backGround)
    
    local action1 = cc.MoveTo:create(0.4, cc.p(s_DESIGN_WIDTH / 2,0))
    backGround:runAction(action1)
    
--    local summary_label = cc.Label:createWithSystemFont("小结（"..current_boss_number.."/"..totol_boss_number..")","",48)
--    summary_label:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.95 + 200)
--    summary_label:setColor(cc.c4b(0,0,0,255))
--    summary_label:ignoreAnchorPointForPosition(false)
--    summary_label:setAnchorPoint(0.5,0.5)
--    layer:addChild(summary_label)
--    
--    local action1 = cc.MoveBy:create(0.4, cc.p(0,-200))
--    summary_label:runAction(action1)
    
    local summury_back = cc.Sprite:create("image/newreviewboss/backgroundreviewboss1.png")
    summury_back:setPosition(s_DESIGN_WIDTH / 2,-100)
    summury_back:ignoreAnchorPointForPosition(false)
    summury_back:setAnchorPoint(0.5,0)
    layer:addChild(summury_back)
    
    local action1 = cc.MoveTo:create(0.4, cc.p(s_DESIGN_WIDTH / 2,0))
    summury_back:runAction(action1)
    
    local wordList = {}
    table.foreachi(reviewWordList, function(i, v)
        if  reviewWordList[i] ~= "" then
            table.insert(wordList,reviewWordList[i] )
        end
    end) 
    local wordListLen = table.getn(wordList)  
    
    local word = {}
    local meaning = {}
    for i = 1,wordListLen  do
        --word[i] = s_WordPool[wordList[i]].wordName
        --meaning[i] = s_WordPool[wordList[i]].wordMeaning

        local currentWord = s_LocalDatabaseManager.getWordInfoFromWordName(wordList[i])
        word[i] = currentWord.wordName
        meaning[i] = currentWord.wordMeaning
    end
    


    local scrollViewEvent = function (sender, evenType)

    end


    
    listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_DESIGN_WIDTH, s_DESIGN_HEIGHT * 0.7))
    listView:setPosition(s_DESIGN_WIDTH / 2 - listView:getContentSize().width / 2.0 + 5,
        s_DESIGN_HEIGHT *0.5 - listView:getContentSize().height / 2.0 - 25)
    listView:addScrollViewEventListener(scrollViewEvent)
    listView:setBounceEnabled(true)
    
    summury_back:addChild(listView,backGround:getLocalZOrder()+1)
    
    local init_circle = function (custom_sprite)
        local circle
        for i = 1,4 do
            if i >= type + 1 then
                circle = cc.Sprite:create("image/word_list/libruary_quan1.png")
            else
                circle = cc.Sprite:create("image/word_list/button_wordbook_blue.png")
            end
            circle:setPosition(custom_sprite:getContentSize().width * ( 1.3 - 0.075 * i) ,custom_sprite:getContentSize().height * 0.85)
            circle:setTag(i - 1)
            custom_sprite:addChild(circle)
        end    
    end


    local count = table.getn(word)
    listView:removeAllChildren()

    --add custom item
    for i = 1,count do
        custom_sprite[i] = cc.LayerColor:create(cc.c4b(255,255,255,255),summury_back:getContentSize().width * 0.7,
        summury_back:getContentSize().height * 0.2)
        custom_sprite[i]:ignoreAnchorPointForPosition(false)
        custom_sprite[i]:setAnchorPoint(0.5,0.5)              
        
        local custom_label = cc.Label:createWithSystemFont(word[i],"",30)
        custom_label:setPosition(custom_sprite[i]:getContentSize().width *0.1,custom_sprite[i]:getContentSize().height*0.95)
        custom_label:setColor(cc.c4b(0,0,0,255))
        custom_label:ignoreAnchorPointForPosition(false)
        custom_label:setAnchorPoint(0,1)
        custom_sprite[i]:addChild(custom_label)
        
        local richtext = ccui.RichText:create()

        local opt_meaning = string.gsub(meaning[i],"|||"," ")

        local current_word_wordMeaning = cc.LabelTTF:create (opt_meaning,
            "Helvetica",24, cc.size(summury_back:getContentSize().width *0.9, 200), cc.TEXT_ALIGNMENT_LEFT)

        current_word_wordMeaning:setColor(cc.c4b(0,0,0,255))

        local richElement = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           

        richtext:pushBackElement(richElement) 

        richtext:setContentSize(cc.size(summury_back:getContentSize().width *0.9, 
            custom_sprite[i]:getContentSize().height *0.7)) 
        richtext:ignoreContentAdaptWithSize(false)
        richtext:ignoreAnchorPointForPosition(false)
        richtext:setAnchorPoint(cc.p(0.5,0.5))
        richtext:setPosition(custom_sprite[i]:getContentSize().width *0.7,custom_sprite[i]:getContentSize().height *0.4)
        richtext:setLocalZOrder(10)                    

        custom_sprite[i]:addChild(richtext) 
        
        local line = cc.LayerColor:create(cc.c4b(244,245,246,255),summury_back:getContentSize().width * 0.95  ,4)
        line:ignoreAnchorPointForPosition(false)
        line:setAnchorPoint(0,0.5)
        line:setPosition(0,0)
        custom_sprite[i]:addChild(line)
        
        init_circle(custom_sprite[i])

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_sprite[i]:getContentSize())
        custom_sprite[i]:setPosition(cc.p(custom_sprite[i]:getContentSize().width / 2.0,custom_sprite[i]:getContentSize().height / 2.0))
        custom_item:addChild(custom_sprite[i])

        listView:addChild(custom_item) 
        
    end
    
    listView:setItemsMargin(2.0)
    
    percentBar = cc.Sprite:create("image/newreviewboss/gundongtiaofuxiboss.png")
    percentBar:setPosition(summury_back:getContentSize().width * 0.98 ,summury_back:getContentSize().height * 0.98)
    percentBar:ignoreAnchorPointForPosition(false)
    percentBar:setAnchorPoint(0.5,1)
    summury_back:addChild(percentBar)
    
    
    
    for i = 1,count do
        local animation = cc.Sprite:create("image/word_list/button_wordbook_blue.png")
        local sprite = custom_sprite[i]:getChildByTag(type)
        animation:setPosition(sprite:getContentSize().width/2,sprite:getContentSize().height/2)
        animation:setScale(0)
        sprite:addChild(animation)

        local action0 = cc.ScaleTo:create(1,1.2)
        local action1 = cc.ScaleTo:create(0.5,1)
        animation:runAction(cc.Sequence:create(action0, action1))
        
      
        if type == 3 then
            for j = 0,3 do
                local animation = cc.Sprite:create("image/word_list/button_wordbook_green.png")
                local sprite = custom_sprite[i]:getChildByTag(j)
                animation:setPosition(sprite:getContentSize().width/2,sprite:getContentSize().height/2)
                animation:setScale(0)
                sprite:addChild(animation)

                local action0 = cc.ScaleTo:create(1,1.2)
                local action1 = cc.ScaleTo:create(0.5,1)
                animation:runAction(cc.Sequence:create(action0, action1))
            end
        end

    end
    
    
    local next_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)    
            local action1 = cc.MoveTo:create(0.4, cc.p(s_DESIGN_WIDTH / 2,-200))
            backGround:runAction(action1)

            local rbProgressBar = ProgressBar.create(s_max_wrong_num_everyday,0,"orange")
            rbProgressBar:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.9 + 200)
            layer:addChild(rbProgressBar)
            local action1 = cc.MoveBy:create(0.5,cc.p(0,-200))
            rbProgressBar:runAction(action1)   

            local action1 = cc.MoveTo:create(0.4, cc.p(s_DESIGN_WIDTH / 2,-400))
            summury_back:runAction(action1)    

        elseif eventType == ccui.TouchEventType.ended then   
            
            local SuccessLayer = require("view.newreviewboss.NewReviewBossSuccessPopup")
            local successLayer = SuccessLayer.create()
            s_SCENE:popup(successLayer)
        end
    end
    
    local nextButton = ccui.Button:create("image/newreviewboss/buttonreviewboss1nextend.png","image/newreviewboss/buttonreviewboss1nextend.png","")
    nextButton:setScale9Enabled(true)
    nextButton:setPosition(s_DESIGN_WIDTH / 2, 50)
    nextButton:ignoreAnchorPointForPosition(false)
    nextButton:setAnchorPoint(0.5,0)
    nextButton:addTouchEventListener(next_click)
    nextButton:setScale9Enabled(true)
    layer:addChild(nextButton) 
    
    local nextButton_label = cc.Label:createWithSystemFont("完成复习","",30)
    nextButton_label:setPosition(nextButton:getContentSize().width / 2,nextButton: getContentSize().height / 2)
    nextButton_label:setColor(cc.c4b(255,255,255,255))
    nextButton_label:ignoreAnchorPointForPosition(false)
    nextButton_label:setAnchorPoint(0.5,0.5)
    nextButton:addChild(nextButton_label)
    
    local seagrass = cc.Sprite:create("image/newreviewboss/frontgroundyellow1.png")
    seagrass:setPosition(s_DESIGN_WIDTH / 2,0)
    seagrass:ignoreAnchorPointForPosition(false)
    seagrass:setAnchorPoint(0.5,0)
    layer:addChild(seagrass)
    
    local timer = 0
    local function update(delta)
        local current_y = (0 - listView:getInnerContainer():getPositionY())
        local current_height = listView:getInnerContainerSize().height
        local current_percent = current_y / current_height + 0.2
        local top_y = summury_back:getContentSize().height * 0.98
        local bottom_y = summury_back:getContentSize().height * 0.28
        local changetoposition_y = top_y -  (top_y - bottom_y) * (1 -current_percent)

        timer = timer +  delta
        if timer > 0.2 then
            local action1 = cc.MoveTo:create(timer,cc.p(summury_back:getContentSize().width * 0.98,changetoposition_y))
            percentBar:runAction(action1)
        timer = 0
        end
    end

    layer:scheduleUpdateWithPriorityLua(update, 0)
    
    
    return layer
end

return NewReviewBossSummaryLayer