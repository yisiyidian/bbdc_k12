

local SoundMark = class("SoundMark", function()
    return cc.Layer:create()
end)

function SoundMark.create(wordname, soundmarkus, soundmarken)
    -- system variate
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    
    local gap = 115
    
    local main = SoundMark.new()
    main:setContentSize(size.width, gap)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local button_pronounce
    local button_wordname
    local button_country
    local button_soundmark_en
    local button_soundmark_us

    local changeCountry = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if button_country:getTitleText() == "US" then
                button_country:setTitleText("EN")
                button_soundmark_en:setVisible(true)
                button_soundmark_us:setVisible(false)
            else
                button_country:setTitleText("US")
                button_soundmark_en:setVisible(false)
                button_soundmark_us:setVisible(true)
            end
        end
    end
    
    local pronounce = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
    	   s_logd("pronounce")
    	end
    end

    button_pronounce = ccui.Button:create()
    button_pronounce:loadTextures("image/button/soundButton1.png", "", "")
    button_pronounce:addTouchEventListener(pronounce)
        
    button_wordname = cc.Label:createWithSystemFont(wordname,"",80)
    button_wordname:setColor(cc.c4b(0,0,0,255))
    
    button_country = ccui.Button:create()
    button_country:loadTextures("image/button/USButton1.png", "", "")
    button_country:setTitleText("US")
    button_country:setTitleFontSize(30)
    button_country:addTouchEventListener(changeCountry)
    
    button_soundmark_us = cc.Label:createWithSystemFont(soundmarkus,"",40)
    button_soundmark_us:setColor(cc.c4b(0,0,0,255))
    
    button_soundmark_en = cc.Label:createWithSystemFont(soundmarken,"",40)
    button_soundmark_en:setColor(cc.c4b(0,0,0,255))

    -- handle position
    local max_text_length = math.max(button_wordname:getContentSize().width, button_soundmark_en:getContentSize().width, button_soundmark_us:getContentSize().width)
    local total_length = button_pronounce:getContentSize().width + max_text_length + 10
    local position_left_x = (size.width-total_length)/2 + button_pronounce:getContentSize().width/2
    local position_right_x = (size.width+total_length)/2 - max_text_length/2
    
    button_pronounce:setPosition(position_left_x,gap)
    button_wordname:setPosition(position_right_x,gap)
    button_country:setPosition(position_left_x,0)
    button_soundmark_us:setPosition(position_right_x,0)
    button_soundmark_en:setPosition(position_right_x,0)
    
    -- add node
    main:addChild(button_pronounce)
    main:addChild(button_wordname)
    main:addChild(button_country)
    main:addChild(button_soundmark_us)
    main:addChild(button_soundmark_en)
    
    button_soundmark_en:setVisible(false)

    return main    
end


return SoundMark







