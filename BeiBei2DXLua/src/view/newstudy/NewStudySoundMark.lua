local OfflineTip        = require("view.offlinetip.OfflineTipForStudy")

local SoundMark = class("SoundMark", function()
    return cc.Layer:create()
end)

function SoundMark.create(wordname, soundmarkus, soundmarken, playWordOrNot)
    local height = 80
    
    local main = SoundMark.new()
    main:setContentSize(s_DESIGN_WIDTH, height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local button_pronounce
    local button_wordname
    local button_country
    local button_soundmark_en
    local button_soundmark_us

    local button_pronounce_name1    =   "image/newstudy/wordsound_begin.png"
    local button_pronounce_name2    =   "image/newstudy/wordsound_end.png"
    local button_country_name1      =   "image/newstudy/changemark_begin.png"
    local button_country_name2      =   "image/newstudy/changemark_end.png"
    
    local offlineTip
    

    local changeCountry = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- button sound
            playSound(s_sound_buttonEffect)
            if button_country:getTitleText() == "US" then
                s_CURRENT_USER.isSoundAm = 0
                button_country:setTitleText("EN")
                button_soundmark_en:setVisible(true)
                button_soundmark_us:setVisible(false)
            else
                s_CURRENT_USER.isSoundAm = 1
                button_country:setTitleText("US")
                button_soundmark_en:setVisible(false)
                button_soundmark_us:setVisible(true)
            end
        end
    end

    local pronounce = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local wordSoundState = playWordSound(wordname)
            if wordSoundState == PLAY_WORD_SOUND_NO  then
                offlineTip.setTrue()
            end
        end
    end

    button_pronounce = ccui.Button:create(button_pronounce_name1, button_pronounce_name2, "")
    button_pronounce:addTouchEventListener(pronounce)



    button_wordname = cc.Label:createWithTTF(wordname,'font/CenturyGothic.ttf',64)
    button_wordname:setColor(cc.c4b(31,68,102,255))

    button_country = ccui.Button:create(button_country_name1, button_country_name2, "")
    button_country:setTitleFontSize(24)
    button_country:addTouchEventListener(changeCountry)
    if s_CURRENT_USER.isSoundAm == 1 then
        button_country:setTitleText("US")
    else
        button_country:setTitleText("EN")
    end


    button_soundmark_us = cc.Label:createWithSystemFont(soundmarkus,'',28)
    button_soundmark_us:setColor(cc.c4b(41,109,146,255))

    button_soundmark_en = cc.Label:createWithSystemFont(soundmarken,'',28)
    button_soundmark_en:setColor(cc.c4b(41,109,146,255))

    -- handle position
    local max_text_length = math.max(button_wordname:getContentSize().width, button_soundmark_en:getContentSize().width, button_soundmark_us:getContentSize().width)
    local total_length = button_pronounce:getContentSize().width + max_text_length + 30
    local position_left_x = (s_DESIGN_WIDTH-total_length)/2 + button_pronounce:getContentSize().width/2
    local position_right_x = (s_DESIGN_WIDTH+total_length)/2 - max_text_length/2

    button_pronounce:setPosition(position_left_x,height )
    button_wordname:setPosition(position_right_x,height )
    button_country:setPosition(position_left_x,0)
    button_soundmark_us:setPosition(position_right_x,0)
    button_soundmark_en:setPosition(position_right_x,0)

    -- add node
    main:addChild(button_pronounce)
    main:addChild(button_wordname)
    main:addChild(button_country)
    main:addChild(button_soundmark_us)
    main:addChild(button_soundmark_en)
    
    main.scale = function (float)
    	button_pronounce:setScale(float)
        button_country:setScale(float)
    end

    if s_CURRENT_USER.isSoundAm == 1 then
        button_soundmark_en:setVisible(false)
    else
        button_soundmark_us:setVisible(false)
    end
 
    if playWordOrNot ~= false then
    	playWordSound(wordname)
    end
    --add offline
    offlineTip = OfflineTip.create()
    main:addChild(offlineTip,2)

    local touchLocation 
    local onTouchBegan = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        touchLocation = location
        return true
    end
    
    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
 
        if cc.rectContainsPoint(button_wordname:getBoundingBox(),location) then
            if location == touchLocation then
                playWordSound(wordname)
                if s_SERVER.isNetworkConnectedNow()  == false then
                   offlineTip.setTrue()
                end
            end
        elseif s_CURRENT_USER.isSoundAm == 1 and cc.rectContainsPoint(button_soundmark_us:getBoundingBox(),location) then
            s_CURRENT_USER.isSoundAm = 0
            button_country:setTitleText("EN")
            button_soundmark_en:setVisible(true)
            button_soundmark_us:setVisible(false)
        elseif s_CURRENT_USER.isSoundAm == 0 and cc.rectContainsPoint(button_soundmark_en:getBoundingBox(),location) then
            s_CURRENT_USER.isSoundAm = 1
            button_country:setTitleText("US")
            button_soundmark_en:setVisible(false)
            button_soundmark_us:setVisible(true)
        end 
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    main.setSwallowTouches = function (bool)
        listener:setSwallowTouches(bool)
    end

    return main    
end


return SoundMark
