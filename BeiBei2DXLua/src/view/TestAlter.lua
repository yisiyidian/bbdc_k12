require("common.global")

local TestAlter = class("TestAlter", function()
    return cc.Layer:create()
end)

local showDetailInfo
local showGirlAndStar
local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

local main = cc.LayerColor:create(cc.c4b(0,0,0,100),size.width,size.height)
main:setAnchorPoint(0.5,0.5)
main:ignoreAnchorPointForPosition(false)

function TestAlter.createFromFirstAlter()  
    showGirlAndStar()
    return main
end

function TestAlter.createFromSecondAlter()
    showDetailInfo()
    return main
end


showGirlAndStar = function()
    local back = cc.Sprite:create("image/alter/testscene_resultlist_back_long.png")
    back:setPosition(size.width/2, size.height/2)
    main:addChild(back)

    local button_goon_clicked = function ()
        
    end

    local button_goon = ccui.Button:create("image/button/studyscene_blue_button.png")
    button_goon:setPosition(380,200)
    button_goon:setTitleText("继续")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)
end

showDetailInfo = function()
    local back = cc.Sprite:create("image/alter/testscene_resultlist_back_long.png")
    back:setPosition(size.width/2, size.height/2)
    main:addChild(back)

    local selectWordBack = cc.Sprite:create("image/alter/testscene_selectword_back.png")
    selectWordBack:setPosition(277,764)
    back:addChild(selectWordBack)
    
    local content = s_WordPool[s_CorePlayManager.wordList[1]].wordMeaningSmall
    local selectWordMeaning = cc.Label:createWithSystemFont(content,"",28)
    selectWordMeaning:setColor(cc.c4b(0,0,0,255))
    selectWordMeaning:setPosition(selectWordBack:getContentSize().width/2, selectWordBack:getContentSize().height/2)
    selectWordBack:addChild(selectWordMeaning)
    
    local showSelectWordInfo = function(sender,eventType)
        if eventType == ccui.TouchEventType.began then            
            selectWordMeaning:setString(s_WordPool[s_CorePlayManager.wordList[sender.tag]].wordMeaningSmall)
        end
    end
    
    local button_array = {}
    
    for i = 1, 5 do 
        for j = 1, 3 do
            local index = 3*i + j - 3
            if index <= #s_CorePlayManager.wordList then
                local word_back = ccui.Button:create("image/alter/testscene_rightword_back_light.png")
                word_back:setPosition(116+160*(j-1), 676-78*(i-1))
                word_back:setTitleText(s_CorePlayManager.wordList[index])
                word_back:setTitleColor(cc.c4b(0,0,0,255))
                word_back:setTitleFontSize(28)
                word_back:addTouchEventListener(showSelectWordInfo)
                word_back.tag = index
                button_array[index] = word_back
                back:addChild(word_back)
            end
        end
    end
    
    local button_left = ccui.Button:create("image/button/button_blue_147x79.png")
    button_left:setPosition(112, 225)
    button_left:setTitleText("重新玩")
    button_left:setTitleColor(cc.c4b(0,0,0,255))
    button_left:setTitleFontSize(28)
    back:addChild(button_left)
    
    local button_middle = ccui.Button:create("image/button/button_blue_147x79.png")
    button_middle:setPosition(275, 225)
    button_middle:setTitleText("玩错词")
    button_middle:setTitleColor(cc.c4b(0,0,0,255))
    button_middle:setTitleFontSize(28)
    back:addChild(button_middle)
    
    local button_right = ccui.Button:create("image/button/button_blue_147x79.png")
    button_right:setPosition(436, 225)
    button_right:setTitleText("继续玩")
    button_right:setTitleColor(cc.c4b(0,0,0,255))
    button_right:setTitleFontSize(28)
    back:addChild(button_right)
end

return TestAlter







