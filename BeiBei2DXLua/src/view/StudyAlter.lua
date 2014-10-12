require("common.global")

local StudyAlter = class("StudyAlter", function()
    return cc.Layer:create()
end)

function StudyAlter.create()
    -- system variate
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),size.width,size.height)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    local back = cc.Sprite:create("image/alter/studyscene_summary_back.png")
    back:setPosition(size.width/2, size.height/2)
    main:addChild(back)
    
    
    for i = 1, 7 do
        for j = 1, 2 do
            local index = 2*i + j - 2
            if index <= #s_CorePlayManager.wordList then
                local label_word = cc.Label:createWithSystemFont(s_CorePlayManager.wordList[index],"",35)
                label_word:setColor(cc.c4b(0,0,0,255))
                label_word:setPosition(back:getContentSize().width*(0.5*j-0.25), back:getContentSize().height*(0.775-0.083*(i-1)))
                back:addChild(label_word)
            end
        end
    end
    
    local button_left_clicked = function ()
    	
    end
    
    local button_left = ccui.Button:create("image/button/studyscene_blue_button.png")
    button_left:setPosition(140,150)
    button_left:setTitleText("重学")
    button_left:setTitleFontSize(30)
    button_left:addTouchEventListener(button_left_clicked)
    back:addChild(button_left)
    
    local button_right_clicked = function ()

    end

    local button_right = ccui.Button:create("image/button/studyscene_blue_button.png")
    button_right:setPosition(400,150)
    button_right:setTitleText("考试")
    button_right:setTitleFontSize(30)
    button_right:addTouchEventListener(button_right_clicked)
    back:addChild(button_right)

    return main    
end


return StudyAlter







