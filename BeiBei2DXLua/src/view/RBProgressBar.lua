

local RBProgressBar = class("RBProgressBar", function()
    return cc.Layer:create()
end)

function RBProgressBar.create(totalIndex)
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    
    local main = RBProgressBar.new()
    main:setContentSize(size.width, 10)

    -- init framework
    -- TODO

    -- add addOne animation
    main.addOne = function()
        -- TODO
    end

    return main
end

return RBProgressBar