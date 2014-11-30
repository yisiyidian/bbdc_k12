require("common.global")

local TestAlter = class("TestAlter", function()
    return cc.Layer:create()
end)

local showDetailInfo
local showGirlAndStar

local main = nil
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local button_goon_clicked_mark = 0

function TestAlter.createFromFirstAlter()
    
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false) 
    
    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(false)
        s_SCENE.popupLayer.isOtherAlter = true
    end

    local isTested = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentSelectedChapterKey, s_CURRENT_USER.currentSelectedLevelKey).isTested
    if isTested == 0 then
        s_CorePlayManager.recordWordProciency()
    end
    
    showGirlAndStar()
    button_goon_clicked_mark = 0
    
    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)
    
    return main
end

function TestAlter.createFromSecondAlter()
    main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(false)
        s_SCENE.popupLayer.isOtherAlter = true
    end

    showDetailInfo()
    
    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)
    
    return main
end


showGirlAndStar = function()
    local back = cc.Sprite:create("image/alter/testscene_resultlist_back_long.png")
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
--    s_SCENE:popup(back)
    main:addChild(back)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local rightCount = 0
    local starCount = nil
    for i = 1, #s_CorePlayManager.answerStateRecord do
        rightCount = rightCount + s_CorePlayManager.answerStateRecord[i]
    end

    local star1 = s_DATA_MANAGER.starRules[#s_CorePlayManager.wordList]["star_1"]
    local star2 = s_DATA_MANAGER.starRules[#s_CorePlayManager.wordList]["star_2"]
    local star3 = s_DATA_MANAGER.starRules[#s_CorePlayManager.wordList]["star_3"]

    print(rightCount.." "..star1..star2..star3)

    if rightCount >= star3 then
        starCount = 3
    elseif rightCount >= star2 then
        starCount = 2
    elseif rightCount >= star1 then
        starCount = 1
    else
        starCount = 0
    end    
    
    if starCount > 0 then
        local girl = sp.SkeletonAnimation:create("res/spine/bb_happy_public.json", "res/spine/bb_happy_public.atlas", 1)
        girl:setPosition(50,100)
        back:addChild(girl)      
        girl:addAnimation(0, 'animation', true)
    else
        local girl = sp.SkeletonAnimation:create("res/spine/bb_unhappy_public.json", "res/spine/bb_unhappy_public.atlas", 1)
        girl:setPosition(50,100)
        back:addChild(girl)      
        girl:addAnimation(0, 'animation', true)
    end
    
    -- add star
    local showStar = function()
        local stars = sp.SkeletonAnimation:create("res/spine/star_yellow_3_public.json", "res/spine/star_yellow_3_public.atlas", 1)
        stars:setPosition(back:getContentSize().width/2, 700)
        back:addChild(stars)
        
        if starCount == 3 then
            stars:addAnimation(0, 'animation_3_star', false)
        elseif starCount == 2 then
            stars:addAnimation(0, 'animation_2_star', false)
        elseif starCount == 1 then
            stars:addAnimation(0, 'animation_1_star', false)
        else
            stars:addAnimation(0, 'animation_no_star', false)
        end 
        
        s_CorePlayManager.currentScore = starCount
        s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey, s_CURRENT_USER.currentSelectedLevelKey, starCount)
        
        --star sound
        if starCount > 0 then
           playSound(s_sound_star1)
           if starCount > 1 then
               s_SCENE:callFuncWithDelay(0.3,function()
               playSound(s_sound_star2)
               end)
               if starCount > 2 then
                    s_SCENE:callFuncWithDelay(0.6,function()
                        playSound(s_sound_star3)
                    end)
               end
           end
        end 
    end
    
    local action1 = cc.DelayTime:create(0.5)
    local action2 = cc.CallFunc:create(showStar)
    local action3 = cc.Sequence:create(action1, action2)
    back:runAction(action3)
    
    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended and button_goon_clicked_mark == 0 then
        s_SCENE.popupLayer.isOtherAlter = false
            local removeFirstAlter = function()
                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2*3))
                local action2 = cc.EaseBackIn:create(action1)
                back:runAction(action2)
            end
            
            local action1 = cc.CallFunc:create(removeFirstAlter)
            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(showDetailInfo)
            local action4 = cc.Sequence:create(action1, action2 , action3)
            main:runAction(action4)   
          
            button_goon_clicked_mark = 1
            -- button sound
            playSound(s_sound_buttonEffect)
        end
    end

    local button_goon = ccui.Button:create("image/button/studyscene_blue_button.png", "image/button/studyscene_blue_button.png")
    button_goon:setPosition(380,200)
    button_goon:setTitleText("继续")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)
end

showDetailInfo = function()
    local back = cc.Sprite:create("image/alter/testscene_resultlist_back_long.png")
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)
    
    s_SCENE.popupLayer.isOtherAlter = true
    
    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local selectWordBack = cc.Sprite:create("image/alter/testscene_selectword_back.png")
    selectWordBack:setPosition(277,764)
    back:addChild(selectWordBack)
    
    local content = s_WordPool[s_CorePlayManager.wordList[1]].wordMeaningSmall
    local selectWordMeaning = cc.Label:createWithSystemFont(content,"",28)
    selectWordMeaning:setColor(cc.c4b(0,0,0,255))
    selectWordMeaning:setPosition(selectWordBack:getContentSize().width/2, selectWordBack:getContentSize().height/2)
    selectWordBack:addChild(selectWordMeaning)
    
    local button_array = {}
    local lastSelectIndex = nil
    local showSelectWordInfo = function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            selectWordMeaning:setString(s_WordPool[s_CorePlayManager.wordList[sender.tag]].wordMeaningSmall)
            
            if button_array[lastSelectIndex].name == "right" then
                button_array[lastSelectIndex]:loadTextures("image/alter/testscene_rightword_back_light.png", "", "")
            else
                button_array[lastSelectIndex]:loadTextures("image/alter/testscene_wrongword_back_light.png", "", "")
            end
            
            if sender.name == "right" then
                sender:loadTextures("image/alter/testscene_rightword_back_dark.png", "", "")
            else
                sender:loadTextures("image/alter/testscene_wrongword_back_dark.png", "", "")
            end
            
            lastSelectIndex = sender.tag
        end
    end
    
    local right_num = 0
    local wrong_num = 0
    for i = 1, 5 do
        for j = 1, 3 do
            local index = 3*i + j - 3
            if index <= #s_CorePlayManager.wordList then
                local word_back = nil
                if s_CorePlayManager.answerStateRecord[index] == 1 then
                    word_back = ccui.Button:create("image/alter/testscene_rightword_back_light.png", "image/alter/testscene_rightword_back_light.png")
                    word_back.name = "right"
                    right_num = right_num + 1
                else
                    if lastSelectIndex == nil then
                        lastSelectIndex = index
                    end
                    word_back = ccui.Button:create("image/alter/testscene_wrongword_back_light.png", "image/alter/testscene_wrongword_back_light.png")
                    word_back.name = "wrong"
                    wrong_num = wrong_num + 1
                end
                word_back:setPosition(116+160*(j-1), 676-78*(i-1))
                word_back:setTitleText(s_CorePlayManager.wordList[index])
                word_back:setTitleColor(cc.c4b(255,255,255,255))
                word_back:setTitleFontSize(28)
                word_back:addTouchEventListener(showSelectWordInfo)
                word_back.tag = index
                button_array[index] = word_back
                back:addChild(word_back)
            end
        end
    end
    if lastSelectIndex == nil then
        lastSelectIndex = 1
    end
    showSelectWordInfo(button_array[lastSelectIndex], ccui.TouchEventType.ended)
    
    local button_replayall_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.leaveTestLayer_replay()
            s_SCENE.popupLayer.isOtherAlter = false
            -- button sound
            playSound(s_sound_buttonEffect)
        end
    end
    
    local button_replaywrong_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE.popupLayer.isOtherAlter = false
            s_CorePlayManager.generateWrongWordList()
            s_CorePlayManager.enterStudyLayer()
            
            -- button sound
            playSound(s_sound_buttonEffect)
        end
    end
    
    local button_continue_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE.popupLayer.isOtherAlter = false
            s_CorePlayManager.leaveTestLayer()
            
            -- button sound
            playSound(s_sound_buttonEffect)
        end
    end
    
    local button_replayall = ccui.Button:create("image/button/button_blue_147x79.png", "image/button/button_blue_147x79.png")
    button_replayall:setPosition(112, 225)
    button_replayall:setTitleText("重新玩")
    button_replayall:setTitleColor(cc.c4b(255,255,255,255))
    button_replayall:setTitleFontSize(28)
    button_replayall:addTouchEventListener(button_replayall_clicked)
    button_replayall:setVisible(false)
    back:addChild(button_replayall)
    
    local button_replaywrong = ccui.Button:create("image/button/button_blue_147x79.png", "image/button/button_blue_147x79.png")
    button_replaywrong:setPosition(275, 225)
    button_replaywrong:setTitleText("玩错词")
    button_replaywrong:setTitleColor(cc.c4b(255,255,255,255))
    button_replaywrong:setTitleFontSize(28)
    button_replaywrong:addTouchEventListener(button_replaywrong_clicked)
    button_replaywrong:setVisible(false)
    back:addChild(button_replaywrong)
    
    local button_continue = ccui.Button:create("image/button/button_blue_147x79.png", "image/button/button_blue_147x79.png")
    button_continue:setPosition(436, 225)
    button_continue:setTitleText("继续玩")
    button_continue:setTitleColor(cc.c4b(255,255,255,255))
    button_continue:setTitleFontSize(28)
    button_continue:addTouchEventListener(button_continue_clicked)
    button_continue:setVisible(false)
    back:addChild(button_continue)
    
    if s_CorePlayManager.replayWrongWordState then
        if s_CorePlayManager.buttonListState == 1 then
            button_replayall:setVisible(true)
            button_continue:setVisible(true)
            button_replayall:setPositionX(178)
            button_continue:setPositionX(370)
        elseif s_CorePlayManager.buttonListState == 2 then
            -- no this situation
        elseif s_CorePlayManager.buttonListState == 3 then
            button_replayall:setVisible(true)
            button_replayall:setPositionX(275)
        elseif s_CorePlayManager.buttonListState == 4 then
            -- no this situation
        elseif s_CorePlayManager.buttonListState == 5 then
            button_continue:setVisible(true)
            button_continue:setPositionX(275)
        elseif s_CorePlayManager.buttonListState == 6 then
            -- no this situation
        elseif s_CorePlayManager.buttonListState == 7 then
            button_replayall:setVisible(true)
            button_replayall:setPositionX(275)
        elseif s_CorePlayManager.buttonListState == 8 then
            -- no this situation
        end
    else
        local isPassed = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentSelectedChapterKey, s_CURRENT_USER.currentSelectedLevelKey).isPassed
        if isPassed then
            if s_CorePlayManager.currentScore > 0 then
                if wrong_num > 0 then
                    button_replayall:setVisible(true)
                    button_replaywrong:setVisible(true)
                    button_continue:setVisible(true)
                    s_CorePlayManager.buttonListState = 1
                else
                    button_replayall:setVisible(true)
                    button_continue:setVisible(true)
                    button_replayall:setPositionX(178)
                    button_continue:setPositionX(370)
                    s_CorePlayManager.buttonListState = 2
                end
            else
                if wrong_num > 0 then
                    button_replayall:setVisible(true)
                    button_replaywrong:setVisible(true)
                    button_replayall:setPositionX(178)
                    button_replaywrong:setPositionX(370)
                    s_CorePlayManager.buttonListState = 3
                else
                    -- no this situation
                    s_CorePlayManager.buttonListState = 4
                end
            end
        else
            if s_CorePlayManager.currentScore > 0 then
                if wrong_num > 0 then                    
                    button_replaywrong:setVisible(true)
                    button_continue:setVisible(true)
                    button_replaywrong:setPositionX(178)
                    button_continue:setPositionX(370)
                    s_CorePlayManager.buttonListState = 5
                else
                    button_continue:setVisible(true)
                    button_continue:setPositionX(275)
                    s_CorePlayManager.buttonListState = 6
                end
            else
                if wrong_num > 0 then
                    button_replayall:setVisible(true)
                    button_replaywrong:setVisible(true)
                    button_replayall:setPositionX(178)
                    button_replaywrong:setPositionX(370)
                    s_CorePlayManager.buttonListState = 7
                else
                    -- no this situation
                    s_CorePlayManager.buttonListState = 8
                end
            end
        end
    end
end

return TestAlter







