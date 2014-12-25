require("cocos.init")

require("common.global")


local NewReviewBossNode = require("view.newreviewboss.NewReviewBossNode")
local ProgressBar       = require("view.newstudy.NewStudyProgressBar")


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

    local backGround = cc.Sprite:create("image/newreviewboss/newreviewboss_background.png")
    backGround:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    backGround:ignoreAnchorPointForPosition(false)
    backGround:setAnchorPoint(0.5,0.5)
    layer:addChild(backGround)

    for i=1,s_CorePlayManager.currentReward do
        local reward = cc.Sprite:create("image/newstudy/bean.png")
        reward:setPosition(backGround:getContentSize().width - reward:getContentSize().width * (i + 2),
            backGround:getContentSize().height)
        reward:ignoreAnchorPointForPosition(false)
        reward:setAnchorPoint(0.5,1)
        reward:setTag(i)
        backGround:addChild(reward)  
    end

    local rbProgressBar = ProgressBar.create(s_CorePlayManager.maxReviewWordCount,s_CorePlayManager.currentReviewIndex - 1,"red")
    rbProgressBar:setPosition(backGround:getContentSize().width/2, s_DESIGN_HEIGHT * 0.95)
    backGround:addChild(rbProgressBar)

    local huge_word = cc.Label:createWithSystemFont(wordname,"",48)
    huge_word:setPosition(backGround:getContentSize().width / 2,s_DESIGN_HEIGHT * 0.85)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    backGround:addChild(huge_word)


    local getRandomWordForRightWord = function(wordName)

        local tmp =  {"quotation","drama","critical","observer","open",
            "progress","entitle","blank","honourable","single",
            "namely","perfume","matter","lump","thousand",
            "recorder","great","guest","spy","cousin"}

        local wordNumber
        table.foreachi(tmp, function(i, v) if v == wordName then
            wordNumber = i
        end 
        end)               

        local randomIndex = (wordNumber + 5)%20 + 1 
        local word1 = tmp[randomIndex]


        local randomIndex = (wordNumber + 10)%20 + 1 
        local word2 = tmp[randomIndex]

        local rightIndex = math.random(1,1024)%3 + 1
        local ans = {}
        ans[rightIndex] = wordName
        if rightIndex == 1 then
            ans[2] = word1
            ans[3] = word2
        elseif rightIndex == 2 then
            ans[3] = word1
            ans[1] = word2
        else
            ans[1] = word1
            ans[2] = word2
        end
        return ans
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

                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                s_CorePlayManager.insertReviewList(wordToBeTested[rbCurrentWordIndex])
                table.insert(wordToBeTested, wordToBeTested[rbCurrentWordIndex])
                local words = getRandomWordForRightWord(wordToBeTested[rbCurrentWordIndex])
                local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
                local tmp = {}
                for j = 1, 3 do
                    local sprite = NewReviewBossNode.create(words[j])
                    sprite:setPosition(cc.p(backGround:getContentSize().width / 2 - 160 + 160*(j-1), index_y - 260))
                    sprite:setScale(0.8)
                    backGround:addChild(sprite)
                    tmp[j] = sprite
                end
                table.insert(sprite_array, tmp)
                for i = 1, #wordToBeTested do
                    for j = 1, 3 do
                        local sprite = sprite_array[i][j]
                        if i <= rbCurrentWordIndex-1 then

                        elseif i == rbCurrentWordIndex then
                            local action0 = cc.DelayTime:create(0.1)
                            local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,-260))
                            local action2 = cc.ScaleTo:create(0.4, 0)
                            local action3 = cc.Spawn:create(action1, action2)
                            sprite:runAction(cc.Sequence:create(action0, action3))
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
                huge_word:setString(wordname)
            end
        end
    end



    local hint_button = ccui.Button:create("image/newreviewboss/hintbuttonbegin.png","image/newreviewboss/hintbuttonend.png","")
    hint_button:setPosition(backGround:getContentSize().width - 150, s_DESIGN_HEIGHT * 0.85 )
    hint_button:ignoreAnchorPointForPosition(false)
    hint_button:setAnchorPoint(1,0.5)
    hint_button:addTouchEventListener(hint_click)
    backGround:addChild(hint_button) 

    local hint_label = cc.Label:createWithSystemFont("提示","",24)
    hint_label:setPosition(hint_button:getContentSize().width / 2,hint_button:getContentSize().height / 2)
    hint_label:setColor(cc.c4b(255,255,255,255))
    hint_label:ignoreAnchorPointForPosition(false)
    hint_label:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_label)

   

    for i = 1,  s_CorePlayManager.maxReviewWordCount do
        table.insert(wordToBeTested,s_CorePlayManager.ReviewWordList[i])
        local words = getRandomWordForRightWord(s_CorePlayManager.ReviewWordList[i])
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            if i == 1 then
                sprite:setPosition(cc.p(backGround:getContentSize().width / 2 - 200 + 200*(j-1), 850 - 260*i - 260))
                sprite.visible(true)
            else
                sprite:setPosition(cc.p(backGround:getContentSize().width / 2 - 160 + 160*(j-1), 850 - 260*i - 260))
                sprite:setScale(0.8)
                sprite.visible(false)
            end
            backGround:addChild(sprite)
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
        local location = backGround:convertToNodeSpace(touch:getLocation())
        local logic_location = checkTouchIndex(location)

        if logic_location.x == rbCurrentWordIndex then
            -- button sound
            playSound(s_sound_buttonEffect)
            if wordToBeTested[logic_location.x] == sprite_array[logic_location.x][logic_location.y].character then
                sprite_array[logic_location.x][logic_location.y].right()
            else
                sprite_array[logic_location.x][logic_location.y].wrong()
                backGround:removeChildByTag(s_CorePlayManager.currentReward)
                s_CorePlayManager.currentReward = s_CorePlayManager.currentReward - 1
                
                if s_CorePlayManager.currentReward <= 0 then
                
                end

                table.insert(wordToBeTested, wordToBeTested[rbCurrentWordIndex])
                local words = getRandomWordForRightWord(wordToBeTested[#wordToBeTested])
                local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
                local tmp = {}
                for j = 1, 3 do
                    local sprite = NewReviewBossNode.create(words[j])
                    sprite:setPosition(cc.p(backGround:getContentSize().width / 2 - 160 + 160*(j-1), index_y - 260))
                    sprite:setScale(0.8)
                    backGround:addChild(sprite)
                    tmp[j] = sprite
                end
                table.insert(sprite_array, tmp)
            end

            if rbCurrentWordIndex < #wordToBeTested then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                if wordToBeTested[logic_location.x] == sprite_array[logic_location.x][logic_location.y].character then
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
                else
                    for i = 1, #wordToBeTested do
                        for j = 1, 3 do
                            local sprite = sprite_array[i][j]
                            if i <= rbCurrentWordIndex-1 then

                            elseif i == rbCurrentWordIndex then
                                local action0 = cc.DelayTime:create(0.1)
                                local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,-260))
                                local action2 = cc.ScaleTo:create(0.4, 0)
                                local action3 = cc.Spawn:create(action1, action2)
                                sprite:runAction(cc.Sequence:create(action0, action3))
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
                end

                local action1 = cc.DelayTime:create(0.5)
                local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action1, action2))

                rbCurrentWordIndex = rbCurrentWordIndex + 1                
                s_CorePlayManager.updateCurrentReviewIndex()
                currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
                sentenceEn2,sentenceCn2 = updateWord()
                huge_word:setString(wordname)

            else
                rbCurrentWordIndex = rbCurrentWordIndex + 1
                s_CorePlayManager.enterReviewBossSummaryLayer()
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
            end            
        end

        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = backGround:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backGround)


    return layer
end

return NewReviewBossMainLayer