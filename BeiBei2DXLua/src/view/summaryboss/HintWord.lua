

local HintWord = class ("HintWord",function ()
    return cc.Layer:create()
end)

function HintWord.create(word,target,firstTime)
    local layer = HintWord.new(word,target,firstTime)
    return layer
end

function HintWord:ctor(word,target,firstTime)
    self.hintOver = function() end

    local director = cc.Director:getInstance()
    self.targets = director:getActionManager():pauseTarget(target)

    --
    local curtain = cc.LayerColor:create(cc.c4b(0,0,0,150),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    self:addChild(curtain)
    curtain:setPosition(s_LEFT_X,0)
    self.isPaused = false
    local wordBoard
    if word ~= '' then
        --出现中英对照
        wordBoard = cc.Sprite:create('image/summarybossscene/bckground_words_h5_boss.png')
        wordBoard:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 3 / 2)
        self:addChild(wordBoard,100)

        local word_en = cc.Label:createWithTTF(word,'font/CenturyGothic.ttf',40)
        word_en:setPosition(wordBoard:getContentSize().width / 2,wordBoard:getContentSize().height * 3 / 4)
        wordBoard:addChild(word_en)
        word_en:setColor(cc.c3b(0,0,0))

        local word_cn = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getWordInfoFromWordName(word).wordMeaningSmall,'',40)
        word_cn:setPosition(wordBoard:getContentSize().width / 2,wordBoard:getContentSize().height * 1 / 4)
        wordBoard:addChild(word_cn)
        word_cn:setColor(cc.c3b(0,0,0))

        local title = cc.Sprite:create('image/guide/yindao_boss_time.png')
        title:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.8)
        --title:setScale(1.5)
        self:addChild(title)
        
        if firstTime then
            local tutorial_text = cc.Sprite:create('image/guide/yindao_background_yellow.png')
            tutorial_text:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 0.5)
            self:addChild(tutorial_text)
            local text = cc.Label:createWithSystemFont('这个词一会儿还会再出现的哦！','',28)
            text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
            text:setColor(cc.c3b(0,0,0))
            tutorial_text:addChild(text)
            tutorial_text:setVisible(false)
            tutorial_text:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.Show:create()))
        end

        wordBoard:runAction(cc.EaseBackOut:create(cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT))))
    else

        local tutorial_text = cc.Sprite:create('image/guide/yindao_background_yellow.png')
        tutorial_text:setPosition(s_DESIGN_WIDTH / 2, 500)
        self:addChild(tutorial_text,120)
        local text = cc.Label:createWithSystemFont('不会的话果断求提示','',36)
        text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
        text:setColor(cc.c3b(0,0,0))
        tutorial_text:addChild(text)
        local sprite = cc.Sprite:create("image/guide/yindao_boss_finger.png")
        sprite:setPosition(s_DESIGN_WIDTH * 0.84,210)
        self:addChild(sprite)

        local hint = cc.Sprite:create('image/guide/yindao_background_here.png')
        hint:setPosition(sprite:getContentSize().width/2-20,sprite:getContentSize().height + 40)
        sprite:addChild(hint)

        local label = cc.Label:createWithSystemFont('戳这里  戳这里','',28)
        label:setPosition(hint:getContentSize().width / 2,hint:getContentSize().height/2)
        hint:addChild(label)
    end

    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        if self.isPaused then
            wordBoard:stopAllActions()
            --self:removeFromParent()
            self.hintOver()
            self:removeFromParent()
            return
        end
        if word ~= '' then
            
            director:getActionManager():resumeTarget(target)
            local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local delaytime = 0
            if firstTime then
                delaytime = 3
            end
            local pause = cc.CallFunc:create(function (  )
                self.isPaused = true
            end)
            local action3 = cc.DelayTime:create(delaytime)
            local action4 = cc.CallFunc:create(function()
                self.hintOver()
                self:removeFromParent()
            end)
            wordBoard:runAction(cc.Sequence:create(action2,pause,action3,action4))
        else
            self.hintOver()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return HintWord