local ProgressBar = class("ProgressBar", function()
    return cc.Layer:create()
end)

function ProgressBar.create(totalIndex, currentIndex)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backImageName     = "image/islandPopup/subtask_progress_bar_bg.png"
    local frontImageName    = "image/islandPopup/subtask_progress_bar_rectangle.png"
    local indexImageName    = "image/islandPopup/subtask_progress_bar_beibei_present.png"

    local main = ProgressBar.new()
    main:setContentSize(s_DESIGN_WIDTH, 10)
    main:ignoreAnchorPointForPosition(false)
    main:setAnchorPoint(0.5,0.5)

    local local_size = main:getContentSize()

    -- init framework
    local progress_back = cc.Sprite:create(backImageName)
    progress_back:setPosition(local_size.width/2, local_size.height/2)
    main:addChild(progress_back)

    local progress = cc.ProgressTimer:create(cc.Sprite:create(frontImageName))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(100*currentIndex/totalIndex)
    main:addChild(progress)

    local left = (local_size.width - progress_back:getContentSize().width) / 2
    local gap = progress_back:getContentSize().width / totalIndex

    local index = cc.Sprite:create(indexImageName)
    index:setAnchorPoint(0.5,0)
    index:setPosition(left + gap*currentIndex, 0)
    main:addChild(index)

    for i=1,totalIndex do
        local point_sprite = cc.Sprite:create(indexImageName)
        point_sprite:setAnchorPoint(0.5,0.5)
        point_sprite:setPosition(left + gap*currentIndex, 0)
        main:addChild(index)
    end  
    
    main.swell = function ()
    	local action1 = cc.ScaleTo:create(0.5,1.2)
    	local action2 = cc.ScaleTo:create(0.5,1)
    	index:runAction(cc.Sequence:create(action1,action2))
    end

    main.addOne = function()
        currentIndex = currentIndex + 1
        label_number:setString(currentIndex)
        local action1 = cc.MoveTo:create(0.2,cc.p(left + gap* (currentIndex), 0))
        index:runAction(action1)
        local action2 = cc.ProgressTo:create(0.2, 100*(currentIndex)/totalIndex)
        progress:runAction(action2)
    end

    return main
end

return ProgressBar