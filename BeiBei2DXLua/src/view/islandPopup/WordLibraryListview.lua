local WordLibraryListview = class ("WordLibraryListview",function ()
    return ccui.ListView:create()
end)

local wordInfoPopup = require("view.islandPopup.WordInfoPopup")

function WordLibraryListview.create(wordList)
    local layer = WordLibraryListview.new(wordList)
    return layer
end

function WordLibraryListview:ctor(wordList)

    local scrollViewEvent = function (sender, evenType)

    end
    
    local visible
    if s_CURRENT_USER.familiarOrUnfamiliar == 0 then
        visible = true
    else
        visible = false
    end
    
    self:setDirection(ccui.ScrollViewDir.vertical)
    self:setBackGroundImageScale9Enabled(true)
    self:setContentSize(cc.size(541, s_DESIGN_HEIGHT * 0.65))
    self:setPosition(545 / 2 - self:getContentSize().width / 2.0 ,
        s_DESIGN_HEIGHT *0.65 - self:getContentSize().height / 2 )
    self:addScrollViewEventListener(scrollViewEvent)
    self:setBounceEnabled(true)


    local word = {}
    local meaning = {}
    for i = 1,#wordList  do
        word[i] = s_WordPool[wordList[i]].wordName
        meaning[i] = s_WordPool[wordList[i]].wordMeaningSmall
    end

    local count = table.getn(wordList)
    self:removeAllChildren()

    local lookup_button_click = function (sender,eventType)
        if eventType == ccui.TouchEventType.ended then
           sender:setVisible(false)
        end
    end
    
    local arrow_button_click = function (sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local Name = sender:getName()
            print("name"..Name)
            local part = split(Name,"||")
            local wordInfo = wordInfoPopup.create(part[1],part[2],wordList)
            s_SCENE.popupLayer:addChild(wordInfo)
        end
    end
    
    for i = 1,count do
        local current_sprite = cc.LayerColor:create(cc.c4b(255,255,255,255),541 ,
            150)
        current_sprite:ignoreAnchorPointForPosition(false)
        current_sprite:setAnchorPoint(0.5,0.5)              

        local custom_label = cc.Label:createWithSystemFont(word[i],"",30)
        custom_label:setPosition(current_sprite:getContentSize().width *0.1,current_sprite:getContentSize().height*0.5)
        custom_label:setColor(cc.c4b(0,0,0,255))
        custom_label:ignoreAnchorPointForPosition(false)
        custom_label:setAnchorPoint(0,0.5)
        current_sprite:addChild(custom_label)

        local richtext = ccui.RichText:create()

        local opt_meaning = string.gsub(meaning[i],"|||"," ")

        local current_word_wordMeaning = cc.LabelTTF:create (opt_meaning,
            "Helvetica",24, cc.size(current_sprite:getContentSize().width *0.32, 100), cc.TEXT_ALIGNMENT_LEFT)
        current_word_wordMeaning:setPosition(cc.p(current_sprite:getContentSize().width * 0.5,current_sprite:getContentSize().height * 0.25))
        current_word_wordMeaning:setColor(cc.c4b(0,0,0,255))
        current_word_wordMeaning:ignoreAnchorPointForPosition(false)
        current_word_wordMeaning:setAnchorPoint(0,0.5)
        current_sprite:addChild(current_word_wordMeaning)
        
        local lookup_button = ccui.Button:create("image/islandPopup/havealook.png","","")
        lookup_button:setPosition(cc.p(current_sprite:getContentSize().width * 0.45,current_sprite:getContentSize().height / 2.0))
        lookup_button:ignoreAnchorPointForPosition(false)
        lookup_button:setAnchorPoint(0,0.5)
        lookup_button:addTouchEventListener(lookup_button_click)
        lookup_button:setName("i"..i)
        lookup_button:setVisible(visible)
        current_sprite:addChild(lookup_button)
        
        local lookup_label = cc.Label:createWithSystemFont("点击查看示意","",25)
        lookup_label:setColor(cc.c4b(108,122,126,255))
        lookup_label:setPosition(cc.p(lookup_button:getContentSize().width * 0.5,lookup_button:getContentSize().height / 2.0))
        lookup_button:addChild(lookup_label)
        
        local arrow_button = ccui.Button:create("image/islandPopup/arrow.png","","")
        arrow_button:setPosition(cc.p(current_sprite:getContentSize().width * 0.92,current_sprite:getContentSize().height / 2.0))
        arrow_button:addTouchEventListener(arrow_button_click)
        arrow_button:setName("arrow||"..i)
        current_sprite:addChild(arrow_button)
          
        local line = cc.LayerColor:create(cc.c4b(244,245,246,255),current_sprite:getContentSize().width * 0.95  ,4)
        line:ignoreAnchorPointForPosition(false)
        line:setAnchorPoint(0,0.5)
        line:setPosition(0,0)
        current_sprite:addChild(line)

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(current_sprite:getContentSize())
        current_sprite:setPosition(cc.p(current_sprite:getContentSize().width / 2.0,current_sprite:getContentSize().height / 2.0))
        custom_item:addChild(current_sprite)

        self:addChild(custom_item) 

    end

    self:setItemsMargin(2.0)

    self.getPosition = function ()
        local current_y = (0 - self:getInnerContainer():getPositionY())
        local current_height = self:getInnerContainerSize().height
        local current_percent = current_y / current_height + 0.2
        return current_percent
    end
 
end

return WordLibraryListview