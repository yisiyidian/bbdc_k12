

local SoundMark = class("SoundMark", function()
    return cc.Layer:create()
end)

function SoundMark.create(wordname, soundmarkus, soundmarken, typeIndex)
    -- system variate
    
    local gap = 115
    
    local main = SoundMark.new()
    main:setContentSize(s_DESIGN_WIDTH, gap)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local button_pronounce
    local button_wordname
    local button_country
    local button_soundmark_en
    local button_soundmark_us
    
    local button_pronounce_name1    =   "image/button/button_sound"..typeIndex.."1.png"
    local button_pronounce_name2    =   "image/button/button_sound"..typeIndex.."2.png"
    local button_country_name1      =   "image/button/button_mark"..typeIndex.."1.png"
    local button_country_name2      =   "image/button/button_mark"..typeIndex.."2.png"

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
            playWordSound(wordname)
    	end
    end

    button_pronounce = ccui.Button:create(button_pronounce_name1, button_pronounce_name2, "")
    button_pronounce:addTouchEventListener(pronounce)
        
    button_wordname = cc.Label:createWithSystemFont(wordname,"",80)
    button_wordname:setColor(cc.c4b(0,0,0,255))
    
    button_country = ccui.Button:create(button_country_name1, button_country_name2, "")
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
    local position_left_x = (s_DESIGN_WIDTH-total_length)/2 + button_pronounce:getContentSize().width/2
    local position_right_x = (s_DESIGN_WIDTH+total_length)/2 - max_text_length/2
    
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
    
    if s_CURRENT_USER.isSoundAm == 1 then
        button_soundmark_en:setVisible(false)
    else
        button_soundmark_us:setVisible(false)
    end
    
    if typeIndex == 2 and typeIndex == 3 then
        button_wordname:setColor(cc.c4b(255,255,255,255))
        button_soundmark_us:setColor(cc.c4b(255,255,255,255))
        button_soundmark_en:setColor(cc.c4b(255,255,255,255))
    end

    return main    
end


return SoundMark







