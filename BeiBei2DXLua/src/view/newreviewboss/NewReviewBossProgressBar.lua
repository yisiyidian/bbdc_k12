local NewReviewBossProgressBar = class("NewReviewBossProgressBar", function()
    return cc.Layer:create()
end)

function NewReviewBossProgressBar.create(totalIndex, color)

    local pngColor          = color
    local backImageName     = "image/progress/rb_progressBack_"..pngColor..".png"
    local frontImageName    = "image/progress/rb_progressFront_"..pngColor..".png"
    local indexImageName    = "image/progress/rb_progressIndex_"..pngColor..".png"

    local main = NewReviewBossProgressBar.new()
    main:setContentSize(s_DESIGN_WIDTH, 10)
    main:ignoreAnchorPointForPosition(false)
    main:setAnchorPoint(0.5,0.5)

    local local_size = main:getContentSize()

    local currentIndex = 1

    -- init framework
    local progress_back = cc.Sprite:create(backImageName)
    progress_back:setPosition(local_size.width/2, local_size.height/2)
    main:addChild(progress_back)

    local progress = cc.ProgressTimer:create(cc.Sprite:create(frontImageName))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(100*(currentIndex-1)/totalIndex)
    main:addChild(progress)

    local left = (local_size.width - progress_back:getContentSize().width) / 2
    local gap = progress_back:getContentSize().width / totalIndex

    local index = cc.Sprite:create(indexImageName)
    index:setAnchorPoint(0.5,1)
    index:setPosition(left + gap* (currentIndex - 1), 0)
    main:addChild(index)

    local label_number = cc.Label:createWithSystemFont(currentIndex-1,"",24)
    label_number:setColor(cc.c4b(255,255,255,255))
    label_number:setPosition(index:getContentSize().width/2, index:getContentSize().height*0.4)
    index:addChild(label_number)


    -- add addOne animation
    main.addOne = function()
        currentIndex = currentIndex + 1

        label_number:setString(currentIndex-1)

        local action1 = cc.MoveTo:create(0.5,cc.p(left + gap* (currentIndex - 1), 0))
        index:runAction(action1)

        local action2 = cc.ProgressTo:create(0.5, 100*(currentIndex-1)/totalIndex)
        progress:runAction(action2)
    end



    return main
end

return NewReviewBossProgressBar