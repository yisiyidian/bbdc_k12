local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newreviewboss.NewReviewBossWordInfo")
local Button                = require("view.button.longButtonInStudy")

local LastWordInfoPopup = class ("LastWordInfoPopup",function ()
    return cc.Layer:create()
end)

function LastWordInfoPopup.create(currentWordName)
    local layer = LastWordInfoPopup.new(currentWordName)
    return layer
end

function LastWordInfoPopup:ctor(currentWordName)

    local currentWord       = s_LocalDatabaseManager.getWordInfoFromWordName(currentWordName)
    local wordname          = currentWord.wordName
    local wordSoundMarkEn   = currentWord.wordSoundMarkEn
    local wordSoundMarkAm   = currentWord.wordSoundMarkAm
    local wordMeaningSmall  = currentWord.wordMeaningSmall
    local wordMeaning       = currentWord.wordMeaning
    local sentenceEn        = currentWord.sentenceEn
    local sentenceCn        = currentWord.sentenceCn
    local sentenceEn2       = currentWord.sentenceEn2
    local sentenceCn2       = currentWord.sentenceCn2

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local back = cc.Sprite:create("image/newstudy/infopopup.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    self:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local soundMark = SoundMark.create(wordname, wordSoundMarkEn, wordSoundMarkAm)
    soundMark:setPosition(back:getContentSize().width/2, back:getContentSize().height * 0.85 )  
    back:addChild(soundMark)
    
    soundMark.scale(0.8)
    
    local detailInfo = DetailInfo.create(currentWord,400)
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(back:getContentSize().width/2, back:getContentSize().height * 0.45 )
    back:addChild(detailInfo)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end

    local button_func = function()
        playSound(s_sound_buttonEffect)
        closeAnimation()
    end

    local button_goon = Button.create("small","blue","确定") 
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.1)
    button_goon.func = function ()
        button_func()
    end

    back:addChild(button_goon)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
           closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    onAndroidKeyPressed(self, function ()
        closeAnimation()
    end, function ()

    end)
end

return LastWordInfoPopup