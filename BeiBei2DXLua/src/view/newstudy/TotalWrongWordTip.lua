local TotalWrongWordTip = class("TotalWrongWordTip", function()
    return cc.Layer:create()
end)

function TotalWrongWordTip:getCurrentLevelWrongNum()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local currentNumber = #bossList[#bossList].wrongWordList 
    return currentNumber
end

function TotalWrongWordTip.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local total_number = getMaxWrongNumEveryLevel()
    local layer = TotalWrongWordTip.new()

    layer.todayNumber = 9999
    layer.setNumber = function (todayNumber)
        if todayNumber == -1 then
        else
            layer.todayNumber = todayNumber
            local sprite = cc.Sprite:create("image/newstudy/bag_study_small_background.png")
            sprite:setPosition(bigWidth/2 + 240,1100)
            sprite:setAnchorPoint(0.5,0.5)
            sprite:ignoreAnchorPointForPosition(false)
            layer:addChild(sprite,1)

            local bag = cc.Sprite:create("image/newstudy/bag_study_small.png")
            bag:setPosition(sprite:getContentSize().width * 0.2,sprite:getContentSize().height * 0.5)
            sprite:addChild(bag)

            local progressLabel = cc.Label:createWithSystemFont(todayNumber.." / "..total_number,"",22)
            progressLabel:setPosition(sprite:getContentSize().width *0.75, sprite:getContentSize().height / 2)
            progressLabel:ignoreAnchorPointForPosition(false)
            progressLabel:setAnchorPoint(0.5,0.5)
            progressLabel:setColor(cc.c4b(0,0,0,255))
            progressLabel:enableOutline(cc.c4b(0,0,0,255),1)
            sprite:addChild(progressLabel)
        end
    end

    return layer
end

return TotalWrongWordTip