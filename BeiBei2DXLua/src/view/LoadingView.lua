require("common.DynamicUpdate")

local LoadingView = class ("LoadingView", function()
    return cc.Layer:create()
end)



function LoadingView.create()
    
    local layer = LoadingView.new()
    
    local background = cc.Sprite:create('image/loading/loading_little_girl_background.png')
    
    background:ignoreAnchorPointForPosition(false)
    background:setAnchorPoint(0,0.5)
    background:setPosition(s_LEFT_X  , s_DESIGN_HEIGHT / 2 )
    layer:addChild(background)

    local leaf = cc.Sprite:create('image/loading/loading-little-girl-leaf.png')
    leaf:ignoreAnchorPointForPosition(false)
    leaf:setAnchorPoint(0.5,0.5)
    leaf:setPosition(background:getContentSize().width * 0.4 ,background:getContentSize().height * 0.66)    
    background:addChild(leaf)

    local sleep_girl = sp.SkeletonAnimation:create('spine/loading-little-girl.json','spine/loading-little-girl.atlas',1) 
    sleep_girl:setAnimation(0,'animation',true)
    sleep_girl:ignoreAnchorPointForPosition(false)
    sleep_girl:setAnchorPoint(0.5,0.5)
    sleep_girl:setPosition(leaf:getContentSize().width * 0.2 ,leaf:getContentSize().height * 0.3)    
    leaf:addChild(sleep_girl)
    
    local updateInfoLabel =DynamicUpdate.initUpdateLabel()
    layer:addChild(updateInfoLabel,1000)
    DynamicUpdate.beginLoginUpdate(updateInfoLabel)
    
    return layer
end

return LoadingView