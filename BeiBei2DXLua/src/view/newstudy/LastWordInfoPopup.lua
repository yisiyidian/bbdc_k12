local SoundMark         = require("view.newstudy.NewStudySoundMark")
local DetailInfo        = require("view.newreviewboss.NewReviewBossWordInfo")

local LastWordInfoPopup = class ("LastWordInfoPopup",function ()
    return cc.Layer:create()
end)

function LastWordInfoPopup.create(currentWordName)
    local layer = LastWordInfoPopup.new(currentWordName)
    return layer
end

function LastWordInfoPopup:ctor(currentWordName)

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
    
    local detailInfo = DetailInfo.create(currentWord)
    detailInfo:setAnchorPoint(0.5,0.5)
    detailInfo:ignoreAnchorPointForPosition(false)
    detailInfo:setPosition(back:getContentSize().width/2, back:getContentSize().height * 0.35 )
    back:addChild(detailInfo)
   
    local button_goon_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end

    local button_goon = ccui.Button:create("image/newstudy/button_ok.png","","")
    button_goon:setScale9Enabled(true)
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.1)
    button_goon:setTitleText("确定")
    button_goon:setTitleFontSize(30)
    button_goon:addTouchEventListener(button_goon_clicked)
    back:addChild(button_goon)
end

return LastWordInfoPopup