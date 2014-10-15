

local ProgressBar = class("ProgressBar", function()
return cc.Layer:create()
end)

function ProgressBar.create(isWrongStateShow)
    local totalIndex = #s_CorePlayManager.wordList
    local currentIndex = s_CorePlayManager.currentWordIndex

    -- system variate
    local main = ProgressBar.new()
    main:setContentSize(s_DESIGN_WIDTH, 10)

    local gap = 40
    local left = (s_DESIGN_WIDTH - (totalIndex-1)*gap)/2
    
    -- new code
    local imageNameList = {}
    for i = 1, currentIndex - 1 do
        imageNameList[i] = "image/ProgressBar/yellow_middle.png"
        if isWrongStateShow and s_CorePlayManager.answerStateRecord[i] == 0 then
            imageNameList[i] = "image/ProgressBar/red_middle.png"
        end
    end
    for i = currentIndex, totalIndex do
        imageNameList[i] = "image/ProgressBar/blue_middle.png"  
    end
    
    if totalIndex > 1 then
        if imageNameList[1] == "image/ProgressBar/yellow_middle.png" then
            imageNameList[1] = "image/ProgressBar/yellow_left.png"
        else if imageNameList[1] == "image/ProgressBar/red_middle.png" then
            imageNameList[1] = "image/ProgressBar/red_left.png"
        else
            imageNameList[1] = "image/ProgressBar/blue_left.png"
        end
        end
--        
        if imageNameList[totalIndex] == "image/ProgressBar/yellow_middle.png" then
            imageNameList[totalIndex] = "image/ProgressBar/yellow_right.png"
        else if imageNameList[totalIndex] == "image/ProgressBar/red_middle.png" then
            imageNameList[totalIndex] = "image/ProgressBar/red_right.png"
        else
            imageNameList[totalIndex] = "image/ProgressBar/blue_right.png"
        end
        end
    end
    
    local frame = nil
    for i = 1, totalIndex do
        local node = cc.Sprite:create(imageNameList[i])
        node:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
        main:addChild(node)
        
        if i == currentIndex then
            frame = cc.Sprite:create("image/ProgressBar/frame_middle.png")
            if totalIndex > 1 then
                if currentIndex == 1 then
                    frame = cc.Sprite:create("image/ProgressBar/frame_left.png")
                else if currentIndex == totalIndex then
                    frame = cc.Sprite:create("image/ProgressBar/frame_right.png")
                end
                end
            end
            frame:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
            main:addChild(frame)
        end
    end
    
    local fadeOut = cc.FadeOut:create(0.5)
    local fadeIn = cc.FadeIn:create(0.5)
    local sequence = cc.Sequence:create(fadeOut, fadeIn)
    frame:runAction(cc.RepeatForever:create(sequence))
    

    -- add right and wrong animation
    main.rightStyle = function()
        local name = nil
        if imageNameList[currentIndex] == "image/ProgressBar/blue_left.png" then
            name = "image/ProgressBar/yellow_left.png"
        else if imageNameList[currentIndex] == "image/ProgressBar/blue_middle.png" then
            name = "image/ProgressBar/yellow_middle.png"
        else
            name = "image/ProgressBar/yellow_right.png"
        end   
        end
        local block = cc.Sprite:create(name)
        block:setPosition(frame:getPosition())
        block:setOpacity(0)
        main:addChild(block)
        
        local action = cc.FadeIn:create(0.5)
        block:runAction(action)
        
        local right = sp.SkeletonAnimation:create("res/spine/huadanci_jindutiao_public_wright.json", "res/spine/huadanci_jindutiao_public_wright.atlas", 1)
        right:setPosition(frame:getPosition())
        main:addChild(right)
        right:addAnimation(0, 'animation', false)
        
        main:removeChild(frame,true)
    end
    
    main.wrongStyle = function()
        local name = nil
        if imageNameList[currentIndex] == "image/ProgressBar/blue_left.png" then
            name = "image/ProgressBar/red_left.png"
        else if imageNameList[currentIndex] == "image/ProgressBar/blue_middle.png" then
            name = "image/ProgressBar/red_middle.png"
        else
            name = "image/ProgressBar/red_right.png"
        end   
        end
        local block = cc.Sprite:create(name)
        block:setPosition(frame:getPosition())
        block:setOpacity(0)
        main:addChild(block)

        local action = cc.FadeIn:create(0.5)
        block:runAction(action)
        
        local wrong = sp.SkeletonAnimation:create("res/spine/huadanci_jindutiao_public_wrong.json", "res/spine/huadanci_jindutiao_public_wrong.atlas", 1)
        wrong:setPosition(frame:getPosition())
        main:addChild(wrong)
        wrong:addAnimation(0, 'animation', false)
        
        frame:setVisible(false)
    end
    
    return main
end


return ProgressBar







