local GuideLine = class("GuideLine", function()
    return cc.Sprite:create()
end)

function GuideLine:createLayer(oldLayer)  
    local main = cc.Layer:create()
    local main_width = oldLayer:getContentSize().width
    local main_height = oldLayer:getContentSize().height
    main:setContentSize(main_width, main_height)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)
end

function GuideLine.create(color)
    local line = cc.Sprite:create("image/guideline/line_light_study.png")
    line:setAnchorPoint(0.5,0.5)
    line:ignoreAnchorPointForPosition(false)
    
    if color == "dark" then
    	line:setTexture("image/guideline/line_dark_study.png")
    end

    return line
end

return GuideLine