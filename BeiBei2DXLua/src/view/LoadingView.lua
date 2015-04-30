--Loading界面
--只是做个loading效果，没有loading任何东西
local LoadingView = class ("LoadingView", function()
    return cc.Layer:create()
end)

function LoadingView.create()
    local layer = LoadingView.new()
    
    local background = cc.Sprite:create('image/loading/loading_little_girl_background.png')
    
    background:ignoreAnchorPointForPosition(false)
    background:setAnchorPoint(0.5,0.5)
    background:setPosition(s_DESIGN_WIDTH / 2  , s_DESIGN_HEIGHT / 2 )
    layer:addChild(background)

    local leaf = cc.Sprite:create('image/loading/loading-little-girl-leaf.png')
    leaf:ignoreAnchorPointForPosition(false)
    leaf:setAnchorPoint(0.5,0.5)
    leaf:setPosition(background:getContentSize().width * 0.45 ,background:getContentSize().height * 0.66)    
    background:addChild(leaf)

    local sleep_girl = sp.SkeletonAnimation:create('spine/loading-little-girl.json','spine/loading-little-girl.atlas',1) 
    sleep_girl:setAnimation(0,'animation',true)
    sleep_girl:ignoreAnchorPointForPosition(false)
    sleep_girl:setAnchorPoint(0.5,0.5)
    sleep_girl:setPosition(leaf:getContentSize().width * 0.2 ,leaf:getContentSize().height * 0.3)    
    leaf:addChild(sleep_girl)
    
    local backCircle = cc.Sprite:create("image/loading/loadingbegin.png")
    backCircle:setPosition(background:getContentSize().width / 2,background:getContentSize().height / 2)
    background:addChild(backCircle)

    local runProgress = cc.ProgressTo:create(0.2,93)

    local progressCircle = cc.ProgressTimer:create(cc.Sprite:create("image/loading/loadingend.png"))
    progressCircle:setPosition(backCircle:getContentSize().width / 2 ,backCircle:getContentSize().height / 2)
    progressCircle:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progressCircle:setReverseDirection(false)
    progressCircle:setPercentage(0)
    progressCircle:runAction(runProgress)
    backCircle:addChild(progressCircle)

    local progressText = cc.Label:createWithSystemFont("","",30)
    progressText:setColor(cc.c4b(0,0,0,255))
    progressText:setPosition(backCircle:getContentSize().width / 2 ,backCircle:getContentSize().height / 2)
    backCircle:addChild(progressText)

    local seed = math.randomseed(os.time())
    local randomNum = math.random(1,5)

    local hint = cc.Sprite:create("image/loading/loading"..randomNum..".png")
    hint:setPosition(background:getContentSize().width / 2,80)
    background:addChild(hint)

    local time = 0

    local function update(delta)
        time = time + delta
        if time > 10 then
            time = 0
            seed = math.randomseed(os.time())
            randomNum = math.random(1,5)
            hint:setTexture("image/loading/loading"..randomNum..".png")
        end
        local per = '%'
        local str = string.format("%d%s",progressCircle:getPercentage()  * 99 / 93,per)
        progressText:setString(str)
    end
    layer:scheduleUpdateWithPriorityLua(update, 0)
    
    return layer
end

return LoadingView