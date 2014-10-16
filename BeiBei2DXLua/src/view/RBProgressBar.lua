

local RBProgressBar = class("RBProgressBar", function()
    return cc.Layer:create()
end)

function RBProgressBar.create(totalIndex)
    
    local main = RBProgressBar.new()
    main:setContentSize(s_DESIGN_WIDTH, 10)
    main:ignoreAnchorPointForPosition(false)
    main:setAnchorPoint(0.5,0.5)
    
    local local_size = main:getContentSize()
    
    local currentIndex = 1
    
    -- init framework
    local progress_back = cc.Sprite:create("image/progress/rb_progressBack.png")
    progress_back:setPosition(local_size.width/2, local_size.height/2)
    main:addChild(progress_back)

    local progress = cc.ProgressTimer:create(cc.Sprite:create("image/progress/rb_progressFront.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(100*(currentIndex-1)/totalIndex)
    main:addChild(progress)
    
    local left = (local_size.width - progress_back:getContentSize().width) / 2
    local gap = progress_back:getContentSize().width / totalIndex
    
    local index = cc.Sprite:create("image/progress/rb_progressIndex.png")
    index:setAnchorPoint(0.5,1)
    index:setPosition(left + gap* (currentIndex - 1), 0)
    main:addChild(index)

    local label_number = cc.Label:createWithSystemFont(currentIndex,"",24)
    label_number:setColor(cc.c4b(255,255,255,255))
    label_number:setPosition(index:getContentSize().width/2, index:getContentSize().height*0.4)
    index:addChild(label_number)

    
    -- add addOne animation
    main.addOne = function()
        currentIndex = currentIndex + 1
        
        label_number:setString(currentIndex)
        
        local action1 = cc.MoveTo:create(0.5,cc.p(left + gap* (currentIndex - 1), 0))
        index:runAction(action1)
        --index:setPosition(left + gap* (currentIndex - 1), 0)
    
        local scrPercent = progress:getPercentage()
        local dstPercent = 100*(currentIndex-1)/totalIndex
        local gap = (dstPercent - scrPercent)/50     
        
        local scheduler = nil
        local schedulerEntry = nil
        
        local add = function()
            progress:setPercentage(progress:getPercentage() + gap)
            if progress:getPercentage() >= dstPercent then
                scheduler:unscheduleScriptEntry(schedulerEntry)
            end
        end
    
        scheduler = cc.Director:getInstance():getScheduler()
        
        schedulerEntry = scheduler:scheduleScriptFunc(add, 0.01, false)
        
        --progress:setPercentage(100*(currentIndex-1)/totalIndex)
    end

    return main
end

return RBProgressBar