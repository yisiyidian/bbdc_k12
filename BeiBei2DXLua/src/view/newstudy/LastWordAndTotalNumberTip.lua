local LastWordInfo = require("view.newstudy.LastWordInfoPopup")

local LastWordAndTotalNumberTip = class("LastWordAndTotalNumberTip", function()
    return cc.Layer:create()
end)

function LastWordAndTotalNumberTip.create()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = LastWordAndTotalNumberTip.new()
    
    layer.todayNumber = 9999
    layer.word  = "apple"

    
    layer.setNumber = function (todayNumber)
        if todayNumber == -1 then
        else
            layer.todayNumber = todayNumber
            local richtext1 = ccui.RichText:create()
            local richElement1 = ccui.RichElementText:create(1,cc.c3b(41, 110, 146),255,"今已学习：","Helvetica",26)  
            local richElement2 = ccui.RichElementText:create(2,cc.c3b(252, 128, 0),255,layer.todayNumber,"Helvetica",26)  
            local richElement3 = ccui.RichElementText:create(3,cc.c3b(41, 110, 146),255," 个","Helvetica",26)                           
            richtext1:pushBackElement(richElement1) 
            richtext1:pushBackElement(richElement2) 
            richtext1:pushBackElement(richElement3) 
            richtext1:setContentSize(cc.size(300,50)) 
            richtext1:ignoreContentAdaptWithSize(false)
            richtext1:ignoreAnchorPointForPosition(false)
            richtext1:setAnchorPoint(cc.p(0.5,0.5))
            richtext1:setPosition(bigWidth/2 - 150,1100)     
            layer:addChild(richtext1,1)
        end
    end
    
    layer.setWord = function (word,bool)
        if word ~= 0 then
            layer.word  = word
            local lastButtonClick =  function(sender, eventType)
                if eventType == ccui.TouchEventType.began then
                    -- button sound
                    playSound(s_sound_buttonEffect)
                elseif eventType == ccui.TouchEventType.ended then
                    local lastWordInfo = LastWordInfo.create(layer.word)
                    s_SCENE:popup(lastWordInfo)
                end
            end

            local lastButton = ccui.Button:create("image/newstudy/lastbutton.png","","")
            lastButton:setOpacity(200)
            lastButton:setScale9Enabled(true)
            lastButton:setPosition(bigWidth/2 + 250,1110)
            lastButton:setAnchorPoint(0.5,0.5)
            lastButton:ignoreContentAdaptWithSize(false)
            lastButton:addTouchEventListener(lastButtonClick)
            layer:addChild(lastButton,1)

            local mark = cc.Sprite:create("image/newstudy/right.png")
            mark:setPosition(lastButton:getContentSize().width * 0.1,lastButton:getContentSize().height * 0.5)
            mark:setScale(0.8)
            lastButton:addChild(mark)
            
            if bool == true then
                mark:setTexture("image/newstudy/right.png")
            else
                mark:setTexture("image/newstudy/wrong.png")
            end

            local lastWord = cc.Label:createWithSystemFont(layer.word,"Helvetica",26)
            lastWord:setColor(cc.c4b(119,232,251,255))
            lastWord:setPosition(lastButton:getContentSize().width * 0.2,lastButton:getContentSize().height * 0.5)
            lastWord:ignoreAnchorPointForPosition(false)
            lastWord:setAnchorPoint(0,0.5)
            lastButton:addChild(lastWord)
        else

        end
    end
    
    return layer
end

return LastWordAndTotalNumberTip