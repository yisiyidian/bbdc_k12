require("Cocos2d")
require("Cocos2dConstants")

require("common.global")


local NewStudyLayer = class("NewStudyLayer", function ()
    return cc.Layer:create()
end)


function NewStudyLayer.create()
    local layer = NewStudyLayer.new()

    s_WordPool = s_DATA_MANAGER.loadAllWords()

    -- fake data, you can add if not enough
    local wordList              =   {"apple", "many", "where", "happy", "go", "sad", "at", "moon", "table", "desk"}
    local currentIndex          =   1
    local currentWord           =   s_WordPool[wordList[currentIndex]]
 
    local wordName              =   currentWord.wordName
    local wordSoundMarkEn       =   currentWord.wordSoundMarkEn
    local wordSoundMarkAm       =   currentWord.wordSoundMarkAm
    local wordMeaning           =   currentWord.wordMeaning
    local wordMeaningSmall      =   currentWord.wordMeaningSmall
    local sentenceEn            =   currentWord.sentenceEn
    local sentenceCn            =   currentWord.sentenceCn
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    --TODO for houqi:
    -- code about new study layer
    -- record right word list and wrong word list
    -- end if 20 wrong words have been generate
    local rightWordList         = {}
    local wrongWordList         = {}
    local maxWrongWordCount     = 20
    
    

    return layer
end

return NewStudyLayer
