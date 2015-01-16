require("cocos.init")
require("common.global")

local NewReviewBossNode = require("view.newreviewboss.NewReviewBossNode")
local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")
local Pause             = require("view.newreviewboss.NewReviewBossPause")


local  NewReviewBossMainLayer = class("NewReviewBossMainLayer", function ()
    return cc.Layer:create()
end)



function NewReviewBossMainLayer.create()
    AnalyticsFirst(ANALYTICS_FIRST_REVIEW_BOSS, 'SHOW')

    --pause music
    cc.SimpleAudioEngine:getInstance():pauseMusic()    

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = NewReviewBossMainLayer.new()

    -- word info
    local currentWordName   
    local currentWord      
    local wordname         
    local wordSoundMarkEn   
    local wordSoundMarkAm   
    local wordMeaningSmall 
    local wordMeaning      
    local sentenceEn        
    local sentenceCn        
    local sentenceEn2       
    local sentenceCn2    
    
    local type = s_CorePlayManager.typeIndex
    local answer
    
    local wordList = {}
    table.foreachi(s_CorePlayManager.ReviewWordList, function(i, v)
        if  s_CorePlayManager.ReviewWordList[i] ~= "" then
            table.insert(wordList,s_CorePlayManager.ReviewWordList[i] )
        end
    end) 
    local wordListLen = table.getn(wordList)
      
    local rbCurrentWordIndex = 1
    local wordToBeTested = {}
    local sprite_array = {}
    

    local getRandomWordForRightWord = function(wordName)

        local tmp =  {}            
        table.foreachi(wordList, function(i, v)  tmp[i] = wordList[i]  end)     
        local wordNumber
        table.foreachi(tmp, function(i, v) if v == wordName then  wordNumber = i end end)               

        local randomIndex = (wordNumber )%wordListLen + 1 
        local word1 = tmp[randomIndex]
        local randomIndex = (wordNumber + 1)%wordListLen + 1 
        local word2 = tmp[randomIndex]

        local rightIndex = math.random(1,1024)%3 + 1

        if type%2 == 0 then    
            local ans = {}
            ans[rightIndex] = wordName
            if rightIndex == 1 then  ans[2] = word1 ans[3] = word2
            elseif rightIndex == 2 then ans[3] = word1 ans[1] = word2
            else ans[1] = word1 ans[2] = word2        end
            return ans
        else
            local ans = {}
            ans[rightIndex]  = s_WordPool[wordName].wordMeaningSmall
            if rightIndex == 1 then  ans[2] = s_WordPool[word1].wordMeaningSmall ans[3] = s_WordPool[word2].wordMeaningSmall
            elseif rightIndex == 2 then ans[3] = s_WordPool[word1].wordMeaningSmall  ans[1] = s_WordPool[word2].wordMeaningSmall
            else ans[1] = s_WordPool[word1].wordMeaningSmall ans[2] = s_WordPool[word2].wordMeaningSmall    end
            return ans
        end
    end
    

    for i = 1,  wordListLen do   
        table.insert(wordToBeTested,wordList[i])
        local words = getRandomWordForRightWord(wordList[i])
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            if i == 1 then
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 200 + 200*(j-1), 850 - 200*i - 150))
                sprite.visible(true)
            elseif i == 2 then 
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 200*i - 150))
                sprite:setScale(0.8)
                sprite.visible(false)
            else
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 200*i - 150))
                sprite:setScale(0)
                sprite.visible(false)
            end
            layer:addChild(sprite,1)
            tmp[j] = sprite
        end
        sprite_array[i] = tmp
    end
    
    local checkTouchIndex = function(location)
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if cc.rectContainsPoint(sprite:getBoundingBox(), location) then
                    return {x=i, y=j}
                end
            end
        end
        return {x=-1, y=-1}
    end

    local updateWord = function ()
        local currentWordName   = wordToBeTested[rbCurrentWordIndex]
        local currentWord       = s_WordPool[currentWordName]
        local wordname          = currentWord.wordName
        local wordSoundMarkEn   = currentWord.wordSoundMarkEn
        local wordSoundMarkAm   = currentWord.wordSoundMarkAm
        local wordMeaningSmall  = currentWord.wordMeaningSmall
        local wordMeaning       = currentWord.wordMeaning
        local sentenceEn        = currentWord.sentenceEn
        local sentenceCn        = currentWord.sentenceCn
        local sentenceEn2       = currentWord.sentenceEn2
        local sentenceCn2       = currentWord.sentenceCn2
        return currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
            sentenceEn2,sentenceCn2
    end
    
    currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
            sentenceEn2,sentenceCn2 =  updateWord()

    local pauseButton = Pause.create()
    layer:addChild(pauseButton,100)
    
    local fillColor1 = cc.LayerColor:create(cc.c4b(10,152,210,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 393)
    fillColor1:setAnchorPoint(0.5,0)
    fillColor1:ignoreAnchorPointForPosition(false)
    fillColor1:setPosition(s_DESIGN_WIDTH/2,0)
    layer:addChild(fillColor1)

    local fillColor2 = cc.LayerColor:create(cc.c4b(26,169,227,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 614-393)
    fillColor2:setAnchorPoint(0.5,0)
    fillColor2:ignoreAnchorPointForPosition(false)
    fillColor2:setPosition(s_DESIGN_WIDTH/2,393)
    layer:addChild(fillColor2)

    local fillColor3 = cc.LayerColor:create(cc.c4b(36,186,248,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 811-614)
    fillColor3:setAnchorPoint(0.5,0)
    fillColor3:ignoreAnchorPointForPosition(false)
    fillColor3:setPosition(s_DESIGN_WIDTH/2,614)
    layer:addChild(fillColor3)

    local fillColor4 = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-811)
    fillColor4:setAnchorPoint(0.5,0)
    fillColor4:ignoreAnchorPointForPosition(false)
    fillColor4:setPosition(s_DESIGN_WIDTH/2,811)
    layer:addChild(fillColor4)

    local rbProgressBar = ProgressBar.create(wordListLen,s_CorePlayManager.rightReviewWordNum,"yellow")
    rbProgressBar:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.9)
    layer:addChild(rbProgressBar)
    
    local huge_word = cc.Label:createWithSystemFont(wordname,"",48)
    huge_word:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT * 0.8)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    layer:addChild(huge_word)
    
    if type % 2 == 0 then
        huge_word:setString(wordMeaningSmall)
    else
        huge_word:setString(wordname)
    end
    
    local rightWordFuntion = function ()
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,200))
                    local action2 = cc.ScaleTo:create(0.4, 0)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,200))
                    local action2 = cc.ScaleTo:create(0.4, 0.8)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex + 1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,200))
                    local action2 = cc.ScaleTo:create(0.4, 1)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(true)
                elseif i == rbCurrentWordIndex + 2 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,200))
                    local action2 = cc.ScaleTo:create(0.4, 0.8)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                else
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,200))
                    sprite:runAction(cc.Sequence:create(action0, action1))
                    sprite.visible(false)
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        s_CorePlayManager.updateRightReviewWordNum()
        currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
        sentenceEn2,sentenceCn2 = updateWord()
        if type % 2 == 0 then
            huge_word:setString(wordMeaningSmall)
        else
            huge_word:setString(wordname)
        end
    end
    
    local wrongWordFunction = function ()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        local action3 = cc.CallFunc:create(function()
            local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossFailPopup")
            local newReviewBossLayerChange = NewReviewBossLayerChange.create()
            s_SCENE:popup(newReviewBossLayerChange)
            end)
        layer:runAction(cc.Sequence:create(action1, action2,action3))

    end
    
    local hintWordFunction = function ()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        table.insert(wordToBeTested, wordname)
        local words = getRandomWordForRightWord(wordname)
        local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), index_y - 200))
            sprite:setScale(0.8)
            layer:addChild(sprite)
            tmp[j] = sprite
        end
        table.insert(sprite_array, tmp)
        if type % 2 == 0 then
            answer = wordToBeTested[rbCurrentWordIndex]
        else
            answer = s_WordPool[wordToBeTested[rbCurrentWordIndex]].wordMeaningSmall
        end
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then
                elseif i == rbCurrentWordIndex then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,-200))
                    local action2 = cc.ScaleTo:create(0.4, 0)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                elseif i == rbCurrentWordIndex + 1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,200))
                    local action2 = cc.ScaleTo:create(0.4, 1)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(true)
                elseif i == rbCurrentWordIndex + 2 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,200))
                    local action2 = cc.ScaleTo:create(0.4, 0.8)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                else
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,200))
                    sprite:runAction(cc.Sequence:create(action0, action1))
                    sprite.visible(false)                
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
        sentenceEn2,sentenceCn2 = updateWord()
        if type % 2 == 0 then
            huge_word:setString(wordMeaningSmall)
        else
            huge_word:setString(wordname)
        end
    end

    local hint_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveBy:create(0.4,cc.p(0,200))
            pauseButton:runAction(action1)
            local HintView = require("view.newreviewboss.NewReviewBossHintLayer")
            local hintView = HintView.create(currentWordName)
            layer:addChild(hintView,2)          
            hintView.close = function ()          
                hintView:removeFromParent()
                hintWordFunction()        
                local action2 = cc.MoveBy:create(0.4,cc.p(0,-200))
                pauseButton:runAction(action2)
            end   
        end
    end
    
    local hint_button = ccui.Button:create("image/newreviewboss/buttonreviewboss1nextend.png","","")
    hint_button:setScale9Enabled(true)
    hint_button:setPosition(s_DESIGN_WIDTH / 2, 100)
    hint_button:ignoreAnchorPointForPosition(false)
    hint_button:setAnchorPoint(0.5,0)
    hint_button:addTouchEventListener(hint_click)
    hint_button:setScale9Enabled(true)
    layer:addChild(hint_button) 

    local hint_label = cc.Label:createWithSystemFont("这是啥？","",36)
    hint_label:setPosition(hint_button:getContentSize().width * 0.5,hint_button:getContentSize().height * 0.5)
    hint_label:setColor(cc.c4b(255,255,255,255))
    hint_label:ignoreAnchorPointForPosition(false)
    hint_label:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_label)
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        local logic_location = checkTouchIndex(location)
        if logic_location.x == rbCurrentWordIndex then
            playSound(s_sound_buttonEffect)
            if type % 2 == 0 then
                answer = wordToBeTested[logic_location.x]
            else
                answer = s_WordPool[wordToBeTested[logic_location.x]].wordMeaningSmall
            end
            if answer == sprite_array[logic_location.x][logic_location.y].character then
                sprite_array[logic_location.x][logic_location.y].right()
                
                local x = rbProgressBar:getPos()
                
                local position_X,position_Y = sprite_array[logic_location.x][logic_location.y]:getPosition()
                local true_mark = cc.Sprite:create("image/testscene/testscene_right_v.png")
                true_mark:setPosition(position_X,position_Y)
                layer:addChild(true_mark) 
                
                local action1 = cc.MoveTo:create(0.5,cc.p(x ,990))
                local action2 = cc.ScaleTo:create(0.5,0)
                true_mark:runAction(cc.Sequence:create(action1, action2))
                
            else
                sprite_array[logic_location.x][logic_location.y].wrong()                        
                wrongWordFunction()  
                return true              
            end

            if rbCurrentWordIndex < #wordToBeTested then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                if answer == sprite_array[logic_location.x][logic_location.y].character then
                    rightWordFuntion()
                    rbProgressBar.addOne()
                end
            else            
                rbProgressBar.addOne()
                
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            
                s_SCENE:callFuncWithDelay(0.5,function()
                    local action1 = cc.MoveBy:create(0.5,cc.p(0,200))
                    rbProgressBar:runAction(action1)   
                    for i = 1, #wordToBeTested do
                        for j = 1, 3 do
                            local sprite = sprite_array[i][j]
                            local action1 = cc.ScaleTo:create(0.5, 0)
                            sprite:runAction(action1)
                        end
                    end
                end)
                
                local action1 = cc.DelayTime:create(1)
                local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action1, action2))

                s_SCENE:callFuncWithDelay(1,function()
                rbCurrentWordIndex = rbCurrentWordIndex + 1
                s_CorePlayManager.enterReviewBossSummaryLayer()
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                end)
            end            
        end

        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return NewReviewBossMainLayer