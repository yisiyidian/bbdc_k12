require("cocos.init")
require("common.global")

local NewReviewBossNode = require("view.newreviewboss.NewReviewBossNode")
local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")


local  NewReviewBossMainLayer = class("NewReviewBossMainLayer", function ()
    return cc.Layer:create()
end)



function NewReviewBossMainLayer.create()

    --pause music
    cc.SimpleAudioEngine:getInstance():pauseMusic()    

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
    
      
    local rbCurrentWordIndex = 1
    local wordToBeTested = {}
    local sprite_array = {}

    local updateWord = function ()
        local currentWordName   = s_CorePlayManager.ReviewWordList[s_CorePlayManager.currentReviewIndex]
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
            
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewReviewBossMainLayer.new()
    
    local pauseBtn = ccui.Button:create("image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT *0.99)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    layer:addChild(pauseBtn,100)
    local Pause = require('view.Pause')
    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer:addChild(pauseLayer)
            s_SCENE.popupLayer.listener:setSwallowTouches(true)
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)
    
    local fillColor1 = cc.LayerColor:create(cc.c4b(10,152,210,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 263)
    fillColor1:setAnchorPoint(0.5,0)
    fillColor1:ignoreAnchorPointForPosition(false)
    fillColor1:setPosition(s_DESIGN_WIDTH/2,0)
    layer:addChild(fillColor1)

    local fillColor2 = cc.LayerColor:create(cc.c4b(26,169,227,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 542-263)
    fillColor2:setAnchorPoint(0.5,0)
    fillColor2:ignoreAnchorPointForPosition(false)
    fillColor2:setPosition(s_DESIGN_WIDTH/2,263)
    layer:addChild(fillColor2)

    local fillColor3 = cc.LayerColor:create(cc.c4b(36,186,248,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 776-542)
    fillColor3:setAnchorPoint(0.5,0)
    fillColor3:ignoreAnchorPointForPosition(false)
    fillColor3:setPosition(s_DESIGN_WIDTH/2,542)
    layer:addChild(fillColor3)

    local fillColor4 = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-776)
    fillColor4:setAnchorPoint(0.5,0)
    fillColor4:ignoreAnchorPointForPosition(false)
    fillColor4:setPosition(s_DESIGN_WIDTH/2,776)
    layer:addChild(fillColor4)

    local back = sp.SkeletonAnimation:create("spine/fuxiboss_background.json", "spine/fuxiboss_background.atlas", 1)
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(back)      
    back:addAnimation(0, 'animation', true)

    for i=1,s_CorePlayManager.currentReward do
        local reward = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
        reward:setPosition(s_RIGHT_X - reward:getContentSize().width * i,
            s_DESIGN_HEIGHT * 0.95)
        reward:ignoreAnchorPointForPosition(false)
        reward:setAnchorPoint(0.5,0.5)
        reward:setTag(i)       
        local action1 = cc.ScaleTo:create(2,1)
        layer:addChild(reward)  
        reward:runAction(action1)
        reward:setScale(0)
    end
    
    

    local rbProgressBar = ProgressBar.create(s_CorePlayManager.maxReviewWordCount,s_CorePlayManager.rightReviewWordNum,"yellow")
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


    local getRandomWordForRightWord = function(wordName)

        local tmp =  {}            
        table.foreachi(s_CorePlayManager.ReviewWordList, function(i, v) tmp[i] = s_CorePlayManager.ReviewWordList[i]  end)     
        local wordNumber
        table.foreachi(tmp, function(i, v) if v == wordName then  wordNumber = i end end)               

        local randomIndex = (wordNumber )%s_CorePlayManager.maxReviewWordCount + 1 
        local word1 = tmp[randomIndex]
        local randomIndex = (wordNumber + 1)%s_CorePlayManager.maxReviewWordCount + 1 
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
    
    local rightWordFuntion = function ()
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                    local action2 = cc.ScaleTo:create(0.4, 0)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                    local action2 = cc.ScaleTo:create(0.4, 0.8)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex + 1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,260))
                    local action2 = cc.ScaleTo:create(0.4, 1)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(true)
                else
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,260))
                    sprite:runAction(cc.Sequence:create(action0, action1))
                    sprite.visible(false)
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        s_CorePlayManager.updateCurrentReviewIndex()
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
        s_CorePlayManager.insertReviewList(wordname)
        table.insert(wordToBeTested, wordname)
        local words = getRandomWordForRightWord(wordname)
        local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), index_y - 260))
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
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                    local action2 = cc.ScaleTo:create(0.4, 0)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex then
                
                    if answer == sprite_array[i][j].character then
                        local action0 = cc.DelayTime:create(0.1)
                        local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                        local action2 = cc.ScaleTo:create(0.4, 0.8)
                        local action3 = cc.Spawn:create(action1, action2)
                        sprite:runAction(cc.Sequence:create(action0, action3))
                        sprite.right()
                        sprite.visible(false)
                    else
                        local action0 = cc.DelayTime:create(0.1)
                        local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,-260))
                        local action2 = cc.ScaleTo:create(0.4, 0)
                        local action3 = cc.Spawn:create(action1, action2)
                        sprite:runAction(cc.Sequence:create(action0, action3))
                    end

                elseif i == rbCurrentWordIndex + 1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,260))
                    local action2 = cc.ScaleTo:create(0.4, 1)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(true)
                else
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,260))
                    sprite:runAction(cc.Sequence:create(action0, action1))
                    sprite.visible(false)
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        s_CorePlayManager.updateCurrentReviewIndex()
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
            local HintView = require("view.newreviewboss.NewReviewBossHintLayer")
            local hintView = HintView.create()
            layer:addChild(hintView)          
            hintView.close = function ()          
                hintView:removeFromParent()
                wrongWordFunction()
            end   
        end
    end

    local hint_button = ccui.Button:create("image/newreviewboss/buttontip.png","image/newreviewboss/buttontip.png","")
    hint_button:setPosition(s_RIGHT_X + 100 , s_DESIGN_HEIGHT * 0.81 )
    hint_button:ignoreAnchorPointForPosition(false)
    hint_button:setAnchorPoint(0.5,0.5)
    hint_button:addTouchEventListener(hint_click)
    layer:addChild(hint_button) 
    
    local action1 = cc.MoveTo:create(0.4, cc.p(s_RIGHT_X,s_DESIGN_HEIGHT * 0.81 ))
    hint_button:runAction(action1)
    

    local hint_label = cc.Label:createWithSystemFont("偷看","",36)
    hint_label:setPosition(hint_button:getContentSize().width * 0.3,hint_button:getContentSize().height * 0.5)
    hint_label:setColor(cc.c4b(255,255,255,255))
    hint_label:ignoreAnchorPointForPosition(false)
    hint_label:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_label)
    
    local hint_arrow = cc.Sprite:create("image/newreviewboss/buttonarrow.png")
    hint_arrow:setPosition(hint_button:getContentSize().width * 0.6,hint_button:getContentSize().height * 0.5)
    hint_arrow:ignoreAnchorPointForPosition(false)
    hint_arrow:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_arrow)

    for i = 1,  s_CorePlayManager.maxReviewWordCount do
        table.insert(wordToBeTested,s_CorePlayManager.ReviewWordList[i])
        local words = getRandomWordForRightWord(s_CorePlayManager.ReviewWordList[i])
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            if i == 1 then
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 200 + 200*(j-1), 850 - 260*i - 260))
                sprite.visible(true)
            else
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 260*i - 260))
                sprite:setScale(0.8)
                sprite.visible(false)
            end
            layer:addChild(sprite)
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
--                for j = 1, 3 do
--                    if answer == sprite_array[logic_location.x][j].character then
--                        sprite_array[logic_location.x][j].right()
--                	end
--                end
                

                local sprite = layer:getChildByTag(s_CorePlayManager.currentReward)
                local reward_miss = sp.SkeletonAnimation:create('spine/fuxiboss_bea_dispare.json', 'spine/fuxiboss_bea_dispare.atlas',1)
                reward_miss:setPosition(sprite:getContentSize().width * 0.5, -10)
                reward_miss:addAnimation(0, 'oudupus3', false)
                sprite:addChild(reward_miss, 5)             
                s_SCENE:callFuncWithDelay(0.2,function()
                    layer:removeChildByTag(s_CorePlayManager.currentReward + 1)
                end)                    
                s_CorePlayManager.minusReviewReward() 
               

                if s_CorePlayManager.currentReward <= 0 then
                    local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossFailPopup")
                    local newReviewBossLayerChange = NewReviewBossLayerChange.create()
                    s_SCENE:popup(newReviewBossLayerChange)
                end
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