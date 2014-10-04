

local ProgressBar = class("ProgressBar", function()
return cc.Layer:create()
end)

function ProgressBar.create(totalIndex, currentIndex)
    -- system variate
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local main = ProgressBar.new()
    main:setContentSize(size.width, 10)

    local gap = 40
    local left = (size.width - (totalIndex-1)*gap)/2

    local frame

    if totalIndex == 1 then
        local node = cc.Sprite:create("image/ProgressBar/blue_middle.png")
        node:setPosition(main:getContentSize().width/2, main:getContentSize().height/2)
        main:addChild(node)

        frame = cc.Sprite:create("image/ProgressBar/frame_middle.png")
        frame:setPosition(main:getContentSize().width/2, main:getContentSize().height/2)
    elseif totalIndex == 2 then
        for i = 1, totalIndex do
            local node
            if i == 1 then
                if i < currentIndex then
                node = cc.Sprite:create("image/ProgressBar/yellow_left.png")
                else
                node = cc.Sprite:create("image/ProgressBar/blue_left.png")
                end

                if i == currentIndex then
                    frame = cc.Sprite:create("image/ProgressBar/frame_left.png")
                    frame:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
                end
            else
                if i < currentIndex then
                node = cc.Sprite:create("image/ProgressBar/yellow_right.png")
                else
                node = cc.Sprite:create("image/ProgressBar/blue_right.png")
                end

                if i == currentIndex then
                    frame = cc.Sprite:create("image/ProgressBar/frame_right.png")
                    frame:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
                end
            end
            node:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
            main:addChild(node)
        end
    else
        for i = 1, totalIndex do
            local node
            if i == 1 then
                if i < currentIndex then
                    node = cc.Sprite:create("image/ProgressBar/yellow_left.png")
                else
                    node = cc.Sprite:create("image/ProgressBar/blue_left.png")
                end

                if i == currentIndex then
                    frame = cc.Sprite:create("image/ProgressBar/frame_left.png")
                    frame:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
                end
            elseif i == totalIndex then
                if i < currentIndex then
                    node = cc.Sprite:create("image/ProgressBar/yellow_right.png")
                else
                    node = cc.Sprite:create("image/ProgressBar/blue_right.png")
                end

                if i == currentIndex then
                    frame = cc.Sprite:create("image/ProgressBar/frame_right.png")
                    frame:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
                end
            else
                if i < currentIndex then
                    node = cc.Sprite:create("image/ProgressBar/yellow_middle.png")
                else
                    node = cc.Sprite:create("image/ProgressBar/blue_middle.png")
                end

                if i == currentIndex then
                    frame = cc.Sprite:create("image/ProgressBar/frame_middle.png")
                    frame:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
                end
            end
            node:setPosition(left+(i-1)*gap, main:getContentSize().height/2)
            main:addChild(node)
        end
    end

    main:addChild(frame)

    -- add animation
    local fadeOut = cc.FadeOut:create(0.5)
    local fadeIn = cc.FadeIn:create(0.5)
    local sequence = cc.Sequence:create(fadeOut, fadeIn)
    frame:runAction(cc.RepeatForever:create(sequence))

    return main
end


return ProgressBar







